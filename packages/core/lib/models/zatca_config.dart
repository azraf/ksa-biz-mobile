import 'package:equatable/equatable.dart';

/// ZATCA e-invoicing config served by GET /config/mobile (`zatca` block):
/// which phase is active plus the seller identity printed on invoices.
class ZatcaConfig extends Equatable {
  const ZatcaConfig({
    this.phase = 'off',
    this.autoGenerate = false,
    this.sellerName = '',
    this.sellerNameAr = '',
    this.vatNumber = '',
    this.crNumber = '',
    this.sellerAddress = '',
  });

  final String phase;
  final bool autoGenerate;
  final String sellerName;
  final String sellerNameAr;
  final String vatNumber;
  final String crNumber;
  final String sellerAddress;

  bool get enabled => phase != 'off';

  factory ZatcaConfig.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ZatcaConfig();
    return ZatcaConfig(
      phase: json['phase'] as String? ?? 'off',
      autoGenerate: json['auto_generate'] == true,
      sellerName: json['seller_name'] as String? ?? '',
      sellerNameAr: json['seller_name_ar'] as String? ?? '',
      vatNumber: json['vat_number'] as String? ?? '',
      crNumber: json['cr_number'] as String? ?? '',
      sellerAddress: json['seller_address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'phase': phase,
        'auto_generate': autoGenerate,
        'seller_name': sellerName,
        'seller_name_ar': sellerNameAr,
        'vat_number': vatNumber,
        'cr_number': crNumber,
        'seller_address': sellerAddress,
      };

  @override
  List<Object?> get props =>
      [phase, autoGenerate, sellerName, sellerNameAr, vatNumber, crNumber, sellerAddress];
}
