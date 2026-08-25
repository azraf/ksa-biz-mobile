import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';
import 'discount_approval_request.dart';
import 'manual_order_request.dart';
import 'order_item.dart';
import 'payment.dart';
import 'sales_person.dart';

class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.customerTypeId,
    this.invoiceNumber,
    this.salesPersonId,
    this.customerShopId,
    this.customerVanId,
    this.customerImporterId,
    this.manualOrderRequestId,
    this.subtotal = 0,
    this.vatTotal = 0,
    this.includeVat = false,
    this.vatInclusive = false,
    this.vatRate,
    this.totalBill = 0,
    this.grandDiscount = 0,
    this.promotionDiscount = 0,
    this.amountPaid = 0,
    this.amountDue = 0,
    this.paymentStatus = 'pending',
    this.status = 'confirmed',
    this.fulfillmentSource,
    this.dueDate,
    this.isOverdue = false,
    this.daysOverdue = 0,
    this.isWalkInCustomer = false,
    this.cancellationReason,
    this.cancelledAt,
    this.items = const [],
    this.payments = const [],
    this.discountRequests = const [],
    this.manualOrderRequests = const [],
    this.salesPerson,
    this.customerShopName,
    this.customerShopAreaName,
    this.createdAt,
    this.zatca,
  });

  final int id;

  /// Human-facing invoice number (SA-M…), null for offline/legacy rows.
  final String? invoiceNumber;
  final int? salesPersonId;
  final int customerTypeId;
  final int? customerVanId;
  final int? customerImporterId;
  final int? customerShopId;
  final int? manualOrderRequestId;
  final double subtotal;
  final double vatTotal;

  /// Order-level VAT flags (absent on legacy rows → false/false/null).
  final bool includeVat;
  final bool vatInclusive;
  final double? vatRate;
  final double totalBill;
  final double grandDiscount;
  final double promotionDiscount;
  final double amountPaid;
  final double amountDue;
  final String paymentStatus;
  final String status;
  final String? fulfillmentSource;
  final String? dueDate;
  final bool isOverdue;
  final int daysOverdue;
  final bool isWalkInCustomer;
  final String? cancellationReason;
  final String? cancelledAt;
  final List<OrderItemModel> items;
  final List<PaymentModel> payments;
  final List<DiscountApprovalRequestModel> discountRequests;

  /// Instructions (manual order requests) linked to this order (M:N trace).
  final List<ManualOrderRequestModel> manualOrderRequests;
  final SalesPersonModel? salesPerson;
  final String? customerShopName;
  final String? customerShopAreaName;
  final String? createdAt;

  /// Null when the server has e-invoicing off or the row predates ZATCA.
  final OrderZatcaModel? zatca;

  bool get isCancelled => status == 'cancelled';

  /// Server value renamed pending→draft; 'pending' accepted for cached rows
  /// written by older builds.
  bool get isDraft => status == 'draft' || status == 'pending';
  bool get isEditable => !isCancelled && status != 'cancellation_pending';
  bool get hasPendingDiscount => discountRequests.any((r) => r.status == 'pending');

  /// Server amount_due when set, else derived remainder (offline/legacy rows).
  double get outstandingDue => amountDue > 0 ? amountDue : totalBill - amountPaid;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String?,
      salesPersonId: json['sales_person_id'] as int?,
      customerTypeId: json['customer_type_id'] as int,
      customerVanId: json['customer_van_id'] as int?,
      customerImporterId: json['customer_importer_id'] as int?,
      customerShopId: json['customer_shop_id'] as int?,
      manualOrderRequestId: json['manual_order_request_id'] as int?,
      subtotal: _toDouble(json['subtotal']),
      vatTotal: _toDouble(json['vat_total']),
      includeVat: parseJsonBool(json['include_vat']),
      vatInclusive: parseJsonBool(json['vat_inclusive']),
      vatRate: parseJsonDoubleOrNull(json['vat_rate']),
      totalBill: _toDouble(json['total_bill']),
      grandDiscount: _toDouble(json['grand_discount']),
      promotionDiscount: _toDouble(json['promotion_discount']),
      amountPaid: _toDouble(json['amount_paid']),
      amountDue: _toDouble(json['amount_due']),
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      status: json['status'] as String? ?? 'confirmed',
      fulfillmentSource: json['fulfillment_source'] as String?,
      dueDate: json['due_date'] as String?,
      isOverdue: json['is_overdue'] as bool? ?? false,
      daysOverdue: json['days_overdue'] as int? ?? 0,
      isWalkInCustomer: json['is_walk_in_customer'] as bool? ?? false,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledAt: json['cancelled_at']?.toString(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountRequests: (json['discount_approval_requests'] as List<dynamic>? ?? [])
          .map((e) => DiscountApprovalRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      manualOrderRequests: (json['manual_order_requests'] as List<dynamic>? ?? [])
          .map((e) => ManualOrderRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      salesPerson: json['sales_person'] is Map
          ? SalesPersonModel.fromJson(json['sales_person'] as Map<String, dynamic>)
          : null,
      customerShopName: json['customer_shop'] is Map
          ? (json['customer_shop'] as Map)['name'] as String?
          : null,
      customerShopAreaName: _customerShopAreaName(json['customer_shop']),
      createdAt: json['created_at']?.toString(),
      zatca: json['zatca'] is Map
          ? OrderZatcaModel.fromJson(json['zatca'] as Map<String, dynamic>)
          : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static String? _customerShopAreaName(dynamic shopJson) {
    if (shopJson is! Map) return null;
    final shop = shopJson;
    final direct = shop['area_name'] as String?;
    if (direct != null && direct.isNotEmpty) return direct;
    if (shop['area'] is Map) {
      return (shop['area'] as Map)['name'] as String?;
    }
    return null;
  }

  @override
  List<Object?> get props => [id, status, paymentStatus, totalBill, amountPaid, amountDue];
}


/// ZATCA e-invoice state for one order (`zatca` block on the order API).
class OrderZatcaModel extends Equatable {
  const OrderZatcaModel({
    this.invoiceGenerated = false,
    this.icv,
    this.uuid,
    this.qr,
    this.status,
    this.printCount = 0,
  });

  final bool invoiceGenerated;
  final int? icv;
  final String? uuid;

  /// Base64 TLV payload for the invoice QR code.
  final String? qr;
  final String? status;
  final int printCount;

  factory OrderZatcaModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const OrderZatcaModel();
    return OrderZatcaModel(
      invoiceGenerated: json['invoice_generated'] == true,
      icv: json['icv'] as int?,
      uuid: json['uuid'] as String?,
      qr: json['qr'] as String?,
      status: json['status'] as String?,
      printCount: json['print_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [invoiceGenerated, icv, status, printCount];
}
