// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get commonRetry => 'আবার চেষ্টা করুন';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonDelete => 'মুছুন';

  @override
  String get commonBack => 'পিছনে';

  @override
  String get commonSubmit => 'জমা দিন';

  @override
  String get commonSkip => 'এড়িয়ে যান';

  @override
  String get commonAdd => 'যোগ করুন';

  @override
  String get commonPhoto => 'ছবি';

  @override
  String get commonVoice => 'ভয়েস';

  @override
  String get commonStop => 'বন্ধ';

  @override
  String get commonLoading => 'লোড হচ্ছে...';

  @override
  String get commonSignIn => 'সাইন ইন';

  @override
  String get commonSignOut => 'সাইন আউট';

  @override
  String logoutUnsyncedWarning(int count) {
    return 'এই ডিভাইসে অন্য কোনো ব্যবহারকারী সাইন ইন করলে $countটি অসিঙ্ক করা রেকর্ড স্থায়ীভাবে হারিয়ে যাবে। তবুও সাইন আউট করবেন?';
  }

  @override
  String get logoutAnyway => 'তবুও সাইন আউট করুন';

  @override
  String get commonEmail => 'ইমেইল';

  @override
  String get commonPassword => 'পাসওয়ার্ড';

  @override
  String get commonApiBaseUrl => 'API বেস URL';

  @override
  String get commonApiUrl => 'API URL';

  @override
  String get commonRoles => 'ভূমিকা';

  @override
  String get commonActingAs => 'হিসেবে কাজ করছেন';

  @override
  String get commonUser => 'ব্যবহারকারী';

  @override
  String get commonPhone => 'ফোন';

  @override
  String get commonMobile => 'মোবাইল';

  @override
  String get commonNameRequired => 'নাম *';

  @override
  String get commonAddress => 'ঠিকানা';

  @override
  String get commonCity => 'শহর';

  @override
  String get commonReason => 'কারণ';

  @override
  String get commonQuantity => 'পরিমাণ';

  @override
  String get commonNotes => 'নোট';

  @override
  String get commonNotesOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get commonItems => 'আইটেম';

  @override
  String get commonNoItemsYet => 'এখনও কোনো আইটেম নেই';

  @override
  String commonTotal(String amount) {
    return 'মোট: $amount';
  }

  @override
  String get commonUnit => 'ইউনিট';

  @override
  String get commonUnitCarton => 'কার্টন (CTN)';

  @override
  String commonUnitPiece(int piecesPerCarton) {
    return 'পিস (pcs) · প্রতি CTN $piecesPerCarton';
  }

  @override
  String get commonPrice => 'মূল্য';

  @override
  String get commonDiscount => 'ছাড়';

  @override
  String get commonVat => 'ভ্যাট';

  @override
  String get commonExclVat => 'ভ্যাট ব্যতীত';

  @override
  String lineItemVatSubtitle(
    String qtyLabel,
    String excl,
    String vat,
    String total,
  ) {
    return '$qtyLabel · ভ্যাট ছাড়া $excl · ভ্যাট $vat · $total';
  }

  @override
  String get commonSearchProducts => 'পণ্য খুঁজুন';

  @override
  String commonProductPriceCtn(String price, String pieces) {
    return 'SAR $price / CTN · $pieces পিস';
  }

  @override
  String commonProductPrice(String price) {
    return 'SAR $price';
  }

  @override
  String commonQtyLine(String quantity) {
    return 'পরিমাণ $quantity';
  }

  @override
  String commonQtyAtPrice(String quantity, String price) {
    return 'পরিমাণ $quantity @ $price';
  }

  @override
  String commonProductFallback(int id) {
    return 'পণ্য #$id';
  }

  @override
  String commonShopFallback(int id) {
    return 'দোকান #$id';
  }

  @override
  String get commonInvoiceLabel => 'ইনভয়েস';

  @override
  String get commonPageNotFound => 'পৃষ্ঠা পাওয়া যায়নি';

  @override
  String commonOrderNumber(int id) {
    return 'অর্ডার #$id';
  }

  @override
  String commonRequestNumber(int id) {
    return 'অনুরোধ #$id';
  }

  @override
  String get commonRecording => 'রেকর্ডিং';

  @override
  String get commonRecordings => 'রেকর্ডিংসমূহ';

  @override
  String get commonAddRecording => 'রেকর্ডিং যোগ করুন';

  @override
  String get commonRecordAudio => 'অডিও রেকর্ড';

  @override
  String get commonRecordVideo => 'ভিডিও রেকর্ড';

  @override
  String get commonStopAndUpload => 'বন্ধ ও আপলোড';

  @override
  String get commonRecordingUploaded => 'রেকর্ডিং আপলোড হয়েছে';

  @override
  String get commonCall => 'কল';

  @override
  String get commonWhatsapp => 'হোয়াটসঅ্যাপ';

  @override
  String commonCouldNotOpen(String action) {
    return '$action খুলতে পারেনি';
  }

  @override
  String get commonPhoneDialer => 'ফোন ডায়ালার';

  @override
  String get commonDiary => 'ডায়েরি';

  @override
  String commonDiaryTitle(String customerName) {
    return 'ডায়েরি — $customerName';
  }

  @override
  String get commonDiaryNote => 'ডায়েরি নোট';

  @override
  String get commonDiaryEmpty => 'এখনও কোনো ডায়েরি এন্ট্রি নেই।';

  @override
  String get commonDiaryText => 'টেক্সট';

  @override
  String get commonDiaryLoadMore => 'আরো লোড করুন';

  @override
  String get commonDiaryPlayVoice => 'ভয়েস নোট চালান';

  @override
  String get commonAddNote => 'নোট যোগ করুন';

  @override
  String get commonTextNote => 'টেক্সট নোট';

  @override
  String get commonRecordingTitle => 'রেকর্ড হচ্ছে...';

  @override
  String get commonStopAndSave => 'বন্ধ ও সংরক্ষণ';

  @override
  String get commonAddVisitNoteTitle => 'ভিজিট নোট যোগ করবেন?';

  @override
  String commonAddVisitNoteBody(String customerName) {
    return '$customerName-এর জন্য ডায়েরি নোট যোগ করবেন?';
  }

  @override
  String get commonGpsNotCaptured => 'ধারণ করা হয়নি';

  @override
  String get commonGpsCapturing => 'ধারণ করা হচ্ছে...';

  @override
  String get commonGpsRefresh => 'রিফ্রেশ';

  @override
  String get commonGpsCapture => 'GPS ধারণ';

  @override
  String get commonGpsLocationRequired =>
      'দোকানের GPS-এর জন্য লোকেশন অনুমতি প্রয়োজন।';

  @override
  String get commonCameraPermission => 'ক্যামেরা অনুমতি প্রয়োজন।';

  @override
  String get commonMicrophonePermission => 'মাইক্রোফোন অনুমতি প্রয়োজন।';

  @override
  String get commonRecordingPermission =>
      'রেকর্ডিং বাছাইয়ের জন্য অনুমতি প্রয়োজন।';

  @override
  String get commonAll => 'সব';

  @override
  String get commonCash => 'নগদ';

  @override
  String get commonBankTransfer => 'ব্যাংক ট্রান্সফার';

  @override
  String get commonCheque => 'চেক';

  @override
  String get commonOther => 'অন্যান্য';

  @override
  String get commonNoProductsFound => 'কোনো পণ্য পাওয়া যায়নি';

  @override
  String get commonNoProductsCached =>
      'কোনো পণ্য ক্যাশে নেই। অনলাইনে ডেটা ডাউনলোড করুন।';

  @override
  String get commonNameIsRequired => 'নাম প্রয়োজন';

  @override
  String get commonAddAtLeastOneProduct => 'অন্তত একটি পণ্য যোগ করুন';

  @override
  String get commonPlaceOrder => 'অর্ডার দিন';

  @override
  String commonSourceLabel(String source) {
    return 'উৎস: $source';
  }

  @override
  String get commonReference => 'রেফারেন্স';

  @override
  String get commonCallReference => 'কল রেফারেন্স';

  @override
  String get commonManualOrderRequest => 'ম্যানুয়াল অর্ডার অনুরোধ';

  @override
  String get commonOrderNotes => 'অর্ডার নোট';

  @override
  String get commonOrderNotesHint =>
      'পণ্য, পরিমাণ বা বিশেষ নির্দেশনা বর্ণনা করুন';

  @override
  String get commonSubmitRequest => 'অনুরোধ জমা দিন';

  @override
  String get commonNewOrder => 'নতুন অর্ডার';

  @override
  String get commonNoOrdersYet => 'এখনও কোনো অর্ডার নেই';

  @override
  String get commonCreateOrder => 'অর্ডার তৈরি';

  @override
  String get commonOrderDetail => 'অর্ডার বিবরণ';

  @override
  String get commonEditOrder => 'অর্ডার সম্পাদনা';

  @override
  String get commonCustomer => 'গ্রাহক';

  @override
  String get commonPaid => 'পরিশোধিত';

  @override
  String get commonDue => 'বকেয়া';

  @override
  String get commonTotalLabel => 'মোট';

  @override
  String get commonGrandDiscount => 'মোট ছাড়';

  @override
  String get commonDueDate => 'পরিশোধের তারিখ';

  @override
  String get commonOverdue => 'মেয়াদোত্তীর্ণ';

  @override
  String commonOverdueDays(int days) {
    return '$days দিন';
  }

  @override
  String get commonPayments => 'পেমেন্ট';

  @override
  String get commonLanguage => 'ভাষা';

  @override
  String get commonLanguageEnglish => 'English';

  @override
  String get commonLanguageArabic => 'العربية';

  @override
  String get commonLanguageBangla => 'বাংলা';

  @override
  String get commonConvert => 'রূপান্তর';

  @override
  String get commonPickVideo => 'ভিডিও বাছুন';

  @override
  String get salesAppName => 'ARM Sales(M)';

  @override
  String get salesSignInSubtitle =>
      'আপনার সেলসপারসন অ্যাকাউন্ট দিয়ে সাইন ইন করুন';

  @override
  String get salesNavHome => 'হোম';

  @override
  String get salesNavManual => 'ম্যানুয়াল';

  @override
  String get salesNavOrders => 'অর্ডার';

  @override
  String get salesNavVan => 'ভ্যান';

  @override
  String get salesNavDues => 'বকেয়া';

  @override
  String get salesTitleDashboard => 'ড্যাশবোর্ড';

  @override
  String get salesTitleManualOrders => 'ম্যানুয়াল অর্ডার';

  @override
  String get salesTitleOrders => 'অর্ডার';

  @override
  String get salesTitleVanStock => 'ভ্যান স্টক';

  @override
  String get salesTitleDues => 'বকেয়া';

  @override
  String get salesTitleCreateOrder => 'অর্ডার তৈরি';

  @override
  String get salesTitleEditOrder => 'অর্ডার সম্পাদনা';

  @override
  String get salesTitleOrderDetail => 'অর্ডার বিবরণ';

  @override
  String get salesTitleConvertOrder => 'অর্ডারে রূপান্তর';

  @override
  String get salesTitleManualOrder => 'ম্যানুয়াল অর্ডার';

  @override
  String get salesTitleLoadVan => 'ভ্যান লোড';

  @override
  String get salesTitleTransferStock => 'স্টক স্থানান্তর';

  @override
  String get salesTitleDamageReplacement => 'ক্ষতি প্রতিস্থাপন';

  @override
  String get salesTitleProductExchange => 'পণ্য বিনিময়';

  @override
  String get salesSelectSalesperson => 'সেলসপারসন নির্বাচন';

  @override
  String get salesSearchSalesperson => 'নাম বা ইমেইল দিয়ে খুঁজুন';

  @override
  String get salesNoSalespeople => 'কোনো সেলসপারসন পাওয়া যায়নি';

  @override
  String get salesProfile => 'প্রোফাইল';

  @override
  String get salesSalespersonProfile => 'সেলসপারসন প্রোফাইল';

  @override
  String get salesNoSalespersonSelected => 'কোনো সেলসপারসন নির্বাচিত নয়';

  @override
  String get salesChooseSalespersonHint =>
      'বিক্রয় কাজ করতে সেলসপারসন নির্বাচন করুন।';

  @override
  String get salesSelectSalespersonBtn => 'সেলসপারসন নির্বাচন';

  @override
  String get salesChangeSalespersonBtn => 'সেলসপারসন পরিবর্তন';

  @override
  String get salesSelectSalespersonFirst => 'প্রথমে সেলসপারসন নির্বাচন করুন।';

  @override
  String get salesDashboardLoading => 'ড্যাশবোর্ড লোড হচ্ছে...';

  @override
  String get salesDashboardSelectSp =>
      'ড্যাশবোর্ড দেখতে সেলসপারসন নির্বাচন করুন।';

  @override
  String get salesDashboardNoProfile =>
      'আপনার অ্যাকাউন্ট কোনো সেলসপারসন প্রোফাইলের সাথে যুক্ত নয়।';

  @override
  String salesDashboardCachedDues(String fetchedAt) {
    return '$fetchedAt থেকে ক্যাশ করা বকেয়া দেখানো হচ্ছে';
  }

  @override
  String salesHello(String name) {
    return 'হ্যালো, $name';
  }

  @override
  String get salesDefaultSalesperson => 'সেলসপারসন';

  @override
  String salesActingAsName(String name) {
    return 'হিসেবে কাজ করছেন: $name';
  }

  @override
  String get salesCardOutstandingDues => 'বকেয়া dues';

  @override
  String salesCardUnpaidOrders(int count) {
    return '$count অপরিশোধিত অর্ডার';
  }

  @override
  String get salesCardManualOrders => 'ম্যানুয়াল অর্ডার';

  @override
  String get salesCardManualSubtitle => 'খোলা / নিয়োগ / পর্যালোচনায়';

  @override
  String get salesCardVanStock => 'ভ্যান স্টক';

  @override
  String salesCardVanProducts(int count) {
    return '$count পণ্য';
  }

  @override
  String salesCardLowStockAlerts(int count) {
    return '$count কম স্টক সতর্কতা';
  }

  @override
  String get salesCardTapManageStock => 'স্টক পরিচালনার জন্য ট্যাপ করুন';

  @override
  String get salesCardMyOrders => 'আমার অর্ডার';

  @override
  String get salesCardViewAll => 'সব দেখুন';

  @override
  String get salesCardOrdersSubtitle => 'অর্ডার তৈরি ও সম্পাদনা';

  @override
  String get salesCardWatchlist => 'ওয়াচলিস্ট';

  @override
  String get salesCardWatchlistValue => 'লিড সংরক্ষণ';

  @override
  String get salesCardWatchlistSubtitle => 'ভবিষ্যত ভিজিটের GPS অবস্থান';

  @override
  String get salesQuickSaveLocation => 'বর্তমান অবস্থান দ্রুত সংরক্ষণ';

  @override
  String get salesLocationSaved => 'অবস্থান ওয়াচলিস্টে সংরক্ষিত';

  @override
  String get salesAddNotesAction => 'নোট যোগ করুন';

  @override
  String salesNearbyShop(String name, String distance) {
    return 'কাছের দোকান: $name ($distanceমি)';
  }

  @override
  String salesDuplicateWatchlist(String distance) {
    return 'ওয়াচলিস্টে $distanceমি-এর মধ্যে ডুপ্লিকেট';
  }

  @override
  String get salesDuesTotalDue => 'মোট বকেয়া';

  @override
  String get salesDuesNone => 'কোনো বকেয়া নেই';

  @override
  String get salesDuesLongPressHint =>
      'পেমেন্ট সংগ্রহের জন্য অর্ডারে দীর্ঘ চাপুন';

  @override
  String get salesNotifications => 'বিজ্ঞপ্তি';

  @override
  String get salesNotificationsEmpty => 'কোনো বিজ্ঞপ্তি নেই';

  @override
  String get salesOfflineMode => 'অফলাইন মোড';

  @override
  String get salesOfflineSync => 'সিঙ্ক';

  @override
  String salesOfflineSyncing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি মুলতুবি পরিবর্তন...',
      one: '1টি মুলতুবি পরিবর্তন...',
    );
    return 'সিঙ্ক হচ্ছে $_temp0';
  }

  @override
  String salesOfflineSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countটি পরিবর্তন স্থানীয়ভাবে সংরক্ষিত',
      one: '1টি পরিবর্তন স্থানীয়ভাবে সংরক্ষিত',
    );
    return 'অফলাইন — $_temp0';
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
  String get salesManualTabOpenPool => 'খোলা পুল';

  @override
  String get salesManualTabAssigned => 'নিয়োগ';

  @override
  String get salesManualTabInReview => 'পর্যালোচনায়';

  @override
  String get salesManualTabConverted => 'রূপান্তরিত';

  @override
  String get salesManualEmpty => 'কোনো ম্যানুয়াল অর্ডার নেই';

  @override
  String get salesManualClaimed => 'অনুরোধ দাবি করা হয়েছে';

  @override
  String get salesManualClaimRequest => 'অনুরোধ দাবি';

  @override
  String get salesManualConvertOrder => 'অর্ডারে রূপান্তর';

  @override
  String get salesManualViewConverted => 'রূপান্তরিত অর্ডার দেখুন';

  @override
  String get salesManualTakeShopPhoto => 'দোকানের ছবি তুলুন';

  @override
  String get salesManualShopPhotoUploaded => 'দোকানের ছবি আপলোড হয়েছে';

  @override
  String get salesManualGpsCleared => 'দোকানের GPS মুছে ফেলা হয়েছে';

  @override
  String salesManualGpsUpdated(String gps) {
    return 'GPS আপডেট: $gps';
  }

  @override
  String get salesConvertShopOrder => 'দোকান অর্ডার';

  @override
  String get salesConvertOrderItems => 'অর্ডার আইটেম';

  @override
  String get salesConvertAddProduct => 'পণ্য যোগ করুন';

  @override
  String get salesConvertOrderCreated => 'অর্ডার তৈরি হয়েছে';

  @override
  String get salesOrderWalkInQuick => 'ওয়াক-ইন দ্রুত অর্ডার';

  @override
  String get salesOrderWalkInShop => 'ওয়াক-ইন দোকান';

  @override
  String get salesOrderWalkInSubtitle => 'বেনামী দ্রুত বিক্রয়';

  @override
  String get salesOrderWalkInNote => 'নোট (ঐচ্ছিক)';

  @override
  String get salesOrderWalkInNoteHint => 'ক্যাশিয়ার নোট';

  @override
  String get salesOrderCustomerType => 'গ্রাহকের ধরন';

  @override
  String get salesOrderSelectCustomer => 'গ্রাহক নির্বাচন';

  @override
  String get salesOrderSelected => 'নির্বাচিত';

  @override
  String get salesOrderAddCustomer => 'গ্রাহক যোগ করুন';

  @override
  String get salesOrderSelectCustomerItems =>
      'গ্রাহক নির্বাচন করুন এবং আইটেম যোগ করুন';

  @override
  String get salesOrderSavedLocally =>
      'অর্ডার স্থানীয়ভাবে সংরক্ষিত — অনলাইনে সিঙ্ক হবে';

  @override
  String get salesOrderWalkInUnavailable =>
      'ওয়াক-ইন দোকান উপলব্ধ নয়। সিঙ্কের জন্য অনলাইনে যান।';

  @override
  String get salesOrderGoOnlineCatalog =>
      'গ্রাহক ও পণ্য ডেটা ডাউনলোডের জন্য প্রথমে অনলাইনে যান।';

  @override
  String get salesOrderNoCustomerTypes =>
      'কোনো গ্রাহক ধরন উপলব্ধ নয়। রিফ্রেশের জন্য অনলাইনে যান।';

  @override
  String get salesOrderCannotEdit => 'এই অর্ডার সম্পাদনা করা যাবে না।';

  @override
  String get salesOrderAddProduct => 'পণ্য যোগ করুন';

  @override
  String get salesOrderChangeQty => 'পরিমাণ পরিবর্তন';

  @override
  String get salesOrderSalesReturn => 'বিক্রয় ফেরত';

  @override
  String get salesOrderReturn => 'ফেরত';

  @override
  String get salesOrderRemoveItem => 'আইটেম সরান';

  @override
  String get salesOrderUpdateQty => 'পরিমাণ আপডেট';

  @override
  String get salesOrderCollectPayment => 'পেমেন্ট সংগ্রহ';

  @override
  String salesOrderCollectPaymentTitle(int orderId) {
    return 'পেমেন্ট সংগ্রহ #$orderId';
  }

  @override
  String get salesOrderAmountDue => 'বকেয়া পরিমাণ';

  @override
  String get salesOrderAmountCollected => 'সংগৃহীত পরিমাণ';

  @override
  String get salesOrderPaymentMethod => 'পেমেন্ট পদ্ধতি';

  @override
  String get salesOrderRecordPayment => 'পেমেন্ট রেকর্ড';

  @override
  String get paymentVoidPayment => 'পেমেন্ট বাতিল';

  @override
  String get paymentVoidReason => 'বাতিলের কারণ';

  @override
  String get paymentVoided => 'পেমেন্ট বাতিল হয়েছে';

  @override
  String get paymentVoidedLabel => 'বাতিল';

  @override
  String get salesOrderEnterValidAmount => 'বৈধ পরিমাণ লিখুন';

  @override
  String get salesOrderRequestDiscount => 'ছাড়ের অনুরোধ';

  @override
  String get salesOrderRequestGrandDiscount => 'মোট ছাড়ের অনুরোধ';

  @override
  String get salesOrderDiscountAmount => 'ছাড়ের পরিমাণ (SAR)';

  @override
  String get salesOrderDiscountSubmitted => 'ছাড়ের অনুরোধ জমা হয়েছে';

  @override
  String get salesOrderCancelOrder => 'অর্ডার বাতিল';

  @override
  String get salesOrderCancelled => 'অর্ডার বাতিল হয়েছে';

  @override
  String get salesOrderCancellationPendingApproval =>
      'বাতিলের অনুরোধ অ্যাডমিনের অনুমোদনের জন্য পাঠানো হয়েছে';

  @override
  String get salesOrderEditTooltip => 'অর্ডার সম্পাদনা';

  @override
  String get salesPickerSelectShop => 'দোকান নির্বাচন';

  @override
  String get salesPickerSelectVan => 'ভ্যান নির্বাচন';

  @override
  String get salesPickerSelectImporter => 'ইমপোর্টার নির্বাচন';

  @override
  String get salesPickerSearchHint => 'নাম, ফোন, যোগাযোগ দিয়ে খুঁজুন';

  @override
  String get salesPickerNoCustomers => 'কোনো গ্রাহক পাওয়া যায়নি';

  @override
  String get salesQuickNewShop => 'নতুন দোকান';

  @override
  String get salesQuickShopName => 'দোকানের নাম *';

  @override
  String get salesQuickSaveShop => 'দোকান সংরক্ষণ';

  @override
  String get salesQuickNewVan => 'নতুন ভ্যান গ্রাহক';

  @override
  String get salesQuickIqama => 'ইকামা';

  @override
  String get salesQuickSaveVan => 'ভ্যান সংরক্ষণ';

  @override
  String get salesQuickNewImporter => 'নতুন ইমপোর্টার';

  @override
  String get salesQuickSaveImporter => 'ইমপোর্টার সংরক্ষণ';

  @override
  String get salesVanEmpty => 'ভ্যান খালি';

  @override
  String get salesVanLowStock => 'কম স্টক';

  @override
  String get salesVanExchange => 'বিনিময়';

  @override
  String get salesVanDamage => 'ক্ষতি';

  @override
  String get salesVanTransfer => 'স্থানান্তর';

  @override
  String get salesVanLoad => 'ভ্যান লোড';

  @override
  String get salesVanUnloadMessage => 'ভ্যান থেকে গুদামে স্টক ফেরত দিন।';

  @override
  String get salesVanUnloadQty => 'পরিমাণ (কার্টন)';

  @override
  String get salesVanUnloadBtn => 'আনলোড';

  @override
  String get salesVanLoadSelectAll => 'সব নির্বাচন';

  @override
  String get salesVanLoadNoStock => 'গুদামে স্টক নেই';

  @override
  String salesVanLoadAvailable(String balance) {
    return 'উপলব্ধ: $balance';
  }

  @override
  String get salesVanLoadSelectOne => 'অন্তত একটি পণ্য নির্বাচন করুন';

  @override
  String salesVanLoadSuccess(int count) {
    return 'ভ্যানে $count পণ্য লোড হয়েছে';
  }

  @override
  String get salesVanLoadAll => 'সব উপলব্ধ লোড';

  @override
  String get salesVanLoadSelected => 'নির্বাচিত লোড';

  @override
  String get salesVanTransferProduct => 'আপনার ভ্যান পণ্য';

  @override
  String get salesVanTransferTo => 'স্থানান্তর করুন';

  @override
  String get salesVanTransferCompleted => 'স্থানান্তর সম্পন্ন';

  @override
  String get salesVanDamageSelect => 'পণ্য নির্বাচন';

  @override
  String get salesVanDamageRecord => 'প্রতিস্থাপন রেকর্ড';

  @override
  String get salesVanExchangeReturns => 'গ্রাহক ফেরত';

  @override
  String get salesVanExchangeSelectReturn => 'ফেরত পণ্য নির্বাচন';

  @override
  String get salesVanExchangeReturnQty => 'ফেরত পরিমাণ';

  @override
  String get salesVanExchangeSettlement => 'নিষ্পত্তি';

  @override
  String get salesVanExchangeGiveProduct => 'অন্য পণ্য দিন';

  @override
  String get salesVanExchangeCashRefund => 'নগদ ফেরত';

  @override
  String get salesVanExchangeGiveTo => 'গ্রাহককে দিন';

  @override
  String get salesVanExchangeSelectOut => 'আউট পণ্য নির্বাচন';

  @override
  String get salesVanExchangeOutQty => 'আউট পরিমাণ';

  @override
  String get salesVanExchangeCashAmount => 'নগদ পরিমাণ (SAR)';

  @override
  String get salesVanExchangeRecord => 'বিনিময় রেকর্ড';

  @override
  String get salesWatchlist => 'ওয়াচলিস্ট';

  @override
  String get salesWatchlistMap => 'ওয়াচলিস্ট মানচিত্র';

  @override
  String get salesWatchlistViewMap => 'মানচিত্রে দেখুন';

  @override
  String get salesWatchlistSortDistance => 'দূরত্ব অনুযায়ী সাজান';

  @override
  String get salesWatchlistActive => 'সক্রিয়';

  @override
  String get salesWatchlistArchived => 'আর্কাইভ';

  @override
  String get salesWatchlistAddLocation => 'অবস্থান যোগ';

  @override
  String get salesWatchlistLoading => 'ওয়াচলিস্ট লোড হচ্ছে...';

  @override
  String get salesWatchlistEmpty => 'এখনও কোনো ওয়াচলিস্ট আইটেম নেই।';

  @override
  String get salesWatchlistSaveTitle => 'ওয়াচলিস্টে সংরক্ষণ';

  @override
  String get salesWatchlistPlaceName => 'স্থানের নাম';

  @override
  String get salesWatchlistNoteOptional => 'নোট (ঐচ্ছিক)';

  @override
  String get salesWatchlistSaveLocation => 'অবস্থান সংরক্ষণ';

  @override
  String get salesWatchlistVoicePending =>
      'এন্ট্রি তৈরির পর ভয়েস সংরক্ষিত হবে (বিবরণ থেকে আপলোড)।';

  @override
  String get salesWatchlistMediaPartial =>
      'সংরক্ষিত হয়েছে, তবে কিছু সংযুক্তি আপলোড করা যায়নি।';

  @override
  String get salesWatchlistPhotosAfterSave =>
      'বিবরণ স্ক্রিন থেকে সংরক্ষণের পর ছবি যোগ করুন।';

  @override
  String get salesWatchlistDeleteTitle => 'ওয়াচলিস্ট এন্ট্রি মুছবেন?';

  @override
  String get salesWatchlistSyncBeforeConvert =>
      'রূপান্তরের আগে অনলাইনে সিঙ্ক করুন।';

  @override
  String get salesWatchlistConvertTitle => 'দোকানে রূপান্তর';

  @override
  String get salesWatchlistShopName => 'দোকানের নাম *';

  @override
  String get salesWatchlistPriorityRating => 'অগ্রাধিকার রেটিং';

  @override
  String get salesWatchlistShopCreated => 'দোকান তৈরি হয়েছে';

  @override
  String get salesWatchlistSyncBeforeUpload =>
      'সংযুক্তি আপলোডের আগে সিঙ্ক করুন।';

  @override
  String get salesWatchlistRecordingHint =>
      'রেকর্ড হচ্ছে… বন্ধ করতে আবার ভয়েস ট্যাপ করুন (সর্বোচ্চ ৩ মিনিট)';

  @override
  String get salesWatchlistMarkVisited => 'ভিজিট চিহ্নিত';

  @override
  String get salesWatchlistDismiss => 'বাতিল';

  @override
  String get salesWatchlistVoiceNotes => 'ভয়েস নোট';

  @override
  String get salesWatchlistPhotos => 'ছবি';

  @override
  String get salesWatchlistConvertBtn => 'দোকানে রূপান্তর';

  @override
  String get salesWatchlistPendingSync => 'সিঙ্ক মুলতুবি';

  @override
  String get salesWatchlistActivateAgain => 'আবার সক্রিয় করুন';

  @override
  String get salesWatchlistRemove => 'সরান';

  @override
  String get salesWatchlistActivated => 'ওয়াচলিস্ট আইটেম সক্রিয় হয়েছে';

  @override
  String salesWatchlistArchivedReason(String reason) {
    return 'আর্কাইভ: $reason';
  }

  @override
  String get orderAppName => 'ARM Orders';

  @override
  String get orderSignInSubtitle =>
      'আপনার দোকান, ভ্যান বা ইমপোর্টার অ্যাকাউন্ট দিয়ে সাইন ইন করুন';

  @override
  String get orderNavCatalog => 'ক্যাটালগ';

  @override
  String get orderNavOrders => 'অর্ডার';

  @override
  String get orderNavManual => 'ম্যানুয়াল';

  @override
  String get orderNavProfile => 'প্রোফাইল';

  @override
  String get orderTitleCatalog => 'ক্যাটালগ';

  @override
  String get orderTitleCreateOrder => 'অর্ডার তৈরি';

  @override
  String get orderTitleOrderDetail => 'অর্ডার বিবরণ';

  @override
  String get orderTitleNewRequest => 'নতুন অনুরোধ';

  @override
  String get orderTitleRequestDetail => 'অনুরোধ বিবরণ';

  @override
  String get orderTitleManualOrders => 'ম্যানুয়াল অর্ডার';

  @override
  String get orderProfileCustomer => 'গ্রাহক প্রোফাইল';

  @override
  String get orderProfileShopContacts => 'দোকান যোগাযোগ';

  @override
  String get orderManualShopOnly =>
      'ম্যানুয়াল অর্ডার অনুরোধ শুধু দোকান অ্যাকাউন্টের জন্য।';

  @override
  String get orderManualNewRequest => 'নতুন অনুরোধ';

  @override
  String get orderManualEmpty => 'এখনও কোনো ম্যানুয়াল অর্ডার অনুরোধ নেই';

  @override
  String get orderManualShopOnlyCreate =>
      'শুধু দোকান অ্যাকাউন্ট ম্যানুয়াল অনুরোধ তৈরি করতে পারে';

  @override
  String get orderManualNotesRequired => 'অর্ডার নোট লিখুন';

  @override
  String get orderManualAddMedia => 'ছবি, ভয়েস বা ভিডিও (ঐচ্ছিক)';

  @override
  String get orderManualGallery => 'গ্যালারি';

  @override
  String get orderManualNoteOrMediaRequired =>
      'একটি নোট বা অন্তত একটি সংযুক্তি যোগ করুন';

  @override
  String get orderManualQueuedOffline =>
      'অফলাইনে সংরক্ষিত — সংযোগ হলে পাঠানো হবে';

  @override
  String get orderManualLinkedOrders => 'সংযুক্ত অর্ডার';

  @override
  String get commonLinkToOrders => 'অর্ডারের সাথে সংযুক্ত করুন';

  @override
  String get commonNoOrdersForCustomer =>
      'এই গ্রাহকের কোনো অর্ডার পাওয়া যায়নি';

  @override
  String get commonOrdersLinked => 'অর্ডার সংযুক্ত হয়েছে';

  @override
  String get orderCustomerProfileNotLoaded => 'গ্রাহক প্রোফাইল লোড হয়নি';

  @override
  String get statusConfirmed => 'নিশ্চিত';

  @override
  String get statusModified => 'পরিবর্তিত';

  @override
  String get statusCancelled => 'বাতিল';

  @override
  String get statusPending => 'মুলতুবি';

  @override
  String get statusDraft => 'খসড়া';

  @override
  String get planPurposeField => 'উদ্দেশ্য';

  @override
  String get orderDraftEditableNotice =>
      'এই অর্ডারটি একটি খসড়া — বিক্রয়কর্মী নিশ্চিত করার আগ পর্যন্ত আপনি এটি সম্পাদনা করতে পারবেন।';

  @override
  String get commonEdit => 'সম্পাদনা';

  @override
  String get statusPartial => 'আংশিক';

  @override
  String get statusPaid => 'পরিশোধিত';

  @override
  String get statusAssigned => 'নিয়োগ';

  @override
  String get statusInReview => 'পর্যালোচনায়';

  @override
  String get statusConverted => 'রূপান্তরিত';

  @override
  String get statusActive => 'সক্রিয়';

  @override
  String get statusArchived => 'আর্কাইভ';

  @override
  String get statusPendingSync => 'সিঙ্ক মুলতুবি';

  @override
  String get statusDiscountPendingApproval => 'ছাড় অনুমোদন মুলতুবি';

  @override
  String get statusAddItem => 'আইটেম যোগ';

  @override
  String get statusUpdateItem => 'আইটেম আপডেট';

  @override
  String get statusRemoveItem => 'আইটেম সরান';

  @override
  String get statusReturn => 'ফেরত';

  @override
  String get statusFrequent => 'ঘন ঘন';

  @override
  String get statusRegular => 'নিয়মিত';

  @override
  String get statusOccasional => 'মাঝে মাঝে';

  @override
  String get statusDormant => 'নিষ্ক্রিয়';

  @override
  String get statusNever => 'কখনো নয়';

  @override
  String get statusGoodPayer => 'ভালো পেয়ার';

  @override
  String get statusFair => 'মোটামুটি';

  @override
  String get statusPoor => 'দুর্বল';

  @override
  String get salesPickerFiltersOffline =>
      'কিছু ফিল্টারের জন্য ইন্টারনেট প্রয়োজন। ক্যাশে গ্রাহক দেখানো হচ্ছে।';

  @override
  String get salesPickerPhoneSearch => 'ফোন দিয়ে সব গ্রাহক খুঁজছি';

  @override
  String get salesPickerOrderPlaced => 'অর্ডার দেওয়া হয়েছে';

  @override
  String get commonArea => 'এলাকা';

  @override
  String get commonAllAreas => 'সব এলাকা';

  @override
  String get commonSortAz => 'ক–হ';

  @override
  String get commonSortNearest => 'নিকটতম';

  @override
  String get commonSort => 'সাজান';

  @override
  String get commonSortByDate => 'তারিখ';

  @override
  String get commonSortByArea => 'এলাকা';

  @override
  String get commonSortBySalesPerson => 'বিক্রয়কর্মী';

  @override
  String get commonCreateCustomer => 'গ্রাহক তৈরি';

  @override
  String get commonAddWatchlistPlace => 'স্থান যোগ';

  @override
  String get salesCustomerCreateGoOnline => 'গ্রাহক তৈরি করতে অনলাইনে যান';

  @override
  String get adminShopQuickAdd => 'দ্রুত দোকান যোগ';

  @override
  String get salesPickerInactive60d => '৬০+ দিন নিষ্ক্রিয়';

  @override
  String commonPageOf(int page, int lastPage) {
    return 'পৃষ্ঠা $page / $lastPage';
  }

  @override
  String get salesPickerFiltersNeedInternet =>
      'কার্যকলাপ ও এলাকা ফিল্টারের জন্য ইন্টারনেট প্রয়োজন।';

  @override
  String get salesPickerActivity1Day => '১ দিন';

  @override
  String get salesPickerActivity1Week => '১ সপ্তাহ';

  @override
  String get salesPickerActivity15Days => '১৫ দিন';

  @override
  String get salesPickerActivity30Days => '৩০ দিন';

  @override
  String get salesPickerActivity60Days => '৬০ দিন';

  @override
  String get salesPickerActivity90Days => '৯০ দিন';

  @override
  String commonAvgOrderInterval(int days) {
    return '~প্রতি $days দিন';
  }

  @override
  String get commonEnable => 'সক্রিয় করুন';

  @override
  String get biometricEnableTitle => 'ফিঙ্গারপ্রিন্ট লগইন';

  @override
  String get biometricEnableSubtitle =>
      'ফিঙ্গারপ্রিন্ট বা Face ID দিয়ে দ্রুত অ্যাপ আনলক করুন';

  @override
  String get biometricEnableReason =>
      'ফিঙ্গারপ্রিন্ট লগইন সক্রিয় করতে নিশ্চিত করুন';

  @override
  String get biometricUnlockReason => 'চালিয়ে যেতে অ্যাপ আনলক করুন';

  @override
  String get biometricUnlockButton => 'ফিঙ্গারপ্রিন্ট দিয়ে আনলক';

  @override
  String get biometricUsePassword => 'পাসওয়ার্ড ব্যবহার করুন';

  @override
  String get biometricNotAvailable =>
      'এই ডিভাইসে বায়োমেট্রিক প্রমাণীকরণ উপলব্ধ নয়';

  @override
  String get biometricOptInMessage =>
      'এই ডিভাইসে অ্যাপ আনলক করতে ফিঙ্গারপ্রিন্ট বা Face ID ব্যবহার করবেন?';

  @override
  String get biometricAppLockedTitle => 'অ্যাপ লক করা';

  @override
  String get biometricAppLockedSubtitle =>
      'অ্যাপ ব্যবহার চালিয়ে যেতে প্রমাণীকরণ করুন';

  @override
  String biometricSignInAs(String email) {
    return '$email হিসেবে সাইন ইন';
  }

  @override
  String get sessionExpired =>
      'আপনার সেশন মেয়াদ শেষ হয়েছে। আবার সাইন ইন করুন।';

  @override
  String get tokenExpiresAtTitle => 'সেশন মেয়াদ শেষ';

  @override
  String tokenExpiresAtValue(String date) {
    return '$date এর মধ্যে পুনরায় লগইন প্রয়োজন';
  }

  @override
  String get gpsOptional => 'জিপিএস (ঐচ্ছিক)';

  @override
  String get gpsCapture => 'ক্যাপচার';

  @override
  String get gpsPermissionRequired => 'জিপিএসের জন্য লোকেশন অনুমতি প্রয়োজন।';

  @override
  String get gpsEnableServices => 'অনুগ্রহ করে লোকেশন সার্ভিস চালু করুন।';

  @override
  String get gpsOptionsTooltip => 'জিপিএস অপশন';

  @override
  String get gpsClear => 'জিপিএস লোকেশন মুছুন';

  @override
  String get gpsReplace => 'বর্তমান লোকেশন দিয়ে প্রতিস্থাপন করুন';

  @override
  String get gpsClearConfirm => 'সংরক্ষিত লোকেশন মুছে ফেলতে চান?';

  @override
  String get gpsReplaceConfirm =>
      'সংরক্ষিত লোকেশন বর্তমান লোকেশন দিয়ে প্রতিস্থাপন করতে চান?';

  @override
  String get commonConfirm => 'নিশ্চিত করুন';

  @override
  String get customerContactPerson => 'যোগাযোগের ব্যক্তি (ঐচ্ছিক)';

  @override
  String get customerCreatedPartial =>
      'তৈরি হয়েছে, তবে কিছু তথ্য সংরক্ষণ করা যায়নি। কাস্টমার পেজ থেকে যোগ করুন।';

  @override
  String get customerDuplicatePhoneTitle => 'সম্ভাব্য ডুপ্লিকেট';

  @override
  String get commonOpenExisting => 'বিদ্যমানটি খুলুন';

  @override
  String get commonCreateAnyway => 'তবুও তৈরি করুন';

  @override
  String get customerAssignSalesPerson => 'সেলসপারসন নির্ধারণ (ঐচ্ছিক)';

  @override
  String get watchlistSaveProspect => 'প্রসপেক্ট হিসেবে সংরক্ষণ (অফলাইন)';

  @override
  String get watchlistProspectSaved =>
      'ওয়াচলিস্টে সংরক্ষিত — অনলাইনে এলে দোকানে রূপান্তর করুন।';

  @override
  String get watchlistProspectNeedsGps =>
      'অফলাইন প্রসপেক্ট সংরক্ষণে জিপিএস প্রয়োজন।';

  @override
  String get accountCreateLogin => 'লগইন অ্যাকাউন্ট তৈরি করুন';

  @override
  String get accountUsesContactDetails =>
      'লগইনের জন্য উপরের যোগাযোগ তথ্য ব্যবহার হবে';

  @override
  String get accountSignInHint =>
      'কাস্টমার ইমেইল বা ফোন দিয়ে সাইন ইন করতে পারবেন';

  @override
  String get accountLoginEmailOptional => 'লগইন ইমেইল (ঐচ্ছিক)';

  @override
  String get accountLoginPhoneOptional => 'লগইন ফোন (ঐচ্ছিক)';

  @override
  String get accountConfirmPassword => 'পাসওয়ার্ড নিশ্চিত করুন';

  @override
  String get accountPhoneOrEmailRequired =>
      'লগইন অ্যাকাউন্টের জন্য ফোন বা ইমেইল প্রয়োজন';

  @override
  String get accountPasswordMin => 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';

  @override
  String get accountPasswordsNoMatch => 'পাসওয়ার্ড মিলছে না';

  @override
  String get accountCreateSubmit => 'অ্যাকাউন্ট তৈরি করুন';

  @override
  String get accountUsesContactForLogin =>
      'লগইনের জন্য কাস্টমারের যোগাযোগ তথ্য ব্যবহার হবে';

  @override
  String get accountPasswordCheck =>
      'পাসওয়ার্ড যাচাই করুন (কমপক্ষে ৮ অক্ষর, মিলতে হবে)';

  @override
  String get accountResetPasswordTitle => 'লগইন পাসওয়ার্ড রিসেট করুন';

  @override
  String get accountResetPassword => 'পাসওয়ার্ড রিসেট';

  @override
  String get accountPasswordResetDone => 'লগইন পাসওয়ার্ড রিসেট হয়েছে';

  @override
  String get accountSection => 'লগইন অ্যাকাউন্ট';

  @override
  String get accountNone => 'কোনো লগইন অ্যাকাউন্ট নেই';

  @override
  String get accountNoneHint =>
      'এই কাস্টমার যেন OrderApp বা ওয়েব পোর্টাল ব্যবহার করতে পারে সেজন্য লগইন তথ্য তৈরি করুন।';

  @override
  String get accountCreateDisabledHint =>
      'শুধুমাত্র অ্যাডমিন এই কাস্টমারের লগইন তৈরি করতে পারবেন। চালু করতে অ্যাডমিনকে বলুন।';

  @override
  String get accountAllowSalespersonCreate => 'সেলসপারসন লগইন তৈরি করতে পারবে';

  @override
  String get accountCreated => 'লগইন অ্যাকাউন্ট তৈরি হয়েছে';

  @override
  String customerDuplicatePhoneBody(String name) {
    return '\"$name\" ইতিমধ্যে এই ফোন নম্বর ব্যবহার করছে।';
  }

  @override
  String get updateAvailableTitle => 'আপডেট উপলব্ধ';

  @override
  String get updateNow => 'আপডেট';

  @override
  String updateAvailableBody(int current, int latest) {
    return 'নতুন সংস্করণ ইনস্টলের জন্য প্রস্তুত (বিল্ড $current → $latest)।';
  }

  @override
  String get commonSalesperson => 'বিক্রয়কর্মী';

  @override
  String get commonVideo => 'ভিডিও';

  @override
  String commonVideoTooLarge(int maxMb) {
    return 'ভিডিওটি খুব বড় (সর্বোচ্চ $maxMb এমবি)';
  }

  @override
  String get commonViewAll => 'সব দেখুন';

  @override
  String get statusPlanned => 'পরিকল্পিত';

  @override
  String get statusDone => 'সম্পন্ন';

  @override
  String get statusMissed => 'মিস হয়েছে';

  @override
  String get salesNavPlan => 'পরিকল্পনা';

  @override
  String get salesTitlePlan => 'পরিকল্পনা';

  @override
  String get salesSyncItemVisit => 'ভিজিট';

  @override
  String get planTabVisits => 'ভিজিট';

  @override
  String get planTabDues => 'বকেয়া';

  @override
  String get planNewVisit => 'নতুন ভিজিট';

  @override
  String get planEditVisit => 'ভিজিট সম্পাদনা';

  @override
  String get planScheduleVisit => 'ভিজিট নির্ধারণ করুন';

  @override
  String get planPurposeDueCollection => 'বকেয়া আদায়';

  @override
  String get planPurposeRegularVisit => 'নিয়মিত ভিজিট';

  @override
  String get planPurposeDelivery => 'ডেলিভারি';

  @override
  String get planPurposePromotionalVisit => 'প্রমোশনাল ভিজিট';

  @override
  String get planPurposeNewClientSearch => 'নতুন ক্লায়েন্ট খোঁজা';

  @override
  String get planPurposeOther => 'অন্যান্য';

  @override
  String get planMarkDone => 'সম্পন্ন করুন';

  @override
  String get planMarkMissed => 'মিস হিসেবে চিহ্নিত';

  @override
  String get planCancelVisit => 'ভিজিট বাতিল';

  @override
  String get planOutcomeNote => 'ফলাফল নোট (ঐচ্ছিক)';

  @override
  String get planDuration => 'সময়কাল (মিনিট)';

  @override
  String get planPickCustomer => 'কাস্টমার নির্বাচন';

  @override
  String get planPickWatchlist => 'ওয়াচ-লিস্ট প্রসপেক্ট নির্বাচন';

  @override
  String get planCollectionCandidates => 'আদায় ভিজিটের জন্য উপযুক্ত';

  @override
  String get planPlanVisit => 'ভিজিট পরিকল্পনা';

  @override
  String planTodayVisits(int count) {
    return 'আজ $countটি ভিজিট';
  }

  @override
  String get planNoVisits => 'এই ফিল্টারে কোনো ভিজিট নেই।';

  @override
  String get planVisitSaved => 'ভিজিট সংরক্ষিত হয়েছে।';

  @override
  String get planSyncFirst => 'স্ট্যাটাস পরিবর্তনের আগে এই ভিজিটটি সিঙ্ক করুন।';

  @override
  String get planReminderTitle => 'পরিকল্পিত ভিজিট';

  @override
  String planReminderBody(int count) {
    return 'আপনার $countটি ভিজিট পরিকল্পিত আছে';
  }

  @override
  String get orderDiaryTitle => 'অর্ডার ডায়েরি';

  @override
  String get orderSaveAsDraft => 'খসড়া হিসেবে সংরক্ষণ';

  @override
  String get orderApplyVat => 'ভ্যাট প্রয়োগ করুন';

  @override
  String get orderVatIncluded => 'ভ্যাট সহ';

  @override
  String get orderVatExcluded => 'ভ্যাট ছাড়া';

  @override
  String get orderVatRateLabel => 'ভ্যাট %';

  @override
  String get orderSavedAsDraft => 'খসড়া হিসেবে সংরক্ষিত হয়েছে';

  @override
  String get orderKeepAsDraft => 'খসড়া হিসেবে রাখুন';

  @override
  String get orderConnectToConfirm =>
      'অর্ডার পৃষ্ঠা থেকে নিশ্চিত করতে ইন্টারনেটে সংযুক্ত হোন';

  @override
  String get purchaseSavePost => 'সংরক্ষণ ও পোস্ট';

  @override
  String get customerMoneyTitle => 'আর্থিক সারসংক্ষেপ';

  @override
  String get customerMoneyOrders => 'অর্ডার';

  @override
  String get customerMoneyPurchased => 'মোট ক্রয়';

  @override
  String get customerMoneyPaid => 'পরিশোধিত';

  @override
  String get customerMoneyDiscounts => 'ডিসকাউন্ট';

  @override
  String get customerMoneyDue => 'বকেয়া';

  @override
  String get customerMoneyOverdue => 'মেয়াদোত্তীর্ণ';

  @override
  String get customerMoneyNextPayment => 'পরবর্তী পেমেন্ট';

  @override
  String get customerMoneyLastPayment => 'সর্বশেষ পেমেন্ট';

  @override
  String get customerOrdersTitle => 'অর্ডার';

  @override
  String get customerOrdersEmpty => 'এখনও কোনো অর্ডার নেই।';

  @override
  String get commonSearch => 'খুঁজুন';

  @override
  String get commonClear => 'মুছুন';

  @override
  String get commonStatus => 'অবস্থা';

  @override
  String get commonClearFilters => 'ফিল্টার মুছুন';

  @override
  String get statusInactive => 'নিষ্ক্রিয়';

  @override
  String get statusAll => 'সব';

  @override
  String get searchFiltersTitle => 'খোঁজ ও ফিল্টার';

  @override
  String searchNoExactMatch(String query) {
    return '“$query”-এর সাথে হুবহু মিল নেই — সবচেয়ে কাছাকাছি ফলাফল দেখানো হচ্ছে।';
  }

  @override
  String get searchWatchlistHint => 'স্থান, ঠিকানা বা নোট খুঁজুন';

  @override
  String get commonProductsTitle => 'পণ্যসমূহ';

  @override
  String get commonProductsAllTab => 'সব পণ্য';

  @override
  String get commonProductsMyVanTab => 'আমার ভ্যান';

  @override
  String get commonProductSources => 'ইনভেন্টরি উৎস';

  @override
  String get commonProductSourceWarehouse => 'গুদাম';

  @override
  String get commonProductSourceMyVan => 'আমার ভ্যান';

  @override
  String get commonProductSourceOtherVans => 'অন্যান্য ভ্যান';

  @override
  String get commonProductInStockOnly => 'শুধু স্টকে আছে';

  @override
  String get commonProductInStock => 'স্টকে আছে';

  @override
  String get commonProductOutOfStock => 'স্টকে নেই';

  @override
  String get commonProductLowStock => 'স্টক কম';

  @override
  String get commonProductBrand => 'ব্র্যান্ড';

  @override
  String get commonProductCategory => 'ক্যাটাগরি';

  @override
  String get commonProductAllBrands => 'সব ব্র্যান্ড';

  @override
  String get commonProductAllCategories => 'সব ক্যাটাগরি';

  @override
  String get commonProductSortName => 'নাম (অ–হ)';

  @override
  String get commonProductSortStockDesc => 'স্টক (বেশি থেকে কম)';

  @override
  String get commonProductSortStockAsc => 'স্টক (কম থেকে বেশি)';

  @override
  String get commonProductSortPriceAsc => 'দাম (কম থেকে বেশি)';

  @override
  String get commonProductSortPriceDesc => 'দাম (বেশি থেকে কম)';

  @override
  String get commonProductViewGrid => 'গ্রিড ভিউ';

  @override
  String get commonProductViewList => 'লিস্ট ভিউ';

  @override
  String commonProductStockAsOf(String time) {
    return '$time পর্যন্ত স্টক';
  }

  @override
  String get commonProductTotalStock => 'মোট';

  @override
  String get commonProductStockBreakdown => 'উৎস অনুযায়ী স্টক';

  @override
  String get commonProductNoImage => 'ছবি নেই';

  @override
  String get salesProductLoadToVan => 'আমার ভ্যানে লোড করুন';

  @override
  String get salesProductDetailTitle => 'পণ্য';
}
