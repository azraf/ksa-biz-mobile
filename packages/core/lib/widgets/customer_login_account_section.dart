import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/user.dart';
import '../repositories/customer_repository.dart';
import 'customer_user_account_fields.dart';

class CustomerLoginAccountSection extends StatelessWidget {
  const CustomerLoginAccountSection({
    super.key,
    required this.customerType,
    required this.customerId,
    required this.customer,
    required this.customerRepository,
    this.onUpdated,
    this.isAdmin = false,
  });

  final String customerType;
  final int customerId;
  final dynamic customer;
  final CustomerRepository customerRepository;
  final VoidCallback? onUpdated;

  /// Admins can always create a login and can toggle whether salespeople may;
  /// non-admins only see the create action when the flag is on (the API
  /// enforces this server-side regardless).
  final bool isAdmin;

  bool get _allowCreate {
    if (customer is CustomerShopModel) {
      return (customer as CustomerShopModel).allowUserAccountCreation;
    }
    if (customer is CustomerVanModel) {
      return (customer as CustomerVanModel).allowUserAccountCreation;
    }
    if (customer is CustomerImporterModel) {
      return (customer as CustomerImporterModel).allowUserAccountCreation;
    }
    return false;
  }

  CustomerLinkedUserModel? get _user {
    if (customer is CustomerShopModel) return (customer as CustomerShopModel).user;
    if (customer is CustomerVanModel) return (customer as CustomerVanModel).user;
    if (customer is CustomerImporterModel) return (customer as CustomerImporterModel).user;
    return null;
  }

  String? get _contactPhone {
    if (customer is CustomerShopModel) {
      return (customer as CustomerShopModel).primaryContact?.contactMobile;
    }
    if (customer is CustomerVanModel) return (customer as CustomerVanModel).mobile;
    if (customer is CustomerImporterModel) return (customer as CustomerImporterModel).mobile;
    return null;
  }

  String? get _contactEmail {
    if (customer is CustomerVanModel) return (customer as CustomerVanModel).email;
    if (customer is CustomerImporterModel) return (customer as CustomerImporterModel).email;
    return null;
  }

  Future<void> _resetPassword(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showCreateCustomerUserSheet(
      context: context,
      title: l10n.accountResetPasswordTitle,
      submitLabel: l10n.accountResetPassword,
      passwordOnly: true,
      onSubmit: ({
        email,
        phone,
        required password,
        required passwordConfirmation,
      }) async {
        switch (customerType) {
          case 'customer_shop':
            await customerRepository.resetShopUserPassword(
              shopId: customerId,
              password: password,
              passwordConfirmation: passwordConfirmation,
            );
          case 'customer_van':
            await customerRepository.resetVanUserPassword(
              vanId: customerId,
              password: password,
              passwordConfirmation: passwordConfirmation,
            );
          case 'customer_importer':
            await customerRepository.resetImporterUserPassword(
              importerId: customerId,
              password: password,
              passwordConfirmation: passwordConfirmation,
            );
        }
        onUpdated?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.accountPasswordResetDone)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = _user;
    if (user != null) {
      return Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: Text(l10n.accountSection),
              subtitle: Text(
                [
                  if (user.email != null && user.email!.isNotEmpty) user.email!,
                  if (user.phone != null && user.phone!.isNotEmpty) user.phone!,
                ].join(' · '),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _resetPassword(context),
                child: Text(l10n.accountResetPassword),
              ),
            ),
          ],
        ),
      );
    }

    // No linked login yet. Salespeople may only create one when the admin
    // enabled it for this customer.
    if (!isAdmin && !_allowCreate) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.person_off_outlined),
          title: Text(l10n.accountNone),
          subtitle: Text(l10n.accountCreateDisabledHint),
        ),
      );
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAdmin)
            SwitchListTile(
              secondary: const Icon(Icons.manage_accounts_outlined),
              title: Text(l10n.accountAllowSalespersonCreate),
              value: _allowCreate,
              onChanged: (value) async {
                await customerRepository.setAllowUserAccountCreation(
                  customerType: customerType,
                  customerId: customerId,
                  allow: value,
                );
                onUpdated?.call();
              },
            ),
          ListTile(
        leading: const Icon(Icons.person_add_alt_1_outlined),
        title: Text(l10n.accountNone),
        subtitle: Text(l10n.accountNoneHint),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => showCreateCustomerUserSheet(
          context: context,
          contactPhone: _contactPhone,
          contactEmail: _contactEmail,
          onSubmit: ({
            email,
            phone,
            required password,
            required passwordConfirmation,
          }) async {
            switch (customerType) {
              case 'customer_shop':
                await customerRepository.createShopUser(
                  shopId: customerId,
                  email: email,
                  phone: phone,
                  password: password,
                  passwordConfirmation: passwordConfirmation,
                );
              case 'customer_van':
                await customerRepository.createVanUser(
                  vanId: customerId,
                  email: email,
                  phone: phone,
                  password: password,
                  passwordConfirmation: passwordConfirmation,
                );
              case 'customer_importer':
                await customerRepository.createImporterUser(
                  importerId: customerId,
                  email: email,
                  phone: phone,
                  password: password,
                  passwordConfirmation: passwordConfirmation,
                );
            }
            onUpdated?.call();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.accountCreated)),
              );
            }
          },
            ),
          ),
        ],
      ),
    );
  }
}
