// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select Your Preferred Language';

  @override
  String get continue_ => 'Continue';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'English';

  @override
  String get loginOrSignUp => 'Login or Sign up';

  @override
  String get enterWhatsappNumber => 'Enter your WhatsApp number';

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get otpSentMessage =>
      'We\'ve sent a verification code to your WhatsApp';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend code in $seconds sec';
  }

  @override
  String get didntGetOtp => 'Didn\'t get the OTP?';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get done => 'Done';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Login';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String registrationSuccessful(String name) {
    return 'Registration successful! Welcome $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'Guest Login';

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get sell => 'Sell';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get profile => 'Profile';

  @override
  String get categories => 'Categories';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get recommendationsForYou => 'Recommendations for You';

  @override
  String get grainsCereals => 'Grains & Cereals';

  @override
  String get vegetables => 'Vegetables';

  @override
  String get livestockMeat => 'Livestock & Meat';

  @override
  String get poultryEggs => 'Poultry & Eggs';

  @override
  String get aboutUs => 'About us';

  @override
  String available(String quantity) {
    return '$quantity Kg Available';
  }

  @override
  String pricePerKg(String price) {
    return '$price MRU / Kg';
  }

  @override
  String daysAgo(int days) {
    return '$days day ago';
  }

  @override
  String get details => 'Details';

  @override
  String get makeADeal => 'Make a Deal';

  @override
  String get makeAnOffer => 'Make an Offer';

  @override
  String get quantityKg => 'Quantity (Kg)';

  @override
  String get cancel => 'Cancel';

  @override
  String get sendOffer => 'Send Offer';

  @override
  String get postedBy => 'Posted by';

  @override
  String get viewProfile => 'View Profile';

  @override
  String adId(String id) {
    return 'Ad ID: $id';
  }

  @override
  String get reportAd => 'Report Ad';

  @override
  String get reportAdReason => 'Please provide a reason for reporting this ad.';

  @override
  String get reason => 'Reason';

  @override
  String get submit => 'Submit';

  @override
  String get relatedAds => 'Related Ads';

  @override
  String get noDescription => 'No description available for this product.';

  @override
  String get yourOfferPrice => 'Your Offer Price (MRU/Kg)';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get required => 'Required';

  @override
  String get verifyIdentity => 'Verify your identity to sell';

  @override
  String get verifyIdentityDesc =>
      'We need to confirm your identity before you can post ads. This helps keep the marketplace safe. It only takes a minute.';

  @override
  String get verify => 'Verify';

  @override
  String get filtersSorting => 'Filters & Sorting';

  @override
  String get adReported => 'Ad report submitted successfully';

  @override
  String get failedReport => 'Failed to submit report';

  @override
  String get pleaseEnterReason => 'Please enter a reason';

  @override
  String get pleaseEnterPrice => 'Please enter price';

  @override
  String get pleaseEnterQuantity => 'Please enter quantity';

  @override
  String get invalidInput => 'Invalid Input';

  @override
  String get validNumericQuantity => 'Please enter a valid numeric quantity';

  @override
  String get validNumericPrice => 'Please enter a valid numeric price';

  @override
  String get generateInvoice => 'Generate Invoice';

  @override
  String get waitingForBuyer => 'Waiting for buyer confirmation';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get transport => 'Transport';

  @override
  String get delivery => 'Delivery';

  @override
  String get payNow => 'Pay Now';

  @override
  String get orderNow => 'Order Now';

  @override
  String get paymentRules => 'Payment Rules';

  @override
  String get transportCost => 'Transport Cost (MRU)';

  @override
  String get deliveryDuration => 'Delivery Duration (Days)';

  @override
  String get messageHint => 'Message....';

  @override
  String get gallery => 'Gallery';

  @override
  String get sendLocation => 'Send Location';

  @override
  String get pdf => 'PDF';

  @override
  String get couldNotDownloadInvoice => 'Could not download invoice';

  @override
  String get failedToGenerateInvoice => 'Failed to generate invoice';

  @override
  String get enterPrice => 'Enter Price';

  @override
  String get enterQuantity => 'Enter Quantity';

  @override
  String get enterTransportCost => 'Enter Transport Cost';

  @override
  String get selectExpectedDelivery => 'Select Expected Delivery';

  @override
  String get days => 'Days';

  @override
  String get proceed => 'Proceed';

  @override
  String get pleaseEnterTransportCost => 'Please enter transport cost';

  @override
  String get pleaseEnterDeliveryDuration => 'Please enter delivery duration';

  @override
  String get validNumericTransport =>
      'Please enter a valid numeric transport cost';

  @override
  String get validNumericDays => 'Please enter a valid number of days';

  @override
  String get settings => 'Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notification => 'Notification';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete\nyour account?';

  @override
  String get delete => 'Delete';

  @override
  String get orders => 'Orders';

  @override
  String get bought => 'Bought';

  @override
  String get sold => 'Sold';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get seller => 'Seller: ';

  @override
  String get buyer => 'Buyer: ';

  @override
  String get totalAmount => 'Total Amount: ';

  @override
  String get invoiceGenerated => 'Invoice Generated: ';

  @override
  String get payment => 'Payment: ';

  @override
  String get paymentFromBuyer => 'Payment from Buyer: ';

  @override
  String get paymentFromAdmin => 'Payment from Admin: ';

  @override
  String get paymentReleaseDate => 'Payment Release Date: ';

  @override
  String get dispatched => 'Dispatched: ';

  @override
  String get delivered => 'Delivered: ';

  @override
  String get viewInvoice => 'View Invoice';

  @override
  String get received => 'Received';

  @override
  String get uploadDeliveryProof => 'Upload Delivery Proof';

  @override
  String get uploadImages => 'Upload Images';

  @override
  String get raiseDispute => 'Raise Dispute';

  @override
  String get invoice => 'Invoice';

  @override
  String autoCancelIn(String time) {
    return 'Auto cancel in $time';
  }

  @override
  String get disputeSubmission => 'Dispute Submission';

  @override
  String get selectReason => 'Select Reason';

  @override
  String get uploadEvidence => 'Upload Evidence';

  @override
  String get describeIssue => 'Describe the issue in detail...';

  @override
  String get notes => 'Notes';

  @override
  String get disputeSubmitted => 'Dispute Submitted';

  @override
  String get reviewRequestShortly => 'We will review your request shortly.';

  @override
  String get pleaseSelectReason => 'Please select a reason for the dispute';

  @override
  String get pleaseProvideDescription =>
      'Please provide a detailed description';

  @override
  String publishedAds(int count) {
    return '$count Published Ads';
  }

  @override
  String get subscription => 'Subscription';

  @override
  String get upgradeDescription => 'Upgrade your plan to sell your products';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get myAds => 'My Ads';

  @override
  String get myPackages => 'My Packages';

  @override
  String get identityVerificationKyc => 'Identity Verification (KYC)';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get search => 'Search';

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get reportChat => 'Report Chat';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get chatReportedMessage =>
      'This chat has been reported. You cannot send messages.';

  @override
  String get whatsAppNumberRequired => 'WhatsApp number is required';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get allProducts => 'All Products';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get noRecommendationsFound => 'No recommendations found';

  @override
  String get uploadNationalIdProof => 'Upload National ID Proof';

  @override
  String get nationalIdFront => 'National ID Front';

  @override
  String get nationalIdBack => 'National ID Back';

  @override
  String get documentsSubmitted => 'Documents submitted';

  @override
  String get documentsSubmittedDesc =>
      'We have received your documents. Our team will review them and update you soon.';

  @override
  String get continueToHome => 'Continue to Home';

  @override
  String get dispatch => 'Dispatch';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get selectCountryCode => 'Select Country Code';

  @override
  String get searchCountryCode => 'Search country code...';

  @override
  String get noCountryCodesFound => 'No country codes found';

  @override
  String get uploadBusinessCertificate => 'Upload Business certificate';

  @override
  String get uploadFarmCertificate => 'Upload Farm certificate (optional)';

  @override
  String get pleaseUploadNationalId => 'Please upload National ID Proof';

  @override
  String get pleaseUploadBusinessCertificate =>
      'Please upload Business certificate';

  @override
  String get failedToUploadDocuments => 'Failed to upload documents';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get pleaseEnterCompleteOtp => 'Please enter complete 6-digit OTP';

  @override
  String get failedToSaveProfile => 'Failed to save profile. Please try again.';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';

  @override
  String get noItemsInWishlist => 'No items in wishlist';

  @override
  String get noItemsInWishlistDesc =>
      'Add products to your wishlist to save them for later';

  @override
  String get removeFromWishlist => 'Remove from Wishlist';

  @override
  String get removeFromWishlistConfirmation =>
      'Are you sure to delete this product from wishlist?';

  @override
  String get remove => 'Remove';

  @override
  String get activeAds => 'Active ads';

  @override
  String get active => 'Active';

  @override
  String get rejected => 'Rejected';

  @override
  String get deactivated => 'Deactivated';

  @override
  String get expired => 'Expired';

  @override
  String noAdsFound(String status) {
    return 'No $status ads found';
  }

  @override
  String get repost => 'Repost';

  @override
  String get edit => 'Edit';

  @override
  String get markAsSold => 'Mark as Sold';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get editItem => 'Edit Item';

  @override
  String get productName => 'Product Name';

  @override
  String get description => 'Description';

  @override
  String get priceHint => 'Ex. 100 MRU / Kg';

  @override
  String get update => 'Update';

  @override
  String get pleaseEnterProductName => 'Please enter product name';

  @override
  String get pleaseEnterDescription => 'Please enter description';

  @override
  String get adUpdatedSuccessfully => 'Ad updated successfully';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String get max4Images => 'Maximum 4 images allowed';

  @override
  String get max1Video => 'Maximum 1 video allowed';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get recordVideo => 'Record Video';

  @override
  String get selectRegion => 'Select Region';

  @override
  String get pleaseSelectRegion => 'Please select a region';

  @override
  String get pleaseAddOneImage => 'Please add at least one image';

  @override
  String get sorry => 'Sorry !';

  @override
  String get noActivePackageDesc =>
      'You don’t have an active package. Please purchase a package to post your ad.';

  @override
  String get buyPackage => 'Buy Package';

  @override
  String get sellItem => 'Sell Item';

  @override
  String get uploadImagesVideos => 'Upload Images, Videos';

  @override
  String get maxImagesVideoDesc => 'Max 4 Images, 1 Video';

  @override
  String get selectMediaType => 'Select Media Type';

  @override
  String get imageFromGallery => 'Image from Gallery';

  @override
  String get videoFromGallery => 'Video from Gallery';

  @override
  String get addMedia => 'Add Media';

  @override
  String get failedToPickImage => 'Failed to pick image';

  @override
  String get failedToPickVideo => 'Failed to pick video';

  @override
  String get post => 'Post';

  @override
  String get kycVerification => 'KYC Verification';

  @override
  String get completeKyc => 'Complete your KYC to proceed with the purchase.';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get idProofNumber => 'ID Proof Number';

  @override
  String get enterNationalId => 'Enter National ID number';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter your address';

  @override
  String get paymentIdRef => 'Payment ID / Reference Number';

  @override
  String get enterTransactionReceipt => 'Enter the transaction receipt ID';

  @override
  String get submitBuyNow => 'Submit & Buy Now';

  @override
  String get failedToCreateAd => 'Failed to create ad. Please try again.';

  @override
  String get serverErrorPostAd =>
      'Server Error: Unable to post ad. Please try again later.';

  @override
  String get nouakchott => 'Nouakchott';

  @override
  String get nouadhibou => 'Nouadhibou';

  @override
  String get rosso => 'Rosso';

  @override
  String get callUs => 'Call us';

  @override
  String get emailUs => 'Email us';

  @override
  String get buyPackages => 'Buy Packages';

  @override
  String get noPackagesAvailable => 'No packages available';

  @override
  String get support247 => '24/7 Support';

  @override
  String get featuredAdPlacement => 'Featured Ad placement';

  @override
  String get buyNow => 'Buy Now';

  @override
  String numberOfAds(String count) {
    return 'Number of Ads: $count';
  }

  @override
  String validityLabel(String days) {
    return 'Validity: $days';
  }

  @override
  String get noPackagesFound => 'No packages found';

  @override
  String remainingAds(String count) {
    return 'Remaining Ads: $count';
  }

  @override
  String expiryDate(String date) {
    return 'Expiry Date: $date';
  }

  @override
  String get searchProductsHint => 'Search Products';

  @override
  String get quantityRange => 'Quantity Range';

  @override
  String get anyQuantity => 'Any Quantity';

  @override
  String get priceRangeLabel => 'Price Range';

  @override
  String get to => 'To';

  @override
  String get sortBy => 'Sort By';

  @override
  String get relevance => 'Relevance';

  @override
  String get recentlyPosted => 'Recently Posted';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get clearAll => 'Clear All';

  @override
  String get apply => 'Apply';

  @override
  String get damagedItem => 'Damaged Item';

  @override
  String get wrongItemSent => 'Wrong Item Sent';

  @override
  String get itemNotReceived => 'Item Not Received';

  @override
  String get qualityIssue => 'Quality Issue';

  @override
  String get disputeNote1 =>
      'Disputes are reviewed and resolved within 72 hours.';

  @override
  String get buyMorePackages => 'Buy More Packages';

  @override
  String adsAvailable(Object count) {
    return '$count Ads Available';
  }

  @override
  String get noActivePackages => 'No active packages';

  @override
  String get remainingAdsLabel => 'Remaining Ads';

  @override
  String get pleaseEnterIdProof => 'Please enter your ID Proof Number';

  @override
  String get pleaseEnterAddress => 'Please enter your address';

  @override
  String get pleaseEnterPaymentId =>
      'Please enter Payment ID / Reference Number';

  @override
  String get processing => 'Processing';

  @override
  String get deletingAd => 'Deleting ad...';

  @override
  String get adDeletedSuccessfully => 'Ad deleted successfully';

  @override
  String get failedToDeleteAd => 'Failed to delete ad';

  @override
  String get markingAsSold => 'Marking ad as sold...';

  @override
  String get adMarkedAsSold => 'Ad marked as sold';

  @override
  String get failedToMarkAsSold => 'Failed to mark as sold';

  @override
  String get deactivatingAd => 'Deactivating ad...';

  @override
  String get adDeactivatedSuccessfully => 'Ad deactivated successfully';

  @override
  String get failedToDeactivateAd => 'Failed to deactivate ad';

  @override
  String get failedToUpdateAd => 'Failed to update ad';

  @override
  String get notice => 'Notice';

  @override
  String get guestUser => 'Guest';

  @override
  String connectionError(String details) {
    return 'Connection Error: Please stop the app and \"Run\" again to link the new social media plugin correctly. \nDetails: $details';
  }

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get cashOnDelivery => 'Cash on Delivery';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get confirmOrderMessage =>
      'Are you sure you want to place this order?';

  @override
  String get orderPlacedSuccessfully => 'Order placed successfully';

  @override
  String get orderCheckout => 'Order Checkout';

  @override
  String get statusPendingPayment => 'Pending Payment';

  @override
  String get statusDeliveryPending => 'Delivery Pending';

  @override
  String get statusWaitingForDelivery => 'Waiting for Delivery';

  @override
  String get statusDispatched => 'Dispatched';

  @override
  String get statusWaitingForDeliveryComplete =>
      'Waiting for Delivery complete';

  @override
  String get statusPaymentReceived => 'Payment Received';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusAwaitingPayment => 'Awaiting Payment';

  @override
  String get statusOrderPlaced => 'Order Placed';

  @override
  String get invoiceTitle => 'Invoice';

  @override
  String get expectedDelivery => 'Expected delivery';

  @override
  String get priceLabel => 'Price';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get transportCostLabel => 'Transport cost';

  @override
  String get orderConfirmedSuccess => 'Order confirmed successfully';

  @override
  String get orderConfirmedFailed => 'Failed to confirm order';

  @override
  String get orderMarkedReceived => 'Order marked as received';

  @override
  String get orderMarkedReceivedFailed => 'Failed to mark as received';

  @override
  String get orderDispatchedSuccess => 'Order dispatched successfully';

  @override
  String get orderDispatchedFailed => 'Failed to dispatch order';

  @override
  String get disputeSubmittedSuccess => 'Dispute submitted successfully';

  @override
  String get disputeSubmittedFailed => 'Failed to submit dispute';

  @override
  String get invoiceDetailsTitle => 'Invoice Details';

  @override
  String get orderDetailsTitle => 'Order Details';

  @override
  String get productImageTitle => 'Product Image';

  @override
  String couldNotFindOrderDetails(String id) {
    return 'Could not find order details for invoice #$id';
  }

  @override
  String get disputeNote2 =>
      'You can report an issue if the product is damaged.';

  @override
  String get disputeNote3 => 'Upload clear images as evidence.';

  @override
  String get disputeNote4 =>
      'The support team will review your request shortly.';

  @override
  String get saimpexAgro => 'SAIMPEX AGRO';

  @override
  String get loadMore => 'Load More';

  @override
  String get unitKg => 'Kg';

  @override
  String get currencyMru => 'MRU';

  @override
  String get fileExtensionPdf => '.pdf';

  @override
  String get paymentRule1 =>
      'Invoice will be cancelled automatically if the buyer does not confirm within 48 hours.';

  @override
  String get paymentRule2 => 'Dispute must be raised within 72 hours.';

  @override
  String get paymentRule3 => 'Cras dapibus est suscipit accumsan sollicitudin.';

  @override
  String get paymentRule4 =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  @override
  String get paymentRule5 =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  @override
  String get paymentRule6 =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
}
