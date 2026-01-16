// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get selectLanguage => 'اختر لغتك المفضلة';

  @override
  String get continue_ => 'متابعة';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'English';

  @override
  String get loginOrSignUp => 'تسجيل الدخول أو التسجيل';

  @override
  String get enterWhatsappNumber => 'أدخل رقم الواتساب الخاص بك';

  @override
  String get otpVerification => 'التحقق من رمز OTP';

  @override
  String get otpSentMessage => 'لقد أرسلنا رمز التحقق إلى واتسابك';

  @override
  String resendCodeIn(int seconds) {
    return 'إعادة إرسال الرمز خلال $seconds ثانية';
  }

  @override
  String get didntGetOtp => 'لم تستلم رمز OTP؟';

  @override
  String get resendOtp => 'إعادة إرسال رمز OTP';

  @override
  String get whatsYourName => 'ما هو اسمك؟';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get done => 'تم';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ سجل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ تسجيل الدخول';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String registrationSuccessful(String name) {
    return 'تم التسجيل بنجاح! مرحباً $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'تسجيل الدخول كضيف';

  @override
  String get home => 'الرئيسية';

  @override
  String get chat => 'الدردشة';

  @override
  String get sell => 'بيع';

  @override
  String get wishlist => 'قائمة الأمنيات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get categories => 'الفئات';

  @override
  String get recentlyAdded => 'المضاف حديثاً';

  @override
  String get recommendationsForYou => 'التوصيات لك';

  @override
  String get grainsCereals => 'الحبوب والحنطة';

  @override
  String get vegetables => 'الخضروات';

  @override
  String get livestockMeat => 'الماشية واللحوم';

  @override
  String get poultryEggs => 'الدواجن والبيض';

  @override
  String get aboutUs => 'من نحن';

  @override
  String available(String quantity) {
    return '$quantity كجم متاح';
  }

  @override
  String pricePerKg(String price) {
    return '$price أوقية / كجم';
  }

  @override
  String daysAgo(int days) {
    return 'منذ $days يوم';
  }

  @override
  String get details => 'التفاصيل';

  @override
  String get makeADeal => 'إبرام صفقة';

  @override
  String get makeAnOffer => 'تقديم عرض';

  @override
  String get quantityKg => 'الكمية (كجم)';

  @override
  String get cancel => 'إلغاء';

  @override
  String get sendOffer => 'إرسال العرض';

  @override
  String get postedBy => 'نشر بواسطة';

  @override
  String get viewProfile => 'عرض الملف الشخصي';

  @override
  String adId(String id) {
    return 'معرف الإعلان: $id';
  }

  @override
  String get reportAd => 'إبلاغ عن الإعلان';

  @override
  String get reportAdReason => 'يرجى تقديم سبب للإبلاغ عن هذا الإعلان.';

  @override
  String get reason => 'السبب';

  @override
  String get submit => 'إرسال';

  @override
  String get relatedAds => 'إعلانات ذات صلة';

  @override
  String get noDescription => 'لا يوجد وصف متاح لهذا المنتج.';

  @override
  String get yourOfferPrice => 'سعر العرض الخاص بك (أوقية)';

  @override
  String get success => 'نجاح';

  @override
  String get error => 'خطأ';

  @override
  String get required => 'مطلوب';

  @override
  String get verifyIdentity => 'تحقق من هويتك للبيع';

  @override
  String get verifyIdentityDesc =>
      'نحتاج إلى تأكيد هويتك قبل أن تتمكن من نشر الإعلانات. هذا يساعد في الحفاظ على أمان السوق. يستغرق الأمر دقيقة واحدة فقط.';

  @override
  String get verify => 'تحقق';

  @override
  String get filtersSorting => 'الفلاتر والترتيب';

  @override
  String get adReported => 'تم تقديم تقرير الإعلان بنجاح';

  @override
  String get failedReport => 'فشل تقديم التقرير';

  @override
  String get pleaseEnterReason => 'يرجى إدخال سبب';

  @override
  String get pleaseEnterPrice => 'يرجى إدخال السعر';

  @override
  String get pleaseEnterQuantity => 'يرجى إدخال الكمية';

  @override
  String get invalidInput => 'إدخال غير صالح';

  @override
  String get validNumericQuantity => 'يرجى إدخال كمية رقمية صالحة';

  @override
  String get validNumericPrice => 'يرجى إدخال سعر رقمي صالح';

  @override
  String get generateInvoice => 'إنشاء فاتورة';

  @override
  String get waitingForBuyer => 'بانتظار تأكيد المشتري';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get price => 'السعر';

  @override
  String get quantity => 'الكمية';

  @override
  String get transport => 'النقل';

  @override
  String get delivery => 'التوصيل';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get paymentRules => 'قواعد الدفع';

  @override
  String get transportCost => 'تكلفة النقل (أوقية)';

  @override
  String get deliveryDuration => 'مدة التوصيل (أيام)';

  @override
  String get messageHint => 'رسالة....';

  @override
  String get gallery => 'المعرض';

  @override
  String get sendLocation => 'إرسال الموقع';

  @override
  String get pdf => 'PDF';

  @override
  String get couldNotDownloadInvoice => 'تعذر تنزيل الفاتورة';

  @override
  String get failedToGenerateInvoice => 'فشل في إنشاء الفاتورة';

  @override
  String get enterPrice => 'أدخل السعر';

  @override
  String get enterQuantity => 'أدخل الكمية';

  @override
  String get enterTransportCost => 'أدخل تكلفة النقل';

  @override
  String get selectExpectedDelivery => 'اختر موعد التسليم المتوقع';

  @override
  String get days => 'أيام';

  @override
  String get proceed => 'متابعة';

  @override
  String get pleaseEnterTransportCost => 'يرجى إدخال تكلفة النقل';

  @override
  String get pleaseEnterDeliveryDuration => 'يرجى إدخال مدة التوصيل';

  @override
  String get validNumericTransport => 'يرجى إدخال تكلفة نقل رقمية صالحة';

  @override
  String get validNumericDays => 'يرجى إدخال عدد أيام صالح';

  @override
  String get settings => 'الإعدادات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get notification => 'إشعارات';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirmation => 'هل أنت متأكد أنك تريد حذف\nحسابك؟';

  @override
  String get delete => 'حذف';

  @override
  String get orders => 'الطلبات';

  @override
  String get bought => 'مشتريات';

  @override
  String get sold => 'تم البيع';

  @override
  String get noOrdersYet => 'لا توجد طلبات حتى الآن';

  @override
  String get seller => 'البائع: ';

  @override
  String get buyer => 'المشتري: ';

  @override
  String get totalAmount => 'المبلغ الإجمالي: ';

  @override
  String get invoiceGenerated => 'تم إنشاء الفاتورة: ';

  @override
  String get payment => 'الدفع: ';

  @override
  String get paymentFromBuyer => 'دفع من المشتري: ';

  @override
  String get paymentFromAdmin => 'دفع من المسؤول: ';

  @override
  String get paymentReleaseDate => 'تاريخ تحرير الدفع: ';

  @override
  String get dispatched => 'تم الشحن: ';

  @override
  String get delivered => 'تم التوصيل: ';

  @override
  String get viewInvoice => 'عرض الفاتورة';

  @override
  String get received => 'تم الاستلام';

  @override
  String get uploadDeliveryProof => 'تحميل إثبات التوصيل';

  @override
  String get uploadImages => 'تحميل الصور';

  @override
  String get raiseDispute => 'رفع نزاع';

  @override
  String get invoice => 'فاتورة';

  @override
  String autoCancelIn(String time) {
    return 'إلغاء تلقائي خلال $time';
  }

  @override
  String get disputeSubmission => 'تقديم نزاع';

  @override
  String get selectReason => 'اختر السبب';

  @override
  String get uploadEvidence => 'تحميل الأدلة';

  @override
  String get describeIssue => 'صف المشكلة بالتفصيل...';

  @override
  String get notes => 'ملاحظات';

  @override
  String get disputeSubmitted => 'تم تقديم النزاع';

  @override
  String get reviewRequestShortly => 'سنراجع طلبك قريبا.';

  @override
  String get pleaseSelectReason => 'يرجى اختيار سبب للنزاع';

  @override
  String get pleaseProvideDescription => 'يرجى تقديم وصف مفصل';

  @override
  String publishedAds(int count) {
    return '$count إعلان منشور';
  }

  @override
  String get subscription => 'الاشتراك';

  @override
  String get upgradeDescription => 'قم بترقية خطتك لبيع منتجاتك';

  @override
  String get upgrade => 'ترقية';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get myAds => 'إعلاناتي';

  @override
  String get myPackages => 'باكاتي';

  @override
  String get identityVerificationKyc => 'التحقق من الهوية (KYC)';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get no => 'لا';

  @override
  String get search => 'بحث';

  @override
  String get noChatsYet => 'لا توجد دردشات بعد';

  @override
  String get reportChat => 'الإبلاغ عن الدردشة';

  @override
  String get deleteChat => 'حذف الدردشة';

  @override
  String get whatsAppNumberRequired => 'رقم الواتساب مطلوب';

  @override
  String get pleaseEnterPhoneNumber => 'يرجى إدخال رقم هاتفك';

  @override
  String get allProducts => 'كل المنتجات';

  @override
  String get noProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get noRecommendationsFound => 'لم يتم العثور على توصيات';

  @override
  String get uploadNationalIdProof => 'تحميل إثبات الهوية الوطنية';

  @override
  String get nationalIdFront => 'واجهة الهوية الوطنية';

  @override
  String get nationalIdBack => 'خلفية الهوية الوطنية';

  @override
  String get documentsSubmitted => 'تم تقديم المستندات';

  @override
  String get documentsSubmittedDesc =>
      'لقد استلمنا مستنداتك. سيقوم فريقنا بمراجعتها وتحديثك قريبا.';

  @override
  String get continueToHome => 'المتابعة إلى الصفحة الرئيسية';

  @override
  String get dispatch => 'شحن';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get failedToUpdateProfile => 'فشل تحديث الملف الشخصي';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get pleaseEnterName => 'يرجى إدخال اسمك';

  @override
  String get selectCountryCode => 'اختر رمز الدولة';

  @override
  String get searchCountryCode => 'البحث عن رمز الدولة...';

  @override
  String get noCountryCodesFound => 'لم يتم العثور على رموز دول';

  @override
  String get uploadBusinessCertificate => 'تحميل شهادة عمل';

  @override
  String get uploadFarmCertificate => 'تحميل شهادة مزرعة (اختياري)';

  @override
  String get pleaseUploadNationalId => 'يرجى تحميل إثبات الهوية الوطنية';

  @override
  String get pleaseUploadBusinessCertificate => 'يرجى تحميل شهادة عمل';

  @override
  String get failedToUploadDocuments => 'فشل تحميل المستندات';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get pleaseEnterCompleteOtp =>
      'يرجى إدخال رمز التحقق المكون من 6 أرقام';

  @override
  String get failedToSaveProfile =>
      'فشل حفظ الملف الشخصي. يرجى المحاولة مرة أخرى.';

  @override
  String get errorOccurred => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get noItemsInWishlist => 'لا توجد عناصر في قائمة الرغبات';

  @override
  String get noItemsInWishlistDesc =>
      'أضف منتجات إلى قائمة الرغبات الخاصة بك لحفظها لوقت لاحق';

  @override
  String get removeFromWishlist => 'إزالة من قائمة الرغبات';

  @override
  String get removeFromWishlistConfirmation =>
      'هل أنت متأكد من حذف هذا المنتج من قائمة الرغبات؟';

  @override
  String get remove => 'إزالة';

  @override
  String get activeAds => 'الإعلانات النشطة';

  @override
  String get active => 'نشط';

  @override
  String get rejected => 'مرفوض';

  @override
  String get deactivated => 'غير مفعل';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String noAdsFound(String status) {
    return 'لا توجد إعلانات $status';
  }

  @override
  String get repost => 'إعادة نشر';

  @override
  String get edit => 'تعديل';

  @override
  String get markAsSold => 'علامة كمنتهي';

  @override
  String get deactivate => 'إلغاء تنشيط';

  @override
  String get editItem => 'تعديل العنصر';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get description => 'الوصف';

  @override
  String get priceHint => 'مثال. 100 أوقية / كجم';

  @override
  String get update => 'تحديث';

  @override
  String get pleaseEnterProductName => 'يرجى إدخال اسم المنتج';

  @override
  String get pleaseEnterDescription => 'يرجى إدخال الوصف';

  @override
  String get adUpdatedSuccessfully => 'تم تحديث الإعلان بنجاح';

  @override
  String get limitReached => 'تم الوصول إلى الحد الأقصى';

  @override
  String get max4Images => 'يُسمح بحد أقصى 4 صور';

  @override
  String get max1Video => 'يُسمح بحد أقصى فيديو واحد';

  @override
  String get chooseFromGallery => 'اختر من معرض الصور';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get recordVideo => 'تسجيل فيديو';

  @override
  String get selectRegion => 'اختر المنطقة';

  @override
  String get pleaseSelectRegion => 'يرجى اختيار منطقة';

  @override
  String get pleaseAddOneImage => 'يرجى إضافة صورة واحدة على الأقل';

  @override
  String get sorry => 'عذراً !';

  @override
  String get noActivePackageDesc =>
      'ليس لديك باقة نشطة. يرجى شراء باقة لنشر إعلانك.';

  @override
  String get buyPackage => 'شراء باقة';

  @override
  String get sellItem => 'بيع عنصر';

  @override
  String get uploadImagesVideos => 'تحميل صور وفيديوهات';

  @override
  String get maxImagesVideoDesc => 'بحد أقصى 4 صور وفيديو واحد';

  @override
  String get selectMediaType => 'اختر نوع الوسائط';

  @override
  String get imageFromGallery => 'صورة من المعرض';

  @override
  String get videoFromGallery => 'فيديو من المعرض';

  @override
  String get addMedia => 'إضافة وسائط';

  @override
  String get failedToPickImage => 'فشل اختيار الصورة';

  @override
  String get failedToPickVideo => 'فشل اختيار الفيديو';

  @override
  String get post => 'نشر';

  @override
  String get kycVerification => 'تحقق KYC';

  @override
  String get completeKyc => 'أكمل تحقق KYC للمتابعة في الشراء.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get idProofNumber => 'رقم إثبات الهوية';

  @override
  String get enterNationalId => 'أدخل رقم الهوية الوطنية';

  @override
  String get address => 'العنوان';

  @override
  String get enterAddress => 'أدخل عنوانك';

  @override
  String get paymentIdRef => 'رقم الدفع / المرجع';

  @override
  String get enterTransactionReceipt => 'أدخل رقم إيصال العملية';

  @override
  String get submitBuyNow => 'إرسال وشراء الآن';

  @override
  String get failedToCreateAd => 'فشل إنشاء الإعلان. يرجى المحاولة مرة أخرى.';

  @override
  String get serverErrorPostAd =>
      'خطأ في السيرفر: تعذر نشر الإعلان. يرجى المحاولة لاحقاً.';

  @override
  String get nouakchott => 'نواكشوط';

  @override
  String get nouadhibou => 'نواذيبو';

  @override
  String get rosso => 'روصو';

  @override
  String get callUs => 'اتصل بنا';

  @override
  String get emailUs => 'أرسل لنا بريداً إلكترونياً';

  @override
  String get buyPackages => 'شراء باقات';

  @override
  String get noPackagesAvailable => 'لا توجد باقات متاحة';

  @override
  String get support247 => 'دعم 24/7';

  @override
  String get featuredAdPlacement => 'مكان إعلان مميز';

  @override
  String get buyNow => 'اشتري الآن';

  @override
  String numberOfAds(String count) {
    return 'عدد الإعلانات: $count';
  }

  @override
  String validityLabel(String days) {
    return 'الصلاحية: $days';
  }

  @override
  String get noPackagesFound => 'لم يتم العثور على باقات';

  @override
  String remainingAds(String count) {
    return 'الإعلانات المتبقية: $count';
  }

  @override
  String expiryDate(String date) {
    return 'تاريخ الانتهاء: $date';
  }

  @override
  String get searchProductsHint => 'البحث عن المنتجات';

  @override
  String get quantityRange => 'نطاق الكمية';

  @override
  String get anyQuantity => 'أي كمية';

  @override
  String get priceRangeLabel => 'نطاق السعر';

  @override
  String get to => 'إلى';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get relevance => 'الأهمية';

  @override
  String get recentlyPosted => 'نشر مؤخراً';

  @override
  String get newestFirst => 'الأحدث أولاً';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get apply => 'تطبيق';

  @override
  String get damagedItem => 'منتج تالف';

  @override
  String get wrongItemSent => 'تم إرسال منتج خطأ';

  @override
  String get itemNotReceived => 'لم يتم استلام المنتج';

  @override
  String get qualityIssue => 'مشكلة في الجودة';

  @override
  String get disputeNote1 => 'تتم مراجعة النزاعات وحلها في غضون 72 ساعة.';

  @override
  String get buyMorePackages => 'شراء المزيد من الباقات';

  @override
  String adsAvailable(Object count) {
    return '$count إعلانات متاحة';
  }

  @override
  String get noActivePackages => 'لا توجد باقات نشطة';

  @override
  String get remainingAdsLabel => 'الإعلانات المتبقية';

  @override
  String get pleaseEnterIdProof => 'يرجى إدخال رقم بطاقة الهوية';

  @override
  String get pleaseEnterAddress => 'يرجى إدخال عنوانك';

  @override
  String get pleaseEnterPaymentId => 'يرجى إدخال معرف الدفع / الرقم المرجعي';

  @override
  String get processing => 'جاري المعالجة';

  @override
  String get deletingAd => 'جاري حذف الإعلان...';

  @override
  String get adDeletedSuccessfully => 'تم حذف الإعلان بنجاح';

  @override
  String get failedToDeleteAd => 'فشل حذف الإعلان';

  @override
  String get markingAsSold => 'جاري وضع علامة كمباع...';

  @override
  String get adMarkedAsSold => 'تم وضع علامة على الإعلان كمباع';

  @override
  String get failedToMarkAsSold => 'فشل وضع علامة كمباع';

  @override
  String get deactivatingAd => 'جاري إلغاء تنشيط الإعلان...';

  @override
  String get adDeactivatedSuccessfully => 'تم إلغاء تنشيط الإعلان بنجاح';

  @override
  String get failedToDeactivateAd => 'فشل إلغاء تنشيط الإعلان';

  @override
  String get failedToUpdateAd => 'فشل تحديث الإعلان';

  @override
  String get notice => 'ملاحظة';

  @override
  String get guestUser => 'ضيف';

  @override
  String connectionError(String details) {
    return 'خطأ في الاتصال: يرجى إيقاف التطبيق وتشغيله مرة أخرى لربط المكون الإضافي الجديد لوسائل التواصل الاجتماعي بشكل صحيح. \nالتفاصيل: $details';
  }
}
