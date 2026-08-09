import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../providers/repositories.dart';

/// On-device daily digests ("N visits today", 08:00) for planned visits.
///
/// Cancel-all-and-reschedule on every refresh keeps reschedules and
/// cancellations self-healing with zero bookkeeping, and the inexact schedule
/// mode needs no exact-alarm permission on Android 14+.
/// ponytail: daily digest only; per-visit exact alarms are the upgrade path.
class VisitReminderService {
  VisitReminderService._();

  static final VisitReminderService instance = VisitReminderService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Set once at app start; invoked when a reminder is tapped.
  void Function()? onOpenPlanner;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    tzdata.initializeTimeZones();
    // ponytail: offset-matched location instead of a timezone plugin — exact
    // enough for a daily digest in a no-DST deployment (KSA, UTC+3).
    final offset = DateTime.now().timeZoneOffset;
    final location = tz.timeZoneDatabase.locations.values.firstWhere(
      (l) => l.currentTimeZone.offset == offset.inMilliseconds,
      orElse: () => tz.UTC,
    );
    tz.setLocalLocation(location);

    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (_) => onOpenPlanner?.call(),
    );
  }

  /// Android 13+ runtime prompt; asked lazily the first time a visit is saved
  /// so the request arrives in context.
  Future<void> requestPermissionIfNeeded() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  Future<void> rescheduleDigests(
    List<({DateTime when, String title, String body})> digests,
  ) async {
    await init();
    await _plugin.cancelAll();

    var id = 1000;
    for (final digest in digests) {
      if (!digest.when.isAfter(DateTime.now())) continue;
      await _plugin.zonedSchedule(
        id++,
        digest.title,
        digest.body,
        tz.TZDateTime.from(digest.when, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'visit_reminders',
            'Visit reminders',
            channelDescription: 'Daily digest of planned shop visits',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }
}

extension _DayCount on List<VisitScheduleModel> {
  int plannedOn(DateTime day) => where((v) {
        if (!v.isPlanned) return false;
        final when = v.scheduledDate;
        return when != null &&
            when.year == day.year &&
            when.month == day.month &&
            when.day == day.day;
      }).length;
}

/// Recomputes the today/tomorrow 08:00 digests from the offline cache.
/// Called after sync, on planner load and after any visit mutation.
Future<void> refreshVisitReminders(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  try {
    final now = DateTime.now();
    final visits = await ref.read(offlineVisitRepositoryProvider).list(
          from: now,
          to: now.add(const Duration(days: 1)),
        );

    final digests = <({DateTime when, String title, String body})>[];
    for (final dayOffset in [0, 1]) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: dayOffset));
      final count = visits.plannedOn(day);
      if (count == 0) continue;
      digests.add((
        when: day.add(const Duration(hours: 8)),
        title: l10n.planReminderTitle,
        body: l10n.planReminderBody(count),
      ));
    }

    await VisitReminderService.instance.rescheduleDigests(digests);
  } catch (_) {
    // Reminders are best-effort; never let them break the calling flow.
  }
}
