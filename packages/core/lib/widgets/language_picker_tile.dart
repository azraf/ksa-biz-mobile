import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

class LanguagePickerTile extends ConsumerWidget {
  const LanguagePickerTile({super.key});

  static const _locales = [
    Locale('en'),
    Locale('ar'),
    Locale('bn'),
  ];

  String _label(AppLocalizations l10n, String code) {
    return switch (code) {
      'en' => l10n.commonLanguageEnglish,
      'ar' => l10n.commonLanguageArabic,
      'bn' => l10n.commonLanguageBangla,
      _ => code,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(localeNotifierProvider);

    return ListTile(
      title: Text(l10n.commonLanguage),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: current,
          isExpanded: true,
          items: [
            for (final locale in _locales)
              DropdownMenuItem(
                value: locale,
                child: Text(_label(l10n, locale.languageCode)),
              ),
          ],
          onChanged: (locale) {
            if (locale != null) {
              ref.read(localeNotifierProvider.notifier).setLocale(locale);
            }
          },
        ),
      ),
    );
  }
}
