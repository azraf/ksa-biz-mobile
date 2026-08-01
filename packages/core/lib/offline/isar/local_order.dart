import 'package:isar_community/isar.dart';

part 'local_order.g.dart';

@embedded
class LocalOrderLine {
  int productId = 0;
  int quantity = 0;
  double productPrice = 0;
  double productDiscount = 0;
  double productVat = 0;
  double bill = 0;
  bool isPreorder = false;
}

@embedded
class LocalPayment {
  double amount = 0;
  String? paymentMethod;
  String? notes;
  String? paidAt;
}

@collection
class LocalOrder {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late int serverId;

  int? salesPersonId;
  late int customerTypeId;
  int? customerVanId;
  int? customerImporterId;
  int? customerShopId;
  int? manualOrderRequestId;

  late double subtotal;
  late double vatTotal;
  late double totalBill;
  late double grandDiscount;
  late double promotionDiscount;
  late double amountPaid;
  late double amountDue;

  @Index()
  late String status;

  @Index()
  late String paymentStatus;

  String? dueDate;
  bool isOverdue = false;
  int daysOverdue = 0;
  bool isWalkInCustomer = false;
  String? cancellationReason;
  String? cancelledAt;
  String? customerShopName;
  String? createdAt;

  @Index()
  late bool pendingSync;

  @Index()
  late DateTime updatedAt;

  List<LocalOrderLine> items = [];
  List<LocalPayment> payments = [];
}
