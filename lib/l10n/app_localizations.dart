import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('fr'),
  ];

  /// Title for language selection modal
  ///
  /// In en, this message translates to:
  /// **'Select Your Preferred Language'**
  String get selectLanguage;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get arabic;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Section title for login/register
  ///
  /// In en, this message translates to:
  /// **'Login or Sign up'**
  String get loginOrSignUp;

  /// Placeholder for phone number input
  ///
  /// In en, this message translates to:
  /// **'Enter your whatsapp number'**
  String get enterWhatsappNumber;

  /// OTP verification screen title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// Message shown after OTP is sent
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your WhatsApp'**
  String get otpSentMessage;

  /// Resend code timer message
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds} sec'**
  String resendCodeIn(int seconds);

  /// Text before resend OTP link
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the OTP?'**
  String get didntGetOtp;

  /// Resend OTP link text
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Name input screen title
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// Placeholder for name input
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Link to register screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// Link to login screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get alreadyHaveAccount;

  /// Success message after login
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// Success message after registration
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Welcome {name}'**
  String registrationSuccessful(String name);

  /// Welcome/description text on login/register screens
  ///
  /// In en, this message translates to:
  /// **'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.'**
  String get welcomeMessage;

  /// Guest login button text
  ///
  /// In en, this message translates to:
  /// **'Guest Login'**
  String get guestLogin;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @recommendationsForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommendations for You'**
  String get recommendationsForYou;

  /// No description provided for @grainsCereals.
  ///
  /// In en, this message translates to:
  /// **'Grains & Cereals'**
  String get grainsCereals;

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @livestockMeat.
  ///
  /// In en, this message translates to:
  /// **'Livestock & Meat'**
  String get livestockMeat;

  /// No description provided for @poultryEggs.
  ///
  /// In en, this message translates to:
  /// **'Poultry & Eggs'**
  String get poultryEggs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'{quantity} Kg Available'**
  String available(String quantity);

  /// No description provided for @pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'{price} MRU / Kg'**
  String pricePerKg(String price);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} day ago'**
  String daysAgo(int days);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @makeADeal.
  ///
  /// In en, this message translates to:
  /// **'Make a Deal'**
  String get makeADeal;

  /// No description provided for @makeAnOffer.
  ///
  /// In en, this message translates to:
  /// **'Make an Offer'**
  String get makeAnOffer;

  /// No description provided for @quantityKg.
  ///
  /// In en, this message translates to:
  /// **'Quantity (Kg)'**
  String get quantityKg;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sendOffer.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get sendOffer;

  /// No description provided for @postedBy.
  ///
  /// In en, this message translates to:
  /// **'Posted by'**
  String get postedBy;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @adId.
  ///
  /// In en, this message translates to:
  /// **'Ad ID: {id}'**
  String adId(String id);

  /// No description provided for @reportAd.
  ///
  /// In en, this message translates to:
  /// **'Report Ad'**
  String get reportAd;

  /// No description provided for @reportAdReason.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for reporting this ad.'**
  String get reportAdReason;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @relatedAds.
  ///
  /// In en, this message translates to:
  /// **'Related Ads'**
  String get relatedAds;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available for this product.'**
  String get noDescription;

  /// No description provided for @yourOfferPrice.
  ///
  /// In en, this message translates to:
  /// **'Your Offer Price (MRU)'**
  String get yourOfferPrice;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @verifyIdentity.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to sell'**
  String get verifyIdentity;

  /// No description provided for @verifyIdentityDesc.
  ///
  /// In en, this message translates to:
  /// **'We need to confirm your identity before you can post ads. This helps keep the marketplace safe. It only takes a minute.'**
  String get verifyIdentityDesc;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @filtersSorting.
  ///
  /// In en, this message translates to:
  /// **'Filters & Sorting'**
  String get filtersSorting;

  /// No description provided for @adReported.
  ///
  /// In en, this message translates to:
  /// **'Ad report submitted successfully'**
  String get adReported;

  /// No description provided for @failedReport.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report'**
  String get failedReport;

  /// No description provided for @pleaseEnterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get pleaseEnterReason;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter quantity'**
  String get pleaseEnterQuantity;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalidInput;

  /// No description provided for @validNumericQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid numeric quantity'**
  String get validNumericQuantity;

  /// No description provided for @validNumericPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid numeric price'**
  String get validNumericPrice;

  /// No description provided for @generateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get generateInvoice;

  /// No description provided for @waitingForBuyer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for buyer confirmation'**
  String get waitingForBuyer;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentRules.
  ///
  /// In en, this message translates to:
  /// **'Payment Rules'**
  String get paymentRules;

  /// No description provided for @transportCost.
  ///
  /// In en, this message translates to:
  /// **'Transport Cost (MRU)'**
  String get transportCost;

  /// No description provided for @deliveryDuration.
  ///
  /// In en, this message translates to:
  /// **'Delivery Duration (Days)'**
  String get deliveryDuration;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message....'**
  String get messageHint;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @sendLocation.
  ///
  /// In en, this message translates to:
  /// **'Send Location'**
  String get sendLocation;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @couldNotDownloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Could not download invoice'**
  String get couldNotDownloadInvoice;

  /// No description provided for @failedToGenerateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invoice'**
  String get failedToGenerateInvoice;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Price'**
  String get enterPrice;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter Quantity'**
  String get enterQuantity;

  /// No description provided for @enterTransportCost.
  ///
  /// In en, this message translates to:
  /// **'Enter Transport Cost'**
  String get enterTransportCost;

  /// No description provided for @selectExpectedDelivery.
  ///
  /// In en, this message translates to:
  /// **'Select Expected Delivery'**
  String get selectExpectedDelivery;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @pleaseEnterTransportCost.
  ///
  /// In en, this message translates to:
  /// **'Please enter transport cost'**
  String get pleaseEnterTransportCost;

  /// No description provided for @pleaseEnterDeliveryDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter delivery duration'**
  String get pleaseEnterDeliveryDuration;

  /// No description provided for @validNumericTransport.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid numeric transport cost'**
  String get validNumericTransport;

  /// No description provided for @validNumericDays.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number of days'**
  String get validNumericDays;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete\nyour account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @bought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get bought;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller: '**
  String get seller;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer: '**
  String get buyer;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount: '**
  String get totalAmount;

  /// No description provided for @invoiceGenerated.
  ///
  /// In en, this message translates to:
  /// **'Invoice Generated: '**
  String get invoiceGenerated;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment: '**
  String get payment;

  /// No description provided for @paymentFromBuyer.
  ///
  /// In en, this message translates to:
  /// **'Payment from Buyer: '**
  String get paymentFromBuyer;

  /// No description provided for @paymentFromAdmin.
  ///
  /// In en, this message translates to:
  /// **'Payment from Admin: '**
  String get paymentFromAdmin;

  /// No description provided for @paymentReleaseDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Release Date: '**
  String get paymentReleaseDate;

  /// No description provided for @dispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched: '**
  String get dispatched;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered: '**
  String get delivered;

  /// No description provided for @viewInvoice.
  ///
  /// In en, this message translates to:
  /// **'View Invoice'**
  String get viewInvoice;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @uploadDeliveryProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Delivery Proof'**
  String get uploadDeliveryProof;

  /// No description provided for @uploadImages.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImages;

  /// No description provided for @raiseDispute.
  ///
  /// In en, this message translates to:
  /// **'Raise Dispute'**
  String get raiseDispute;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @autoCancelIn.
  ///
  /// In en, this message translates to:
  /// **'Auto cancel in {time}'**
  String autoCancelIn(String time);

  /// No description provided for @disputeSubmission.
  ///
  /// In en, this message translates to:
  /// **'Dispute Submission'**
  String get disputeSubmission;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Select Reason'**
  String get selectReason;

  /// No description provided for @uploadEvidence.
  ///
  /// In en, this message translates to:
  /// **'Upload Evidence'**
  String get uploadEvidence;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue in detail...'**
  String get describeIssue;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @disputeSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Dispute Submitted'**
  String get disputeSubmitted;

  /// No description provided for @reviewRequestShortly.
  ///
  /// In en, this message translates to:
  /// **'We will review your request shortly.'**
  String get reviewRequestShortly;

  /// No description provided for @pleaseSelectReason.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for the dispute'**
  String get pleaseSelectReason;

  /// No description provided for @pleaseProvideDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide a detailed description'**
  String get pleaseProvideDescription;

  /// No description provided for @publishedAds.
  ///
  /// In en, this message translates to:
  /// **'{count} Published Ads'**
  String publishedAds(int count);

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @upgradeDescription.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your plan to sell your products'**
  String get upgradeDescription;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @myAds.
  ///
  /// In en, this message translates to:
  /// **'My Ads'**
  String get myAds;

  /// No description provided for @myPackages.
  ///
  /// In en, this message translates to:
  /// **'My Packages'**
  String get myPackages;

  /// No description provided for @identityVerificationKyc.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification (KYC)'**
  String get identityVerificationKyc;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;

  /// No description provided for @reportChat.
  ///
  /// In en, this message translates to:
  /// **'Report Chat'**
  String get reportChat;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @whatsAppNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number is required'**
  String get whatsAppNumberRequired;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get allProducts;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @noRecommendationsFound.
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get noRecommendationsFound;

  /// No description provided for @uploadNationalIdProof.
  ///
  /// In en, this message translates to:
  /// **'Upload National ID Proof'**
  String get uploadNationalIdProof;

  /// No description provided for @nationalIdFront.
  ///
  /// In en, this message translates to:
  /// **'National ID Front'**
  String get nationalIdFront;

  /// No description provided for @nationalIdBack.
  ///
  /// In en, this message translates to:
  /// **'National ID Back'**
  String get nationalIdBack;

  /// No description provided for @documentsSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Documents submitted'**
  String get documentsSubmitted;

  /// No description provided for @documentsSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'We have received your documents. Our team will review them and update you soon.'**
  String get documentsSubmittedDesc;

  /// No description provided for @continueToHome.
  ///
  /// In en, this message translates to:
  /// **'Continue to Home'**
  String get continueToHome;

  /// No description provided for @dispatch.
  ///
  /// In en, this message translates to:
  /// **'Dispatch'**
  String get dispatch;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @selectCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Select Country Code'**
  String get selectCountryCode;

  /// No description provided for @searchCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Search country code...'**
  String get searchCountryCode;

  /// No description provided for @noCountryCodesFound.
  ///
  /// In en, this message translates to:
  /// **'No country codes found'**
  String get noCountryCodesFound;

  /// No description provided for @uploadBusinessCertificate.
  ///
  /// In en, this message translates to:
  /// **'Upload Business certificate'**
  String get uploadBusinessCertificate;

  /// No description provided for @uploadFarmCertificate.
  ///
  /// In en, this message translates to:
  /// **'Upload Farm certificate (optional)'**
  String get uploadFarmCertificate;

  /// No description provided for @pleaseUploadNationalId.
  ///
  /// In en, this message translates to:
  /// **'Please upload National ID Proof'**
  String get pleaseUploadNationalId;

  /// No description provided for @pleaseUploadBusinessCertificate.
  ///
  /// In en, this message translates to:
  /// **'Please upload Business certificate'**
  String get pleaseUploadBusinessCertificate;

  /// No description provided for @failedToUploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload documents'**
  String get failedToUploadDocuments;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @pleaseEnterCompleteOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter complete 6-digit OTP'**
  String get pleaseEnterCompleteOtp;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get failedToSaveProfile;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// No description provided for @noItemsInWishlist.
  ///
  /// In en, this message translates to:
  /// **'No items in wishlist'**
  String get noItemsInWishlist;

  /// No description provided for @noItemsInWishlistDesc.
  ///
  /// In en, this message translates to:
  /// **'Add products to your wishlist to save them for later'**
  String get noItemsInWishlistDesc;

  /// No description provided for @removeFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Wishlist'**
  String get removeFromWishlist;

  /// No description provided for @removeFromWishlistConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete this product from wishlist?'**
  String get removeFromWishlistConfirmation;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @activeAds.
  ///
  /// In en, this message translates to:
  /// **'Active ads'**
  String get activeAds;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get deactivated;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @noAdsFound.
  ///
  /// In en, this message translates to:
  /// **'No {status} ads found'**
  String noAdsFound(String status);

  /// No description provided for @repost.
  ///
  /// In en, this message translates to:
  /// **'Repost'**
  String get repost;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @markAsSold.
  ///
  /// In en, this message translates to:
  /// **'Mark as Sold'**
  String get markAsSold;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'Ex. 100 MRU / Kg'**
  String get priceHint;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @pleaseEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get pleaseEnterProductName;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get pleaseEnterDescription;

  /// No description provided for @adUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ad updated successfully'**
  String get adUpdatedSuccessfully;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get limitReached;

  /// No description provided for @max4Images.
  ///
  /// In en, this message translates to:
  /// **'Maximum 4 images allowed'**
  String get max4Images;

  /// No description provided for @max1Video.
  ///
  /// In en, this message translates to:
  /// **'Maximum 1 video allowed'**
  String get max1Video;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record Video'**
  String get recordVideo;

  /// No description provided for @selectRegion.
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get selectRegion;

  /// No description provided for @pleaseSelectRegion.
  ///
  /// In en, this message translates to:
  /// **'Please select a region'**
  String get pleaseSelectRegion;

  /// No description provided for @pleaseAddOneImage.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one image'**
  String get pleaseAddOneImage;

  /// No description provided for @sorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry !'**
  String get sorry;

  /// No description provided for @noActivePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'You don’t have an active package. Please purchase a package to post your ad.'**
  String get noActivePackageDesc;

  /// No description provided for @buyPackage.
  ///
  /// In en, this message translates to:
  /// **'Buy Package'**
  String get buyPackage;

  /// No description provided for @sellItem.
  ///
  /// In en, this message translates to:
  /// **'Sell Item'**
  String get sellItem;

  /// No description provided for @uploadImagesVideos.
  ///
  /// In en, this message translates to:
  /// **'Upload Images, Videos'**
  String get uploadImagesVideos;

  /// No description provided for @maxImagesVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Max 4 Images, 1 Video'**
  String get maxImagesVideoDesc;

  /// No description provided for @selectMediaType.
  ///
  /// In en, this message translates to:
  /// **'Select Media Type'**
  String get selectMediaType;

  /// No description provided for @imageFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Image from Gallery'**
  String get imageFromGallery;

  /// No description provided for @videoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Video from Gallery'**
  String get videoFromGallery;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add Media'**
  String get addMedia;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @failedToPickVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick video'**
  String get failedToPickVideo;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @kycVerification.
  ///
  /// In en, this message translates to:
  /// **'KYC Verification'**
  String get kycVerification;

  /// No description provided for @completeKyc.
  ///
  /// In en, this message translates to:
  /// **'Complete your KYC to proceed with the purchase.'**
  String get completeKyc;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @idProofNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Proof Number'**
  String get idProofNumber;

  /// No description provided for @enterNationalId.
  ///
  /// In en, this message translates to:
  /// **'Enter National ID number'**
  String get enterNationalId;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterAddress;

  /// No description provided for @paymentIdRef.
  ///
  /// In en, this message translates to:
  /// **'Payment ID / Reference Number'**
  String get paymentIdRef;

  /// No description provided for @enterTransactionReceipt.
  ///
  /// In en, this message translates to:
  /// **'Enter the transaction receipt ID'**
  String get enterTransactionReceipt;

  /// No description provided for @submitBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Submit & Buy Now'**
  String get submitBuyNow;

  /// No description provided for @failedToCreateAd.
  ///
  /// In en, this message translates to:
  /// **'Failed to create ad. Please try again.'**
  String get failedToCreateAd;

  /// No description provided for @serverErrorPostAd.
  ///
  /// In en, this message translates to:
  /// **'Server Error: Unable to post ad. Please try again later.'**
  String get serverErrorPostAd;

  /// No description provided for @nouakchott.
  ///
  /// In en, this message translates to:
  /// **'Nouakchott'**
  String get nouakchott;

  /// No description provided for @nouadhibou.
  ///
  /// In en, this message translates to:
  /// **'Nouadhibou'**
  String get nouadhibou;

  /// No description provided for @rosso.
  ///
  /// In en, this message translates to:
  /// **'Rosso'**
  String get rosso;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call us'**
  String get callUs;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email us'**
  String get emailUs;

  /// No description provided for @buyPackages.
  ///
  /// In en, this message translates to:
  /// **'Buy Packages'**
  String get buyPackages;

  /// No description provided for @noPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get noPackagesAvailable;

  /// No description provided for @support247.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get support247;

  /// No description provided for @featuredAdPlacement.
  ///
  /// In en, this message translates to:
  /// **'Featured Ad placement'**
  String get featuredAdPlacement;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @numberOfAds.
  ///
  /// In en, this message translates to:
  /// **'Number of Ads: {count}'**
  String numberOfAds(String count);

  /// No description provided for @validityLabel.
  ///
  /// In en, this message translates to:
  /// **'Validity: {days}'**
  String validityLabel(String days);

  /// No description provided for @noPackagesFound.
  ///
  /// In en, this message translates to:
  /// **'No packages found'**
  String get noPackagesFound;

  /// No description provided for @remainingAds.
  ///
  /// In en, this message translates to:
  /// **'Remaining Ads: {count}'**
  String remainingAds(String count);

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date: {date}'**
  String expiryDate(String date);

  /// No description provided for @searchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search Products'**
  String get searchProductsHint;

  /// No description provided for @quantityRange.
  ///
  /// In en, this message translates to:
  /// **'Quantity Range'**
  String get quantityRange;

  /// No description provided for @anyQuantity.
  ///
  /// In en, this message translates to:
  /// **'Any quantity'**
  String get anyQuantity;

  /// No description provided for @priceRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRangeLabel;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @relevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get relevance;

  /// No description provided for @recentlyPosted.
  ///
  /// In en, this message translates to:
  /// **'Recently posted'**
  String get recentlyPosted;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @damagedItem.
  ///
  /// In en, this message translates to:
  /// **'Damaged Item'**
  String get damagedItem;

  /// No description provided for @wrongItemSent.
  ///
  /// In en, this message translates to:
  /// **'Wrong Item Sent'**
  String get wrongItemSent;

  /// No description provided for @itemNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Item Not Received'**
  String get itemNotReceived;

  /// No description provided for @qualityIssue.
  ///
  /// In en, this message translates to:
  /// **'Quality Issue'**
  String get qualityIssue;

  /// No description provided for @disputeNote1.
  ///
  /// In en, this message translates to:
  /// **'Disputes are reviewed and resolved within 72 hours.'**
  String get disputeNote1;

  /// No description provided for @buyMorePackages.
  ///
  /// In en, this message translates to:
  /// **'Buy More Packages'**
  String get buyMorePackages;

  /// No description provided for @adsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} Ads Available'**
  String adsAvailable(Object count);

  /// No description provided for @noActivePackages.
  ///
  /// In en, this message translates to:
  /// **'No active packages'**
  String get noActivePackages;

  /// No description provided for @remainingAdsLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Ads'**
  String get remainingAdsLabel;

  /// No description provided for @pleaseEnterIdProof.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID Proof Number'**
  String get pleaseEnterIdProof;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address'**
  String get pleaseEnterAddress;

  /// No description provided for @pleaseEnterPaymentId.
  ///
  /// In en, this message translates to:
  /// **'Please enter Payment ID / Reference Number'**
  String get pleaseEnterPaymentId;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @deletingAd.
  ///
  /// In en, this message translates to:
  /// **'Deleting ad...'**
  String get deletingAd;

  /// No description provided for @adDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ad deleted successfully'**
  String get adDeletedSuccessfully;

  /// No description provided for @failedToDeleteAd.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete ad'**
  String get failedToDeleteAd;

  /// No description provided for @markingAsSold.
  ///
  /// In en, this message translates to:
  /// **'Marking ad as sold...'**
  String get markingAsSold;

  /// No description provided for @adMarkedAsSold.
  ///
  /// In en, this message translates to:
  /// **'Ad marked as sold'**
  String get adMarkedAsSold;

  /// No description provided for @failedToMarkAsSold.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark as sold'**
  String get failedToMarkAsSold;

  /// No description provided for @deactivatingAd.
  ///
  /// In en, this message translates to:
  /// **'Deactivating ad...'**
  String get deactivatingAd;

  /// No description provided for @adDeactivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ad deactivated successfully'**
  String get adDeactivatedSuccessfully;

  /// No description provided for @failedToDeactivateAd.
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate ad'**
  String get failedToDeactivateAd;

  /// No description provided for @failedToUpdateAd.
  ///
  /// In en, this message translates to:
  /// **'Failed to update ad'**
  String get failedToUpdateAd;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUser;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error: Please stop the app and \"Run\" again to link the new social media plugin correctly. \nDetails: {details}'**
  String connectionError(String details);
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
