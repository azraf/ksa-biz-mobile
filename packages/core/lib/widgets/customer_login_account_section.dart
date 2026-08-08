import 'package:flutter/material.dart';

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
  });

  final String customerType;
  final int customerId;
  final dynamic customer;
  final CustomerRepository customerRepository;
  final VoidCallback? onUpdated;

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
    await showCreateCustomerUserSheet(
      context: context,
      title: 'Reset login password',
      submitLabel: 'Reset password',
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
            const SnackBar(content: Text('Login password reset')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user != null) {
      return Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text('Login account'),
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
                child: const Text('Reset password'),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_add_alt_1_outlined),
        title: const Text('No login account'),
        subtitle: const Text('Create credentials so this customer can use OrderApp or the web portal.'),
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
                const SnackBar(content: Text('Login account created')),
              );
            }
          },
        ),
      ),
    );
  }
}
