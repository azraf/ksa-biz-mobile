import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l10n/l10n.dart';
import 'package:maps_ui/maps_ui.dart';

import '../errors/app_error_mapper.dart';
import '../repositories/customer_repository.dart';
import 'customer_user_account_fields.dart';
import 'list_sort_button.dart';

/// Dependencies for online-only quick customer create sheets.
class QuickCreateCustomerHost {
  const QuickCreateCustomerHost({
    required this.customerRepository,
    required this.isOnline,
    this.attachShopPhoto,
  });

  final CustomerRepository customerRepository;
  final bool Function() isOnline;
  final Future<void> Function(File file, int shopId)? attachShopPhoto;
}

Future<dynamic> showQuickCreateCustomerSheet({
  required BuildContext context,
  required QuickCreateCustomerHost host,
  required String customerType,
  required int? salesPersonId,
}) {
  if (!tryOpenQuickCreateCustomer(context: context, isOnline: host.isOnline())) {
    return Future.value();
  }
  return showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: switch (customerType) {
        'customer_van' => QuickVanCreateSheet(host: host, salesPersonId: salesPersonId),
        'customer_importer' => QuickImporterCreateSheet(host: host, salesPersonId: salesPersonId),
        _ => QuickShopCreateSheet(host: host, salesPersonId: salesPersonId),
      },
    ),
  );
}

class QuickShopCreateSheet extends StatefulWidget {
  const QuickShopCreateSheet({super.key, required this.host, required this.salesPersonId});

  final QuickCreateCustomerHost host;
  final int? salesPersonId;

  @override
  State<QuickShopCreateSheet> createState() => _QuickShopCreateSheetState();
}

class _QuickShopCreateSheetState extends State<QuickShopCreateSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();
  final _accountFieldsKey = GlobalKey<CustomerUserAccountFieldsState>();
  final _picker = ImagePicker();
  String? _gps;
  XFile? _photo;
  bool _saving = false;
  bool _createUser = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _userPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!widget.host.isOnline()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesCustomerCreateGoOnline)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    if (_createUser) {
      final accountError = _accountFieldsKey.currentState?.validate();
      if (accountError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accountError)));
        return;
      }
    }
    setState(() => _saving = true);
    try {
      final repo = widget.host.customerRepository;
      final account = _accountFieldsKey.currentState?.accountValues();
      final shop = await repo.createShop(
        name: name,
        gps: _gps,
        salesPersonId: widget.salesPersonId,
        createUser: _createUser,
        userEmail: account?['email'],
        userPhone: account?['phone'],
        userPassword: account?['password'],
        userPasswordConfirmation: account?['password_confirmation'],
      );
      final phone = _phoneController.text.trim();
      if (phone.isNotEmpty) {
        await repo.createShopContact(shopId: shop.id, contactName: name, contactMobile: phone);
      }
      if (_photo != null && widget.host.attachShopPhoto != null) {
        await widget.host.attachShopPhoto!(File(_photo!.path), shop.id);
      }
      if (mounted) Navigator.pop(context, shop);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.salesQuickNewShop, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.salesQuickShopName)),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: l10n.commonPhone),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
          ),
          CustomerUserAccountFields(
            key: _accountFieldsKey,
            createUser: _createUser,
            onCreateUserChanged: (value) => setState(() => _createUser = value),
            emailController: _userEmailController,
            phoneController: _userPhoneController,
            passwordController: _userPasswordController,
            confirmPasswordController: _userConfirmPasswordController,
            contactPhone: _phoneController.text,
          ),
          GpsLocationRow(
            gps: _gps,
            title: 'GPS (optional)',
            notCapturedLabel: l10n.commonGpsNotCaptured,
            trailing: GpsCaptureActions(
              gps: _gps,
              onGpsChanged: (value) => setState(() => _gps = value),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final p = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                    if (p != null) setState(() => _photo = p);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text(l10n.commonPhoto),
                ),
              ),
            ],
          ),
          if (_photo != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.file(File(_photo!.path), height: 120, fit: BoxFit.cover),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving ? const CircularProgressIndicator() : Text(l10n.salesQuickSaveShop),
          ),
        ],
      ),
    );
  }
}

class QuickVanCreateSheet extends StatefulWidget {
  const QuickVanCreateSheet({super.key, required this.host, required this.salesPersonId});

  final QuickCreateCustomerHost host;
  final int? salesPersonId;

  @override
  State<QuickVanCreateSheet> createState() => _QuickVanCreateSheetState();
}

class _QuickVanCreateSheetState extends State<QuickVanCreateSheet> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _iqamaController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();
  final _accountFieldsKey = GlobalKey<CustomerUserAccountFieldsState>();
  final _picker = ImagePicker();
  XFile? _photo;
  bool _saving = false;
  bool _createUser = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _iqamaController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _userPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!widget.host.isOnline()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesCustomerCreateGoOnline)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    if (_createUser) {
      final accountError = _accountFieldsKey.currentState?.validate();
      if (accountError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accountError)));
        return;
      }
    }
    setState(() => _saving = true);
    try {
      final repo = widget.host.customerRepository;
      final account = _accountFieldsKey.currentState?.accountValues();
      final van = await repo.createVan(
        name: name,
        mobile: _mobileController.text.trim().isEmpty ? null : _mobileController.text.trim(),
        iqamaNumber: _iqamaController.text.trim().isEmpty ? null : _iqamaController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        salesPersonId: widget.salesPersonId,
        createUser: _createUser,
        userEmail: account?['email'],
        userPhone: account?['phone'],
        userPassword: account?['password'],
        userPasswordConfirmation: account?['password_confirmation'],
      );
      if (_photo != null) {
        final bytes = await _photo!.readAsBytes();
        await repo.uploadVanImage(van.id, bytes, _photo!.name);
      }
      if (mounted) Navigator.pop(context, van);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.salesQuickNewVan, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.commonNameRequired)),
          TextField(
            controller: _mobileController,
            decoration: InputDecoration(labelText: l10n.commonMobile),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
          ),
          TextField(controller: _iqamaController, decoration: InputDecoration(labelText: l10n.salesQuickIqama)),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: l10n.commonEmail),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: l10n.commonAddress)),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.commonCity)),
          CustomerUserAccountFields(
            key: _accountFieldsKey,
            createUser: _createUser,
            onCreateUserChanged: (value) => setState(() => _createUser = value),
            emailController: _userEmailController,
            phoneController: _userPhoneController,
            passwordController: _userPasswordController,
            confirmPasswordController: _userConfirmPasswordController,
            contactPhone: _mobileController.text,
            contactEmail: _emailController.text,
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final p = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
              if (p != null) setState(() => _photo = p);
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(l10n.commonPhoto),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving ? const CircularProgressIndicator() : Text(l10n.salesQuickSaveVan),
          ),
        ],
      ),
    );
  }
}

class QuickImporterCreateSheet extends StatefulWidget {
  const QuickImporterCreateSheet({super.key, required this.host, required this.salesPersonId});

  final QuickCreateCustomerHost host;
  final int? salesPersonId;

  @override
  State<QuickImporterCreateSheet> createState() => _QuickImporterCreateSheetState();
}

class _QuickImporterCreateSheetState extends State<QuickImporterCreateSheet> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();
  final _accountFieldsKey = GlobalKey<CustomerUserAccountFieldsState>();
  bool _saving = false;
  bool _createUser = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _userEmailController.dispose();
    _userPhoneController.dispose();
    _userPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!widget.host.isOnline()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesCustomerCreateGoOnline)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    if (_createUser) {
      final accountError = _accountFieldsKey.currentState?.validate();
      if (accountError != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accountError)));
        return;
      }
    }
    setState(() => _saving = true);
    try {
      final account = _accountFieldsKey.currentState?.accountValues();
      final importer = await widget.host.customerRepository.createImporter(
        name: name,
        mobile: _mobileController.text.trim().isEmpty ? null : _mobileController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        salesPersonId: widget.salesPersonId,
        createUser: _createUser,
        userEmail: account?['email'],
        userPhone: account?['phone'],
        userPassword: account?['password'],
        userPasswordConfirmation: account?['password_confirmation'],
      );
      if (mounted) Navigator.pop(context, importer);
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.salesQuickNewImporter, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.commonNameRequired)),
          TextField(
            controller: _mobileController,
            decoration: InputDecoration(labelText: l10n.commonMobile),
            keyboardType: TextInputType.phone,
            onChanged: (_) => setState(() {}),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: l10n.commonEmail),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: l10n.commonAddress)),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.commonCity)),
          CustomerUserAccountFields(
            key: _accountFieldsKey,
            createUser: _createUser,
            onCreateUserChanged: (value) => setState(() => _createUser = value),
            emailController: _userEmailController,
            phoneController: _userPhoneController,
            passwordController: _userPasswordController,
            confirmPasswordController: _userConfirmPasswordController,
            contactPhone: _mobileController.text,
            contactEmail: _emailController.text,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving ? const CircularProgressIndicator() : Text(l10n.salesQuickSaveImporter),
          ),
        ],
      ),
    );
  }
}
