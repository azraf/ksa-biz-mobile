import 'package:flutter/material.dart';
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
    final number = ContactLauncher.normalizePhone(phoneNumber);
    if (number == null) return const SizedBox.shrink();

    Future<void> showError(String action) async {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $action')),
      );
    }

    Future<void> onCall() async {
      if (!await ContactLauncher.dialPhone(phoneNumber)) {
        await showError('phone dialer');
      }
    }

    Future<void> onWhatsApp() async {
      if (!await ContactLauncher.openWhatsApp(phoneNumber, message: whatsappMessage)) {
        await showError('WhatsApp');
      }
    }

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            tooltip: 'Call',
            onPressed: onCall,
          ),
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: 'WhatsApp',
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
          label: const Text('Call'),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onWhatsApp,
          icon: const Icon(Icons.chat_outlined),
          label: const Text('WhatsApp'),
        ),
      ],
    );
  }
}

/// First active shop contact mobile, if any.
String? shopContactPhone(CustomerShopModel? shop) {
  if (shop == null || shop.contacts.isEmpty) return null;
  for (final contact in shop.contacts) {
    if (contact.active && contact.contactMobile != null && contact.contactMobile!.isNotEmpty) {
      return contact.contactMobile;
    }
  }
  return shop.contacts.first.contactMobile;
}
