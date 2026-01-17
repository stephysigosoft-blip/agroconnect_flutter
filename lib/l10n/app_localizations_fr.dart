// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get selectLanguage => 'Sélectionnez votre langue préférée';

  @override
  String get continue_ => 'Continuer';

  @override
  String get french => 'Français';

  @override
  String get arabic => 'عربي';

  @override
  String get english => 'Anglais';

  @override
  String get loginOrSignUp => 'Connexion ou Inscription';

  @override
  String get enterWhatsappNumber => 'Entrez votre numéro WhatsApp';

  @override
  String get otpVerification => 'Vérification OTP';

  @override
  String get otpSentMessage =>
      'Nous avons envoyé un code de vérification à votre WhatsApp';

  @override
  String resendCodeIn(int seconds) {
    return 'Renvoyer le code dans $seconds sec';
  }

  @override
  String get didntGetOtp => 'Vous n\'avez pas reçu l\'OTP?';

  @override
  String get resendOtp => 'Renvoyer l\'OTP';

  @override
  String get whatsYourName => 'Quel est votre nom?';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get done => 'Terminé';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte? S\'inscrire';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte? Connexion';

  @override
  String get loginSuccessful => 'Connexion réussie!';

  @override
  String registrationSuccessful(String name) {
    return 'Inscription réussie! Bienvenue $name';
  }

  @override
  String get welcomeMessage =>
      'Nam eget turpis ultricies, sollicitudin massa eu, convallis felis.';

  @override
  String get guestLogin => 'Connexion invité';

  @override
  String get home => 'Accueil';

  @override
  String get chat => 'Chat';

  @override
  String get sell => 'Vendre';

  @override
  String get wishlist => 'Liste de souhaits';

  @override
  String get profile => 'Profil';

  @override
  String get categories => 'Catégories';

  @override
  String get recentlyAdded => 'Récemment ajouté';

  @override
  String get recommendationsForYou => 'Recommandations pour vous';

  @override
  String get grainsCereals => 'Céréales et grains';

  @override
  String get vegetables => 'Légumes';

  @override
  String get livestockMeat => 'Bétail et viande';

  @override
  String get poultryEggs => 'Volaille et œufs';

  @override
  String get aboutUs => 'À propos de nous';

  @override
  String available(String quantity) {
    return '$quantity Kg Disponible';
  }

  @override
  String pricePerKg(String price) {
    return '$price MRU / Kg';
  }

  @override
  String daysAgo(int days) {
    return 'Il y a $days jour';
  }

  @override
  String get details => 'Détails';

  @override
  String get makeADeal => 'Faire une affaire';

  @override
  String get makeAnOffer => 'Faire une offre';

  @override
  String get quantityKg => 'Quantité (Kg)';

  @override
  String get cancel => 'Annuler';

  @override
  String get sendOffer => 'Envoyer l\'offre';

  @override
  String get postedBy => 'Publié par';

  @override
  String get viewProfile => 'Voir le profil';

  @override
  String adId(String id) {
    return 'ID de l\'annonce: $id';
  }

  @override
  String get reportAd => 'Signaler l\'annonce';

  @override
  String get reportAdReason =>
      'Veuillez fournir une raison pour signaler cette annonce.';

  @override
  String get reason => 'Raison';

  @override
  String get submit => 'Soumettre';

  @override
  String get relatedAds => 'Annonces similaires';

  @override
  String get noDescription => 'Aucune description disponible pour ce produit.';

  @override
  String get yourOfferPrice => 'Votre prix d\'offre (MRU)';

  @override
  String get success => 'Succès';

  @override
  String get error => 'Erreur';

  @override
  String get required => 'Requis';

  @override
  String get verifyIdentity => 'Vérifiez votre identité pour vendre';

  @override
  String get verifyIdentityDesc =>
      'Nous devons confirmer votre identité avant que vous puissiez publier des annonces. Cela aide à maintenir la sécurité du marché. Cela ne prend qu\'une minute.';

  @override
  String get verify => 'Vérifier';

  @override
  String get filtersSorting => 'Filtres et tri';

  @override
  String get adReported => 'Rapport d\'annonce soumis avec succès';

  @override
  String get failedReport => 'Échec de la soumission du rapport';

  @override
  String get pleaseEnterReason => 'Veuillez entrer une raison';

  @override
  String get pleaseEnterPrice => 'Veuillez entrer le prix';

  @override
  String get pleaseEnterQuantity => 'Veuillez entrer la quantité';

  @override
  String get invalidInput => 'Entrée invalide';

  @override
  String get validNumericQuantity =>
      'Veuillez entrer une quantité numérique valide';

  @override
  String get validNumericPrice => 'Veuillez entrer un prix numérique valide';

  @override
  String get generateInvoice => 'Générer une facture';

  @override
  String get waitingForBuyer => 'En attente de confirmation de l\'acheteur';

  @override
  String get orderSummary => 'Récapitulatif de la commande';

  @override
  String get price => 'Prix';

  @override
  String get quantity => 'Quantité';

  @override
  String get transport => 'Transport';

  @override
  String get delivery => 'Livraison';

  @override
  String get payNow => 'Payer maintenant';

  @override
  String get orderNow => 'Commander maintenant';

  @override
  String get paymentRules => 'Règles de paiement';

  @override
  String get transportCost => 'Coût du transport (MRU)';

  @override
  String get deliveryDuration => 'Durée de livraison (Jours)';

  @override
  String get messageHint => 'Message....';

  @override
  String get gallery => 'Galerie';

  @override
  String get sendLocation => 'Envoyer la position';

  @override
  String get pdf => 'PDF';

  @override
  String get couldNotDownloadInvoice => 'Impossible de télécharger la facture';

  @override
  String get failedToGenerateInvoice => 'Échec de la génération de la facture';

  @override
  String get enterPrice => 'Entrez le prix';

  @override
  String get enterQuantity => 'Entrez la quantité';

  @override
  String get enterTransportCost => 'Entrez le coût du transport';

  @override
  String get selectExpectedDelivery => 'Sélectionnez la livraison prévue';

  @override
  String get days => 'Jours';

  @override
  String get proceed => 'Procéder';

  @override
  String get pleaseEnterTransportCost => 'Veuillez entrer le coût du transport';

  @override
  String get pleaseEnterDeliveryDuration =>
      'Veuillez entrer la durée de livraison';

  @override
  String get validNumericTransport =>
      'Veuillez entrer un coût de transport numérique valide';

  @override
  String get validNumericDays => 'Veuillez entrer un nombre de jours valide';

  @override
  String get settings => 'Paramètres';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get notification => 'Notification';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirmation =>
      'Êtes-vous sûr de vouloir supprimer\nvotre compte ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get orders => 'Commandes';

  @override
  String get bought => 'Acheté';

  @override
  String get sold => 'Vendu';

  @override
  String get noOrdersYet => 'Pas encore de commandes';

  @override
  String get seller => 'Vendeur : ';

  @override
  String get buyer => 'Acheteur : ';

  @override
  String get totalAmount => 'Montant total : ';

  @override
  String get invoiceGenerated => 'Facture générée : ';

  @override
  String get payment => 'Paiement : ';

  @override
  String get paymentFromBuyer => 'Paiement de l\'acheteur : ';

  @override
  String get paymentFromAdmin => 'Paiement de l\'administrateur : ';

  @override
  String get paymentReleaseDate => 'Date de déblocage du paiement : ';

  @override
  String get dispatched => 'Expédié : ';

  @override
  String get delivered => 'Livré : ';

  @override
  String get viewInvoice => 'Voir la facture';

  @override
  String get received => 'Reçu';

  @override
  String get uploadDeliveryProof => 'Télécharger la preuve de livraison';

  @override
  String get uploadImages => 'Télécharger des images';

  @override
  String get raiseDispute => 'Signaler un litige';

  @override
  String get invoice => 'Facture';

  @override
  String autoCancelIn(String time) {
    return 'Annulation automatique dans $time';
  }

  @override
  String get disputeSubmission => 'Soumission de litige';

  @override
  String get selectReason => 'Sélectionner une raison';

  @override
  String get uploadEvidence => 'Télécharger des preuves';

  @override
  String get describeIssue => 'Décrivez le problème en détail...';

  @override
  String get notes => 'Remarques';

  @override
  String get disputeSubmitted => 'Litige soumis';

  @override
  String get reviewRequestShortly => 'Nous examinerons votre demande sous peu.';

  @override
  String get pleaseSelectReason =>
      'Veuillez sélectionner une raison pour le litige';

  @override
  String get pleaseProvideDescription =>
      'Veuillez fournir une description détaillée';

  @override
  String publishedAds(int count) {
    return '$count Annonces publiées';
  }

  @override
  String get subscription => 'Abonnement';

  @override
  String get upgradeDescription =>
      'Améliorez votre plan pour vendre vos produits';

  @override
  String get upgrade => 'Améliorer';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get myAds => 'Mes annonces';

  @override
  String get myPackages => 'Mes packages';

  @override
  String get identityVerificationKyc => 'Vérification d\'identité (KYC)';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get termsConditions => 'Conditions générales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirmation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get search => 'Rechercher';

  @override
  String get noChatsYet => 'Pas encore de discussions';

  @override
  String get reportChat => 'Signaler la discussion';

  @override
  String get deleteChat => 'Supprimer la discussion';

  @override
  String get chatReportedMessage =>
      'This chat has been reported. You cannot send messages.';

  @override
  String get whatsAppNumberRequired => 'Le numéro WhatsApp est requis';

  @override
  String get pleaseEnterPhoneNumber =>
      'Veuillez entrer votre numéro de téléphone';

  @override
  String get allProducts => 'Tous les produits';

  @override
  String get noProductsFound => 'Aucun produit trouvé';

  @override
  String get noRecommendationsFound => 'Aucune recommandation trouvée';

  @override
  String get uploadNationalIdProof => 'Télécharger l\'identifiant national';

  @override
  String get nationalIdFront => 'Recto de la carte d\'identité';

  @override
  String get nationalIdBack => 'Verso de la carte d\'identité';

  @override
  String get documentsSubmitted => 'Documents soumis';

  @override
  String get documentsSubmittedDesc =>
      'Nous avons reçu vos documents. Notre équipe les examinera et vous contactera bientôt.';

  @override
  String get continueToHome => 'Continuer vers l\'accueil';

  @override
  String get dispatch => 'Expédier';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get failedToUpdateProfile => 'Échec de la mise à jour du profil';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get pleaseEnterName => 'Veuillez entrer votre nom';

  @override
  String get selectCountryCode => 'Sélectionner le code pays';

  @override
  String get searchCountryCode => 'Rechercher le code pays...';

  @override
  String get noCountryCodesFound => 'Aucun code pays trouvé';

  @override
  String get uploadBusinessCertificate =>
      'Télécharger le certificat d\'entreprise';

  @override
  String get uploadFarmCertificate =>
      'Télécharger le certificat de ferme (facultatif)';

  @override
  String get pleaseUploadNationalId =>
      'Veuillez télécharger la pièce d\'identité';

  @override
  String get pleaseUploadBusinessCertificate =>
      'Veuillez télécharger le certificat d\'entreprise';

  @override
  String get failedToUploadDocuments => 'Échec du téléchargement des documents';

  @override
  String get unexpectedError => 'Une erreur inattendue est survenue';

  @override
  String get pleaseEnterCompleteOtp =>
      'Veuillez saisir le code OTP complet à 6 chiffres';

  @override
  String get failedToSaveProfile =>
      'Échec de l\'enregistrement du profil. Réessayez.';

  @override
  String get errorOccurred => 'Une erreur est survenue. Réessayez.';

  @override
  String get noItemsInWishlist => 'Aucun article dans la liste de souhaits';

  @override
  String get noItemsInWishlistDesc =>
      'Ajoutez des produits à votre liste de souhaits pour les sauvegarder.';

  @override
  String get removeFromWishlist => 'Retirer de la liste de souhaits';

  @override
  String get removeFromWishlistConfirmation =>
      'Voulez-vous vraiment supprimer ce produit de la liste de souhaits ?';

  @override
  String get remove => 'Retirer';

  @override
  String get activeAds => 'Annonces actives';

  @override
  String get active => 'Actif';

  @override
  String get rejected => 'Rejeté';

  @override
  String get deactivated => 'Désactivé';

  @override
  String get expired => 'Expiré';

  @override
  String noAdsFound(String status) {
    return 'Aucune annonce $status trouvée';
  }

  @override
  String get repost => 'Republier';

  @override
  String get edit => 'Modifier';

  @override
  String get markAsSold => 'Marquer comme vendu';

  @override
  String get deactivate => 'Désactiver';

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get productName => 'Nom du produit';

  @override
  String get description => 'Description';

  @override
  String get priceHint => 'Ex. 100 MRU / Kg';

  @override
  String get update => 'Mettre à jour';

  @override
  String get pleaseEnterProductName => 'Veuillez entrer le nom du produit';

  @override
  String get pleaseEnterDescription => 'Veuillez entrer une description';

  @override
  String get adUpdatedSuccessfully => 'Annonce mise à jour avec succès';

  @override
  String get limitReached => 'Limite atteinte';

  @override
  String get max4Images => 'Maximum 4 images autorisées';

  @override
  String get max1Video => 'Maximum 1 vidéo autorisée';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get recordVideo => 'Enregistrer une vidéo';

  @override
  String get selectRegion => 'Sélectionner la région';

  @override
  String get pleaseSelectRegion => 'Veuillez sélectionner une région';

  @override
  String get pleaseAddOneImage => 'Veuillez ajouter au moins une image';

  @override
  String get sorry => 'Désolé !';

  @override
  String get noActivePackageDesc =>
      'Vous n\'avez pas de package actif. Veuillez en acheter un pour publier.';

  @override
  String get buyPackage => 'Acheter un package';

  @override
  String get sellItem => 'Vendre un article';

  @override
  String get uploadImagesVideos => 'Télécharger images/vidéos';

  @override
  String get maxImagesVideoDesc => 'Max 4 images, 1 vidéo';

  @override
  String get selectMediaType => 'Sélectionner le type de média';

  @override
  String get imageFromGallery => 'Image de la galerie';

  @override
  String get videoFromGallery => 'Vidéo de la galerie';

  @override
  String get addMedia => 'Ajouter un média';

  @override
  String get failedToPickImage => 'Échec du choix de l\'image';

  @override
  String get failedToPickVideo => 'Échec du choix de la vidéo';

  @override
  String get post => 'Publier';

  @override
  String get kycVerification => 'Vérification KYC';

  @override
  String get completeKyc => 'Complétez votre KYC pour continuer l\'achat.';

  @override
  String get fullName => 'Nom complet';

  @override
  String get enterFullName => 'Entrez votre nom complet';

  @override
  String get idProofNumber => 'Numéro de pièce d\'identité';

  @override
  String get enterNationalId => 'Entrez le numéro d\'identité nationale';

  @override
  String get address => 'Adresse';

  @override
  String get enterAddress => 'Entrez votre adresse';

  @override
  String get paymentIdRef => 'ID de paiement / Référence';

  @override
  String get enterTransactionReceipt => 'Entrez l\'ID du reçu de transaction';

  @override
  String get submitBuyNow => 'Soumettre et Acheter';

  @override
  String get failedToCreateAd => 'Échec de la création de l\'annonce.';

  @override
  String get serverErrorPostAd =>
      'Erreur serveur : Impossible de publier l\'annonce.';

  @override
  String get nouakchott => 'Nouakchott';

  @override
  String get nouadhibou => 'Nouadhibou';

  @override
  String get rosso => 'Rosso';

  @override
  String get callUs => 'Appelez-nous';

  @override
  String get emailUs => 'Envoyez-nous un email';

  @override
  String get buyPackages => 'Acheter des packages';

  @override
  String get noPackagesAvailable => 'Aucun forfait disponible';

  @override
  String get support247 => 'Support 24/7';

  @override
  String get featuredAdPlacement => 'Placement d\'annonce en vedette';

  @override
  String get buyNow => 'Acheter maintenant';

  @override
  String numberOfAds(String count) {
    return 'Nombre d\'annonces : $count';
  }

  @override
  String validityLabel(String days) {
    return 'Validité : $days';
  }

  @override
  String get noPackagesFound => 'Aucun package trouvé';

  @override
  String remainingAds(String count) {
    return 'Annonces restantes : $count';
  }

  @override
  String expiryDate(String date) {
    return 'Date d\'expiration : $date';
  }

  @override
  String get searchProductsHint => 'Rechercher des produits';

  @override
  String get quantityRange => 'Gamme de quantité';

  @override
  String get anyQuantity => 'Toute quantité';

  @override
  String get priceRangeLabel => 'Gamme de prix';

  @override
  String get to => 'À';

  @override
  String get sortBy => 'Trier par';

  @override
  String get relevance => 'Pertinence';

  @override
  String get recentlyPosted => 'Récemment publié';

  @override
  String get newestFirst => 'Le plus récent en premier';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get apply => 'Appliquer';

  @override
  String get damagedItem => 'Article endommagé';

  @override
  String get wrongItemSent => 'Mauvais article envoyé';

  @override
  String get itemNotReceived => 'Article non reçu';

  @override
  String get qualityIssue => 'Problème de qualité';

  @override
  String get disputeNote1 =>
      'Les litiges sont examinés et résolus dans les 72 heures.';

  @override
  String get buyMorePackages => 'Acheter plus de forfaits';

  @override
  String adsAvailable(Object count) {
    return '$count Annonces disponibles';
  }

  @override
  String get noActivePackages => 'Aucun forfait actif';

  @override
  String get remainingAdsLabel => 'Annonces restantes';

  @override
  String get pleaseEnterIdProof =>
      'Veuillez saisir votre numéro de pièce d\'identité';

  @override
  String get pleaseEnterAddress => 'Veuillez saisir votre adresse';

  @override
  String get pleaseEnterPaymentId =>
      'Veuillez saisir l\'ID de paiement / Numéro de référence';

  @override
  String get processing => 'Traitement en cours';

  @override
  String get deletingAd => 'Suppression de l\'annonce...';

  @override
  String get adDeletedSuccessfully => 'Annonce supprimée avec succès';

  @override
  String get failedToDeleteAd => 'Échec de la suppression de l\'annonce';

  @override
  String get markingAsSold => 'Marquage comme vendu...';

  @override
  String get adMarkedAsSold => 'Annonce marquée comme vendue';

  @override
  String get failedToMarkAsSold => 'Échec du marquage comme vendu';

  @override
  String get deactivatingAd => 'Désactivation de l\'annonce...';

  @override
  String get adDeactivatedSuccessfully => 'Annonce désactivée avec succès';

  @override
  String get failedToDeactivateAd => 'Échec de la désactivation de l\'annonce';

  @override
  String get failedToUpdateAd => 'Échec de la mise à jour de l\'annonce';

  @override
  String get notice => 'Avis';

  @override
  String get guestUser => 'Invité';

  @override
  String connectionError(String details) {
    return 'Erreur de connexion : Veuillez arrêter l\'application et \"Exécuter\" à nouveau pour lier correctement le nouveau plugin de médias sociaux. \nDétails : $details';
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
}
