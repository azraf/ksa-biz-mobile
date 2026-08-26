import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get commonPhoto;

  /// No description provided for @commonVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get commonVoice;

  /// No description provided for @commonStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get commonStop;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get commonSignIn;

  /// No description provided for @commonSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get commonSignOut;

  /// No description provided for @logoutUnsyncedWarning.
  ///
  /// In en, this message translates to:
  /// **'{count} unsynced record(s) will be permanently lost if a different user signs in on this device. Sign out anyway?'**
  String logoutUnsyncedWarning(int count);

  /// No description provided for @logoutAnyway.
  ///
  /// In en, this message translates to:
  /// **'Sign out anyway'**
  String get logoutAnyway;

  /// No description provided for @commonEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get commonPassword;

  /// No description provided for @commonApiBaseUrl.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get commonApiBaseUrl;

  /// No description provided for @commonApiUrl.
  ///
  /// In en, this message translates to:
  /// **'API URL'**
  String get commonApiUrl;

  /// No description provided for @commonRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get commonRoles;

  /// No description provided for @commonActingAs.
  ///
  /// In en, this message translates to:
  /// **'Acting as'**
  String get commonActingAs;

  /// No description provided for @commonUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get commonUser;

  /// No description provided for @commonPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get commonPhone;

  /// No description provided for @commonMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get commonMobile;

  /// No description provided for @commonNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get commonNameRequired;

  /// No description provided for @commonNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get commonNameArabic;

  /// No description provided for @commonAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get commonAddress;

  /// No description provided for @commonCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get commonCity;

  /// No description provided for @commonReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get commonReason;

  /// No description provided for @commonQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get commonQuantity;

  /// No description provided for @commonQuantityCartons.
  ///
  /// In en, this message translates to:
  /// **'Quantity (cartons)'**
  String get commonQuantityCartons;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get commonNotesOptional;

  /// No description provided for @commonItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get commonItems;

  /// No description provided for @commonNoItemsYet.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get commonNoItemsYet;

  /// No description provided for @commonTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String commonTotal(String amount);

  /// No description provided for @commonUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get commonUnit;

  /// No description provided for @commonUnitCarton.
  ///
  /// In en, this message translates to:
  /// **'Carton (CTN)'**
  String get commonUnitCarton;

  /// No description provided for @commonUnitPiece.
  ///
  /// In en, this message translates to:
  /// **'Piece (pcs) · {piecesPerCarton} per CTN'**
  String commonUnitPiece(int piecesPerCarton);

  /// No description provided for @commonPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get commonPrice;

  /// No description provided for @commonDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get commonDiscount;

  /// No description provided for @commonVat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get commonVat;

  /// No description provided for @commonExclVat.
  ///
  /// In en, this message translates to:
  /// **'Excl. VAT'**
  String get commonExclVat;

  /// No description provided for @lineItemVatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{qtyLabel} · excl {excl} · VAT {vat} · {total}'**
  String lineItemVatSubtitle(
      String qtyLabel, String excl, String vat, String total);

  /// No description provided for @commonSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get commonSearchProducts;

  /// No description provided for @commonProductPriceCtn.
  ///
  /// In en, this message translates to:
  /// **'SAR {price} / CTN · {pieces} pcs'**
  String commonProductPriceCtn(String price, String pieces);

  /// No description provided for @commonProductPrice.
  ///
  /// In en, this message translates to:
  /// **'SAR {price}'**
  String commonProductPrice(String price);

  /// No description provided for @commonQtyLine.
  ///
  /// In en, this message translates to:
  /// **'Qty {quantity}'**
  String commonQtyLine(String quantity);

  /// No description provided for @commonQtyAtPrice.
  ///
  /// In en, this message translates to:
  /// **'Qty {quantity} @ {price}'**
  String commonQtyAtPrice(String quantity, String price);

  /// No description provided for @commonProductFallback.
  ///
  /// In en, this message translates to:
  /// **'Product #{id}'**
  String commonProductFallback(int id);

  /// No description provided for @commonShopFallback.
  ///
  /// In en, this message translates to:
  /// **'Shop #{id}'**
  String commonShopFallback(int id);

  /// No description provided for @commonInvoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get commonInvoiceLabel;

  /// No description provided for @commonPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get commonPageNotFound;

  /// No description provided for @commonOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #{id}'**
  String commonOrderNumber(int id);

  /// No description provided for @commonRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request #{id}'**
  String commonRequestNumber(int id);

  /// No description provided for @commonRecording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get commonRecording;

  /// No description provided for @commonRecordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get commonRecordings;

  /// No description provided for @commonAddRecording.
  ///
  /// In en, this message translates to:
  /// **'Add recording'**
  String get commonAddRecording;

  /// No description provided for @commonRecordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record audio'**
  String get commonRecordAudio;

  /// No description provided for @commonRecordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record video'**
  String get commonRecordVideo;

  /// No description provided for @commonStopAndUpload.
  ///
  /// In en, this message translates to:
  /// **'Stop & upload'**
  String get commonStopAndUpload;

  /// No description provided for @commonRecordingUploaded.
  ///
  /// In en, this message translates to:
  /// **'Recording uploaded'**
  String get commonRecordingUploaded;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get commonWhatsapp;

  /// No description provided for @commonCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open {action}'**
  String commonCouldNotOpen(String action);

  /// No description provided for @commonPhoneDialer.
  ///
  /// In en, this message translates to:
  /// **'phone dialer'**
  String get commonPhoneDialer;

  /// No description provided for @commonDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get commonDiary;

  /// No description provided for @commonDiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Diary — {customerName}'**
  String commonDiaryTitle(String customerName);

  /// No description provided for @commonDiaryNote.
  ///
  /// In en, this message translates to:
  /// **'Diary note'**
  String get commonDiaryNote;

  /// No description provided for @commonDiaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet.'**
  String get commonDiaryEmpty;

  /// No description provided for @commonDiaryText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get commonDiaryText;

  /// No description provided for @commonDiaryLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get commonDiaryLoadMore;

  /// No description provided for @commonDiaryPlayVoice.
  ///
  /// In en, this message translates to:
  /// **'Play voice note'**
  String get commonDiaryPlayVoice;

  /// No description provided for @commonAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get commonAddNote;

  /// No description provided for @commonTextNote.
  ///
  /// In en, this message translates to:
  /// **'Text note'**
  String get commonTextNote;

  /// No description provided for @commonRecordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get commonRecordingTitle;

  /// No description provided for @commonStopAndSave.
  ///
  /// In en, this message translates to:
  /// **'Stop & save'**
  String get commonStopAndSave;

  /// No description provided for @commonAddVisitNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add visit note?'**
  String get commonAddVisitNoteTitle;

  /// No description provided for @commonAddVisitNoteBody.
  ///
  /// In en, this message translates to:
  /// **'Add a diary note for {customerName}?'**
  String commonAddVisitNoteBody(String customerName);

  /// No description provided for @commonGpsNotCaptured.
  ///
  /// In en, this message translates to:
  /// **'Not captured'**
  String get commonGpsNotCaptured;

  /// No description provided for @commonGpsCapturing.
  ///
  /// In en, this message translates to:
  /// **'Capturing...'**
  String get commonGpsCapturing;

  /// No description provided for @commonGpsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonGpsRefresh;

  /// No description provided for @commonGpsCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture GPS'**
  String get commonGpsCapture;

  /// No description provided for @commonGpsLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required for shop GPS.'**
  String get commonGpsLocationRequired;

  /// No description provided for @commonCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required.'**
  String get commonCameraPermission;

  /// No description provided for @commonMicrophonePermission.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required.'**
  String get commonMicrophonePermission;

  /// No description provided for @commonRecordingPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission required to pick recordings.'**
  String get commonRecordingPermission;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get commonCash;

  /// No description provided for @commonBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get commonBankTransfer;

  /// No description provided for @commonCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get commonCheque;

  /// No description provided for @commonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get commonOther;

  /// No description provided for @commonNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get commonNoProductsFound;

  /// No description provided for @commonNoProductsCached.
  ///
  /// In en, this message translates to:
  /// **'No products cached. Go online to download product data.'**
  String get commonNoProductsCached;

  /// No description provided for @commonNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get commonNameIsRequired;

  /// No description provided for @commonAddAtLeastOneProduct.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product'**
  String get commonAddAtLeastOneProduct;

  /// No description provided for @commonPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get commonPlaceOrder;

  /// No description provided for @commonSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String commonSourceLabel(String source);

  /// No description provided for @commonReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get commonReference;

  /// No description provided for @commonCallReference.
  ///
  /// In en, this message translates to:
  /// **'Call reference'**
  String get commonCallReference;

  /// No description provided for @commonManualOrderRequest.
  ///
  /// In en, this message translates to:
  /// **'Manual order request'**
  String get commonManualOrderRequest;

  /// No description provided for @commonOrderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order notes'**
  String get commonOrderNotes;

  /// No description provided for @commonOrderNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Describe products, quantities, or special instructions'**
  String get commonOrderNotesHint;

  /// No description provided for @commonSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get commonSubmitRequest;

  /// No description provided for @commonNewOrder.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get commonNewOrder;

  /// No description provided for @commonNoOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get commonNoOrdersYet;

  /// No description provided for @commonCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get commonCreateOrder;

  /// No description provided for @commonOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order detail'**
  String get commonOrderDetail;

  /// No description provided for @commonEditOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get commonEditOrder;

  /// No description provided for @commonCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get commonCustomer;

  /// No description provided for @commonPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get commonPaid;

  /// No description provided for @commonDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get commonDue;

  /// No description provided for @commonTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotalLabel;

  /// No description provided for @commonGrandDiscount.
  ///
  /// In en, this message translates to:
  /// **'Grand discount'**
  String get commonGrandDiscount;

  /// No description provided for @commonDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get commonDueDate;

  /// No description provided for @commonOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get commonOverdue;

  /// No description provided for @commonOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String commonOverdueDays(int days);

  /// No description provided for @commonPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get commonPayments;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonLanguageEnglish;

  /// No description provided for @commonLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get commonLanguageArabic;

  /// No description provided for @commonLanguageBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get commonLanguageBangla;

  /// No description provided for @commonConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get commonConvert;

  /// No description provided for @commonPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick video'**
  String get commonPickVideo;

  /// No description provided for @salesAppName.
  ///
  /// In en, this message translates to:
  /// **'ARM Sales(M)'**
  String get salesAppName;

  /// No description provided for @salesSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your salesperson account'**
  String get salesSignInSubtitle;

  /// No description provided for @salesNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get salesNavHome;

  /// No description provided for @salesNavManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get salesNavManual;

  /// No description provided for @salesNavOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get salesNavOrders;

  /// No description provided for @salesNavVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get salesNavVan;

  /// No description provided for @salesNavDues.
  ///
  /// In en, this message translates to:
  /// **'Dues'**
  String get salesNavDues;

  /// No description provided for @salesTitleDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get salesTitleDashboard;

  /// No description provided for @salesTitleManualOrders.
  ///
  /// In en, this message translates to:
  /// **'Manual Orders'**
  String get salesTitleManualOrders;

  /// No description provided for @salesTitleOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get salesTitleOrders;

  /// No description provided for @salesTitleVanStock.
  ///
  /// In en, this message translates to:
  /// **'Van Stock'**
  String get salesTitleVanStock;

  /// No description provided for @salesTitleDues.
  ///
  /// In en, this message translates to:
  /// **'Dues'**
  String get salesTitleDues;

  /// No description provided for @salesTitleCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get salesTitleCreateOrder;

  /// No description provided for @salesTitleEditOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get salesTitleEditOrder;

  /// No description provided for @salesTitleOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order detail'**
  String get salesTitleOrderDetail;

  /// No description provided for @salesTitleConvertOrder.
  ///
  /// In en, this message translates to:
  /// **'Convert to order'**
  String get salesTitleConvertOrder;

  /// No description provided for @salesTitleManualOrder.
  ///
  /// In en, this message translates to:
  /// **'Manual order'**
  String get salesTitleManualOrder;

  /// No description provided for @salesTitleLoadVan.
  ///
  /// In en, this message translates to:
  /// **'Load van'**
  String get salesTitleLoadVan;

  /// No description provided for @salesTitleTransferStock.
  ///
  /// In en, this message translates to:
  /// **'Transfer stock'**
  String get salesTitleTransferStock;

  /// No description provided for @salesTitleDamageReplacement.
  ///
  /// In en, this message translates to:
  /// **'Damage replacement'**
  String get salesTitleDamageReplacement;

  /// No description provided for @salesTitleProductExchange.
  ///
  /// In en, this message translates to:
  /// **'Product exchange'**
  String get salesTitleProductExchange;

  /// No description provided for @salesSelectSalesperson.
  ///
  /// In en, this message translates to:
  /// **'Select salesperson'**
  String get salesSelectSalesperson;

  /// No description provided for @salesSearchSalesperson.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get salesSearchSalesperson;

  /// No description provided for @salesNoSalespeople.
  ///
  /// In en, this message translates to:
  /// **'No salespeople found'**
  String get salesNoSalespeople;

  /// No description provided for @salesProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get salesProfile;

  /// No description provided for @salesSalespersonProfile.
  ///
  /// In en, this message translates to:
  /// **'Salesperson profile'**
  String get salesSalespersonProfile;

  /// No description provided for @salesNoSalespersonSelected.
  ///
  /// In en, this message translates to:
  /// **'No salesperson selected'**
  String get salesNoSalespersonSelected;

  /// No description provided for @salesChooseSalespersonHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a salesperson to perform sales tasks.'**
  String get salesChooseSalespersonHint;

  /// No description provided for @salesSelectSalespersonBtn.
  ///
  /// In en, this message translates to:
  /// **'Select salesperson'**
  String get salesSelectSalespersonBtn;

  /// No description provided for @salesChangeSalespersonBtn.
  ///
  /// In en, this message translates to:
  /// **'Change salesperson'**
  String get salesChangeSalespersonBtn;

  /// No description provided for @salesSelectSalespersonFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a salesperson first.'**
  String get salesSelectSalespersonFirst;

  /// No description provided for @salesDashboardLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get salesDashboardLoading;

  /// No description provided for @salesDashboardSelectSp.
  ///
  /// In en, this message translates to:
  /// **'Select a salesperson to view the dashboard.'**
  String get salesDashboardSelectSp;

  /// No description provided for @salesDashboardNoProfile.
  ///
  /// In en, this message translates to:
  /// **'Your account is not linked to a salesperson profile.'**
  String get salesDashboardNoProfile;

  /// No description provided for @salesDashboardCachedDues.
  ///
  /// In en, this message translates to:
  /// **'Showing cached dues from {fetchedAt}'**
  String salesDashboardCachedDues(String fetchedAt);

  /// No description provided for @salesHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String salesHello(String name);

  /// No description provided for @salesDefaultSalesperson.
  ///
  /// In en, this message translates to:
  /// **'Salesperson'**
  String get salesDefaultSalesperson;

  /// No description provided for @salesActingAsName.
  ///
  /// In en, this message translates to:
  /// **'Acting as: {name}'**
  String salesActingAsName(String name);

  /// No description provided for @salesCardOutstandingDues.
  ///
  /// In en, this message translates to:
  /// **'Outstanding dues'**
  String get salesCardOutstandingDues;

  /// No description provided for @salesCardUnpaidOrders.
  ///
  /// In en, this message translates to:
  /// **'{count} unpaid orders'**
  String salesCardUnpaidOrders(int count);

  /// No description provided for @salesCardManualOrders.
  ///
  /// In en, this message translates to:
  /// **'Manual orders'**
  String get salesCardManualOrders;

  /// No description provided for @salesCardManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open / assigned / in review'**
  String get salesCardManualSubtitle;

  /// No description provided for @salesCardVanStock.
  ///
  /// In en, this message translates to:
  /// **'Van stock'**
  String get salesCardVanStock;

  /// No description provided for @salesCardVanProducts.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String salesCardVanProducts(int count);

  /// No description provided for @salesCardLowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count} low stock alerts'**
  String salesCardLowStockAlerts(int count);

  /// No description provided for @salesCardTapManageStock.
  ///
  /// In en, this message translates to:
  /// **'Tap to manage stock'**
  String get salesCardTapManageStock;

  /// No description provided for @salesCardMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get salesCardMyOrders;

  /// No description provided for @salesCardViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get salesCardViewAll;

  /// No description provided for @salesCardOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and edit orders'**
  String get salesCardOrdersSubtitle;

  /// No description provided for @salesCardWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watch-list'**
  String get salesCardWatchlist;

  /// No description provided for @salesCardWatchlistValue.
  ///
  /// In en, this message translates to:
  /// **'Save leads'**
  String get salesCardWatchlistValue;

  /// No description provided for @salesCardWatchlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GPS locations for future visits'**
  String get salesCardWatchlistSubtitle;

  /// No description provided for @salesQuickSaveLocation.
  ///
  /// In en, this message translates to:
  /// **'Quick-save current location'**
  String get salesQuickSaveLocation;

  /// No description provided for @salesLocationSaved.
  ///
  /// In en, this message translates to:
  /// **'Location saved to watch-list'**
  String get salesLocationSaved;

  /// No description provided for @salesAddNotesAction.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get salesAddNotesAction;

  /// No description provided for @salesNearbyShop.
  ///
  /// In en, this message translates to:
  /// **'Nearby shop: {name} ({distance}m)'**
  String salesNearbyShop(String name, String distance);

  /// No description provided for @salesDuplicateWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Duplicate watch-list within {distance}m'**
  String salesDuplicateWatchlist(String distance);

  /// No description provided for @salesDuesTotalDue.
  ///
  /// In en, this message translates to:
  /// **'Total due'**
  String get salesDuesTotalDue;

  /// No description provided for @salesDuesNone.
  ///
  /// In en, this message translates to:
  /// **'No outstanding dues'**
  String get salesDuesNone;

  /// No description provided for @salesDuesLongPressHint.
  ///
  /// In en, this message translates to:
  /// **'Long press an order to collect payment'**
  String get salesDuesLongPressHint;

  /// No description provided for @salesNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get salesNotifications;

  /// No description provided for @salesNotificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get salesNotificationsEmpty;

  /// No description provided for @salesOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get salesOfflineMode;

  /// No description provided for @salesOfflineSync.
  ///
  /// In en, this message translates to:
  /// **'SYNC'**
  String get salesOfflineSync;

  /// No description provided for @salesOfflineSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing {count, plural, =1{1 pending change...} other{{count} pending changes...}}'**
  String salesOfflineSyncing(int count);

  /// No description provided for @salesOfflineSaved.
  ///
  /// In en, this message translates to:
  /// **'Offline — {count, plural, =1{1 change saved locally} other{{count} changes saved locally}}'**
  String salesOfflineSaved(int count);

  /// No description provided for @salesOfflineAllSynced.
  ///
  /// In en, this message translates to:
  /// **'All changes synced'**
  String get salesOfflineAllSynced;

  /// No description provided for @salesOfflineSyncProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing {completed} of {total}…'**
  String salesOfflineSyncProgress(int completed, int total);

  /// No description provided for @salesOfflineServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Connected but server is unreachable'**
  String get salesOfflineServerUnreachable;

  /// No description provided for @salesOfflineRetryUploads.
  ///
  /// In en, this message translates to:
  /// **'Retry uploads'**
  String get salesOfflineRetryUploads;

  /// No description provided for @salesOfflineUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 upload failed} other{{count} uploads failed}}'**
  String salesOfflineUploadFailed(int count);

  /// No description provided for @salesOfflineUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading… {percent}%'**
  String salesOfflineUploading(int percent);

  /// No description provided for @salesErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Showing saved data when available.'**
  String get salesErrorOffline;

  /// No description provided for @salesErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get salesErrorGeneric;

  /// No description provided for @salesErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Please try again.'**
  String get salesErrorTimeout;

  /// No description provided for @salesErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get salesErrorUnauthorized;

  /// No description provided for @salesErrorPayloadTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File is too large. Try a smaller photo or shorter recording.'**
  String get salesErrorPayloadTooLarge;

  /// No description provided for @salesErrorConflict.
  ///
  /// In en, this message translates to:
  /// **'Server has newer data. Check Sync issues.'**
  String get salesErrorConflict;

  /// No description provided for @salesPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get salesPendingSync;

  /// No description provided for @salesSyncExhausted.
  ///
  /// In en, this message translates to:
  /// **'Max retries reached — dismiss or retry all'**
  String get salesSyncExhausted;

  /// No description provided for @salesSyncItemOrderCreate.
  ///
  /// In en, this message translates to:
  /// **'Order (create)'**
  String get salesSyncItemOrderCreate;

  /// No description provided for @salesSyncItemOrderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order (update)'**
  String get salesSyncItemOrderUpdate;

  /// No description provided for @salesSyncItemExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get salesSyncItemExpense;

  /// No description provided for @salesSyncItemWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watch-list entry'**
  String get salesSyncItemWatchlist;

  /// No description provided for @salesSyncItemDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary note'**
  String get salesSyncItemDiary;

  /// No description provided for @salesOrderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by shop or order #'**
  String get salesOrderSearchHint;

  /// No description provided for @salesOrderFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get salesOrderFilterToday;

  /// No description provided for @salesOrderFilterWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get salesOrderFilterWeek;

  /// No description provided for @salesOrderFilterPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get salesOrderFilterPendingSync;

  /// No description provided for @salesOrderFilterUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get salesOrderFilterUnpaid;

  /// No description provided for @salesManualEmptyOpenPool.
  ///
  /// In en, this message translates to:
  /// **'No open manual order requests'**
  String get salesManualEmptyOpenPool;

  /// No description provided for @salesManualEmptyAssigned.
  ///
  /// In en, this message translates to:
  /// **'No assigned manual orders'**
  String get salesManualEmptyAssigned;

  /// No description provided for @salesManualEmptyInReview.
  ///
  /// In en, this message translates to:
  /// **'No orders in review'**
  String get salesManualEmptyInReview;

  /// No description provided for @salesManualEmptyConverted.
  ///
  /// In en, this message translates to:
  /// **'No converted manual orders'**
  String get salesManualEmptyConverted;

  /// No description provided for @salesEmptyOrdersCta.
  ///
  /// In en, this message translates to:
  /// **'Create your first order'**
  String get salesEmptyOrdersCta;

  /// No description provided for @salesEmptyCustomersOnline.
  ///
  /// In en, this message translates to:
  /// **'Go online to refresh your assigned customers'**
  String get salesEmptyCustomersOnline;

  /// No description provided for @salesEmptyDuesHint.
  ///
  /// In en, this message translates to:
  /// **'Outstanding dues appear after delivered orders'**
  String get salesEmptyDuesHint;

  /// No description provided for @salesVanOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'Van stock changes require an internet connection'**
  String get salesVanOfflineBanner;

  /// No description provided for @salesVanActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Van stock actions'**
  String get salesVanActionsTitle;

  /// No description provided for @salesOfflineHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get salesOfflineHelpTitle;

  /// No description provided for @salesOfflineHelpWorks.
  ///
  /// In en, this message translates to:
  /// **'Works offline: create orders, watch-list, diary text, browse cached customers and products.'**
  String get salesOfflineHelpWorks;

  /// No description provided for @salesOfflineHelpNeedsInternet.
  ///
  /// In en, this message translates to:
  /// **'Needs internet: manual orders, van stock, diary voice upload, quick-create customer, payments on unsynced orders.'**
  String get salesOfflineHelpNeedsInternet;

  /// No description provided for @salesPaymentSyncFirst.
  ///
  /// In en, this message translates to:
  /// **'Sync this order before collecting payment'**
  String get salesPaymentSyncFirst;

  /// No description provided for @salesStorageLowContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue anyway'**
  String get salesStorageLowContinue;

  /// No description provided for @salesQuickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick links'**
  String get salesQuickLinks;

  /// No description provided for @salesDuesCollect.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get salesDuesCollect;

  /// No description provided for @salesOrderRepeatLast.
  ///
  /// In en, this message translates to:
  /// **'Repeat last order'**
  String get salesOrderRepeatLast;

  /// No description provided for @salesDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get salesDarkMode;

  /// No description provided for @salesFirstRunTipDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard shows dues, van stock, and quick links'**
  String get salesFirstRunTipDashboard;

  /// No description provided for @salesFirstRunTipOrder.
  ///
  /// In en, this message translates to:
  /// **'Tap New Order to sell — works offline when catalog is cached'**
  String get salesFirstRunTipOrder;

  /// No description provided for @salesFirstRunTipOffline.
  ///
  /// In en, this message translates to:
  /// **'The banner shows sync status; tap it for sync issues'**
  String get salesFirstRunTipOffline;

  /// No description provided for @salesFirstRunGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get salesFirstRunGotIt;

  /// No description provided for @orderHomeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get orderHomeRecent;

  /// No description provided for @orderHomeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get orderHomeThisMonth;

  /// No description provided for @orderHomeOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding balance'**
  String get orderHomeOutstanding;

  /// No description provided for @orderContextError.
  ///
  /// In en, this message translates to:
  /// **'Could not match your account to a shop. Contact support.'**
  String get orderContextError;

  /// No description provided for @adminProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get adminProfileTitle;

  /// No description provided for @adminCustomersHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers hub'**
  String get adminCustomersHubTitle;

  /// No description provided for @adminNavAssignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get adminNavAssignments;

  /// No description provided for @adminOfflineWriteBlocked.
  ///
  /// In en, this message translates to:
  /// **'This action requires an internet connection.'**
  String get adminOfflineWriteBlocked;

  /// No description provided for @salesSyncIssuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync issues'**
  String get salesSyncIssuesTitle;

  /// No description provided for @salesSyncIssuesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sync issues'**
  String get salesSyncIssuesEmpty;

  /// No description provided for @salesSyncRetries.
  ///
  /// In en, this message translates to:
  /// **'Retries: {count}'**
  String salesSyncRetries(int count);

  /// No description provided for @salesSyncDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get salesSyncDismiss;

  /// No description provided for @salesSyncRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get salesSyncRetry;

  /// No description provided for @salesSyncRetryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry all'**
  String get salesSyncRetryAll;

  /// No description provided for @salesLastSyncedAt.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String salesLastSyncedAt(String time);

  /// No description provided for @salesCardCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get salesCardCustomers;

  /// No description provided for @salesCardCustomersValue.
  ///
  /// In en, this message translates to:
  /// **'My customers'**
  String get salesCardCustomersValue;

  /// No description provided for @salesCardCustomersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shops, vans, importers — diary & media'**
  String get salesCardCustomersSubtitle;

  /// No description provided for @salesCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get salesCustomersTitle;

  /// No description provided for @salesCustomersShops.
  ///
  /// In en, this message translates to:
  /// **'Shops'**
  String get salesCustomersShops;

  /// No description provided for @salesCustomersVans.
  ///
  /// In en, this message translates to:
  /// **'Vans'**
  String get salesCustomersVans;

  /// No description provided for @salesCustomersImporters.
  ///
  /// In en, this message translates to:
  /// **'Importers'**
  String get salesCustomersImporters;

  /// No description provided for @salesCustomersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No assigned customers'**
  String get salesCustomersEmpty;

  /// No description provided for @salesCustomersAssignedOnly.
  ///
  /// In en, this message translates to:
  /// **'Showing customers assigned to you'**
  String get salesCustomersAssignedOnly;

  /// No description provided for @salesCustomersNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby map'**
  String get salesCustomersNearby;

  /// No description provided for @salesStorageLowWarning.
  ///
  /// In en, this message translates to:
  /// **'Low storage — capture may fail'**
  String get salesStorageLowWarning;

  /// No description provided for @salesCustomerDetail.
  ///
  /// In en, this message translates to:
  /// **'Customer detail'**
  String get salesCustomerDetail;

  /// No description provided for @salesCustomerActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get salesCustomerActivity;

  /// No description provided for @salesCustomerMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get salesCustomerMedia;

  /// No description provided for @salesCustomerDiary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get salesCustomerDiary;

  /// No description provided for @salesOrderEditOfflineBlocked.
  ///
  /// In en, this message translates to:
  /// **'Order editing requires an internet connection.'**
  String get salesOrderEditOfflineBlocked;

  /// No description provided for @salesOrderEditPendingSync.
  ///
  /// In en, this message translates to:
  /// **'This order is still syncing. Edit after sync completes.'**
  String get salesOrderEditPendingSync;

  /// No description provided for @salesManualTabOpenPool.
  ///
  /// In en, this message translates to:
  /// **'Open pool'**
  String get salesManualTabOpenPool;

  /// No description provided for @salesManualTabAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get salesManualTabAssigned;

  /// No description provided for @salesManualTabInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get salesManualTabInReview;

  /// No description provided for @salesManualTabConverted.
  ///
  /// In en, this message translates to:
  /// **'Converted'**
  String get salesManualTabConverted;

  /// No description provided for @salesManualEmpty.
  ///
  /// In en, this message translates to:
  /// **'No manual orders'**
  String get salesManualEmpty;

  /// No description provided for @salesManualClaimed.
  ///
  /// In en, this message translates to:
  /// **'Request claimed'**
  String get salesManualClaimed;

  /// No description provided for @salesManualClaimRequest.
  ///
  /// In en, this message translates to:
  /// **'Claim request'**
  String get salesManualClaimRequest;

  /// No description provided for @salesManualConvertOrder.
  ///
  /// In en, this message translates to:
  /// **'Convert to order'**
  String get salesManualConvertOrder;

  /// No description provided for @salesManualViewConverted.
  ///
  /// In en, this message translates to:
  /// **'View converted order'**
  String get salesManualViewConverted;

  /// No description provided for @salesManualTakeShopPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take shop photo'**
  String get salesManualTakeShopPhoto;

  /// No description provided for @salesManualShopPhotoUploaded.
  ///
  /// In en, this message translates to:
  /// **'Shop photo uploaded'**
  String get salesManualShopPhotoUploaded;

  /// No description provided for @salesManualGpsCleared.
  ///
  /// In en, this message translates to:
  /// **'Shop GPS cleared'**
  String get salesManualGpsCleared;

  /// No description provided for @salesManualGpsUpdated.
  ///
  /// In en, this message translates to:
  /// **'GPS updated: {gps}'**
  String salesManualGpsUpdated(String gps);

  /// No description provided for @salesConvertShopOrder.
  ///
  /// In en, this message translates to:
  /// **'Shop order'**
  String get salesConvertShopOrder;

  /// No description provided for @salesConvertOrderItems.
  ///
  /// In en, this message translates to:
  /// **'Order items'**
  String get salesConvertOrderItems;

  /// No description provided for @salesConvertAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get salesConvertAddProduct;

  /// No description provided for @salesConvertOrderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order created'**
  String get salesConvertOrderCreated;

  /// No description provided for @salesOrderWalkInQuick.
  ///
  /// In en, this message translates to:
  /// **'Walk-in quick order'**
  String get salesOrderWalkInQuick;

  /// No description provided for @salesOrderWalkInShop.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Shop'**
  String get salesOrderWalkInShop;

  /// No description provided for @salesOrderWalkInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Anonymous quick sale'**
  String get salesOrderWalkInSubtitle;

  /// No description provided for @salesOrderWalkInNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get salesOrderWalkInNote;

  /// No description provided for @salesOrderWalkInNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Cashier note'**
  String get salesOrderWalkInNoteHint;

  /// No description provided for @salesOrderCustomerType.
  ///
  /// In en, this message translates to:
  /// **'Customer type'**
  String get salesOrderCustomerType;

  /// No description provided for @salesOrderSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get salesOrderSelectCustomer;

  /// No description provided for @salesOrderSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get salesOrderSelected;

  /// No description provided for @salesOrderAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get salesOrderAddCustomer;

  /// No description provided for @salesOrderSelectCustomerItems.
  ///
  /// In en, this message translates to:
  /// **'Select customer and add items'**
  String get salesOrderSelectCustomerItems;

  /// No description provided for @salesOrderSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Order saved locally — will sync when online'**
  String get salesOrderSavedLocally;

  /// No description provided for @salesOrderWalkInUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Walk-in shop not available. Go online to sync.'**
  String get salesOrderWalkInUnavailable;

  /// No description provided for @salesOrderGoOnlineCatalog.
  ///
  /// In en, this message translates to:
  /// **'Go online first to download customer and product data.'**
  String get salesOrderGoOnlineCatalog;

  /// No description provided for @salesOrderNoCustomerTypes.
  ///
  /// In en, this message translates to:
  /// **'No customer types available. Go online to refresh data.'**
  String get salesOrderNoCustomerTypes;

  /// No description provided for @salesOrderCannotEdit.
  ///
  /// In en, this message translates to:
  /// **'This order cannot be edited.'**
  String get salesOrderCannotEdit;

  /// No description provided for @salesOrderAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get salesOrderAddProduct;

  /// No description provided for @salesOrderChangeQty.
  ///
  /// In en, this message translates to:
  /// **'Change quantity'**
  String get salesOrderChangeQty;

  /// No description provided for @salesOrderSalesReturn.
  ///
  /// In en, this message translates to:
  /// **'Sales return'**
  String get salesOrderSalesReturn;

  /// No description provided for @salesOrderReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get salesOrderReturn;

  /// No description provided for @salesOrderRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get salesOrderRemoveItem;

  /// No description provided for @salesOrderUpdateQty.
  ///
  /// In en, this message translates to:
  /// **'Update quantity'**
  String get salesOrderUpdateQty;

  /// No description provided for @salesOrderCollectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect payment'**
  String get salesOrderCollectPayment;

  /// No description provided for @salesOrderCollectPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Collect payment #{orderId}'**
  String salesOrderCollectPaymentTitle(int orderId);

  /// No description provided for @salesOrderAmountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get salesOrderAmountDue;

  /// No description provided for @salesOrderAmountCollected.
  ///
  /// In en, this message translates to:
  /// **'Amount collected'**
  String get salesOrderAmountCollected;

  /// No description provided for @salesOrderPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get salesOrderPaymentMethod;

  /// No description provided for @salesOrderRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get salesOrderRecordPayment;

  /// No description provided for @paymentVoidPayment.
  ///
  /// In en, this message translates to:
  /// **'Void payment'**
  String get paymentVoidPayment;

  /// No description provided for @paymentVoidReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for voiding'**
  String get paymentVoidReason;

  /// No description provided for @paymentVoided.
  ///
  /// In en, this message translates to:
  /// **'Payment voided'**
  String get paymentVoided;

  /// No description provided for @paymentVoidedLabel.
  ///
  /// In en, this message translates to:
  /// **'voided'**
  String get paymentVoidedLabel;

  /// No description provided for @salesOrderEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get salesOrderEnterValidAmount;

  /// No description provided for @salesOrderRequestDiscount.
  ///
  /// In en, this message translates to:
  /// **'Request discount'**
  String get salesOrderRequestDiscount;

  /// No description provided for @salesOrderRequestGrandDiscount.
  ///
  /// In en, this message translates to:
  /// **'Request grand discount'**
  String get salesOrderRequestGrandDiscount;

  /// No description provided for @salesOrderDiscountAmount.
  ///
  /// In en, this message translates to:
  /// **'Discount amount (SAR)'**
  String get salesOrderDiscountAmount;

  /// No description provided for @salesOrderDiscountSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Discount request submitted'**
  String get salesOrderDiscountSubmitted;

  /// No description provided for @salesOrderCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get salesOrderCancelOrder;

  /// No description provided for @salesOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled'**
  String get salesOrderCancelled;

  /// No description provided for @salesOrderCancellationPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Cancellation submitted for admin approval'**
  String get salesOrderCancellationPendingApproval;

  /// No description provided for @salesOrderEditTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get salesOrderEditTooltip;

  /// No description provided for @salesPickerSelectShop.
  ///
  /// In en, this message translates to:
  /// **'Select shop'**
  String get salesPickerSelectShop;

  /// No description provided for @salesPickerSelectVan.
  ///
  /// In en, this message translates to:
  /// **'Select van'**
  String get salesPickerSelectVan;

  /// No description provided for @salesPickerSelectImporter.
  ///
  /// In en, this message translates to:
  /// **'Select importer'**
  String get salesPickerSelectImporter;

  /// No description provided for @salesPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, phone, contact'**
  String get salesPickerSearchHint;

  /// No description provided for @salesPickerNoCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get salesPickerNoCustomers;

  /// No description provided for @salesQuickNewShop.
  ///
  /// In en, this message translates to:
  /// **'New shop'**
  String get salesQuickNewShop;

  /// No description provided for @salesQuickShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name *'**
  String get salesQuickShopName;

  /// No description provided for @salesQuickSaveShop.
  ///
  /// In en, this message translates to:
  /// **'Save shop'**
  String get salesQuickSaveShop;

  /// No description provided for @salesQuickNewVan.
  ///
  /// In en, this message translates to:
  /// **'New van customer'**
  String get salesQuickNewVan;

  /// No description provided for @salesQuickIqama.
  ///
  /// In en, this message translates to:
  /// **'Iqama'**
  String get salesQuickIqama;

  /// No description provided for @salesQuickSaveVan.
  ///
  /// In en, this message translates to:
  /// **'Save van'**
  String get salesQuickSaveVan;

  /// No description provided for @salesQuickNewImporter.
  ///
  /// In en, this message translates to:
  /// **'New importer'**
  String get salesQuickNewImporter;

  /// No description provided for @salesQuickSaveImporter.
  ///
  /// In en, this message translates to:
  /// **'Save importer'**
  String get salesQuickSaveImporter;

  /// No description provided for @salesVanEmpty.
  ///
  /// In en, this message translates to:
  /// **'Van is empty'**
  String get salesVanEmpty;

  /// No description provided for @salesVanLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get salesVanLowStock;

  /// No description provided for @salesVanExchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get salesVanExchange;

  /// No description provided for @salesVanDamage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get salesVanDamage;

  /// No description provided for @salesVanTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get salesVanTransfer;

  /// No description provided for @salesVanLoad.
  ///
  /// In en, this message translates to:
  /// **'Load van'**
  String get salesVanLoad;

  /// No description provided for @salesVanUnloadMessage.
  ///
  /// In en, this message translates to:
  /// **'Return stock from van to warehouse.'**
  String get salesVanUnloadMessage;

  /// No description provided for @salesVanUnloadQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity (cartons)'**
  String get salesVanUnloadQty;

  /// No description provided for @salesVanUnloadBtn.
  ///
  /// In en, this message translates to:
  /// **'Unload'**
  String get salesVanUnloadBtn;

  /// No description provided for @salesVanLoadSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get salesVanLoadSelectAll;

  /// No description provided for @salesVanLoadNoStock.
  ///
  /// In en, this message translates to:
  /// **'No warehouse stock available'**
  String get salesVanLoadNoStock;

  /// No description provided for @salesVanLoadAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available: {balance}'**
  String salesVanLoadAvailable(String balance);

  /// No description provided for @salesVanLoadSelectOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one product'**
  String get salesVanLoadSelectOne;

  /// No description provided for @salesVanLoadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Loaded {count} product(s) to van'**
  String salesVanLoadSuccess(int count);

  /// No description provided for @salesVanLoadAll.
  ///
  /// In en, this message translates to:
  /// **'Load all available'**
  String get salesVanLoadAll;

  /// No description provided for @salesVanLoadSelected.
  ///
  /// In en, this message translates to:
  /// **'Load selected'**
  String get salesVanLoadSelected;

  /// No description provided for @salesVanTransferProduct.
  ///
  /// In en, this message translates to:
  /// **'Your van product'**
  String get salesVanTransferProduct;

  /// No description provided for @salesVanTransferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to'**
  String get salesVanTransferTo;

  /// No description provided for @salesVanTransferCompleted.
  ///
  /// In en, this message translates to:
  /// **'Transfer completed'**
  String get salesVanTransferCompleted;

  /// No description provided for @salesVanDamageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get salesVanDamageSelect;

  /// No description provided for @salesVanDamageRecord.
  ///
  /// In en, this message translates to:
  /// **'Record replacement'**
  String get salesVanDamageRecord;

  /// No description provided for @salesVanExchangeReturns.
  ///
  /// In en, this message translates to:
  /// **'Customer returns'**
  String get salesVanExchangeReturns;

  /// No description provided for @salesVanExchangeSelectReturn.
  ///
  /// In en, this message translates to:
  /// **'Select return product'**
  String get salesVanExchangeSelectReturn;

  /// No description provided for @salesVanExchangeReturnQty.
  ///
  /// In en, this message translates to:
  /// **'Return quantity (cartons)'**
  String get salesVanExchangeReturnQty;

  /// No description provided for @salesVanExchangeSettlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get salesVanExchangeSettlement;

  /// No description provided for @salesVanExchangeGiveProduct.
  ///
  /// In en, this message translates to:
  /// **'Give another product'**
  String get salesVanExchangeGiveProduct;

  /// No description provided for @salesVanExchangeCashRefund.
  ///
  /// In en, this message translates to:
  /// **'Cash refund'**
  String get salesVanExchangeCashRefund;

  /// No description provided for @salesVanExchangeGiveTo.
  ///
  /// In en, this message translates to:
  /// **'Give to customer'**
  String get salesVanExchangeGiveTo;

  /// No description provided for @salesVanExchangeSelectOut.
  ///
  /// In en, this message translates to:
  /// **'Select out product'**
  String get salesVanExchangeSelectOut;

  /// No description provided for @salesVanExchangeOutQty.
  ///
  /// In en, this message translates to:
  /// **'Out quantity (cartons)'**
  String get salesVanExchangeOutQty;

  /// No description provided for @salesVanExchangeCashAmount.
  ///
  /// In en, this message translates to:
  /// **'Cash amount (SAR)'**
  String get salesVanExchangeCashAmount;

  /// No description provided for @salesVanExchangeRecord.
  ///
  /// In en, this message translates to:
  /// **'Record exchange'**
  String get salesVanExchangeRecord;

  /// No description provided for @salesWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watch-list'**
  String get salesWatchlist;

  /// No description provided for @salesWatchlistMap.
  ///
  /// In en, this message translates to:
  /// **'Watch-list map'**
  String get salesWatchlistMap;

  /// No description provided for @salesWatchlistViewMap.
  ///
  /// In en, this message translates to:
  /// **'View on map'**
  String get salesWatchlistViewMap;

  /// No description provided for @salesWatchlistSortDistance.
  ///
  /// In en, this message translates to:
  /// **'Sort by distance'**
  String get salesWatchlistSortDistance;

  /// No description provided for @salesWatchlistActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get salesWatchlistActive;

  /// No description provided for @salesWatchlistArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get salesWatchlistArchived;

  /// No description provided for @salesWatchlistAddLocation.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get salesWatchlistAddLocation;

  /// No description provided for @salesWatchlistLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading watch-list...'**
  String get salesWatchlistLoading;

  /// No description provided for @salesWatchlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No watch-list items yet.'**
  String get salesWatchlistEmpty;

  /// No description provided for @salesWatchlistSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save to watch-list'**
  String get salesWatchlistSaveTitle;

  /// No description provided for @salesWatchlistPlaceName.
  ///
  /// In en, this message translates to:
  /// **'Place name'**
  String get salesWatchlistPlaceName;

  /// No description provided for @salesWatchlistNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get salesWatchlistNoteOptional;

  /// No description provided for @salesWatchlistSaveLocation.
  ///
  /// In en, this message translates to:
  /// **'Save location'**
  String get salesWatchlistSaveLocation;

  /// No description provided for @salesWatchlistVoicePending.
  ///
  /// In en, this message translates to:
  /// **'Voice saved after you create the entry (upload on detail).'**
  String get salesWatchlistVoicePending;

  /// No description provided for @salesWatchlistMediaPartial.
  ///
  /// In en, this message translates to:
  /// **'Saved, but some attachments could not be uploaded.'**
  String get salesWatchlistMediaPartial;

  /// No description provided for @salesWatchlistPhotosAfterSave.
  ///
  /// In en, this message translates to:
  /// **'Add photos after saving from detail screen.'**
  String get salesWatchlistPhotosAfterSave;

  /// No description provided for @salesWatchlistDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete watch-list entry?'**
  String get salesWatchlistDeleteTitle;

  /// No description provided for @salesWatchlistSyncBeforeConvert.
  ///
  /// In en, this message translates to:
  /// **'Sync this item online before converting.'**
  String get salesWatchlistSyncBeforeConvert;

  /// No description provided for @salesWatchlistConvertTitle.
  ///
  /// In en, this message translates to:
  /// **'Convert to shop'**
  String get salesWatchlistConvertTitle;

  /// No description provided for @salesWatchlistShopName.
  ///
  /// In en, this message translates to:
  /// **'Shop name *'**
  String get salesWatchlistShopName;

  /// No description provided for @salesWatchlistPriorityRating.
  ///
  /// In en, this message translates to:
  /// **'Priority rating'**
  String get salesWatchlistPriorityRating;

  /// No description provided for @salesWatchlistShopCreated.
  ///
  /// In en, this message translates to:
  /// **'Shop created'**
  String get salesWatchlistShopCreated;

  /// No description provided for @salesWatchlistSyncBeforeUpload.
  ///
  /// In en, this message translates to:
  /// **'Sync this item before uploading attachments.'**
  String get salesWatchlistSyncBeforeUpload;

  /// No description provided for @salesWatchlistRecordingHint.
  ///
  /// In en, this message translates to:
  /// **'Recording… tap Voice again to stop (max 3 min)'**
  String get salesWatchlistRecordingHint;

  /// No description provided for @salesWatchlistMarkVisited.
  ///
  /// In en, this message translates to:
  /// **'Mark visited'**
  String get salesWatchlistMarkVisited;

  /// No description provided for @salesWatchlistDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get salesWatchlistDismiss;

  /// No description provided for @salesWatchlistVoiceNotes.
  ///
  /// In en, this message translates to:
  /// **'Voice notes'**
  String get salesWatchlistVoiceNotes;

  /// No description provided for @salesWatchlistPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get salesWatchlistPhotos;

  /// No description provided for @salesWatchlistConvertBtn.
  ///
  /// In en, this message translates to:
  /// **'Convert to shop'**
  String get salesWatchlistConvertBtn;

  /// No description provided for @salesWatchlistPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get salesWatchlistPendingSync;

  /// No description provided for @salesWatchlistActivateAgain.
  ///
  /// In en, this message translates to:
  /// **'Activate again'**
  String get salesWatchlistActivateAgain;

  /// No description provided for @salesWatchlistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get salesWatchlistRemove;

  /// No description provided for @salesWatchlistActivated.
  ///
  /// In en, this message translates to:
  /// **'Watch-list item activated'**
  String get salesWatchlistActivated;

  /// No description provided for @salesWatchlistArchivedReason.
  ///
  /// In en, this message translates to:
  /// **'Archived: {reason}'**
  String salesWatchlistArchivedReason(String reason);

  /// No description provided for @orderAppName.
  ///
  /// In en, this message translates to:
  /// **'ARM Orders'**
  String get orderAppName;

  /// No description provided for @orderSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your shop, van, or importer account'**
  String get orderSignInSubtitle;

  /// No description provided for @orderNavCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get orderNavCatalog;

  /// No description provided for @orderNavOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderNavOrders;

  /// No description provided for @orderNavManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get orderNavManual;

  /// No description provided for @orderNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get orderNavProfile;

  /// No description provided for @orderTitleCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get orderTitleCatalog;

  /// No description provided for @orderTitleCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get orderTitleCreateOrder;

  /// No description provided for @orderTitleOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order detail'**
  String get orderTitleOrderDetail;

  /// No description provided for @orderTitleNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get orderTitleNewRequest;

  /// No description provided for @orderTitleRequestDetail.
  ///
  /// In en, this message translates to:
  /// **'Request detail'**
  String get orderTitleRequestDetail;

  /// No description provided for @orderTitleManualOrders.
  ///
  /// In en, this message translates to:
  /// **'Manual Orders'**
  String get orderTitleManualOrders;

  /// No description provided for @orderProfileCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer profile'**
  String get orderProfileCustomer;

  /// No description provided for @orderProfileShopContacts.
  ///
  /// In en, this message translates to:
  /// **'Shop contacts'**
  String get orderProfileShopContacts;

  /// No description provided for @orderManualShopOnly.
  ///
  /// In en, this message translates to:
  /// **'Manual order requests are available for shop accounts only.'**
  String get orderManualShopOnly;

  /// No description provided for @orderManualNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get orderManualNewRequest;

  /// No description provided for @orderManualEmpty.
  ///
  /// In en, this message translates to:
  /// **'No manual order requests yet'**
  String get orderManualEmpty;

  /// No description provided for @orderManualShopOnlyCreate.
  ///
  /// In en, this message translates to:
  /// **'Only shop accounts can create manual requests'**
  String get orderManualShopOnlyCreate;

  /// No description provided for @orderManualNotesRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter order notes'**
  String get orderManualNotesRequired;

  /// No description provided for @orderManualAddMedia.
  ///
  /// In en, this message translates to:
  /// **'Photos, voice or video (optional)'**
  String get orderManualAddMedia;

  /// No description provided for @orderManualGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get orderManualGallery;

  /// No description provided for @orderManualNoteOrMediaRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a note or at least one attachment'**
  String get orderManualNoteOrMediaRequired;

  /// No description provided for @orderManualQueuedOffline.
  ///
  /// In en, this message translates to:
  /// **'Saved offline — will send when connected'**
  String get orderManualQueuedOffline;

  /// No description provided for @orderManualLinkedOrders.
  ///
  /// In en, this message translates to:
  /// **'Linked orders'**
  String get orderManualLinkedOrders;

  /// No description provided for @commonLinkToOrders.
  ///
  /// In en, this message translates to:
  /// **'Link to order(s)'**
  String get commonLinkToOrders;

  /// No description provided for @commonNoOrdersForCustomer.
  ///
  /// In en, this message translates to:
  /// **'No orders found for this customer'**
  String get commonNoOrdersForCustomer;

  /// No description provided for @commonOrdersLinked.
  ///
  /// In en, this message translates to:
  /// **'Orders linked'**
  String get commonOrdersLinked;

  /// No description provided for @orderCustomerProfileNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Customer profile not loaded'**
  String get orderCustomerProfileNotLoaded;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get statusModified;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @planPurposeField.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get planPurposeField;

  /// No description provided for @orderDraftEditableNotice.
  ///
  /// In en, this message translates to:
  /// **'This order is a draft — you can still edit it until the salesperson confirms it.'**
  String get orderDraftEditableNotice;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @statusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get statusPartial;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get statusAssigned;

  /// No description provided for @statusInReview.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get statusInReview;

  /// No description provided for @statusConverted.
  ///
  /// In en, this message translates to:
  /// **'Converted'**
  String get statusConverted;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get statusArchived;

  /// No description provided for @statusPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get statusPendingSync;

  /// No description provided for @statusDiscountPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Discount pending approval'**
  String get statusDiscountPendingApproval;

  /// No description provided for @statusAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get statusAddItem;

  /// No description provided for @statusUpdateItem.
  ///
  /// In en, this message translates to:
  /// **'Update item'**
  String get statusUpdateItem;

  /// No description provided for @statusRemoveItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get statusRemoveItem;

  /// No description provided for @statusReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get statusReturn;

  /// No description provided for @statusFrequent.
  ///
  /// In en, this message translates to:
  /// **'Frequent'**
  String get statusFrequent;

  /// No description provided for @statusRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get statusRegular;

  /// No description provided for @statusOccasional.
  ///
  /// In en, this message translates to:
  /// **'Occasional'**
  String get statusOccasional;

  /// No description provided for @statusDormant.
  ///
  /// In en, this message translates to:
  /// **'Dormant'**
  String get statusDormant;

  /// No description provided for @statusNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get statusNever;

  /// No description provided for @statusGoodPayer.
  ///
  /// In en, this message translates to:
  /// **'Good payer'**
  String get statusGoodPayer;

  /// No description provided for @statusFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get statusFair;

  /// No description provided for @statusPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get statusPoor;

  /// No description provided for @salesPickerFiltersOffline.
  ///
  /// In en, this message translates to:
  /// **'Some filters require internet. Showing cached customers only.'**
  String get salesPickerFiltersOffline;

  /// No description provided for @salesPickerPhoneSearch.
  ///
  /// In en, this message translates to:
  /// **'Searching all customers by phone'**
  String get salesPickerPhoneSearch;

  /// No description provided for @salesPickerOrderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get salesPickerOrderPlaced;

  /// No description provided for @commonArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get commonArea;

  /// No description provided for @commonAllAreas.
  ///
  /// In en, this message translates to:
  /// **'All areas'**
  String get commonAllAreas;

  /// No description provided for @commonSortAz.
  ///
  /// In en, this message translates to:
  /// **'A–Z'**
  String get commonSortAz;

  /// No description provided for @commonSortNearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get commonSortNearest;

  /// No description provided for @commonSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get commonSort;

  /// No description provided for @commonSortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonSortByDate;

  /// No description provided for @commonSortByArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get commonSortByArea;

  /// No description provided for @commonSortBySalesPerson.
  ///
  /// In en, this message translates to:
  /// **'Sales person'**
  String get commonSortBySalesPerson;

  /// No description provided for @commonCreateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Create customer'**
  String get commonCreateCustomer;

  /// No description provided for @commonAddWatchlistPlace.
  ///
  /// In en, this message translates to:
  /// **'Add place'**
  String get commonAddWatchlistPlace;

  /// No description provided for @salesCustomerCreateGoOnline.
  ///
  /// In en, this message translates to:
  /// **'Go online to create a customer'**
  String get salesCustomerCreateGoOnline;

  /// No description provided for @adminShopQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick add shop'**
  String get adminShopQuickAdd;

  /// No description provided for @salesPickerInactive60d.
  ///
  /// In en, this message translates to:
  /// **'Inactive 60d+'**
  String get salesPickerInactive60d;

  /// No description provided for @commonPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {lastPage}'**
  String commonPageOf(int page, int lastPage);

  /// No description provided for @salesPickerFiltersNeedInternet.
  ///
  /// In en, this message translates to:
  /// **'Activity and area filters require internet.'**
  String get salesPickerFiltersNeedInternet;

  /// No description provided for @salesPickerActivity1Day.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get salesPickerActivity1Day;

  /// No description provided for @salesPickerActivity1Week.
  ///
  /// In en, this message translates to:
  /// **'1 week'**
  String get salesPickerActivity1Week;

  /// No description provided for @salesPickerActivity15Days.
  ///
  /// In en, this message translates to:
  /// **'15 days'**
  String get salesPickerActivity15Days;

  /// No description provided for @salesPickerActivity30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get salesPickerActivity30Days;

  /// No description provided for @salesPickerActivity60Days.
  ///
  /// In en, this message translates to:
  /// **'60 days'**
  String get salesPickerActivity60Days;

  /// No description provided for @salesPickerActivity90Days.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get salesPickerActivity90Days;

  /// No description provided for @commonAvgOrderInterval.
  ///
  /// In en, this message translates to:
  /// **'~every {days} days'**
  String commonAvgOrderInterval(int days);

  /// No description provided for @commonEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get commonEnable;

  /// No description provided for @biometricEnableTitle.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint login'**
  String get biometricEnableTitle;

  /// No description provided for @biometricEnableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app quickly with your fingerprint or Face ID'**
  String get biometricEnableSubtitle;

  /// No description provided for @biometricEnableReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to enable fingerprint login'**
  String get biometricEnableReason;

  /// No description provided for @biometricUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app to continue'**
  String get biometricUnlockReason;

  /// No description provided for @biometricUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint'**
  String get biometricUnlockButton;

  /// No description provided for @biometricUsePassword.
  ///
  /// In en, this message translates to:
  /// **'Use password instead'**
  String get biometricUsePassword;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @biometricOptInMessage.
  ///
  /// In en, this message translates to:
  /// **'Use your fingerprint or Face ID to unlock the app on this device?'**
  String get biometricOptInMessage;

  /// No description provided for @biometricAppLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get biometricAppLockedTitle;

  /// No description provided for @biometricAppLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue using the app'**
  String get biometricAppLockedSubtitle;

  /// No description provided for @biometricSignInAs.
  ///
  /// In en, this message translates to:
  /// **'Sign in as {email}'**
  String biometricSignInAs(String email);

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @tokenExpiresAtTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expires'**
  String get tokenExpiresAtTitle;

  /// No description provided for @tokenExpiresAtValue.
  ///
  /// In en, this message translates to:
  /// **'Re-login required by {date}'**
  String tokenExpiresAtValue(String date);

  /// No description provided for @gpsOptional.
  ///
  /// In en, this message translates to:
  /// **'GPS (optional)'**
  String get gpsOptional;

  /// No description provided for @gpsCapture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get gpsCapture;

  /// No description provided for @gpsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required for GPS.'**
  String get gpsPermissionRequired;

  /// No description provided for @gpsEnableServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services.'**
  String get gpsEnableServices;

  /// No description provided for @gpsOptionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'GPS options'**
  String get gpsOptionsTooltip;

  /// No description provided for @gpsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear GPS location'**
  String get gpsClear;

  /// No description provided for @gpsReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace with current location'**
  String get gpsReplace;

  /// No description provided for @gpsClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the saved location?'**
  String get gpsClearConfirm;

  /// No description provided for @gpsReplaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to replace the saved location with current location?'**
  String get gpsReplaceConfirm;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @customerContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact person (optional)'**
  String get customerContactPerson;

  /// No description provided for @customerCreatedPartial.
  ///
  /// In en, this message translates to:
  /// **'Created, but some details could not be saved. Add them from the customer page.'**
  String get customerCreatedPartial;

  /// No description provided for @customerDuplicatePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate'**
  String get customerDuplicatePhoneTitle;

  /// No description provided for @commonOpenExisting.
  ///
  /// In en, this message translates to:
  /// **'Open existing'**
  String get commonOpenExisting;

  /// No description provided for @commonCreateAnyway.
  ///
  /// In en, this message translates to:
  /// **'Create anyway'**
  String get commonCreateAnyway;

  /// No description provided for @customerAssignSalesPerson.
  ///
  /// In en, this message translates to:
  /// **'Assign salesperson (optional)'**
  String get customerAssignSalesPerson;

  /// No description provided for @watchlistSaveProspect.
  ///
  /// In en, this message translates to:
  /// **'Save as prospect (offline)'**
  String get watchlistSaveProspect;

  /// No description provided for @watchlistProspectSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to watchlist — convert to shop when online.'**
  String get watchlistProspectSaved;

  /// No description provided for @watchlistProspectNeedsGps.
  ///
  /// In en, this message translates to:
  /// **'GPS is required to save an offline prospect.'**
  String get watchlistProspectNeedsGps;

  /// No description provided for @accountCreateLogin.
  ///
  /// In en, this message translates to:
  /// **'Create login account'**
  String get accountCreateLogin;

  /// No description provided for @accountUsesContactDetails.
  ///
  /// In en, this message translates to:
  /// **'Uses contact details above for login'**
  String get accountUsesContactDetails;

  /// No description provided for @accountSignInHint.
  ///
  /// In en, this message translates to:
  /// **'Customer can sign in with email or phone'**
  String get accountSignInHint;

  /// No description provided for @accountLoginEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Login email (optional)'**
  String get accountLoginEmailOptional;

  /// No description provided for @accountLoginPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Login phone (optional)'**
  String get accountLoginPhoneOptional;

  /// No description provided for @accountConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get accountConfirmPassword;

  /// No description provided for @accountPhoneOrEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone or email is required for login account'**
  String get accountPhoneOrEmailRequired;

  /// No description provided for @accountPasswordMin.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get accountPasswordMin;

  /// No description provided for @accountPasswordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get accountPasswordsNoMatch;

  /// No description provided for @accountCreateSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get accountCreateSubmit;

  /// No description provided for @accountUsesContactForLogin.
  ///
  /// In en, this message translates to:
  /// **'Uses the customer contact details for login'**
  String get accountUsesContactForLogin;

  /// No description provided for @accountPasswordCheck.
  ///
  /// In en, this message translates to:
  /// **'Check password (min 8 chars, must match)'**
  String get accountPasswordCheck;

  /// No description provided for @accountResetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset login password'**
  String get accountResetPasswordTitle;

  /// No description provided for @accountResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get accountResetPassword;

  /// No description provided for @accountPasswordResetDone.
  ///
  /// In en, this message translates to:
  /// **'Login password reset'**
  String get accountPasswordResetDone;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Login account'**
  String get accountSection;

  /// No description provided for @accountNone.
  ///
  /// In en, this message translates to:
  /// **'No login account'**
  String get accountNone;

  /// No description provided for @accountNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Create credentials so this customer can use OrderApp or the web portal.'**
  String get accountNoneHint;

  /// No description provided for @accountCreateDisabledHint.
  ///
  /// In en, this message translates to:
  /// **'Only an admin can create a login for this customer. Ask an admin to enable it.'**
  String get accountCreateDisabledHint;

  /// No description provided for @accountAllowSalespersonCreate.
  ///
  /// In en, this message translates to:
  /// **'Salesperson may create login'**
  String get accountAllowSalespersonCreate;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Login account created'**
  String get accountCreated;

  /// No description provided for @customerDuplicatePhoneBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" already uses this phone number.'**
  String customerDuplicatePhoneBody(String name);

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailableTitle;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateNow;

  /// No description provided for @updateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A newer version is ready to install (build {current} → {latest}).'**
  String updateAvailableBody(int current, int latest);

  /// No description provided for @commonSalesperson.
  ///
  /// In en, this message translates to:
  /// **'Salesperson'**
  String get commonSalesperson;

  /// No description provided for @commonVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get commonVideo;

  /// No description provided for @commonVideoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Video is too large (max {maxMb} MB)'**
  String commonVideoTooLarge(int maxMb);

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get commonViewAll;

  /// No description provided for @statusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get statusPlanned;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @salesNavPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get salesNavPlan;

  /// No description provided for @salesTitlePlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get salesTitlePlan;

  /// No description provided for @salesSyncItemVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get salesSyncItemVisit;

  /// No description provided for @planTabVisits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get planTabVisits;

  /// No description provided for @planTabDues.
  ///
  /// In en, this message translates to:
  /// **'Dues'**
  String get planTabDues;

  /// No description provided for @planNewVisit.
  ///
  /// In en, this message translates to:
  /// **'New visit'**
  String get planNewVisit;

  /// No description provided for @planEditVisit.
  ///
  /// In en, this message translates to:
  /// **'Edit visit'**
  String get planEditVisit;

  /// No description provided for @planScheduleVisit.
  ///
  /// In en, this message translates to:
  /// **'Schedule visit'**
  String get planScheduleVisit;

  /// No description provided for @planPurposeDueCollection.
  ///
  /// In en, this message translates to:
  /// **'Due collection'**
  String get planPurposeDueCollection;

  /// No description provided for @planPurposeRegularVisit.
  ///
  /// In en, this message translates to:
  /// **'Regular visit'**
  String get planPurposeRegularVisit;

  /// No description provided for @planPurposeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get planPurposeDelivery;

  /// No description provided for @planPurposePromotionalVisit.
  ///
  /// In en, this message translates to:
  /// **'Promotional visit'**
  String get planPurposePromotionalVisit;

  /// No description provided for @planPurposeNewClientSearch.
  ///
  /// In en, this message translates to:
  /// **'New client search'**
  String get planPurposeNewClientSearch;

  /// No description provided for @planPurposeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get planPurposeOther;

  /// No description provided for @planMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get planMarkDone;

  /// No description provided for @planMarkMissed.
  ///
  /// In en, this message translates to:
  /// **'Mark missed'**
  String get planMarkMissed;

  /// No description provided for @planCancelVisit.
  ///
  /// In en, this message translates to:
  /// **'Cancel visit'**
  String get planCancelVisit;

  /// No description provided for @planOutcomeNote.
  ///
  /// In en, this message translates to:
  /// **'Outcome note (optional)'**
  String get planOutcomeNote;

  /// No description provided for @planDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get planDuration;

  /// No description provided for @planPickCustomer.
  ///
  /// In en, this message translates to:
  /// **'Pick customer'**
  String get planPickCustomer;

  /// No description provided for @planPickWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Pick watch-list prospect'**
  String get planPickWatchlist;

  /// No description provided for @planCollectionCandidates.
  ///
  /// In en, this message translates to:
  /// **'Worth a collection visit'**
  String get planCollectionCandidates;

  /// No description provided for @planPlanVisit.
  ///
  /// In en, this message translates to:
  /// **'Plan visit'**
  String get planPlanVisit;

  /// No description provided for @planTodayVisits.
  ///
  /// In en, this message translates to:
  /// **'{count} visit(s) today'**
  String planTodayVisits(int count);

  /// No description provided for @planNoVisits.
  ///
  /// In en, this message translates to:
  /// **'No visits match these filters.'**
  String get planNoVisits;

  /// No description provided for @planVisitSaved.
  ///
  /// In en, this message translates to:
  /// **'Visit saved.'**
  String get planVisitSaved;

  /// No description provided for @planSyncFirst.
  ///
  /// In en, this message translates to:
  /// **'Sync this visit before changing its status.'**
  String get planSyncFirst;

  /// No description provided for @planReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned visits'**
  String get planReminderTitle;

  /// No description provided for @planReminderBody.
  ///
  /// In en, this message translates to:
  /// **'You have {count} visit(s) planned'**
  String planReminderBody(int count);

  /// No description provided for @orderDiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Order diary'**
  String get orderDiaryTitle;

  /// No description provided for @orderSaveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as draft'**
  String get orderSaveAsDraft;

  /// No description provided for @orderApplyVat.
  ///
  /// In en, this message translates to:
  /// **'Apply VAT'**
  String get orderApplyVat;

  /// No description provided for @orderVatIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get orderVatIncluded;

  /// No description provided for @orderVatExcluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get orderVatExcluded;

  /// No description provided for @orderVatRateLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT %'**
  String get orderVatRateLabel;

  /// No description provided for @orderSavedAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Saved as draft'**
  String get orderSavedAsDraft;

  /// No description provided for @orderKeepAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Keep as draft'**
  String get orderKeepAsDraft;

  /// No description provided for @orderConnectToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Connect to confirm from the order page'**
  String get orderConnectToConfirm;

  /// No description provided for @purchaseSavePost.
  ///
  /// In en, this message translates to:
  /// **'Save & post'**
  String get purchaseSavePost;

  /// No description provided for @customerMoneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Money summary'**
  String get customerMoneyTitle;

  /// No description provided for @customerMoneyOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get customerMoneyOrders;

  /// No description provided for @customerMoneyPurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get customerMoneyPurchased;

  /// No description provided for @customerMoneyPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get customerMoneyPaid;

  /// No description provided for @customerMoneyDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get customerMoneyDiscounts;

  /// No description provided for @customerMoneyDue.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get customerMoneyDue;

  /// No description provided for @customerMoneyOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get customerMoneyOverdue;

  /// No description provided for @customerMoneyNextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get customerMoneyNextPayment;

  /// No description provided for @customerMoneyLastPayment.
  ///
  /// In en, this message translates to:
  /// **'Last payment'**
  String get customerMoneyLastPayment;

  /// No description provided for @customerOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get customerOrdersTitle;

  /// No description provided for @customerOrdersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.'**
  String get customerOrdersEmpty;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get commonClearFilters;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @statusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusAll;

  /// No description provided for @searchFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Search & filters'**
  String get searchFiltersTitle;

  /// No description provided for @searchNoExactMatch.
  ///
  /// In en, this message translates to:
  /// **'No exact match for “{query}” — showing most likely results.'**
  String searchNoExactMatch(String query);

  /// No description provided for @searchWatchlistHint.
  ///
  /// In en, this message translates to:
  /// **'Search place, address or note'**
  String get searchWatchlistHint;

  /// No description provided for @commonProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get commonProductsTitle;

  /// No description provided for @commonProductsAllTab.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get commonProductsAllTab;

  /// No description provided for @commonProductsMyVanTab.
  ///
  /// In en, this message translates to:
  /// **'My Van'**
  String get commonProductsMyVanTab;

  /// No description provided for @commonProductSources.
  ///
  /// In en, this message translates to:
  /// **'Inventory sources'**
  String get commonProductSources;

  /// No description provided for @commonProductSourceWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get commonProductSourceWarehouse;

  /// No description provided for @commonProductSourceMyVan.
  ///
  /// In en, this message translates to:
  /// **'My van'**
  String get commonProductSourceMyVan;

  /// No description provided for @commonProductSourceOtherVans.
  ///
  /// In en, this message translates to:
  /// **'Other vans'**
  String get commonProductSourceOtherVans;

  /// No description provided for @commonProductInStockOnly.
  ///
  /// In en, this message translates to:
  /// **'In stock only'**
  String get commonProductInStockOnly;

  /// No description provided for @commonProductInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get commonProductInStock;

  /// No description provided for @commonProductOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get commonProductOutOfStock;

  /// No description provided for @commonProductLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get commonProductLowStock;

  /// No description provided for @commonProductBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get commonProductBrand;

  /// No description provided for @commonProductCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get commonProductCategory;

  /// No description provided for @commonProductAllBrands.
  ///
  /// In en, this message translates to:
  /// **'All brands'**
  String get commonProductAllBrands;

  /// No description provided for @commonProductAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get commonProductAllCategories;

  /// No description provided for @commonProductSortName.
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get commonProductSortName;

  /// No description provided for @commonProductSortStockDesc.
  ///
  /// In en, this message translates to:
  /// **'Stock (high to low)'**
  String get commonProductSortStockDesc;

  /// No description provided for @commonProductSortStockAsc.
  ///
  /// In en, this message translates to:
  /// **'Stock (low to high)'**
  String get commonProductSortStockAsc;

  /// No description provided for @commonProductSortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price (low to high)'**
  String get commonProductSortPriceAsc;

  /// No description provided for @commonProductSortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price (high to low)'**
  String get commonProductSortPriceDesc;

  /// No description provided for @commonProductViewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get commonProductViewGrid;

  /// No description provided for @commonProductViewList.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get commonProductViewList;

  /// No description provided for @commonProductStockAsOf.
  ///
  /// In en, this message translates to:
  /// **'Stock as of {time}'**
  String commonProductStockAsOf(String time);

  /// No description provided for @commonProductTotalStock.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonProductTotalStock;

  /// No description provided for @commonProductStockBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Stock by source'**
  String get commonProductStockBreakdown;

  /// No description provided for @commonProductNoImage.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get commonProductNoImage;

  /// No description provided for @salesProductLoadToVan.
  ///
  /// In en, this message translates to:
  /// **'Load to my van'**
  String get salesProductLoadToVan;

  /// No description provided for @salesProductDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get salesProductDetailTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get commonCreated;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// No description provided for @commonAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get commonAny;

  /// No description provided for @commonNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get commonNotFound;

  /// No description provided for @commonReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'A reason is required'**
  String get commonReasonRequired;

  /// No description provided for @commonEnterQuantityMin.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity of 1 or more'**
  String get commonEnterQuantityMin;

  /// No description provided for @commonEnterOneOrMore.
  ///
  /// In en, this message translates to:
  /// **'Enter 1 or more'**
  String get commonEnterOneOrMore;

  /// No description provided for @commonEnterPriceMin.
  ///
  /// In en, this message translates to:
  /// **'Enter a price of 0 or more'**
  String get commonEnterPriceMin;

  /// No description provided for @commonEnterDiscountMin.
  ///
  /// In en, this message translates to:
  /// **'Enter a discount of 0 or more'**
  String get commonEnterDiscountMin;

  /// No description provided for @commonDiscountExceedsTotal.
  ///
  /// In en, this message translates to:
  /// **'Discount cannot exceed the line total'**
  String get commonDiscountExceedsTotal;

  /// No description provided for @commonPaymentNumber.
  ///
  /// In en, this message translates to:
  /// **'Payment #{id}'**
  String commonPaymentNumber(int id);

  /// No description provided for @commonRecordingRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s remaining (max {maxMinutes} min)'**
  String commonRecordingRemaining(int seconds, int maxMinutes);

  /// No description provided for @authEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get authEmailOrPhone;

  /// No description provided for @authSwitchUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch user?'**
  String get authSwitchUserTitle;

  /// No description provided for @authSwitchUserBody.
  ///
  /// In en, this message translates to:
  /// **'Unsynced data from another user will be deleted (a recovery file will be saved). Continue?'**
  String get authSwitchUserBody;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password. Please try again.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Check your connection and try again.'**
  String get authErrorTimeout;

  /// No description provided for @authErrorServer.
  ///
  /// In en, this message translates to:
  /// **'The server had a problem. Please try again in a moment.'**
  String get authErrorServer;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your internet connection and try again.'**
  String get authErrorNetwork;

  /// No description provided for @customerTypeShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get customerTypeShop;

  /// No description provided for @customerTypeVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get customerTypeVan;

  /// No description provided for @customerTypeImporter.
  ///
  /// In en, this message translates to:
  /// **'Importer'**
  String get customerTypeImporter;

  /// No description provided for @salesDuesIncludesUnsynced.
  ///
  /// In en, this message translates to:
  /// **'Includes unsynced payment'**
  String get salesDuesIncludesUnsynced;

  /// No description provided for @salesDashboardPartialLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Some data could not be loaded'**
  String get salesDashboardPartialLoadTitle;

  /// No description provided for @salesDashboardPartialLoadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and retry.'**
  String get salesDashboardPartialLoadSubtitle;

  /// No description provided for @salesPrinterSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer settings'**
  String get salesPrinterSettings;

  /// No description provided for @salesPaymentExceedsDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds due'**
  String get salesPaymentExceedsDueTitle;

  /// No description provided for @salesPaymentExceedsDueBody.
  ///
  /// In en, this message translates to:
  /// **'Collecting {amount} is more than the {due} due. Record it anyway?'**
  String salesPaymentExceedsDueBody(String amount, String due);

  /// No description provided for @salesOrderChooseCustomerInstead.
  ///
  /// In en, this message translates to:
  /// **'Choose a customer instead'**
  String get salesOrderChooseCustomerInstead;

  /// No description provided for @salesVanLoadAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This loads all available warehouse stock ({count} products) onto your van:'**
  String salesVanLoadAllConfirm(int count);

  /// No description provided for @salesWatchlistAtLocationConvert.
  ///
  /// In en, this message translates to:
  /// **'You\'re at this location — convert to shop?'**
  String get salesWatchlistAtLocationConvert;

  /// No description provided for @salesWatchlistStars.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String salesWatchlistStars(int count);

  /// No description provided for @orderConfirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get orderConfirmOrder;

  /// No description provided for @orderDeleteDraft.
  ///
  /// In en, this message translates to:
  /// **'Delete draft'**
  String get orderDeleteDraft;

  /// No description provided for @orderDeleteDraftBody.
  ///
  /// In en, this message translates to:
  /// **'This draft will be removed permanently.'**
  String get orderDeleteDraftBody;

  /// No description provided for @orderDraftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Draft deleted'**
  String get orderDraftDeleted;

  /// No description provided for @orderDraftDeleteOnline.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to delete this draft'**
  String get orderDraftDeleteOnline;

  /// No description provided for @perfTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Review'**
  String get perfTitle;

  /// No description provided for @perfNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity in this period yet.'**
  String get perfNoActivity;

  /// No description provided for @perfShowingPreviousData.
  ///
  /// In en, this message translates to:
  /// **'Showing previously loaded data.'**
  String get perfShowingPreviousData;

  /// No description provided for @perfCachedTitle.
  ///
  /// In en, this message translates to:
  /// **'Showing cached data'**
  String get perfCachedTitle;

  /// No description provided for @perfCachedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to refresh from server'**
  String get perfCachedSubtitle;

  /// No description provided for @perfByItem.
  ///
  /// In en, this message translates to:
  /// **'By item'**
  String get perfByItem;

  /// No description provided for @perfNoItemsSold.
  ///
  /// In en, this message translates to:
  /// **'No items sold in this period.'**
  String get perfNoItemsSold;

  /// No description provided for @planCalendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get planCalendarMonth;

  /// No description provided for @fieldMapTitle.
  ///
  /// In en, this message translates to:
  /// **'Field map'**
  String get fieldMapTitle;

  /// No description provided for @fieldMapTitleFiltered.
  ///
  /// In en, this message translates to:
  /// **'Field map ({count})'**
  String fieldMapTitleFiltered(int count);

  /// No description provided for @fieldMapFiltersSort.
  ///
  /// In en, this message translates to:
  /// **'Filters & sort'**
  String get fieldMapFiltersSort;

  /// No description provided for @fieldMapSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone'**
  String get fieldMapSearchHint;

  /// No description provided for @fieldMapFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get fieldMapFrequency;

  /// No description provided for @fieldMapAnyFrequency.
  ///
  /// In en, this message translates to:
  /// **'Any frequency'**
  String get fieldMapAnyFrequency;

  /// No description provided for @fieldMapPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get fieldMapPayment;

  /// No description provided for @fieldMapAnyReliability.
  ///
  /// In en, this message translates to:
  /// **'Any reliability'**
  String get fieldMapAnyReliability;

  /// No description provided for @fieldMapMinRating.
  ///
  /// In en, this message translates to:
  /// **'Min rating'**
  String get fieldMapMinRating;

  /// No description provided for @fieldMapAnyRating.
  ///
  /// In en, this message translates to:
  /// **'Any rating'**
  String get fieldMapAnyRating;

  /// No description provided for @fieldMapStarsPlus.
  ///
  /// In en, this message translates to:
  /// **'{count}+ stars'**
  String fieldMapStarsPlus(int count);

  /// No description provided for @fieldMapInactiveFor.
  ///
  /// In en, this message translates to:
  /// **'Inactive for'**
  String get fieldMapInactiveFor;

  /// No description provided for @fieldMapDaysPlus.
  ///
  /// In en, this message translates to:
  /// **'{days}+ days'**
  String fieldMapDaysPlus(int days);

  /// No description provided for @fieldMapHasDue.
  ///
  /// In en, this message translates to:
  /// **'Has due'**
  String get fieldMapHasDue;

  /// No description provided for @fieldMapNoDue.
  ///
  /// In en, this message translates to:
  /// **'No due'**
  String get fieldMapNoDue;

  /// No description provided for @fieldMapNearestFirst.
  ///
  /// In en, this message translates to:
  /// **'Nearest first'**
  String get fieldMapNearestFirst;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
