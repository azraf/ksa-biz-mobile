// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonSubmit => 'إرسال';

  @override
  String get commonSkip => 'تخطي';

  @override
  String get commonAdd => 'إضافة';

  @override
  String get commonPhoto => 'صورة';

  @override
  String get commonVoice => 'صوت';

  @override
  String get commonStop => 'إيقاف';

  @override
  String get commonLoading => 'جارٍ التحميل...';

  @override
  String get commonSignIn => 'تسجيل الدخول';

  @override
  String get commonSignOut => 'تسجيل الخروج';

  @override
  String get commonEmail => 'البريد الإلكتروني';

  @override
  String get commonPassword => 'كلمة المرور';

  @override
  String get commonApiBaseUrl => 'رابط واجهة API';

  @override
  String get commonApiUrl => 'رابط API';

  @override
  String get commonRoles => 'الأدوار';

  @override
  String get commonActingAs => 'يعمل باسم';

  @override
  String get commonUser => 'مستخدم';

  @override
  String get commonPhone => 'الهاتف';

  @override
  String get commonMobile => 'الجوال';

  @override
  String get commonNameRequired => 'الاسم *';

  @override
  String get commonAddress => 'العنوان';

  @override
  String get commonCity => 'المدينة';

  @override
  String get commonReason => 'السبب';

  @override
  String get commonQuantity => 'الكمية';

  @override
  String get commonNotes => 'ملاحظات';

  @override
  String get commonNotesOptional => 'ملاحظات (اختياري)';

  @override
  String get commonItems => 'العناصر';

  @override
  String get commonNoItemsYet => 'لا توجد عناصر بعد';

  @override
  String commonTotal(String amount) {
    return 'الإجمالي: $amount';
  }

  @override
  String get commonUnit => 'الوحدة';

  @override
  String get commonUnitCarton => 'كرتون (CTN)';

  @override
  String commonUnitPiece(int piecesPerCarton) {
    return 'قطعة (pcs) · $piecesPerCarton لكل كرتون';
  }

  @override
  String get commonPrice => 'السعر';

  @override
  String get commonDiscount => 'الخصم';

  @override
  String get commonVat => 'ضريبة القيمة المضافة';

  @override
  String get commonIncludeVat => 'تضمين ضريبة القيمة المضافة (15%)';

  @override
  String get commonIncludeVatSubtitle => 'إضافة 15% ضريبة إلى إجمالي الطلب';

  @override
  String get commonSearchProducts => 'البحث عن المنتجات';

  @override
  String commonProductPriceCtn(String price, String pieces) {
    return 'ر.س $price / كرتون · $pieces قطعة';
  }

  @override
  String commonProductPrice(String price) {
    return 'ر.س $price';
  }

  @override
  String commonQtyLine(String quantity) {
    return 'الكمية $quantity';
  }

  @override
  String commonQtyAtPrice(String quantity, String price) {
    return 'الكمية $quantity @ $price';
  }

  @override
  String commonProductFallback(int id) {
    return 'منتج #$id';
  }

  @override
  String commonShopFallback(int id) {
    return 'متجر #$id';
  }

  @override
  String commonOrderNumber(int id) {
    return 'طلب #$id';
  }

  @override
  String commonRequestNumber(int id) {
    return 'طلب #$id';
  }

  @override
  String get commonRecording => 'تسجيل';

  @override
  String get commonRecordings => 'التسجيلات';

  @override
  String get commonAddRecording => 'إضافة تسجيل';

  @override
  String get commonRecordAudio => 'تسجيل صوت';

  @override
  String get commonRecordVideo => 'تسجيل فيديو';

  @override
  String get commonStopAndUpload => 'إيقاف ورفع';

  @override
  String get commonRecordingUploaded => 'تم رفع التسجيل';

  @override
  String get commonCall => 'اتصال';

  @override
  String get commonWhatsapp => 'واتساب';

  @override
  String commonCouldNotOpen(String action) {
    return 'تعذر فتح $action';
  }

  @override
  String get commonPhoneDialer => 'مُطبّق الاتصال';

  @override
  String get commonDiary => 'اليوميات';

  @override
  String commonDiaryTitle(String customerName) {
    return 'اليوميات — $customerName';
  }

  @override
  String get commonDiaryNote => 'ملاحظة يومية';

  @override
  String get commonDiaryEmpty => 'لا توجد ملاحظات يومية بعد.';

  @override
  String get commonDiaryText => 'نص';

  @override
  String get commonDiaryLoadMore => 'تحميل المزيد';

  @override
  String get commonDiaryPlayVoice => 'تشغيل الملاحظة الصوتية';

  @override
  String get commonAddNote => 'إضافة ملاحظة';

  @override
  String get commonTextNote => 'ملاحظة نصية';

  @override
  String get commonRecordingTitle => 'جارٍ التسجيل...';

  @override
  String get commonStopAndSave => 'إيقاف وحفظ';

  @override
  String get commonAddVisitNoteTitle => 'إضافة ملاحظة زيارة؟';

  @override
  String commonAddVisitNoteBody(String customerName) {
    return 'إضافة ملاحظة يومية لـ $customerName؟';
  }

  @override
  String get commonGpsNotCaptured => 'لم يُلتقط';

  @override
  String get commonGpsCapturing => 'جارٍ الالتقاط...';

  @override
  String get commonGpsRefresh => 'تحديث';

  @override
  String get commonGpsCapture => 'التقاط GPS';

  @override
  String get commonGpsLocationRequired => 'إذن الموقع مطلوب لـ GPS المتجر.';

  @override
  String get commonCameraPermission => 'إذن الكاميرا مطلوب.';

  @override
  String get commonMicrophonePermission => 'إذن الميكروفون مطلوب.';

  @override
  String get commonRecordingPermission => 'الإذن مطلوب لاختيار التسجيلات.';

  @override
  String get commonAll => 'الكل';

  @override
  String get commonCash => 'نقدي';

  @override
  String get commonBankTransfer => 'تحويل بنكي';

  @override
  String get commonCheque => 'شيك';

  @override
  String get commonOther => 'أخرى';

  @override
  String get commonNoProductsFound => 'لم يُعثر على منتجات';

  @override
  String get commonNoProductsCached =>
      'لا توجد منتجات مخزنة. اتصل بالإنترنت لتحميل البيانات.';

  @override
  String get commonNameIsRequired => 'الاسم مطلوب';

  @override
  String get commonAddAtLeastOneProduct => 'أضف منتجاً واحداً على الأقل';

  @override
  String get commonPlaceOrder => 'تأكيد الطلب';

  @override
  String commonSourceLabel(String source) {
    return 'المصدر: $source';
  }

  @override
  String get commonReference => 'المرجع';

  @override
  String get commonCallReference => 'مرجع المكالمة';

  @override
  String get commonManualOrderRequest => 'طلب يدوي';

  @override
  String get commonOrderNotes => 'ملاحظات الطلب';

  @override
  String get commonOrderNotesHint => 'صف المنتجات والكميات أو التعليمات الخاصة';

  @override
  String get commonSubmitRequest => 'إرسال الطلب';

  @override
  String get commonNewOrder => 'طلب جديد';

  @override
  String get commonNoOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get commonCreateOrder => 'إنشاء طلب';

  @override
  String get commonOrderDetail => 'تفاصيل الطلب';

  @override
  String get commonEditOrder => 'تعديل الطلب';

  @override
  String get commonCustomer => 'العميل';

  @override
  String get commonPaid => 'مدفوع';

  @override
  String get commonDue => 'مستحق';

  @override
  String get commonTotalLabel => 'الإجمالي';

  @override
  String get commonGrandDiscount => 'خصم إجمالي';

  @override
  String get commonDueDate => 'تاريخ الاستحقاق';

  @override
  String get commonOverdue => 'متأخر';

  @override
  String commonOverdueDays(int days) {
    return '$days يوم';
  }

  @override
  String get commonPayments => 'المدفوعات';

  @override
  String get commonLanguage => 'اللغة';

  @override
  String get commonLanguageEnglish => 'English';

  @override
  String get commonLanguageArabic => 'العربية';

  @override
  String get commonLanguageBangla => 'বাংলা';

  @override
  String get commonConvert => 'تحويل';

  @override
  String get commonPickVideo => 'اختيار فيديو';

  @override
  String get salesAppName => 'ARM Sales';

  @override
  String get salesSignInSubtitle => 'سجّل الدخول بحساب مندوب المبيعات';

  @override
  String get salesNavHome => 'الرئيسية';

  @override
  String get salesNavManual => 'يدوي';

  @override
  String get salesNavOrders => 'الطلبات';

  @override
  String get salesNavVan => 'الشاحنة';

  @override
  String get salesNavDues => 'المستحقات';

  @override
  String get salesTitleDashboard => 'لوحة التحكم';

  @override
  String get salesTitleManualOrders => 'الطلبات اليدوية';

  @override
  String get salesTitleOrders => 'الطلبات';

  @override
  String get salesTitleVanStock => 'مخزون الشاحنة';

  @override
  String get salesTitleDues => 'المستحقات';

  @override
  String get salesTitleCreateOrder => 'إنشاء طلب';

  @override
  String get salesTitleEditOrder => 'تعديل الطلب';

  @override
  String get salesTitleOrderDetail => 'تفاصيل الطلب';

  @override
  String get salesTitleConvertOrder => 'تحويل إلى طلب';

  @override
  String get salesTitleManualOrder => 'طلب يدوي';

  @override
  String get salesTitleLoadVan => 'تحميل الشاحنة';

  @override
  String get salesTitleTransferStock => 'نقل المخزون';

  @override
  String get salesTitleDamageReplacement => 'استبدال تالف';

  @override
  String get salesTitleProductExchange => 'تبديل منتج';

  @override
  String get salesSelectSalesperson => 'اختر مندوب المبيعات';

  @override
  String get salesSearchSalesperson => 'البحث بالاسم أو البريد';

  @override
  String get salesNoSalespeople => 'لم يُعثر على مندوبي مبيعات';

  @override
  String get salesProfile => 'الملف الشخصي';

  @override
  String get salesSalespersonProfile => 'ملف مندوب المبيعات';

  @override
  String get salesNoSalespersonSelected => 'لم يُختر مندوب مبيعات';

  @override
  String get salesChooseSalespersonHint =>
      'اختر مندوب مبيعات لأداء مهام المبيعات.';

  @override
  String get salesSelectSalespersonBtn => 'اختر مندوب المبيعات';

  @override
  String get salesChangeSalespersonBtn => 'تغيير مندوب المبيعات';

  @override
  String get salesSelectSalespersonFirst => 'اختر مندوب مبيعات أولاً.';

  @override
  String get salesDashboardLoading => 'جارٍ تحميل لوحة التحكم...';

  @override
  String get salesDashboardSelectSp => 'اختر مندوب مبيعات لعرض لوحة التحكم.';

  @override
  String get salesDashboardNoProfile => 'حسابك غير مرتبط بملف مندوب مبيعات.';

  @override
  String salesHello(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get salesDefaultSalesperson => 'مندوب مبيعات';

  @override
  String salesActingAsName(String name) {
    return 'يعمل باسم: $name';
  }

  @override
  String get salesCardOutstandingDues => 'المستحقات المعلقة';

  @override
  String salesCardUnpaidOrders(int count) {
    return '$count طلبات غير مدفوعة';
  }

  @override
  String get salesCardManualOrders => 'الطلبات اليدوية';

  @override
  String get salesCardManualSubtitle => 'مفتوح / معيّن / قيد المراجعة';

  @override
  String get salesCardVanStock => 'مخزون الشاحنة';

  @override
  String salesCardVanProducts(int count) {
    return '$count منتجات';
  }

  @override
  String salesCardLowStockAlerts(int count) {
    return '$count تنبيهات مخزون منخفض';
  }

  @override
  String get salesCardTapManageStock => 'اضغط لإدارة المخزون';

  @override
  String get salesCardMyOrders => 'طلباتي';

  @override
  String get salesCardViewAll => 'عرض الكل';

  @override
  String get salesCardOrdersSubtitle => 'إنشاء وتعديل الطلبات';

  @override
  String get salesCardWatchlist => 'قائمة المراقبة';

  @override
  String get salesCardWatchlistValue => 'حفظ العملاء المحتملين';

  @override
  String get salesCardWatchlistSubtitle => 'مواقع GPS للزيارات المستقبلية';

  @override
  String get salesQuickSaveLocation => 'حفظ الموقع الحالي سريعاً';

  @override
  String get salesLocationSaved => 'تم حفظ الموقع في قائمة المراقبة';

  @override
  String get salesAddNotesAction => 'إضافة ملاحظات';

  @override
  String salesNearbyShop(String name, String distance) {
    return 'متجر قريب: $name ($distanceم)';
  }

  @override
  String salesDuplicateWatchlist(String distance) {
    return 'تكرار في قائمة المراقبة ضمن $distanceم';
  }

  @override
  String get salesDuesTotalDue => 'إجمالي المستحق';

  @override
  String get salesDuesNone => 'لا توجد مستحقات معلقة';

  @override
  String get salesDuesLongPressHint => 'اضغط مطولاً على طلب لتحصيل الدفع';

  @override
  String get salesNotifications => 'الإشعارات';

  @override
  String get salesNotificationsEmpty => 'لا توجد إشعارات';

  @override
  String get salesOfflineMode => 'وضع عدم الاتصال';

  @override
  String get salesOfflineSync => 'مزامنة';

  @override
  String salesOfflineSyncing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات معلقة...',
      one: 'تغيير واحد معلق...',
    );
    return 'جارٍ مزامنة $_temp0';
  }

  @override
  String salesOfflineSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تغييرات محفوظة محلياً',
      one: 'تغيير واحد محفوظ محلياً',
    );
    return 'غير متصل — $_temp0';
  }

  @override
  String get salesOfflineAllSynced => 'تمت مزامنة جميع التغييرات';

  @override
  String salesOfflineSyncProgress(int completed, int total) {
    return 'Syncing $completed of $total…';
  }

  @override
  String salesDashboardCachedDues(String fetchedAt) {
    return 'عرض المستحقات المخزنة من $fetchedAt';
  }

  @override
  String get salesManualTabOpenPool => 'المجموعة المفتوحة';

  @override
  String get salesManualTabAssigned => 'معيّن';

  @override
  String get salesManualTabInReview => 'قيد المراجعة';

  @override
  String get salesManualTabConverted => 'تم التحويل';

  @override
  String get salesManualEmpty => 'لا توجد طلبات يدوية';

  @override
  String get salesManualClaimed => 'تم المطالبة بالطلب';

  @override
  String get salesManualClaimRequest => 'المطالبة بالطلب';

  @override
  String get salesManualConvertOrder => 'تحويل إلى طلب';

  @override
  String get salesManualViewConverted => 'عرض الطلب المحوّل';

  @override
  String get salesManualTakeShopPhoto => 'التقاط صورة المتجر';

  @override
  String get salesManualShopPhotoUploaded => 'تم رفع صورة المتجر';

  @override
  String get salesManualGpsCleared => 'تم مسح GPS المتجر';

  @override
  String salesManualGpsUpdated(String gps) {
    return 'تم تحديث GPS: $gps';
  }

  @override
  String get salesConvertShopOrder => 'طلب متجر';

  @override
  String get salesConvertOrderItems => 'عناصر الطلب';

  @override
  String get salesConvertAddProduct => 'إضافة منتج';

  @override
  String get salesConvertOrderCreated => 'تم إنشاء الطلب';

  @override
  String get salesOrderWalkInQuick => 'طلب سريع بدون موعد';

  @override
  String get salesOrderWalkInShop => 'متجر بدون موعد';

  @override
  String get salesOrderWalkInSubtitle => 'بيع سريع مجهول';

  @override
  String get salesOrderWalkInNote => 'ملاحظة (اختياري)';

  @override
  String get salesOrderWalkInNoteHint => 'ملاحظة أمين الصندوق';

  @override
  String get salesOrderCustomerType => 'نوع العميل';

  @override
  String get salesOrderSelectCustomer => 'اختر العميل';

  @override
  String get salesOrderSelected => 'محدد';

  @override
  String get salesOrderAddCustomer => 'إضافة عميل';

  @override
  String get salesOrderSelectCustomerItems => 'اختر العميل وأضف العناصر';

  @override
  String get salesOrderSavedLocally =>
      'تم حفظ الطلب محلياً — ستتم المزامنة عند الاتصال';

  @override
  String get salesErrorOffline =>
      'No internet connection. Showing saved data when available.';

  @override
  String get salesErrorGeneric => 'Something went wrong. Please try again.';

  @override
  String get salesErrorTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get salesErrorUnauthorized =>
      'Your session expired. Please sign in again.';

  @override
  String get adminAccessRequired =>
      'لا يمكن لهذا الحساب استخدام تطبيق الإدارة. مطلوب دور المسؤول.';

  @override
  String get adminLoginInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get salesOfflineServerUnreachable => 'متصل ولكن الخادم غير متاح';

  @override
  String get salesOfflineRetryUploads => 'إعادة رفع الملفات';

  @override
  String salesOfflineUploadFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'فشل رفع $count ملفات',
      one: 'فشل رفع ملف واحد',
    );
    return '$_temp0';
  }

  @override
  String salesOfflineUploading(int percent) {
    return 'جارٍ الرفع… $percent%';
  }

  @override
  String get adminOfflineWriteBlocked =>
      'This action requires an internet connection.';

  @override
  String adminShowingCachedList(String fetchedAt) {
    return 'Showing cached list from $fetchedAt';
  }

  @override
  String get adminDashboardSalesMonth => 'Sales (this month)';

  @override
  String get adminDashboardExpensesYtd => 'Expenses (YTD)';

  @override
  String get adminDashboardPendingManual => 'Pending manual orders';

  @override
  String get salesOrderWalkInUnavailable =>
      'متجر بدون موعد غير متاح. اتصل بالإنترنت للمزامنة.';

  @override
  String get salesOrderGoOnlineCatalog =>
      'اتصل بالإنترنت أولاً لتحميل بيانات العملاء والمنتجات.';

  @override
  String get salesOrderNoCustomerTypes =>
      'لا تتوفر أنواع عملاء. اتصل بالإنترنت للتحديث.';

  @override
  String get salesOrderCannotEdit => 'لا يمكن تعديل هذا الطلب.';

  @override
  String get salesOrderAddProduct => 'إضافة منتج';

  @override
  String get salesOrderChangeQty => 'تغيير الكمية';

  @override
  String get salesOrderSalesReturn => 'مرتجع مبيعات';

  @override
  String get salesOrderReturn => 'إرجاع';

  @override
  String get salesOrderRemoveItem => 'إزالة عنصر';

  @override
  String get salesOrderUpdateQty => 'تحديث الكمية';

  @override
  String get salesOrderCollectPayment => 'تحصيل الدفع';

  @override
  String salesOrderCollectPaymentTitle(int orderId) {
    return 'تحصيل الدفع #$orderId';
  }

  @override
  String get salesOrderAmountDue => 'المبلغ المستحق';

  @override
  String get salesOrderAmountCollected => 'المبلغ المحصّل';

  @override
  String get salesOrderPaymentMethod => 'طريقة الدفع';

  @override
  String get salesOrderRecordPayment => 'تسجيل الدفع';

  @override
  String get salesOrderEnterValidAmount => 'أدخل مبلغاً صالحاً';

  @override
  String get salesOrderRequestDiscount => 'طلب خصم';

  @override
  String get salesOrderRequestGrandDiscount => 'طلب خصم إجمالي';

  @override
  String get salesOrderDiscountAmount => 'مبلغ الخصم (ر.س)';

  @override
  String get salesOrderDiscountSubmitted => 'تم إرسال طلب الخصم';

  @override
  String get salesOrderCancelOrder => 'إلغاء الطلب';

  @override
  String get salesOrderCancelled => 'تم إلغاء الطلب';

  @override
  String get salesOrderEditTooltip => 'تعديل الطلب';

  @override
  String get salesPickerSelectShop => 'اختر متجراً';

  @override
  String get salesPickerSelectVan => 'اختر شاحنة';

  @override
  String get salesPickerSelectImporter => 'اختر مستورداً';

  @override
  String get salesPickerSearchHint => 'البحث بالاسم أو الهاتف أو جهة الاتصال';

  @override
  String get salesPickerNoCustomers => 'لم يُعثر على عملاء';

  @override
  String get salesQuickNewShop => 'متجر جديد';

  @override
  String get salesQuickShopName => 'اسم المتجر *';

  @override
  String get salesQuickSaveShop => 'حفظ المتجر';

  @override
  String get salesQuickNewVan => 'عميل شاحنة جديد';

  @override
  String get salesQuickIqama => 'الإقامة';

  @override
  String get salesQuickSaveVan => 'حفظ الشاحنة';

  @override
  String get salesQuickNewImporter => 'مستورد جديد';

  @override
  String get salesQuickSaveImporter => 'حفظ المستورد';

  @override
  String get salesVanEmpty => 'الشاحنة فارغة';

  @override
  String get salesVanLowStock => 'مخزون منخفض';

  @override
  String get salesVanExchange => 'تبديل';

  @override
  String get salesVanDamage => 'تالف';

  @override
  String get salesVanTransfer => 'نقل';

  @override
  String get salesVanLoad => 'تحميل الشاحنة';

  @override
  String get salesVanUnloadMessage => 'إرجاع المخزون من الشاحنة إلى المستودع.';

  @override
  String get salesVanUnloadQty => 'الكمية (كراتين)';

  @override
  String get salesVanUnloadBtn => 'تفريغ';

  @override
  String get salesVanLoadSelectAll => 'تحديد الكل';

  @override
  String get salesVanLoadNoStock => 'لا يوجد مخزون في المستودع';

  @override
  String salesVanLoadAvailable(String balance) {
    return 'متاح: $balance';
  }

  @override
  String get salesVanLoadSelectOne => 'اختر منتجاً واحداً على الأقل';

  @override
  String salesVanLoadSuccess(int count) {
    return 'تم تحميل $count منتج(ات) إلى الشاحنة';
  }

  @override
  String get salesVanLoadAll => 'تحميل كل المتاح';

  @override
  String get salesVanLoadSelected => 'تحميل المحدد';

  @override
  String get salesVanTransferProduct => 'منتج شاحنتك';

  @override
  String get salesVanTransferTo => 'نقل إلى';

  @override
  String get salesVanTransferCompleted => 'اكتمل النقل';

  @override
  String get salesVanDamageSelect => 'اختر المنتج';

  @override
  String get salesVanDamageRecord => 'تسجيل الاستبدال';

  @override
  String get salesVanExchangeReturns => 'مرتجعات العميل';

  @override
  String get salesVanExchangeSelectReturn => 'اختر منتج الإرجاع';

  @override
  String get salesVanExchangeReturnQty => 'كمية الإرجاع';

  @override
  String get salesVanExchangeSettlement => 'التسوية';

  @override
  String get salesVanExchangeGiveProduct => 'إعطاء منتج آخر';

  @override
  String get salesVanExchangeCashRefund => 'استرداد نقدي';

  @override
  String get salesVanExchangeGiveTo => 'إعطاء للعميل';

  @override
  String get salesVanExchangeSelectOut => 'اختر منتج الإخراج';

  @override
  String get salesVanExchangeOutQty => 'كمية الإخراج';

  @override
  String get salesVanExchangeCashAmount => 'المبلغ النقدي (ر.س)';

  @override
  String get salesVanExchangeRecord => 'تسجيل التبديل';

  @override
  String get salesWatchlist => 'قائمة المراقبة';

  @override
  String get salesWatchlistMap => 'خريطة قائمة المراقبة';

  @override
  String get salesWatchlistViewMap => 'عرض على الخريطة';

  @override
  String get salesWatchlistSortDistance => 'ترتيب حسب المسافة';

  @override
  String get salesWatchlistActive => 'نشط';

  @override
  String get salesWatchlistArchived => 'مؤرشف';

  @override
  String get salesWatchlistAddLocation => 'إضافة موقع';

  @override
  String get salesWatchlistLoading => 'جارٍ تحميل قائمة المراقبة...';

  @override
  String get salesWatchlistEmpty => 'لا توجد عناصر في قائمة المراقبة بعد.';

  @override
  String get salesWatchlistSaveTitle => 'حفظ في قائمة المراقبة';

  @override
  String get salesWatchlistPlaceName => 'اسم المكان';

  @override
  String get salesWatchlistNoteOptional => 'ملاحظة (اختياري)';

  @override
  String get salesWatchlistSaveLocation => 'حفظ الموقع';

  @override
  String get salesWatchlistVoicePending =>
      'يُحفظ الصوت بعد إنشاء الإدخال (الرفع من التفاصيل).';

  @override
  String get salesWatchlistPhotosAfterSave =>
      'أضف الصور بعد الحفظ من شاشة التفاصيل.';

  @override
  String get salesWatchlistDeleteTitle => 'حذف إدخال قائمة المراقبة؟';

  @override
  String get salesWatchlistSyncBeforeConvert =>
      'زامن هذا العنصر عبر الإنترنت قبل التحويل.';

  @override
  String get salesWatchlistConvertTitle => 'تحويل إلى متجر';

  @override
  String get salesWatchlistShopName => 'اسم المتجر *';

  @override
  String get salesWatchlistPriorityRating => 'تقييم الأولوية';

  @override
  String get salesWatchlistShopCreated => 'تم إنشاء المتجر';

  @override
  String get salesWatchlistSyncBeforeUpload =>
      'زامن هذا العنصر قبل رفع المرفقات.';

  @override
  String get salesWatchlistRecordingHint =>
      'جارٍ التسجيل… اضغط صوت مرة أخرى للإيقاف (3 دقائق كحد أقصى)';

  @override
  String get salesWatchlistMarkVisited => 'تحديد كمُزار';

  @override
  String get salesWatchlistDismiss => 'رفض';

  @override
  String get salesWatchlistVoiceNotes => 'ملاحظات صوتية';

  @override
  String get salesWatchlistPhotos => 'الصور';

  @override
  String get salesWatchlistConvertBtn => 'تحويل إلى متجر';

  @override
  String get salesWatchlistPendingSync => 'في انتظار المزامنة';

  @override
  String get salesWatchlistActivateAgain => 'تفعيل مرة أخرى';

  @override
  String get salesWatchlistRemove => 'إزالة';

  @override
  String get salesWatchlistActivated => 'تم تفعيل عنصر قائمة المراقبة';

  @override
  String salesWatchlistArchivedReason(String reason) {
    return 'مؤرشف: $reason';
  }

  @override
  String get orderAppName => 'ARM Orders';

  @override
  String get orderSignInSubtitle =>
      'سجّل الدخول بحساب متجرك أو شاحنتك أو الاستيراد';

  @override
  String get orderNavCatalog => 'الكتالوج';

  @override
  String get orderNavOrders => 'الطلبات';

  @override
  String get orderNavManual => 'يدوي';

  @override
  String get orderNavProfile => 'الملف الشخصي';

  @override
  String get orderTitleCatalog => 'الكتالوج';

  @override
  String get orderTitleCreateOrder => 'إنشاء طلب';

  @override
  String get orderTitleOrderDetail => 'تفاصيل الطلب';

  @override
  String get orderTitleNewRequest => 'طلب جديد';

  @override
  String get orderTitleRequestDetail => 'تفاصيل الطلب';

  @override
  String get orderTitleManualOrders => 'الطلبات اليدوية';

  @override
  String get orderProfileCustomer => 'ملف العميل';

  @override
  String get orderProfileShopContacts => 'جهات اتصال المتجر';

  @override
  String get orderManualShopOnly =>
      'طلبات الطلب اليدوي متاحة لحسابات المتاجر فقط.';

  @override
  String get orderManualNewRequest => 'طلب جديد';

  @override
  String get orderManualEmpty => 'لا توجد طلبات يدوية بعد';

  @override
  String get orderManualShopOnlyCreate =>
      'يمكن لحسابات المتاجر فقط إنشاء طلبات يدوية';

  @override
  String get orderManualNotesRequired => 'يرجى إدخال ملاحظات الطلب';

  @override
  String get orderCustomerProfileNotLoaded => 'لم يُحمّل ملف العميل';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusModified => 'معدّل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusPending => 'معلق';

  @override
  String get statusPartial => 'جزئي';

  @override
  String get statusPaid => 'مدفوع';

  @override
  String get statusAssigned => 'معيّن';

  @override
  String get statusInReview => 'قيد المراجعة';

  @override
  String get statusConverted => 'تم التحويل';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String get statusPendingSync => 'في انتظار المزامنة';

  @override
  String get statusDiscountPendingApproval => 'خصم في انتظار الموافقة';

  @override
  String get statusAddItem => 'إضافة عنصر';

  @override
  String get statusUpdateItem => 'تحديث عنصر';

  @override
  String get statusRemoveItem => 'إزالة عنصر';

  @override
  String get statusReturn => 'إرجاع';

  @override
  String get statusFrequent => 'متكرر';

  @override
  String get statusRegular => 'منتظم';

  @override
  String get statusOccasional => 'عرضي';

  @override
  String get statusDormant => 'خامل';

  @override
  String get statusNever => 'أبداً';

  @override
  String get statusGoodPayer => 'دافع جيد';

  @override
  String get statusFair => 'مقبول';

  @override
  String get statusPoor => 'ضعيف';

  @override
  String get salesPickerFiltersOffline =>
      'بعض الفلاتر تتطلب الإنترنت. عرض العملاء المخزنين فقط.';

  @override
  String get salesPickerPhoneSearch => 'البحث عن جميع العملاء بالهاتف';

  @override
  String get salesPickerOrderPlaced => 'تم الطلب';

  @override
  String get commonArea => 'المنطقة';

  @override
  String get commonAllAreas => 'كل المناطق';

  @override
  String get commonSortAz => 'أ–ي';

  @override
  String get commonSortNearest => 'الأقرب';

  @override
  String get salesPickerInactive60d => 'غير نشط 60+ يوم';

  @override
  String commonPageOf(int page, int lastPage) {
    return 'صفحة $page من $lastPage';
  }

  @override
  String get salesPickerFiltersNeedInternet =>
      'فلاتر النشاط والمنطقة تتطلب الإنترنت.';

  @override
  String get salesPickerActivity1Day => 'يوم واحد';

  @override
  String get salesPickerActivity1Week => 'أسبوع';

  @override
  String get salesPickerActivity15Days => '15 يوماً';

  @override
  String get salesPickerActivity30Days => '30 يوماً';

  @override
  String get salesPickerActivity60Days => '60 يوماً';

  @override
  String get salesPickerActivity90Days => '90 يوماً';

  @override
  String commonAvgOrderInterval(int days) {
    return '~كل $days يوم';
  }

  @override
  String get commonEnable => 'تفعيل';

  @override
  String get biometricEnableTitle => 'تسجيل الدخول بالبصمة';

  @override
  String get biometricEnableSubtitle =>
      'افتح التطبيق بسرعة باستخدام بصمة الإصبع أو Face ID';

  @override
  String get biometricEnableReason => 'أكد لتفعيل تسجيل الدخول بالبصمة';

  @override
  String get biometricUnlockReason => 'افتح التطبيق للمتابعة';

  @override
  String get biometricUnlockButton => 'فتح بالبصمة';

  @override
  String get biometricUsePassword => 'استخدم كلمة المرور بدلاً من ذلك';

  @override
  String get biometricNotAvailable =>
      'المصادقة البيومترية غير متاحة على هذا الجهاز';

  @override
  String get biometricCancelled => 'تم إلغاء المصادقة';

  @override
  String get biometricNotEnrolled =>
      'لا توجد بصمة إصبع أو Face ID مسجلة. أضف واحدة في إعدادات الجهاز.';

  @override
  String get biometricEnableFailed =>
      'تعذر تفعيل تسجيل الدخول بالبصمة. حاول مرة أخرى.';

  @override
  String get biometricOptInMessage =>
      'هل تريد استخدام بصمة الإصبع أو Face ID لفتح التطبيق على هذا الجهاز؟';

  @override
  String get biometricAppLockedTitle => 'التطبيق مقفل';

  @override
  String get biometricAppLockedSubtitle => 'صادق للمتابعة في استخدام التطبيق';

  @override
  String biometricSignInAs(String email) {
    return 'تسجيل الدخول كـ $email';
  }

  @override
  String get sessionExpired => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get tokenExpiresAtTitle => 'تنتهي الجلسة';

  @override
  String tokenExpiresAtValue(String date) {
    return 'إعادة تسجيل الدخول مطلوبة بحلول $date';
  }
}
