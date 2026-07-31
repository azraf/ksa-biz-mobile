// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonPhoto => 'Photo';

  @override
  String get commonVoice => 'Voice';

  @override
  String get commonStop => 'Stop';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonSignIn => 'Sign in';

  @override
  String get commonSignOut => 'Sign out';

  @override
  String get commonEmail => 'Email';

  @override
  String get commonPassword => 'Password';

  @override
  String get commonApiBaseUrl => 'API base URL';

  @override
  String get commonApiUrl => 'API URL';

  @override
  String get commonRoles => 'Roles';

  @override
  String get commonActingAs => 'Acting as';

  @override
  String get commonUser => 'User';

  @override
  String get commonPhone => 'Phone';

  @override
  String get commonMobile => 'Mobile';

  @override
  String get commonNameRequired => 'Name *';

  @override
  String get commonAddress => 'Address';

  @override
  String get commonCity => 'City';

  @override
  String get commonReason => 'Reason';

  @override
  String get commonQuantity => 'Quantity';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonNotesOptional => 'Notes (optional)';

  @override
  String get commonItems => 'Items';

  @override
  String get commonNoItemsYet => 'No items yet';

  @override
  String commonTotal(String amount) {
    return 'Total: $amount';
  }

  @override
  String get commonUnit => 'Unit';

  @override
  String get commonUnitCarton => 'Carton (CTN)';

  @override
  String commonUnitPiece(int piecesPerCarton) {
    return 'Piece (pcs) · $piecesPerCarton per CTN';
  }

  @override
  String get commonPrice => 'Price';

  @override
  String get commonDiscount => 'Discount';

  @override
  String get commonVat => 'VAT';

  @override
  String get commonSearchProducts => 'Search products';

  @override
  String commonProductPriceCtn(String price, String pieces) {
    return 'SAR $price / CTN · $pieces pcs';
  }

  @override
  String commonProductPrice(String price) {
    return 'SAR $price';
  }

  @override
  String commonQtyLine(String quantity) {
    return 'Qty $quantity';
  }

  @override
  String commonQtyAtPrice(String quantity, String price) {
    return 'Qty $quantity @ $price';
  }

  @override
  String commonProductFallback(int id) {
    return 'Product #$id';
  }

  @override
  String commonShopFallback(int id) {
    return 'Shop #$id';
  }

  @override
  String commonOrderNumber(int id) {
    return 'Order #$id';
  }

  @override
  String commonRequestNumber(int id) {
    return 'Request #$id';
  }

  @override
  String get commonRecording => 'Recording';

  @override
  String get commonRecordings => 'Recordings';

  @override
  String get commonAddRecording => 'Add recording';

  @override
  String get commonRecordAudio => 'Record audio';

  @override
  String get commonRecordVideo => 'Record video';

  @override
  String get commonStopAndUpload => 'Stop & upload';

  @override
  String get commonRecordingUploaded => 'Recording uploaded';

  @override
  String get commonCall => 'Call';

  @override
  String get commonWhatsapp => 'WhatsApp';

  @override
  String commonCouldNotOpen(String action) {
    return 'Could not open $action';
  }

  @override
  String get commonPhoneDialer => 'phone dialer';

  @override
  String get commonDiary => 'Diary';

  @override
  String commonDiaryTitle(String customerName) {
    return 'Diary — $customerName';
  }

  @override
  String get commonDiaryNote => 'Diary note';

  @override
  String get commonDiaryEmpty => 'No diary entries yet.';

  @override
  String get commonDiaryText => 'Text';

  @override
  String get commonDiaryLoadMore => 'Load more';

  @override
  String get commonDiaryPlayVoice => 'Play voice note';

  @override
  String get commonAddNote => 'Add note';

  @override
  String get commonTextNote => 'Text note';

  @override
  String get commonRecordingTitle => 'Recording...';

  @override
  String get commonStopAndSave => 'Stop & save';

  @override
  String get commonAddVisitNoteTitle => 'Add visit note?';

  @override
  String commonAddVisitNoteBody(String customerName) {
    return 'Add a diary note for $customerName?';
  }

  @override
  String get commonGpsNotCaptured => 'Not captured';

  @override
  String get commonGpsCapturing => 'Capturing...';

  @override
  String get commonGpsRefresh => 'Refresh';

  @override
  String get commonGpsCapture => 'Capture GPS';

  @override
  String get commonGpsLocationRequired =>
      'Location permission is required for shop GPS.';

  @override
  String get commonCameraPermission => 'Camera permission is required.';

  @override
  String get commonMicrophonePermission => 'Microphone permission is required.';

  @override
  String get commonRecordingPermission =>
      'Permission required to pick recordings.';

  @override
  String get commonAll => 'All';

  @override
  String get commonCash => 'Cash';

  @override
  String get commonBankTransfer => 'Bank transfer';

  @override
  String get commonCheque => 'Cheque';

  @override
  String get commonOther => 'Other';

  @override
  String get commonNoProductsFound => 'No products found';

  @override
  String get commonNoProductsCached =>
      'No products cached. Go online to download product data.';

  @override
  String get commonNameIsRequired => 'Name is required';

  @override
  String get commonAddAtLeastOneProduct => 'Add at least one product';

  @override
  String get commonPlaceOrder => 'Place order';

  @override
  String commonSourceLabel(String source) {
    return 'Source: $source';
  }

  @override
  String get commonReference => 'Reference';

  @override
  String get commonCallReference => 'Call reference';

  @override
  String get commonManualOrderRequest => 'Manual order request';

  @override
  String get commonOrderNotes => 'Order notes';

  @override
  String get commonOrderNotesHint =>
      'Describe products, quantities, or special instructions';

  @override
  String get commonSubmitRequest => 'Submit request';

  @override
  String get commonNewOrder => 'New order';

  @override
  String get commonNoOrdersYet => 'No orders yet';

  @override
  String get commonCreateOrder => 'Create order';

  @override
  String get commonOrderDetail => 'Order detail';

  @override
  String get commonEditOrder => 'Edit order';

  @override
  String get commonCustomer => 'Customer';

  @override
  String get commonPaid => 'Paid';

  @override
  String get commonDue => 'Due';

  @override
  String get commonTotalLabel => 'Total';

  @override
  String get commonGrandDiscount => 'Grand discount';

  @override
  String get commonDueDate => 'Due date';

  @override
  String get commonOverdue => 'Overdue';

  @override
  String commonOverdueDays(int days) {
    return '$days days';
  }

  @override
  String get commonPayments => 'Payments';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonLanguageEnglish => 'English';

  @override
  String get commonLanguageArabic => 'العربية';

  @override
  String get commonLanguageBangla => 'বাংলা';

  @override
  String get commonConvert => 'Convert';

  @override
  String get commonPickVideo => 'Pick video';

  @override
  String get salesAppName => 'ARM Sales(M)';

  @override
  String get salesSignInSubtitle => 'Sign in with your salesperson account';

  @override
  String get salesNavHome => 'Home';

  @override
  String get salesNavManual => 'Manual';

  @override
  String get salesNavOrders => 'Orders';

  @override
  String get salesNavVan => 'Van';

  @override
  String get salesNavDues => 'Dues';

  @override
  String get salesTitleDashboard => 'Dashboard';

  @override
  String get salesTitleManualOrders => 'Manual Orders';

  @override
  String get salesTitleOrders => 'Orders';

  @override
  String get salesTitleVanStock => 'Van Stock';

  @override
  String get salesTitleDues => 'Dues';

  @override
  String get salesTitleCreateOrder => 'Create order';

  @override
  String get salesTitleEditOrder => 'Edit order';

  @override
  String get salesTitleOrderDetail => 'Order detail';

  @override
  String get salesTitleConvertOrder => 'Convert to order';

  @override
  String get salesTitleManualOrder => 'Manual order';

  @override
  String get salesTitleLoadVan => 'Load van';

  @override
  String get salesTitleTransferStock => 'Transfer stock';

  @override
  String get salesTitleDamageReplacement => 'Damage replacement';

  @override
  String get salesTitleProductExchange => 'Product exchange';

  @override
  String get salesSelectSalesperson => 'Select salesperson';

  @override
  String get salesSearchSalesperson => 'Search by name or email';

  @override
  String get salesNoSalespeople => 'No salespeople found';

  @override
  String get salesProfile => 'Profile';

  @override
  String get salesSalespersonProfile => 'Salesperson profile';

  @override
  String get salesNoSalespersonSelected => 'No salesperson selected';

  @override
  String get salesChooseSalespersonHint =>
      'Choose a salesperson to perform sales tasks.';

  @override
  String get salesSelectSalespersonBtn => 'Select salesperson';

  @override
  String get salesChangeSalespersonBtn => 'Change salesperson';

  @override
  String get salesSelectSalespersonFirst => 'Select a salesperson first.';

  @override
  String get salesDashboardLoading => 'Loading dashboard...';

  @override
  String get salesDashboardSelectSp =>
      'Select a salesperson to view the dashboard.';

  @override
  String get salesDashboardNoProfile =>
      'Your account is not linked to a salesperson profile.';

  @override
  String salesHello(String name) {
    return 'Hello, $name';
  }

  @override
  String get salesDefaultSalesperson => 'Salesperson';

  @override
  String salesActingAsName(String name) {
    return 'Acting as: $name';
  }

  @override
  String get salesCardOutstandingDues => 'Outstanding dues';

  @override
  String salesCardUnpaidOrders(int count) {
    return '$count unpaid orders';
  }

  @override
  String get salesCardManualOrders => 'Manual orders';

  @override
  String get salesCardManualSubtitle => 'Open / assigned / in review';

  @override
  String get salesCardVanStock => 'Van stock';

  @override
  String salesCardVanProducts(int count) {
    return '$count products';
  }

  @override
  String salesCardLowStockAlerts(int count) {
    return '$count low stock alerts';
  }

  @override
  String get salesCardTapManageStock => 'Tap to manage stock';

  @override
  String get salesCardMyOrders => 'My orders';

  @override
  String get salesCardViewAll => 'View all';

  @override
  String get salesCardOrdersSubtitle => 'Create and edit orders';

  @override
  String get salesCardWatchlist => 'Watch-list';

  @override
  String get salesCardWatchlistValue => 'Save leads';

  @override
  String get salesCardWatchlistSubtitle => 'GPS locations for future visits';

  @override
  String get salesQuickSaveLocation => 'Quick-save current location';

  @override
  String get salesLocationSaved => 'Location saved to watch-list';

  @override
  String get salesAddNotesAction => 'Add notes';

  @override
  String salesNearbyShop(String name, String distance) {
    return 'Nearby shop: $name (${distance}m)';
  }

  @override
  String salesDuplicateWatchlist(String distance) {
    return 'Duplicate watch-list within ${distance}m';
  }

  @override
  String get salesDuesTotalDue => 'Total due';

  @override
  String get salesDuesNone => 'No outstanding dues';

  @override
  String get salesDuesLongPressHint => 'Long press an order to collect payment';

  @override
  String get salesNotifications => 'Notifications';

  @override
  String get salesNotificationsEmpty => 'No notifications';

  @override
  String get salesOfflineMode => 'Offline mode';

  @override
  String get salesOfflineSync => 'SYNC';

  @override
  String salesOfflineSyncing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pending changes...',
      one: '1 pending change...',
    );
    return 'Syncing $_temp0';
  }

  @override
  String salesOfflineSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes saved locally',
      one: '1 change saved locally',
    );
    return 'Offline — $_temp0';
  }

  @override
  String get salesManualTabOpenPool => 'Open pool';

  @override
  String get salesManualTabAssigned => 'Assigned';

  @override
  String get salesManualTabInReview => 'In review';

  @override
  String get salesManualTabConverted => 'Converted';

  @override
  String get salesManualEmpty => 'No manual orders';

  @override
  String get salesManualClaimed => 'Request claimed';

  @override
  String get salesManualClaimRequest => 'Claim request';

  @override
  String get salesManualConvertOrder => 'Convert to order';

  @override
  String get salesManualViewConverted => 'View converted order';

  @override
  String get salesManualTakeShopPhoto => 'Take shop photo';

  @override
  String get salesManualShopPhotoUploaded => 'Shop photo uploaded';

  @override
  String get salesManualGpsCleared => 'Shop GPS cleared';

  @override
  String salesManualGpsUpdated(String gps) {
    return 'GPS updated: $gps';
  }

  @override
  String get salesConvertShopOrder => 'Shop order';

  @override
  String get salesConvertOrderItems => 'Order items';

  @override
  String get salesConvertAddProduct => 'Add product';

  @override
  String get salesConvertOrderCreated => 'Order created';

  @override
  String get salesOrderWalkInQuick => 'Walk-in quick order';

  @override
  String get salesOrderWalkInShop => 'Walk-in Shop';

  @override
  String get salesOrderWalkInSubtitle => 'Anonymous quick sale';

  @override
  String get salesOrderWalkInNote => 'Note (optional)';

  @override
  String get salesOrderWalkInNoteHint => 'Cashier note';

  @override
  String get salesOrderCustomerType => 'Customer type';

  @override
  String get salesOrderSelectCustomer => 'Select customer';

  @override
  String get salesOrderSelected => 'Selected';

  @override
  String get salesOrderAddCustomer => 'Add customer';

  @override
  String get salesOrderSelectCustomerItems => 'Select customer and add items';

  @override
  String get salesOrderSavedLocally =>
      'Order saved locally — will sync when online';

  @override
  String get salesOrderWalkInUnavailable =>
      'Walk-in shop not available. Go online to sync.';

  @override
  String get salesOrderGoOnlineCatalog =>
      'Go online first to download customer and product data.';

  @override
  String get salesOrderNoCustomerTypes =>
      'No customer types available. Go online to refresh data.';

  @override
  String get salesOrderCannotEdit => 'This order cannot be edited.';

  @override
  String get salesOrderAddProduct => 'Add product';

  @override
  String get salesOrderChangeQty => 'Change quantity';

  @override
  String get salesOrderSalesReturn => 'Sales return';

  @override
  String get salesOrderReturn => 'Return';

  @override
  String get salesOrderRemoveItem => 'Remove item';

  @override
  String get salesOrderUpdateQty => 'Update quantity';

  @override
  String get salesOrderCollectPayment => 'Collect payment';

  @override
  String salesOrderCollectPaymentTitle(int orderId) {
    return 'Collect payment #$orderId';
  }

  @override
  String get salesOrderAmountDue => 'Amount due';

  @override
  String get salesOrderAmountCollected => 'Amount collected';

  @override
  String get salesOrderPaymentMethod => 'Payment method';

  @override
  String get salesOrderRecordPayment => 'Record payment';

  @override
  String get salesOrderEnterValidAmount => 'Enter a valid amount';

  @override
  String get salesOrderRequestDiscount => 'Request discount';

  @override
  String get salesOrderRequestGrandDiscount => 'Request grand discount';

  @override
  String get salesOrderDiscountAmount => 'Discount amount (SAR)';

  @override
  String get salesOrderDiscountSubmitted => 'Discount request submitted';

  @override
  String get salesOrderCancelOrder => 'Cancel order';

  @override
  String get salesOrderCancelled => 'Order cancelled';

  @override
  String get salesOrderEditTooltip => 'Edit order';

  @override
  String get salesPickerSelectShop => 'Select shop';

  @override
  String get salesPickerSelectVan => 'Select van';

  @override
  String get salesPickerSelectImporter => 'Select importer';

  @override
  String get salesPickerSearchHint => 'Search name, phone, contact';

  @override
  String get salesPickerNoCustomers => 'No customers found';

  @override
  String get salesQuickNewShop => 'New shop';

  @override
  String get salesQuickShopName => 'Shop name *';

  @override
  String get salesQuickSaveShop => 'Save shop';

  @override
  String get salesQuickNewVan => 'New van customer';

  @override
  String get salesQuickIqama => 'Iqama';

  @override
  String get salesQuickSaveVan => 'Save van';

  @override
  String get salesQuickNewImporter => 'New importer';

  @override
  String get salesQuickSaveImporter => 'Save importer';

  @override
  String get salesVanEmpty => 'Van is empty';

  @override
  String get salesVanLowStock => 'Low stock';

  @override
  String get salesVanExchange => 'Exchange';

  @override
  String get salesVanDamage => 'Damage';

  @override
  String get salesVanTransfer => 'Transfer';

  @override
  String get salesVanLoad => 'Load van';

  @override
  String get salesVanUnloadMessage => 'Return stock from van to warehouse.';

  @override
  String get salesVanUnloadQty => 'Quantity (cartons)';

  @override
  String get salesVanUnloadBtn => 'Unload';

  @override
  String get salesVanLoadSelectAll => 'Select all';

  @override
  String get salesVanLoadNoStock => 'No warehouse stock available';

  @override
  String salesVanLoadAvailable(String balance) {
    return 'Available: $balance';
  }

  @override
  String get salesVanLoadSelectOne => 'Select at least one product';

  @override
  String salesVanLoadSuccess(int count) {
    return 'Loaded $count product(s) to van';
  }

  @override
  String get salesVanLoadAll => 'Load all available';

  @override
  String get salesVanLoadSelected => 'Load selected';

  @override
  String get salesVanTransferProduct => 'Your van product';

  @override
  String get salesVanTransferTo => 'Transfer to';

  @override
  String get salesVanTransferCompleted => 'Transfer completed';

  @override
  String get salesVanDamageSelect => 'Select product';

  @override
  String get salesVanDamageRecord => 'Record replacement';

  @override
  String get salesVanExchangeReturns => 'Customer returns';

  @override
  String get salesVanExchangeSelectReturn => 'Select return product';

  @override
  String get salesVanExchangeReturnQty => 'Return quantity';

  @override
  String get salesVanExchangeSettlement => 'Settlement';

  @override
  String get salesVanExchangeGiveProduct => 'Give another product';

  @override
  String get salesVanExchangeCashRefund => 'Cash refund';

  @override
  String get salesVanExchangeGiveTo => 'Give to customer';

  @override
  String get salesVanExchangeSelectOut => 'Select out product';

  @override
  String get salesVanExchangeOutQty => 'Out quantity';

  @override
  String get salesVanExchangeCashAmount => 'Cash amount (SAR)';

  @override
  String get salesVanExchangeRecord => 'Record exchange';

  @override
  String get salesWatchlist => 'Watch-list';

  @override
  String get salesWatchlistMap => 'Watch-list map';

  @override
  String get salesWatchlistViewMap => 'View on map';

  @override
  String get salesWatchlistSortDistance => 'Sort by distance';

  @override
  String get salesWatchlistActive => 'Active';

  @override
  String get salesWatchlistArchived => 'Archived';

  @override
  String get salesWatchlistAddLocation => 'Add location';

  @override
  String get salesWatchlistLoading => 'Loading watch-list...';

  @override
  String get salesWatchlistEmpty => 'No watch-list items yet.';

  @override
  String get salesWatchlistSaveTitle => 'Save to watch-list';

  @override
  String get salesWatchlistPlaceName => 'Place name';

  @override
  String get salesWatchlistNoteOptional => 'Note (optional)';

  @override
  String get salesWatchlistSaveLocation => 'Save location';

  @override
  String get salesWatchlistVoicePending =>
      'Voice saved after you create the entry (upload on detail).';

  @override
  String get salesWatchlistPhotosAfterSave =>
      'Add photos after saving from detail screen.';

  @override
  String get salesWatchlistDeleteTitle => 'Delete watch-list entry?';

  @override
  String get salesWatchlistSyncBeforeConvert =>
      'Sync this item online before converting.';

  @override
  String get salesWatchlistConvertTitle => 'Convert to shop';

  @override
  String get salesWatchlistShopName => 'Shop name *';

  @override
  String get salesWatchlistPriorityRating => 'Priority rating';

  @override
  String get salesWatchlistShopCreated => 'Shop created';

  @override
  String get salesWatchlistSyncBeforeUpload =>
      'Sync this item before uploading attachments.';

  @override
  String get salesWatchlistRecordingHint =>
      'Recording… tap Voice again to stop (max 3 min)';

  @override
  String get salesWatchlistMarkVisited => 'Mark visited';

  @override
  String get salesWatchlistDismiss => 'Dismiss';

  @override
  String get salesWatchlistVoiceNotes => 'Voice notes';

  @override
  String get salesWatchlistPhotos => 'Photos';

  @override
  String get salesWatchlistConvertBtn => 'Convert to shop';

  @override
  String get salesWatchlistPendingSync => 'Pending sync';

  @override
  String get orderAppName => 'ARM Orders';

  @override
  String get orderSignInSubtitle =>
      'Sign in with your shop, van, or importer account';

  @override
  String get orderNavCatalog => 'Catalog';

  @override
  String get orderNavOrders => 'Orders';

  @override
  String get orderNavManual => 'Manual';

  @override
  String get orderNavProfile => 'Profile';

  @override
  String get orderTitleCatalog => 'Catalog';

  @override
  String get orderTitleCreateOrder => 'Create order';

  @override
  String get orderTitleOrderDetail => 'Order detail';

  @override
  String get orderTitleNewRequest => 'New request';

  @override
  String get orderTitleRequestDetail => 'Request detail';

  @override
  String get orderTitleManualOrders => 'Manual Orders';

  @override
  String get orderProfileCustomer => 'Customer profile';

  @override
  String get orderProfileShopContacts => 'Shop contacts';

  @override
  String get orderManualShopOnly =>
      'Manual order requests are available for shop accounts only.';

  @override
  String get orderManualNewRequest => 'New request';

  @override
  String get orderManualEmpty => 'No manual order requests yet';

  @override
  String get orderManualShopOnlyCreate =>
      'Only shop accounts can create manual requests';

  @override
  String get orderManualNotesRequired => 'Please enter order notes';

  @override
  String get orderCustomerProfileNotLoaded => 'Customer profile not loaded';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusModified => 'Modified';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusPartial => 'Partial';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusAssigned => 'Assigned';

  @override
  String get statusInReview => 'In review';

  @override
  String get statusConverted => 'Converted';

  @override
  String get statusActive => 'Active';

  @override
  String get statusArchived => 'Archived';

  @override
  String get statusPendingSync => 'Pending sync';

  @override
  String get statusDiscountPendingApproval => 'Discount pending approval';

  @override
  String get statusAddItem => 'Add item';

  @override
  String get statusUpdateItem => 'Update item';

  @override
  String get statusRemoveItem => 'Remove item';

  @override
  String get statusReturn => 'Return';

  @override
  String get statusFrequent => 'Frequent';

  @override
  String get statusRegular => 'Regular';

  @override
  String get statusOccasional => 'Occasional';

  @override
  String get statusDormant => 'Dormant';

  @override
  String get statusNever => 'Never';

  @override
  String get statusGoodPayer => 'Good payer';

  @override
  String get statusFair => 'Fair';

  @override
  String get statusPoor => 'Poor';

  @override
  String get salesPickerFiltersOffline =>
      'Some filters require internet. Showing cached customers only.';

  @override
  String get salesPickerPhoneSearch => 'Searching all customers by phone';

  @override
  String get salesPickerOrderPlaced => 'Order placed';

  @override
  String get commonArea => 'Area';

  @override
  String get commonAllAreas => 'All areas';

  @override
  String get commonSortAz => 'A–Z';

  @override
  String get commonSortNearest => 'Nearest';

  @override
  String get salesPickerInactive60d => 'Inactive 60d+';

  @override
  String commonPageOf(int page, int lastPage) {
    return 'Page $page of $lastPage';
  }

  @override
  String get salesPickerFiltersNeedInternet =>
      'Activity and area filters require internet.';

  @override
  String get salesPickerActivity1Day => '1 day';

  @override
  String get salesPickerActivity1Week => '1 week';

  @override
  String get salesPickerActivity15Days => '15 days';

  @override
  String get salesPickerActivity30Days => '30 days';

  @override
  String get salesPickerActivity60Days => '60 days';

  @override
  String get salesPickerActivity90Days => '90 days';

  @override
  String commonAvgOrderInterval(int days) {
    return '~every $days days';
  }
}
