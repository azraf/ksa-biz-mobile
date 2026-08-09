import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/widgets/customer_diary_section.dart' as shared;

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

/// Thin wrapper so existing call sites keep their import; the widget itself is
/// shared with admin and order detail from the media package.
class CustomerDiarySection extends ConsumerWidget {
  const CustomerDiarySection({
    super.key,
    required this.customerType,
    required this.customerId,
    this.orderId,
  });

  final String customerType;
  final int customerId;
  final int? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return shared.CustomerDiarySection(
      customerType: customerType,
      customerId: customerId,
      orderId: orderId,
      diaryRepository: ref.watch(offlineDiaryRepositoryProvider),
      mediaCaptureFacade: ref.watch(mediaCaptureFacadeProvider),
      salesPersonId: ref.watch(authProvider).effectiveSalesPersonId,
    );
  }
}
