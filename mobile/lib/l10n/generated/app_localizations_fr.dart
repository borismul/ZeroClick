// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi Kilométrique';

  @override
  String get tabStatus => 'Statut';

  @override
  String get tabTrips => 'Trajets';

  @override
  String get tabSettings => 'Paramètres';

  @override
  String get tabCharging => 'Recharge';

  @override
  String get chargingStations => 'bornes de recharge';

  @override
  String get logout => 'Déconnexion';

  @override
  String get importantTitle => 'Important';

  @override
  String get backgroundWarningMessage =>
      'Cette application détecte automatiquement quand vous montez dans votre voiture via Bluetooth.\n\nCela ne fonctionne que si l\'application tourne en arrière-plan. Si vous fermez l\'application (balayage vers le haut), la détection automatique cessera de fonctionner.\n\nConseil : Laissez simplement l\'application ouverte, et tout fonctionnera automatiquement.';

  @override
  String get understood => 'Compris';

  @override
  String get loginPrompt => 'Connectez-vous pour commencer';

  @override
  String get loginSubtitle =>
      'Connectez-vous avec votre compte Google et configurez l\'API voiture';

  @override
  String get goToSettings => 'Aller aux Paramètres';

  @override
  String get carPlayConnected => 'CarPlay connecté';

  @override
  String get offlineWarning =>
      'Hors ligne - les actions seront mises en file d\'attente';

  @override
  String get recentTrips => 'Trajets récents';

  @override
  String get configureFirst =>
      'Configurez d\'abord l\'application dans les Paramètres';

  @override
  String get noTripsYet => 'Pas encore de trajets';

  @override
  String routeLongerPercent(int percent) {
    return 'Route +$percent% plus longue';
  }

  @override
  String get route => 'Itinéraire';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get details => 'Détails';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get distance => 'Distance';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Professionnel';

  @override
  String get tripTypePrivate => 'Privé';

  @override
  String get tripTypeMixed => 'Mixte';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Déviation d\'itinéraire';

  @override
  String get car => 'Voiture';

  @override
  String routeDeviationWarning(int percent) {
    return 'L\'itinéraire est $percent% plus long que prévu via Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Modifier le trajet';

  @override
  String get addTrip => 'Ajouter un trajet';

  @override
  String get dateAndTime => 'Date et Heure';

  @override
  String get start => 'Début';

  @override
  String get end => 'Fin';

  @override
  String get fromPlaceholder => 'De';

  @override
  String get toPlaceholder => 'À';

  @override
  String get distanceAndType => 'Distance et Type';

  @override
  String get distanceKm => 'Distance (km)';

  @override
  String get businessKm => 'Km professionnel';

  @override
  String get privateKm => 'Km privé';

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get deleteTrip => 'Supprimer le trajet ?';

  @override
  String get deleteTripConfirmation =>
      'Êtes-vous sûr de vouloir supprimer ce trajet ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get somethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get couldNotDelete => 'Impossible de supprimer';

  @override
  String get statistics => 'Statistiques';

  @override
  String get trips => 'Trajets';

  @override
  String get total => 'Total';

  @override
  String get business => 'Professionnel';

  @override
  String get private => 'Privé';

  @override
  String get account => 'Compte';

  @override
  String get loggedIn => 'Connecté';

  @override
  String get googleAccount => 'Compte Google';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get myCars => 'Mes Voitures';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voitures',
      one: '1 voiture',
      zero: '0 voitures',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Gérez vos véhicules';

  @override
  String get location => 'Localisation';

  @override
  String get requestLocationPermission =>
      'Demander la Permission de Localisation';

  @override
  String get openIOSSettings => 'Ouvrir les Paramètres iOS';

  @override
  String get locationPermissionGranted =>
      'Permission de localisation accordée !';

  @override
  String get locationPermissionDenied =>
      'Permission de localisation refusée - allez dans Paramètres';

  @override
  String get enableLocationServices =>
      'Activez d\'abord les Services de localisation dans les Paramètres iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Détection automatique';

  @override
  String get autoDetectionSubtitle =>
      'Démarrer/arrêter les trajets automatiquement lors de la connexion CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay est connecté';

  @override
  String get queue => 'File d\'attente';

  @override
  String queueItems(int count) {
    return '$count éléments en file d\'attente';
  }

  @override
  String get queueSubtitle => 'Seront envoyés une fois en ligne';

  @override
  String get sendNow => 'Envoyer maintenant';

  @override
  String get aboutApp => 'À propos de cette application';

  @override
  String get aboutDescription =>
      'Cette application remplace l\'automatisation des Raccourcis iPhone pour le suivi kilométrique. Elle détecte automatiquement quand vous montez dans la voiture via Bluetooth/CarPlay et enregistre les trajets.';

  @override
  String loggedInAs(String email) {
    return 'Connecté en tant que $email';
  }

  @override
  String errorSaving(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get carSettingsSaved => 'Paramètres voiture enregistrés';

  @override
  String get enterUsernamePassword =>
      'Entrez le nom d\'utilisateur et le mot de passe';

  @override
  String get cars => 'Voitures';

  @override
  String get addCar => 'Ajouter une voiture';

  @override
  String get noCarsAdded => 'Aucune voiture ajoutée';

  @override
  String get defaultBadge => 'Par défaut';

  @override
  String get editCar => 'Modifier la voiture';

  @override
  String get name => 'Nom';

  @override
  String get nameHint => 'Ex. Audi Q4 e-tron';

  @override
  String get enterName => 'Entrez un nom';

  @override
  String get brand => 'Marque';

  @override
  String get color => 'Couleur';

  @override
  String get icon => 'Icône';

  @override
  String get defaultCar => 'Voiture par défaut';

  @override
  String get defaultCarSubtitle =>
      'Les nouveaux trajets seront liés à cette voiture';

  @override
  String get bluetoothDevice => 'Appareil Bluetooth';

  @override
  String get autoSetOnConnect => 'Sera défini automatiquement à la connexion';

  @override
  String get autoSetOnConnectFull =>
      'Sera défini automatiquement lors de la connexion à CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Connexion API Voiture';

  @override
  String connectWithBrand(String brand) {
    return 'Connectez-vous à $brand pour le kilométrage et l\'état de la batterie';
  }

  @override
  String get brandAudi => 'Audi';

  @override
  String get brandVolkswagen => 'Volkswagen';

  @override
  String get brandSkoda => 'Skoda';

  @override
  String get brandSeat => 'Seat';

  @override
  String get brandCupra => 'Cupra';

  @override
  String get brandRenault => 'Renault';

  @override
  String get brandTesla => 'Tesla';

  @override
  String get brandBMW => 'BMW';

  @override
  String get brandMercedes => 'Mercedes';

  @override
  String get brandOther => 'Autre';

  @override
  String get iconSedan => 'Berline';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Compacte';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Monospace';

  @override
  String get loginWithTesla => 'Se connecter avec Tesla';

  @override
  String get teslaLoginInfo =>
      'Vous serez redirigé vers Tesla pour vous connecter. Ensuite, vous pourrez voir les données de votre voiture.';

  @override
  String get usernameEmail => 'Nom d\'utilisateur / Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get country => 'Pays';

  @override
  String get countryHint => 'FR';

  @override
  String get testApi => 'Tester l\'API';

  @override
  String get carUpdated => 'Voiture mise à jour';

  @override
  String get carAdded => 'Voiture ajoutée';

  @override
  String errorMessage(String error) {
    return 'Erreur : $error';
  }

  @override
  String get carDeleted => 'Voiture supprimée';

  @override
  String get deleteCar => 'Supprimer la voiture ?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$carName\" ? Tous les trajets liés à cette voiture conserveront leurs données.';
  }

  @override
  String get apiSettingsSaved => 'Paramètres API enregistrés';

  @override
  String get teslaAlreadyLinked => 'Tesla est déjà lié !';

  @override
  String get teslaLinked => 'Tesla lié !';

  @override
  String get teslaLinkFailed => 'Échec de la liaison Tesla';

  @override
  String get startTrip => 'Démarrer le trajet';

  @override
  String get stopTrip => 'Arrêter le trajet';

  @override
  String get gpsActiveTracking => 'GPS actif - suivi automatique';

  @override
  String get activeTrip => 'Trajet actif';

  @override
  String startedAt(String time) {
    return 'Démarré : $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count points GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Mis à jour : $time';
  }

  @override
  String get battery => 'Batterie';

  @override
  String get status => 'Statut';

  @override
  String get odometer => 'Kilométrage';

  @override
  String get stateParked => 'Garé';

  @override
  String get stateDriving => 'En route';

  @override
  String get stateCharging => 'En charge';

  @override
  String get stateUnknown => 'Inconnu';

  @override
  String chargingPower(double power) {
    return 'Charge : $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Prêt dans : $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get addFirstCar => 'Ajoutez votre première voiture';

  @override
  String get toTrackPerCar => 'Pour suivre les trajets par voiture';

  @override
  String get selectCar => 'Sélectionner une voiture';

  @override
  String get manageCars => 'Gérer les voitures';

  @override
  String get unknownDevice => 'Appareil inconnu';

  @override
  String deviceName(String name) {
    return 'Appareil : $name';
  }

  @override
  String get linkToCar => 'Lier à la voiture :';

  @override
  String get noCarsFound =>
      'Aucune voiture trouvée. Ajoutez d\'abord une voiture.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName lié à $deviceName - Trajet démarré !';
  }

  @override
  String linkError(String error) {
    return 'Erreur de liaison : $error';
  }

  @override
  String get required => 'Requis';

  @override
  String get invalidDistance => 'Distance invalide';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDutch => 'Nederlands';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageChinese => '中文';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageThai => 'ไทย';

  @override
  String get languageVietnamese => 'Tiếng Việt';

  @override
  String get languageSwedish => 'Svenska';

  @override
  String get languageNorwegian => 'Norsk';

  @override
  String get languageDanish => 'Dansk';

  @override
  String get languageFinnish => 'Suomi';

  @override
  String get languageCzech => 'Čeština';

  @override
  String get languageHungarian => 'Magyar';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get languageGreek => 'Ελληνικά';

  @override
  String get languageRomanian => 'Română';

  @override
  String get languageHebrew => 'עברית';

  @override
  String get distanceSourceOdometer => 'Via odometer';

  @override
  String get distanceSourceOsrm => 'Estimated via route';

  @override
  String get distanceSourceGps => 'Estimated via GPS';

  @override
  String get distanceEstimated => 'Distance estimated';
}
