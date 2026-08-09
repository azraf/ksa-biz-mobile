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
  String get commonInvoiceLabel => 'الفاتورة';

  @override
  String get commonPageNotFound => 'الصفحة غير موجودة';

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
  String get salesAppName => 'ARM Sales(M)';

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
  String salesDashboardCachedDues(String fetchedAt) {
    return 'عرض المستحقات المخزنة من $fetchedAt';
  }

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
  String get salesOfflineAllSynced => 'All changes synced';

  @override
  String salesOfflineSyncProgress(int completed, int total) {
    return 'Syncing $completed of $total…';
  }

  @override
  String get salesOfflineServerUnreachable =>
      'Connected but server is unreachable';

  @override
  String get salesOfflineRetryUploads => 'Retry uploads';

  @override
  String salesOfflineUploadFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uploads failed',
      one: '1 upload failed',
    );
    return '$_temp0';
  }

  @override
  String salesOfflineUploading(int percent) {
    return 'Uploading… $percent%';
  }

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
  String get salesErrorPayloadTooLarge =>
      'File is too large. Try a smaller photo or shorter recording.';

  @override
  String get salesErrorConflict => 'Server has newer data. Check Sync issues.';

  @override
  String get salesPendingSync => 'Pending sync';

  @override
  String get salesSyncExhausted => 'Max retries reached — dismiss or retry all';

  @override
  String get salesSyncItemOrderCreate => 'Order (create)';

  @override
  String get salesSyncItemOrderUpdate => 'Order (update)';

  @override
  String get salesSyncItemExpense => 'Expense';

  @override
  String get salesSyncItemWatchlist => 'Watch-list entry';

  @override
  String get salesSyncItemDiary => 'Diary note';

  @override
  String get salesOrderSearchHint => 'Search by shop or order #';

  @override
  String get salesOrderFilterToday => 'Today';

  @override
  String get salesOrderFilterWeek => 'This week';

  @override
  String get salesOrderFilterPendingSync => 'Pending sync';

  @override
  String get salesOrderFilterUnpaid => 'Unpaid';

  @override
  String get salesManualEmptyOpenPool => 'No open manual order requests';

  @override
  String get salesManualEmptyAssigned => 'No assigned manual orders';

  @override
  String get salesManualEmptyInReview => 'No orders in review';

  @override
  String get salesManualEmptyConverted => 'No converted manual orders';

  @override
  String get salesEmptyOrdersCta => 'Create your first order';

  @override
  String get salesEmptyCustomersOnline =>
      'Go online to refresh your assigned customers';

  @override
  String get salesEmptyDuesHint =>
      'Outstanding dues appear after delivered orders';

  @override
  String get salesVanOfflineBanner =>
      'Van stock changes require an internet connection';

  @override
  String get salesVanActionsTitle => 'Van stock actions';

  @override
  String get salesOfflineHelpTitle => 'Offline mode';

  @override
  String get salesOfflineHelpWorks =>
      'Works offline: create orders, watch-list, diary text, browse cached customers and products.';

  @override
  String get salesOfflineHelpNeedsInternet =>
      'Needs internet: manual orders, van stock, diary voice upload, quick-create customer, payments on unsynced orders.';

  @override
  String get salesPaymentSyncFirst =>
      'Sync this order before collecting payment';

  @override
  String get salesStorageLowContinue => 'Continue anyway';

  @override
  String get salesQuickLinks => 'Quick links';

  @override
  String get salesDuesCollect => 'Collect';

  @override
  String get salesOrderRepeatLast => 'Repeat last order';

  @override
  String get salesDarkMode => 'Dark mode';

  @override
  String get salesFirstRunTipDashboard =>
      'Dashboard shows dues, van stock, and quick links';

  @override
  String get salesFirstRunTipOrder =>
      'Tap New Order to sell — works offline when catalog is cached';

  @override
  String get salesFirstRunTipOffline =>
      'The banner shows sync status; tap it for sync issues';

  @override
  String get salesFirstRunGotIt => 'Got it';

  @override
  String get orderHomeRecent => 'Recent orders';

  @override
  String get orderHomeThisMonth => 'This month';

  @override
  String get orderHomeOutstanding => 'Outstanding balance';

  @override
  String get orderContextError =>
      'Could not match your account to a shop. Contact support.';

  @override
  String get adminProfileTitle => 'Profile';

  @override
  String get adminCustomersHubTitle => 'Customers hub';

  @override
  String get adminNavAssignments => 'Assignments';

  @override
  String get adminOfflineWriteBlocked =>
      'This action requires an internet connection.';

  @override
  String get salesSyncIssuesTitle => 'Sync issues';

  @override
  String get salesSyncIssuesEmpty => 'No sync issues';

  @override
  String salesSyncRetries(int count) {
    return 'Retries: $count';
  }

  @override
  String get salesSyncDismiss => 'Dismiss';

  @override
  String get salesSyncRetry => 'Retry';

  @override
  String get salesSyncRetryAll => 'Retry all';

  @override
  String salesLastSyncedAt(String time) {
    return 'Last synced $time';
  }

  @override
  String get salesCardCustomers => 'Customers';

  @override
  String get salesCardCustomersValue => 'My customers';

  @override
  String get salesCardCustomersSubtitle =>
      'Shops, vans, importers — diary & media';

  @override
  String get salesCustomersTitle => 'Customers';

  @override
  String get salesCustomersShops => 'Shops';

  @override
  String get salesCustomersVans => 'Vans';

  @override
  String get salesCustomersImporters => 'Importers';

  @override
  String get salesCustomersEmpty => 'No assigned customers';

  @override
  String get salesCustomersAssignedOnly => 'Showing customers assigned to you';

  @override
  String get salesCustomersNearby => 'Nearby map';

  @override
  String get salesStorageLowWarning => 'Low storage — capture may fail';

  @override
  String get salesCustomerDetail => 'Customer detail';

  @override
  String get salesCustomerActivity => 'Activity';

  @override
  String get salesCustomerMedia => 'Photos';

  @override
  String get salesCustomerDiary => 'Diary';

  @override
  String get salesOrderEditOfflineBlocked =>
      'Order editing requires an internet connection.';

  @override
  String get salesOrderEditPendingSync =>
      'This order is still syncing. Edit after sync completes.';

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
  String get paymentVoidPayment => 'إلغاء الدفع';

  @override
  String get paymentVoidReason => 'سبب الإلغاء';

  @override
  String get paymentVoided => 'تم إلغاء الدفع';

  @override
  String get paymentVoidedLabel => 'ملغى';

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
  String get salesWatchlistMediaPartial =>
      'تم الحفظ، لكن تعذّر رفع بعض المرفقات.';

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
  String get orderManualAddMedia => 'صور أو صوت أو فيديو (اختياري)';

  @override
  String get orderManualGallery => 'المعرض';

  @override
  String get orderManualNoteOrMediaRequired =>
      'أضف ملاحظة أو مرفقًا واحدًا على الأقل';

  @override
  String get orderManualQueuedOffline =>
      'تم الحفظ دون اتصال — سيُرسل عند الاتصال';

  @override
  String get orderManualLinkedOrders => 'الطلبات المرتبطة';

  @override
  String get commonLinkToOrders => 'ربط بطلب (طلبات)';

  @override
  String get commonNoOrdersForCustomer => 'لا توجد طلبات لهذا العميل';

  @override
  String get commonOrdersLinked => 'تم ربط الطلبات';

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
  String get statusDraft => 'مسودة';

  @override
  String get planPurposeField => 'الغرض';

  @override
  String get orderDraftEditableNotice =>
      'هذا الطلب مسودة — يمكنك تعديله حتى يؤكده مندوب المبيعات.';

  @override
  String get commonEdit => 'تعديل';

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
  String get commonSort => 'ترتيب';

  @override
  String get commonSortByDate => 'التاريخ';

  @override
  String get commonSortByArea => 'المنطقة';

  @override
  String get commonSortBySalesPerson => 'مندوب البيع';

  @override
  String get commonCreateCustomer => 'إنشاء عميل';

  @override
  String get commonAddWatchlistPlace => 'إضافة مكان';

  @override
  String get salesCustomerCreateGoOnline => 'اتصل بالإنترنت لإنشاء عميل';

  @override
  String get adminShopQuickAdd => 'إضافة متجر سريعة';

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

  @override
  String get gpsOptional => 'GPS (اختياري)';

  @override
  String get gpsCapture => 'التقاط';

  @override
  String get gpsPermissionRequired => 'إذن الموقع مطلوب لتحديد GPS.';

  @override
  String get gpsEnableServices => 'يرجى تفعيل خدمات الموقع.';

  @override
  String get gpsOptionsTooltip => 'خيارات GPS';

  @override
  String get gpsClear => 'مسح موقع GPS';

  @override
  String get gpsReplace => 'استبدال بالموقع الحالي';

  @override
  String get gpsClearConfirm => 'هل أنت متأكد من مسح الموقع المحفوظ؟';

  @override
  String get gpsReplaceConfirm =>
      'هل أنت متأكد من استبدال الموقع المحفوظ بالموقع الحالي؟';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get customerContactPerson => 'الشخص المسؤول (اختياري)';

  @override
  String get customerCreatedPartial =>
      'تم الإنشاء، لكن تعذّر حفظ بعض البيانات. أضفها من صفحة العميل.';

  @override
  String get customerDuplicatePhoneTitle => 'تكرار محتمل';

  @override
  String get commonOpenExisting => 'فتح الموجود';

  @override
  String get commonCreateAnyway => 'إنشاء على أي حال';

  @override
  String get customerAssignSalesPerson => 'تعيين مندوب مبيعات (اختياري)';

  @override
  String get watchlistSaveProspect => 'حفظ كعميل محتمل (دون اتصال)';

  @override
  String get watchlistProspectSaved =>
      'تم الحفظ في قائمة المتابعة — حوّله إلى متجر عند الاتصال.';

  @override
  String get watchlistProspectNeedsGps =>
      'يلزم تحديد GPS لحفظ عميل محتمل دون اتصال.';

  @override
  String get accountCreateLogin => 'إنشاء حساب دخول';

  @override
  String get accountUsesContactDetails =>
      'تُستخدم بيانات الاتصال أعلاه لتسجيل الدخول';

  @override
  String get accountSignInHint => 'يمكن للعميل تسجيل الدخول بالبريد أو الهاتف';

  @override
  String get accountLoginEmailOptional => 'بريد الدخول (اختياري)';

  @override
  String get accountLoginPhoneOptional => 'هاتف الدخول (اختياري)';

  @override
  String get accountConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get accountPhoneOrEmailRequired =>
      'الهاتف أو البريد مطلوب لحساب الدخول';

  @override
  String get accountPasswordMin => 'كلمة المرور 8 أحرف على الأقل';

  @override
  String get accountPasswordsNoMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get accountCreateSubmit => 'إنشاء الحساب';

  @override
  String get accountUsesContactForLogin =>
      'تُستخدم بيانات اتصال العميل لتسجيل الدخول';

  @override
  String get accountPasswordCheck =>
      'تحقق من كلمة المرور (8 أحرف على الأقل ومتطابقة)';

  @override
  String get accountResetPasswordTitle => 'إعادة تعيين كلمة مرور الدخول';

  @override
  String get accountResetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get accountPasswordResetDone => 'تمت إعادة تعيين كلمة مرور الدخول';

  @override
  String get accountSection => 'حساب الدخول';

  @override
  String get accountNone => 'لا يوجد حساب دخول';

  @override
  String get accountNoneHint =>
      'أنشئ بيانات دخول ليتمكن هذا العميل من استخدام OrderApp أو البوابة الإلكترونية.';

  @override
  String get accountCreateDisabledHint =>
      'فقط المسؤول يمكنه إنشاء حساب دخول لهذا العميل. اطلب من المسؤول تفعيله.';

  @override
  String get accountAllowSalespersonCreate =>
      'يمكن لمندوب المبيعات إنشاء حساب دخول';

  @override
  String get accountCreated => 'تم إنشاء حساب الدخول';

  @override
  String customerDuplicatePhoneBody(String name) {
    return '\"$name\" يستخدم رقم الهاتف هذا بالفعل.';
  }

  @override
  String get updateAvailableTitle => 'يتوفر تحديث';

  @override
  String get updateNow => 'تحديث';

  @override
  String updateAvailableBody(int current, int latest) {
    return 'إصدار أحدث جاهز للتثبيت (البنية $current → $latest).';
  }

  @override
  String get commonSalesperson => 'مندوب المبيعات';

  @override
  String get commonVideo => 'فيديو';

  @override
  String commonVideoTooLarge(int maxMb) {
    return 'الفيديو كبير جدًا (الحد الأقصى $maxMb م.ب)';
  }

  @override
  String get commonViewAll => 'عرض الكل';

  @override
  String get statusPlanned => 'مخطط';

  @override
  String get statusDone => 'تم';

  @override
  String get statusMissed => 'فائت';

  @override
  String get salesNavPlan => 'الخطة';

  @override
  String get salesTitlePlan => 'الخطة';

  @override
  String get salesSyncItemVisit => 'زيارة';

  @override
  String get planTabVisits => 'الزيارات';

  @override
  String get planTabDues => 'المستحقات';

  @override
  String get planNewVisit => 'زيارة جديدة';

  @override
  String get planEditVisit => 'تعديل الزيارة';

  @override
  String get planScheduleVisit => 'جدولة زيارة';

  @override
  String get planPurposeDueCollection => 'تحصيل مستحقات';

  @override
  String get planPurposeRegularVisit => 'زيارة اعتيادية';

  @override
  String get planPurposeDelivery => 'توصيل';

  @override
  String get planPurposePromotionalVisit => 'زيارة ترويجية';

  @override
  String get planPurposeNewClientSearch => 'البحث عن عملاء جدد';

  @override
  String get planPurposeOther => 'أخرى';

  @override
  String get planMarkDone => 'تمت';

  @override
  String get planMarkMissed => 'فائتة';

  @override
  String get planCancelVisit => 'إلغاء الزيارة';

  @override
  String get planOutcomeNote => 'ملاحظة النتيجة (اختياري)';

  @override
  String get planDuration => 'المدة (دقائق)';

  @override
  String get planPickCustomer => 'اختر العميل';

  @override
  String get planPickWatchlist => 'اختر عميلًا محتملًا';

  @override
  String get planCollectionCandidates => 'تستحق زيارة تحصيل';

  @override
  String get planPlanVisit => 'خطط زيارة';

  @override
  String planTodayVisits(int count) {
    return '$count زيارة اليوم';
  }

  @override
  String get planNoVisits => 'لا توجد زيارات مطابقة.';

  @override
  String get planVisitSaved => 'تم حفظ الزيارة.';

  @override
  String get planSyncFirst => 'زامن هذه الزيارة قبل تغيير حالتها.';

  @override
  String get planReminderTitle => 'زيارات مخططة';

  @override
  String planReminderBody(int count) {
    return 'لديك $count زيارة مخططة';
  }

  @override
  String get orderDiaryTitle => 'يوميات الطلب';

  @override
  String get orderSaveAsDraft => 'حفظ كمسودة';

  @override
  String get purchaseSavePost => 'حفظ وترحيل';

  @override
  String get customerMoneyTitle => 'الملخص المالي';

  @override
  String get customerMoneyOrders => 'الطلبات';

  @override
  String get customerMoneyPurchased => 'إجمالي المشتريات';

  @override
  String get customerMoneyPaid => 'المدفوع';

  @override
  String get customerMoneyDiscounts => 'الخصومات';

  @override
  String get customerMoneyDue => 'المستحق';

  @override
  String get customerMoneyOverdue => 'متأخر';

  @override
  String get customerMoneyNextPayment => 'الدفعة التالية';

  @override
  String get customerMoneyLastPayment => 'آخر دفعة';

  @override
  String get customerOrdersTitle => 'الطلبات';

  @override
  String get customerOrdersEmpty => 'لا توجد طلبات بعد.';
}
