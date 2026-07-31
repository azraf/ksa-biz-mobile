import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l10n/l10n.dart';

import 'package:maps_ui/maps_ui.dart';

import '../providers/connectivity_provider.dart';
import '../providers/repositories.dart';

Future<dynamic> showQuickCreateCustomerSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String customerType,
  required int? salesPersonId,
}) {
  return showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: switch (customerType) {
        'customer_van' => QuickVanCreateSheet(salesPersonId: salesPersonId),
        'customer_importer' => QuickImporterCreateSheet(salesPersonId: salesPersonId),
        _ => QuickShopCreateSheet(salesPersonId: salesPersonId),
      },
    ),
  );
}

class QuickShopCreateSheet extends ConsumerStatefulWidget {
  const QuickShopCreateSheet({super.key, required this.salesPersonId});

  final int? salesPersonId;

  @override
  ConsumerState<QuickShopCreateSheet> createState() => _QuickShopCreateSheetState();
}

class _QuickShopCreateSheetState extends ConsumerState<QuickShopCreateSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _picker = ImagePicker();
  String? _gps;
  XFile? _photo;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(onlineStatusProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesOrderGoOnlineCatalog)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      final shop = await repo.createShop(
        name: name,
        gps: _gps,
        salesPersonId: widget.salesPersonId,
      );
      final phone = _phoneController.text.trim();
      if (phone.isNotEmpty) {
        await repo.createShopContact(shopId: shop.id, contactName: name, contactMobile: phone);
      }
      if (_photo != null) {
        await ref.read(mediaCaptureFacadeProvider).attachShopPhoto(File(_photo!.path), shop.id);
      }
      if (mounted) Navigator.pop(context, shop);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
          TextField(controller: _phoneController, decoration: InputDecoration(labelText: l10n.commonPhone)),
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

class QuickVanCreateSheet extends ConsumerStatefulWidget {
  const QuickVanCreateSheet({super.key, required this.salesPersonId});

  final int? salesPersonId;

  @override
  ConsumerState<QuickVanCreateSheet> createState() => _QuickVanCreateSheetState();
}

class _QuickVanCreateSheetState extends ConsumerState<QuickVanCreateSheet> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _iqamaController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _photo;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _iqamaController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(onlineStatusProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesOrderGoOnlineCatalog)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      final van = await repo.createVan(
        name: name,
        mobile: _mobileController.text.trim().isEmpty ? null : _mobileController.text.trim(),
        iqamaNumber: _iqamaController.text.trim().isEmpty ? null : _iqamaController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
        salesPersonId: widget.salesPersonId,
      );
      if (_photo != null) {
        final bytes = await _photo!.readAsBytes();
        await repo.uploadVanImage(van.id, bytes, _photo!.name);
      }
      if (mounted) Navigator.pop(context, van);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
          TextField(controller: _mobileController, decoration: InputDecoration(labelText: l10n.commonMobile)),
          TextField(controller: _iqamaController, decoration: InputDecoration(labelText: l10n.salesQuickIqama)),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: l10n.commonEmail)),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: l10n.commonAddress)),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.commonCity)),
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

class QuickImporterCreateSheet extends ConsumerStatefulWidget {
  const QuickImporterCreateSheet({super.key, required this.salesPersonId});

  final int? salesPersonId;

  @override
  ConsumerState<QuickImporterCreateSheet> createState() => _QuickImporterCreateSheetState();
}

class _QuickImporterCreateSheetState extends ConsumerState<QuickImporterCreateSheet> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!ref.read(onlineStatusProvider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.salesOrderGoOnlineCatalog)),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonNameIsRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final importer = await ref.read(customerRepositoryProvider).createImporter(
            name: name,
            mobile: _mobileController.text.trim().isEmpty ? null : _mobileController.text.trim(),
            email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
            address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
            city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
            salesPersonId: widget.salesPersonId,
          );
      if (mounted) Navigator.pop(context, importer);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
          TextField(controller: _mobileController, decoration: InputDecoration(labelText: l10n.commonMobile)),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: l10n.commonEmail)),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: l10n.commonAddress)),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.commonCity)),
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
