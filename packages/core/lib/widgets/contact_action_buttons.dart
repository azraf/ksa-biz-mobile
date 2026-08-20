import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import '../models/admin_models.dart';
import '../utils/contact_launcher.dart';

/// Call and WhatsApp action buttons for a phone number.
class ContactActionButtons extends StatelessWidget {
  const ContactActionButtons({
    super.key,
    required this.phoneNumber,
    this.whatsappMessage,
    this.compact = false,
  });

  final String? phoneNumber;
  final String? whatsappMessage;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final number = ContactLauncher.normalizePhone(phoneNumber);
    if (number == null) return const SizedBox.shrink();

    Future<void> showError(String action) async {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.commonCouldNotOpen(action))),
      );
    }

    Future<void> onCall() async {
      if (!await ContactLauncher.dialPhone(phoneNumber)) {
        await showError(l10n.commonPhoneDialer);
      }
    }

    Future<void> onWhatsApp() async {
      if (!await ContactLauncher.openWhatsApp(phoneNumber, message: whatsappMessage)) {
        await showError(l10n.commonWhatsapp);
      }
    }

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            tooltip: l10n.commonCall,
            onPressed: onCall,
          ),
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: l10n.commonWhatsapp,
            onPressed: onWhatsApp,
          ),
        ],
      );
    }

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: onCall,
          icon: const Icon(Icons.phone_outlined),
          label: Text(l10n.commonCall),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onWhatsApp,
          icon: const Icon(Icons.chat_outlined),
          label: Text(l10n.commonWhatsapp),
        ),
      ],
    );
  }
}

/// The shop's number, else the first active contact's mobile.
String? shopContactPhone(CustomerShopModel? shop) {
  if (shop == null) return null;
  if (shop.mobile != null && shop.mobile!.isNotEmpty) return shop.mobile;
  if (shop.contacts.isEmpty) return null;
  for (final contact in shop.contacts) {
    if (contact.active && contact.contactMobile != null && contact.contactMobile!.isNotEmpty) {
      return contact.contactMobile;
    }
  }
  return shop.contacts.first.contactMobile;
}
