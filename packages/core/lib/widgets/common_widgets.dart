import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../errors/app_error_mapper.dart';
import '../theme/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!),
          ],
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, this.onRetry, this.error});

  final String message;
  final VoidCallback? onRetry;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final display = error != null ? AppErrorMapper.localize(context, error!) : message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(display, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  Color _color(BuildContext context) {
    switch (label) {
      case 'cancelled':
        return AppColors.dangerContainer(context);
      case 'converted':
      case 'confirmed':
      case 'paid':
        return AppColors.successContainer(context);
      case 'in_review':
      case 'modified':
      case 'partial':
        return AppColors.warningContainer(context);
      case 'pending':
      case 'assigned':
      case 'pending_sync':
        return AppColors.pendingContainer(context);
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final display = localizedStatusLabel(context, label);
    return Chip(
      avatar: icon != null ? Icon(icon, size: 16) : null,
      label: Text(display),
      backgroundColor: _color(context),
      visualDensity: VisualDensity.compact,
    );
  }
}
