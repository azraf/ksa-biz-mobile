import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstRunTips extends StatefulWidget {
  const FirstRunTips({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  State<FirstRunTips> createState() => _FirstRunTipsState();
}

class _FirstRunTipsState extends State<FirstRunTips> {
  static const _key = 'sales_first_run_tips_done';
  int _step = 0;

  @override
  void initState() {
    super.initState();
    if (widget.prefs.getBool(_key) == true) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showStep());
  }

  void _showStep() {
    if (!mounted || widget.prefs.getBool(_key) == true) return;
    final l10n = AppLocalizations.of(context);
    final messages = [
      l10n.salesFirstRunTipDashboard,
      l10n.salesFirstRunTipOrder,
      l10n.salesFirstRunTipOffline,
    ];
    if (_step >= messages.length) {
      widget.prefs.setBool(_key, true);
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(messages[_step]),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _step++;
              if (_step >= messages.length) {
                widget.prefs.setBool(_key, true);
              } else {
                _showStep();
              }
            },
            child: Text(l10n.salesFirstRunGotIt),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
