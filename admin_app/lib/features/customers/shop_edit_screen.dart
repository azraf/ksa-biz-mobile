import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_ui/maps_ui.dart';

import '../../providers/repositories.dart';
import 'customer_diary_section.dart';

class ShopEditScreen extends ConsumerStatefulWidget {
  const ShopEditScreen({super.key, this.shop});

  final CustomerShopModel? shop;

  @override
  ConsumerState<ShopEditScreen> createState() => _ShopEditScreenState();
}

class _ShopEditScreenState extends ConsumerState<ShopEditScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  String? _gps;
  XFile? _shopPhoto;
  bool _saving = false;
  int? _priorityRating;
  String? _paymentOverride;
  CustomerMetricsFields _metrics = const CustomerMetricsFields();

  @override
  void initState() {
    super.initState();
    final shop = widget.shop;
    if (shop != null) {
      _nameController.text = shop.name;
      _gps = shop.gps;
      _priorityRating = shop.metrics.priorityRating;
      _paymentOverride = shop.metrics.paymentReliabilityOverride;
      _metrics = shop.metrics;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _takeShopPhoto() async {
    if (!await AppPermissions.requestCamera()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to take a shop photo.')),
      );
      return;
    }
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) setState(() => _shopPhoto = photo);
  }

  Future<void> _pickShopPhoto() async {
    if (!await AppPermissions.requestPhotos()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo library permission is required.')),
      );
      return;
    }
    final photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) setState(() => _shopPhoto = photo);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Shop name is required')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      CustomerShopModel shop;
      if (widget.shop == null) {
        shop = await repo.createShop(name: name, gps: _gps);
      } else {
        await ref.read(apiClientProvider).put('/customer-shops/${widget.shop!.id}', body: {
          'name': name,
          'gps': _gps,
          if (_priorityRating != null) 'priority_rating': _priorityRating,
          'payment_reliability_override': _paymentOverride,
        });
        shop = widget.shop!;
      }
      if (_shopPhoto != null) {
        await ref.read(mediaCaptureFacadeProvider).attachShopPhoto(File(_shopPhoto!.path), shop.id);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.shop == null ? 'New Shop' : 'Edit Shop')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          GpsLocationRow(
            gps: _gps,
            notCapturedLabel: 'Not captured',
            trailing: GpsCaptureActions(
              gps: _gps,
              captureLabel: 'Capture GPS',
              locationRequiredMessage: 'Location permission is required for shop GPS.',
              onGpsChanged: (value) => setState(() => _gps = value),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _takeShopPhoto,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Take photo'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickShopPhoto,
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Gallery'),
                ),
              ),
            ],
          ),
          if (_shopPhoto != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(File(_shopPhoto!.path), height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 24),
          if (widget.shop != null) ...[
            CustomerRatingSection(
              priorityRating: _priorityRating,
              paymentOverride: _paymentOverride,
              metrics: _metrics,
              onPriorityChanged: (v) => setState(() => _priorityRating = v),
              onPaymentOverrideChanged: (v) => setState(() => _paymentOverride = v),
            ),
            const SizedBox(height: 12),
            CustomerDiarySection(
              customerType: 'customer_shop',
              customerId: widget.shop!.id,
            ),
            const SizedBox(height: 12),
          ],
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save shop'),
          ),
        ],
      ),
    );
  }
}
