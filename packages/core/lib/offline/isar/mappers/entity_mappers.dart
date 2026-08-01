import 'dart:convert';

import '../../../models/customer_assignment_models.dart';
import '../../../models/admin_models.dart';
import '../../../models/customer.dart';
import '../../../models/customer_diary_note.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../../../models/payment.dart';
import '../../../models/product.dart';
import '../../../models/watchlist_item.dart';
import '../local_customer.dart';
import '../local_diary.dart';
import '../local_order.dart';
import '../local_product.dart';
import '../local_watchlist.dart';

class OrderMapper {
  static LocalOrder fromModel(OrderModel model, {bool pendingSync = false}) {
    final order = LocalOrder()
      ..serverId = model.id
      ..salesPersonId = model.salesPersonId
      ..customerTypeId = model.customerTypeId
      ..customerVanId = model.customerVanId
      ..customerImporterId = model.customerImporterId
      ..customerShopId = model.customerShopId
      ..manualOrderRequestId = model.manualOrderRequestId
      ..subtotal = model.subtotal
      ..vatTotal = model.vatTotal
      ..totalBill = model.totalBill
      ..grandDiscount = model.grandDiscount
      ..promotionDiscount = model.promotionDiscount
      ..amountPaid = model.amountPaid
      ..amountDue = model.amountDue
      ..status = model.status
      ..paymentStatus = model.paymentStatus
      ..dueDate = model.dueDate
      ..isOverdue = model.isOverdue
      ..daysOverdue = model.daysOverdue
      ..isWalkInCustomer = model.isWalkInCustomer
      ..cancellationReason = model.cancellationReason
      ..cancelledAt = model.cancelledAt
      ..customerShopName = model.customerShopName
      ..createdAt = model.createdAt
      ..pendingSync = pendingSync || model.id < 0
      ..updatedAt = DateTime.now()
      ..items = model.items
          .map(
            (i) => LocalOrderLine()
              ..productId = i.productId
              ..quantity = i.quantity
              ..productPrice = i.productPrice
              ..productDiscount = i.productDiscount
              ..productVat = i.productVat
              ..bill = i.bill
              ..isPreorder = i.isPreorder,
          )
          .toList()
      ..payments = model.payments
          .map(
            (p) => LocalPayment()
              ..amount = p.amount
              ..paymentMethod = p.paymentMethod
              ..notes = p.notes
              ..paidAt = p.paidAt,
          )
          .toList();
    return order;
  }

  static LocalOrder fromJson(Map<String, dynamic> json) =>
      fromModel(OrderModel.fromJson(json), pendingSync: json['_pending_sync'] == true);

  static OrderModel toModel(LocalOrder local) {
    return OrderModel(
      id: local.serverId,
      salesPersonId: local.salesPersonId,
      customerTypeId: local.customerTypeId,
      customerVanId: local.customerVanId,
      customerImporterId: local.customerImporterId,
      customerShopId: local.customerShopId,
      manualOrderRequestId: local.manualOrderRequestId,
      subtotal: local.subtotal,
      vatTotal: local.vatTotal,
      totalBill: local.totalBill,
      grandDiscount: local.grandDiscount,
      promotionDiscount: local.promotionDiscount,
      amountPaid: local.amountPaid,
      amountDue: local.amountDue,
      paymentStatus: local.paymentStatus,
      status: local.status,
      dueDate: local.dueDate,
      isOverdue: local.isOverdue,
      daysOverdue: local.daysOverdue,
      isWalkInCustomer: local.isWalkInCustomer,
      cancellationReason: local.cancellationReason,
      cancelledAt: local.cancelledAt,
      customerShopName: local.customerShopName,
      createdAt: local.createdAt,
      items: local.items
          .map(
            (i) => OrderItemModel(
              id: 0,
              productId: i.productId,
              quantity: i.quantity,
              productPrice: i.productPrice,
              productDiscount: i.productDiscount,
              productVat: i.productVat,
              bill: i.bill,
              isPreorder: i.isPreorder,
            ),
          )
          .toList(),
      payments: local.payments
          .map(
            (p) => PaymentModel(
              id: 0,
              orderId: local.serverId,
              amount: p.amount,
              paymentMethod: p.paymentMethod,
              notes: p.notes,
              paidAt: p.paidAt,
            ),
          )
          .toList(),
    );
  }

  static Map<String, dynamic> toCacheJson(LocalOrder local) {
    final model = toModel(local);
    return {
      'id': model.id,
      'sales_person_id': model.salesPersonId,
      'customer_type_id': model.customerTypeId,
      'customer_van_id': model.customerVanId,
      'customer_importer_id': model.customerImporterId,
      'customer_shop_id': model.customerShopId,
      'total_bill': model.totalBill,
      'grand_discount': model.grandDiscount,
      'amount_paid': model.amountPaid,
      'amount_due': model.amountDue,
      'payment_status': model.paymentStatus,
      'status': model.status,
      'items': model.items
          .map((i) => {
                'product_id': i.productId,
                'quantity': i.quantity,
                'product_price': i.productPrice,
              })
          .toList(),
      'created_at': model.createdAt,
      '_pending_sync': local.pendingSync,
    };
  }
}

class ProductMapper {
  static LocalProduct fromModel(ProductModel model) {
    return LocalProduct()
      ..serverId = model.id
      ..name = model.name
      ..price = model.price
      ..wholesalePrice = model.wholesalePrice
      ..alertQuantity = model.alertQuantity
      ..description = model.description
      ..allowBreakPack = model.allowBreakPack
      ..piecesPerCarton = model.piecesPerCarton
      ..piecePrice = model.piecePrice
      ..pcsUnitId = model.pcsUnitId
      ..cartonUnitId = model.cartonUnitId
      ..unitId = model.unitId
      ..updatedAt = DateTime.now();
  }

  static ProductModel toModel(LocalProduct local) {
    return ProductModel(
      id: local.serverId,
      name: local.name,
      price: local.price,
      wholesalePrice: local.wholesalePrice,
      alertQuantity: local.alertQuantity,
      description: local.description,
      allowBreakPack: local.allowBreakPack,
      piecesPerCarton: local.piecesPerCarton,
      piecePrice: local.piecePrice,
      pcsUnitId: local.pcsUnitId,
      cartonUnitId: local.cartonUnitId,
      unitId: local.unitId,
    );
  }
}

class CustomerMapper {
  static LocalCustomerShop shopFromModel(CustomerShopModel shop, {int? salesPersonId}) {
    return LocalCustomerShop()
      ..serverId = shop.id
      ..name = shop.name
      ..phone = shop.primaryContact?.contactMobile ?? ''
      ..salesPersonId = salesPersonId
      ..areaId = shop.areaId
      ..areaName = shop.areaName
      ..gps = shop.gps
      ..isSystem = shop.isSystem
      ..isInactive = shop.isInactive
      ..contactName = shop.primaryContact?.contactName
      ..lastOrderAt = shop.lastOrderAt
      ..salesPersonNameKey = '${salesPersonId ?? 0}_${shop.name}';
  }

  static CustomerShopModel shopToModel(LocalCustomerShop local) {
    return CustomerShopModel(
      id: local.serverId,
      name: local.name,
      gps: local.gps,
      isSystem: local.isSystem,
      areaId: local.areaId,
      areaName: local.areaName,
      lastOrderAt: local.lastOrderAt,
      isInactive: local.isInactive,
      primaryContact: local.contactName != null || local.phone.isNotEmpty
          ? PrimaryContactModel(
              contactName: local.contactName,
              contactMobile: local.phone.isEmpty ? null : local.phone,
            )
          : null,
    );
  }

  static LocalCustomerVan vanFromModel(CustomerVanModel van, {int? salesPersonId}) {
    return LocalCustomerVan()
      ..serverId = van.id
      ..name = van.name
      ..mobile = van.mobile ?? ''
      ..salesPersonId = salesPersonId
      ..areaId = van.areaId
      ..isInactive = van.isInactive;
  }

  static CustomerVanModel vanToModel(LocalCustomerVan local) {
    return CustomerVanModel(
      id: local.serverId,
      name: local.name,
      mobile: local.mobile.isEmpty ? null : local.mobile,
      areaId: local.areaId,
      isInactive: local.isInactive,
    );
  }

  static LocalCustomerImporter importerFromModel(CustomerImporterModel importer, {int? salesPersonId}) {
    return LocalCustomerImporter()
      ..serverId = importer.id
      ..name = importer.name
      ..mobile = importer.mobile ?? ''
      ..salesPersonId = salesPersonId;
  }

  static CustomerImporterModel importerToModel(LocalCustomerImporter local) {
    return CustomerImporterModel(
      id: local.serverId,
      name: local.name,
      mobile: local.mobile.isEmpty ? null : local.mobile,
    );
  }

  static LocalCustomerType typeFromModel(CustomerTypeModel type) {
    return LocalCustomerType()
      ..serverId = type.id
      ..typeName = type.typeName;
  }

  static CustomerTypeModel typeToModel(LocalCustomerType local) {
    return CustomerTypeModel(id: local.serverId, typeName: local.typeName);
  }
}

class WatchlistMapper {
  static LocalWatchlistItem fromModel(WatchlistItemModel item, {bool pendingSync = false}) {
    return LocalWatchlistItem()
      ..serverId = item.id
      ..salesPersonId = item.salesPersonId
      ..gps = item.gps
      ..placeName = item.placeName
      ..noteText = item.noteText
      ..status = item.status
      ..archivedReason = item.archivedReason
      ..customerShopId = item.customerShopId
      ..createdAt = item.createdAt
      ..pendingSync = pendingSync || item.isLocalOnly
      ..updatedAt = DateTime.now();
  }

  static WatchlistItemModel toModel(LocalWatchlistItem local) {
    return WatchlistItemModel(
      id: local.serverId,
      localId: local.serverId < 0 ? local.serverId : null,
      salesPersonId: local.salesPersonId,
      gps: local.gps,
      placeName: local.placeName,
      noteText: local.noteText,
      status: local.status,
      archivedReason: local.archivedReason,
      customerShopId: local.customerShopId,
      isLocalOnly: local.pendingSync,
      createdAt: local.createdAt,
    );
  }
}

class DiaryMapper {
  static LocalDiaryNote fromModel(
    CustomerDiaryNoteModel note, {
    required int customerId,
    bool pendingSync = false,
  }) {
    return LocalDiaryNote()
      ..serverId = note.id
      ..customerType = note.customerType
      ..customerId = customerId
      ..customerKey = '${note.customerType}_$customerId'
      ..noteType = note.noteType
      ..body = note.body
      ..customerShopId = note.customerShopId
      ..customerVanId = note.customerVanId
      ..customerImporterId = note.customerImporterId
      ..createdAt = note.createdAt
      ..pendingSync = pendingSync || note.isLocalOnly
      ..updatedAt = DateTime.now();
  }

  static CustomerDiaryNoteModel toModel(LocalDiaryNote local) {
    return CustomerDiaryNoteModel(
      id: local.serverId,
      customerType: local.customerType,
      noteType: local.noteType,
      body: local.body,
      customerShopId: local.customerShopId,
      customerVanId: local.customerVanId,
      customerImporterId: local.customerImporterId,
      isLocalOnly: local.pendingSync,
      createdAt: local.createdAt,
    );
  }
}

String encodeJson(Map<String, dynamic> data) => jsonEncode(data);

Map<String, dynamic> decodeJson(String json) =>
    jsonDecode(json) as Map<String, dynamic>;
