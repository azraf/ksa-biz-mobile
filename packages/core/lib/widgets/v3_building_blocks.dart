import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Action button that stays translucent so list content underneath remains
/// visible: 35% opacity idle, 80% while its [onOpen] action (a bottom sheet
/// or pushed screen) is open. Pair the list with
/// `padding: EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance)`.
class TranslucentFab extends StatefulWidget {
  const TranslucentFab({
    super.key,
    required this.icon,
    this.label,
    required this.onOpen,
  });

  final Widget icon;
  final String? label;

  /// Awaited; the button stays at 80% opacity until it completes.
  final Future<void> Function() onOpen;

  @override
  State<TranslucentFab> createState() => _TranslucentFabState();
}

class _TranslucentFabState extends State<TranslucentFab> {
  bool _active = false;

  Future<void> _handlePressed() async {
    setState(() => _active = true);
    try {
      await widget.onOpen();
    } finally {
      if (mounted) setState(() => _active = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    return AnimatedOpacity(
      opacity: _active ? 0.8 : 0.35,
      duration: AppDurations.fast,
      child: label == null
          ? FloatingActionButton(onPressed: _handlePressed, child: widget.icon)
          : FloatingActionButton.extended(
              onPressed: _handlePressed,
              icon: widget.icon,
              label: Text(label),
            ),
    );
  }
}

/// Rounded tinted square with an icon — the v3 leading element for cards.
class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Icon(icon, size: size * 0.5, color: cs.onSecondaryContainer),
    );
  }
}

/// KPI / stat card used on dashboards.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.caption,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final String? caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              IconBadge(icon: icon),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                    const SizedBox(height: AppSpacing.xs),
                    Text(value, style: theme.textTheme.headlineSmall),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: theme.textTheme.bodySmall),
                    ],
                    if (caption != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(caption!, style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  rtl ? Icons.chevron_left : Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section heading with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          if (actionLabel != null && onAction != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

/// Brand header for login screens: tinted app-icon badge, title, subtitle.
class LoginHero extends StatelessWidget {
  const LoginHero({super.key, required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadii.xl),
          ),
          child: Icon(icon, size: 36, color: cs.onPrimaryContainer),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

enum NoticeKind { info, warning, offline, danger, success }

/// Inline notice card for dashboards and lists (pending sync, cached data…).
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.kind,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.margin = const EdgeInsets.only(bottom: AppSpacing.md),
  });

  final NoticeKind kind;
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bg, fg) = switch (kind) {
      NoticeKind.info => (AppColors.pendingContainer(context), AppColors.pending(context)),
      NoticeKind.warning => (AppColors.warningContainer(context), AppColors.warning(context)),
      NoticeKind.offline || NoticeKind.danger =>
        (AppColors.dangerContainer(context), AppColors.danger(context)),
      NoticeKind.success => (AppColors.successContainer(context), AppColors.success(context)),
    };
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall!.copyWith(color: fg)),
                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.bodySmall!.copyWith(color: fg)),
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(foregroundColor: fg),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
