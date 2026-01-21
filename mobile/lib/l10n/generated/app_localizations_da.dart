// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Kørebog';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Ture';

  @override
  String get tabSettings => 'Indstillinger';

  @override
  String get tabCharging => 'Opladning';

  @override
  String get chargingStations => 'ladestationer';

  @override
  String get logout => 'Log ud';

  @override
  String get importantTitle => 'Vigtigt';

  @override
  String get backgroundWarningMessage =>
      'Denne app registrerer automatisk, når du sætter dig ind i bilen via Bluetooth.\n\nDette virker kun, hvis appen kører i baggrunden. Hvis du lukker appen (swipe op), stopper automatisk registrering.\n\nTip: Lad bare appen være åben, så virker alt automatisk.';

  @override
  String get understood => 'Forstået';

  @override
  String get loginPrompt => 'Log ind for at begynde';

  @override
  String get loginSubtitle =>
      'Log ind med din Google-konto og konfigurer bil-API\'en';

  @override
  String get goToSettings => 'Gå til Indstillinger';

  @override
  String get carPlayConnected => 'CarPlay tilsluttet';

  @override
  String get offlineWarning => 'Offline - handlinger sættes i kø';

  @override
  String get recentTrips => 'Seneste ture';

  @override
  String get configureFirst => 'Konfigurer appen i Indstillinger først';

  @override
  String get noTripsYet => 'Ingen ture endnu';

  @override
  String routeLongerPercent(int percent) {
    return 'Rute +$percent% længere';
  }

  @override
  String get route => 'Rute';

  @override
  String get from => 'Fra';

  @override
  String get to => 'Til';

  @override
  String get details => 'Detaljer';

  @override
  String get date => 'Dato';

  @override
  String get time => 'Tid';

  @override
  String get distance => 'Afstand';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Erhverv';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Blandet';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Ruteafvigelse';

  @override
  String get car => 'Bil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Ruten er $percent% længere end forventet via Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Rediger tur';

  @override
  String get addTrip => 'Tilføj tur';

  @override
  String get dateAndTime => 'Dato & Tid';

  @override
  String get start => 'Start';

  @override
  String get end => 'Slut';

  @override
  String get fromPlaceholder => 'Fra';

  @override
  String get toPlaceholder => 'Til';

  @override
  String get distanceAndType => 'Afstand & Type';

  @override
  String get distanceKm => 'Afstand (km)';

  @override
  String get businessKm => 'Erhvervs-km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Gem';

  @override
  String get add => 'Tilføj';

  @override
  String get deleteTrip => 'Slet tur?';

  @override
  String get deleteTripConfirmation =>
      'Er du sikker på, at du vil slette denne tur?';

  @override
  String get cancel => 'Annuller';

  @override
  String get delete => 'Slet';

  @override
  String get somethingWentWrong => 'Noget gik galt';

  @override
  String get couldNotDelete => 'Kunne ikke slette';

  @override
  String get statistics => 'Statistik';

  @override
  String get trips => 'Ture';

  @override
  String get total => 'Total';

  @override
  String get business => 'Erhverv';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Logget ind';

  @override
  String get googleAccount => 'Google-konto';

  @override
  String get loginWithGoogle => 'Log ind med Google';

  @override
  String get myCars => 'Mine Biler';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count biler',
      one: '1 bil',
      zero: '0 biler',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Administrer dine køretøjer';

  @override
  String get location => 'Placering';

  @override
  String get requestLocationPermission => 'Anmod om Placeringstilladelse';

  @override
  String get openIOSSettings => 'Åbn iOS-indstillinger';

  @override
  String get locationPermissionGranted => 'Placeringstilladelse givet!';

  @override
  String get locationPermissionDenied =>
      'Placeringstilladelse nægtet - gå til Indstillinger';

  @override
  String get enableLocationServices =>
      'Aktiver Placeringstjenester i iOS-indstillinger først';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatisk registrering';

  @override
  String get autoDetectionSubtitle =>
      'Start/stop ture automatisk ved CarPlay-tilslutning';

  @override
  String get carPlayIsConnected => 'CarPlay er tilsluttet';

  @override
  String get queue => 'Kø';

  @override
  String queueItems(int count) {
    return '$count elementer i køen';
  }

  @override
  String get queueSubtitle => 'Sendes når online';

  @override
  String get sendNow => 'Send nu';

  @override
  String get aboutApp => 'Om denne app';

  @override
  String get aboutDescription =>
      'Denne app erstatter iPhone Genveje-automatisering til kørebog. Den registrerer automatisk, når du sætter dig ind i bilen via Bluetooth/CarPlay og registrerer ture.';

  @override
  String loggedInAs(String email) {
    return 'Logget ind som $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fejl ved gemning: $error';
  }

  @override
  String get carSettingsSaved => 'Bilindstillinger gemt';

  @override
  String get enterUsernamePassword => 'Indtast brugernavn og adgangskode';

  @override
  String get cars => 'Biler';

  @override
  String get addCar => 'Tilføj bil';

  @override
  String get noCarsAdded => 'Ingen biler tilføjet endnu';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Rediger bil';

  @override
  String get name => 'Navn';

  @override
  String get nameHint => 'F.eks. Audi Q4 e-tron';

  @override
  String get enterName => 'Indtast et navn';

  @override
  String get brand => 'Mærke';

  @override
  String get color => 'Farve';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Standardbil';

  @override
  String get defaultCarSubtitle => 'Nye ture tilknyttes denne bil';

  @override
  String get bluetoothDevice => 'Bluetooth-enhed';

  @override
  String get autoSetOnConnect => 'Indstilles automatisk ved tilslutning';

  @override
  String get autoSetOnConnectFull =>
      'Indstilles automatisk ved tilslutning til CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Bil-API-forbindelse';

  @override
  String connectWithBrand(String brand) {
    return 'Tilslut til $brand for kilometertal og batteristatus';
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
  String get brandOther => 'Andet';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Varevogn';

  @override
  String get loginWithTesla => 'Log ind med Tesla';

  @override
  String get teslaLoginInfo =>
      'Du omdirigeres til Tesla for at logge ind. Derefter kan du se dine bildata.';

  @override
  String get usernameEmail => 'Brugernavn / E-mail';

  @override
  String get password => 'Adgangskode';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'DK';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Bil opdateret';

  @override
  String get carAdded => 'Bil tilføjet';

  @override
  String errorMessage(String error) {
    return 'Fejl: $error';
  }

  @override
  String get carDeleted => 'Bil slettet';

  @override
  String get deleteCar => 'Slet bil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Er du sikker på, at du vil slette \"$carName\"? Alle ture tilknyttet denne bil beholder deres data.';
  }

  @override
  String get apiSettingsSaved => 'API-indstillinger gemt';

  @override
  String get teslaAlreadyLinked => 'Tesla er allerede tilsluttet!';

  @override
  String get teslaLinked => 'Tesla tilsluttet!';

  @override
  String get teslaLinkFailed => 'Tesla-tilslutning mislykkedes';

  @override
  String get startTrip => 'Start Tur';

  @override
  String get stopTrip => 'Afslut Tur';

  @override
  String get gpsActiveTracking => 'GPS aktiv - automatisk sporing';

  @override
  String get activeTrip => 'Aktiv tur';

  @override
  String startedAt(String time) {
    return 'Startet: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-punkter';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Opdateret: $time';
  }

  @override
  String get battery => 'Batteri';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Kilometertal';

  @override
  String get stateParked => 'Parkeret';

  @override
  String get stateDriving => 'Kører';

  @override
  String get stateCharging => 'Oplader';

  @override
  String get stateUnknown => 'Ukendt';

  @override
  String chargingPower(double power) {
    return 'Oplader: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Klar om: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}t ${minutes}m';
  }

  @override
  String get addFirstCar => 'Tilføj din første bil';

  @override
  String get toTrackPerCar => 'For at spore ture pr. bil';

  @override
  String get selectCar => 'Vælg bil';

  @override
  String get manageCars => 'Administrer biler';

  @override
  String get unknownDevice => 'Ukendt enhed';

  @override
  String deviceName(String name) {
    return 'Enhed: $name';
  }

  @override
  String get linkToCar => 'Tilknyt til bil:';

  @override
  String get noCarsFound => 'Ingen biler fundet. Tilføj en bil først.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName tilknyttet $deviceName - Tur startet!';
  }

  @override
  String linkError(String error) {
    return 'Tilknytningsfejl: $error';
  }

  @override
  String get required => 'Påkrævet';

  @override
  String get invalidDistance => 'Ugyldig afstand';

  @override
  String get language => 'Sprog';

  @override
  String get systemDefault => 'Systemstandard';

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

  @override
  String get saveLocation => 'Save location';

  @override
  String get locationName => 'Name for this location';

  @override
  String get locationNameHint => 'E.g. Customer ABC';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'Delete your account and all data';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountConfirmation =>
      'This permanently deletes all your trips and data. This action cannot be undone.';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String deleteAccountError(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get onboardingWelcome => 'Welcome to Zero Click';

  @override
  String get onboardingWelcomeSubtitle =>
      'We need a few permissions to automatically track your trips. Let\'s set them up one by one.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingDone => 'Done';

  @override
  String get onboardingOpenSettings => 'Open Settings';

  @override
  String get onboardingLoginTitle => 'Sign In';

  @override
  String get onboardingLoginDescription =>
      'Sign in with your Google account to sync your trips across devices and access the web dashboard.';

  @override
  String get onboardingLoginButton => 'Sign in with Google';

  @override
  String get onboardingLoggingIn => 'Signing in...';

  @override
  String get onboardingNotificationsTitle => 'Notifications';

  @override
  String get onboardingNotificationsDescription =>
      'We\'ll notify you when a trip starts or ends, so you know everything is being tracked.';

  @override
  String get onboardingNotificationsButton => 'Allow Notifications';

  @override
  String get onboardingLocationTitle => 'Location Access';

  @override
  String get onboardingLocationDescription =>
      'We need your location to track where your trips start and end. This is essential for mileage registration.';

  @override
  String get onboardingLocationButton => 'Allow Location';

  @override
  String get onboardingLocationAlwaysTitle => 'Background Location';

  @override
  String get onboardingLocationAlwaysDescription =>
      'For automatic trip detection, we need \'Always\' access. This lets us track trips even when the app is in the background.';

  @override
  String get onboardingLocationAlwaysInstructions =>
      'Tap \'Open Settings\', then go to Location and select \'Always\'.';

  @override
  String get onboardingLocationAlwaysGranted => 'Background location enabled!';

  @override
  String get onboardingMotionTitle => 'Motion & Fitness';

  @override
  String get onboardingMotionDescription =>
      'We use motion sensors to detect when you\'re driving. This helps start trips automatically without draining your battery.';

  @override
  String get onboardingMotionButton => 'Allow Motion Access';

  @override
  String get onboardingHowItWorksTitle => 'How it works';

  @override
  String get onboardingHowItWorksDescription =>
      'Zero Click uses motion sensors to detect when you\'re driving. Fully automatic!';

  @override
  String get onboardingFeatureMotion => 'Motion Detection';

  @override
  String get onboardingFeatureMotionDesc =>
      'Your phone detects driving motion and automatically starts tracking. Works fully in the background.';

  @override
  String get onboardingFeatureBluetooth => 'Car Recognition';

  @override
  String get onboardingFeatureBluetoothDesc =>
      'Connect via Bluetooth to identify which car you\'re driving. Trips are linked to the right vehicle.';

  @override
  String get onboardingFeatureCarApi => 'Car Account';

  @override
  String get onboardingFeatureCarApiDesc =>
      'Link your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings at trip start and end.';

  @override
  String get onboardingSetupTitle => 'Set up your car';

  @override
  String get onboardingSetupDescription =>
      'Follow these steps to get the best experience.';

  @override
  String get onboardingSetupStep1Title => 'Add your car';

  @override
  String get onboardingSetupStep1Desc =>
      'Give your car a name and choose a color. This helps you recognize trips later.';

  @override
  String get onboardingSetupStep1Button => 'Add car now';

  @override
  String get onboardingSetupStep2Title => 'Go to your car';

  @override
  String get onboardingSetupStep2Desc =>
      'Walk to your car and turn it on. Make sure Bluetooth is enabled on your phone.';

  @override
  String get onboardingSetupStep3Title => 'Connect Bluetooth';

  @override
  String get onboardingSetupStep3Desc =>
      'Pair your phone with your car\'s Bluetooth. A notification will appear to link it to your car in the app.';

  @override
  String get onboardingSetupStep4Title => 'Link car account';

  @override
  String get onboardingSetupStep4Desc =>
      'Connect your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings. You can do this later in Settings.';

  @override
  String get onboardingSetupLater => 'I\'ll do this later';

  @override
  String get onboardingAllSet => 'You\'re all set!';

  @override
  String get onboardingAllSetDescription =>
      'Permissions are configured. Your trips will now be tracked automatically when you connect to your car.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get tutorialDialogTitle => 'Set up your car';

  @override
  String get tutorialDialogContent =>
      'Add your car to get the most out of Zero Click. We\'ll link your trips to the right vehicle and read your odometer automatically.';

  @override
  String get tutorialDialogSetup => 'Add car now';

  @override
  String get tutorialDialogLater => 'Later';

  @override
  String get tutorialMyCarsTitle => 'My Cars';

  @override
  String get tutorialMyCarsDesc => 'Tap here to add and manage your cars';

  @override
  String get tutorialAddCarTitle => 'Add a car';

  @override
  String get tutorialAddCarDesc => 'Tap here to add your first car';

  @override
  String get permissionsMissingTitle => 'Permissions Required';

  @override
  String get permissionsMissingMessage =>
      'Some permissions are not granted. The app may not work properly without them.';

  @override
  String get permissionsOpenSettings => 'Open Settings';

  @override
  String get permissionsMissing => 'Missing';

  @override
  String get permissionLocation => 'Background Location';

  @override
  String get permissionMotion => 'Motion & Fitness';

  @override
  String get permissionNotifications => 'Notifications';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicyAndTerms => 'Privacy Policy & Terms';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get readFullVersion => 'Read full version online';

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyPolicyContent =>
      'PRIVACY POLICY\n\nZero Click (\'the app\') is a personal trip tracking application. Your privacy is important to us.\n\nDATA WE COLLECT\n\n• Location data: GPS coordinates during trips to calculate distances and routes\n• Email address: For account identification via Google Sign-In\n• Car odometer readings: Retrieved from your car\'s API (Audi, Tesla, etc.) when linked\n• Device information: For crash reporting and app improvements\n\nWHY WE COLLECT THIS DATA\n\n• Trip tracking: To automatically register your business and private trips\n• Mileage calculation: Using odometer data or GPS coordinates\n• Authentication: To secure your account and sync across devices\n• App improvement: To fix bugs and improve reliability\n\nHOW DATA IS STORED\n\n• All data is stored in Firebase (Google Cloud Platform) in EU region (europe-west4)\n• Data is encrypted in transit and at rest\n• Only you can access your trip data\n\nTHIRD-PARTY SERVICES\n\n• Google Sign-In: For authentication\n• Firebase Analytics: For anonymous usage statistics\n• Car APIs (Audi, Tesla, Renault, etc.): For odometer readings\n• Google Maps: For route visualization\n\nYOUR RIGHTS\n\n• Export: You can export all your trips to Google Sheets via the web dashboard\n• Deletion: You can delete your account and all data in Settings\n• Access: You have full access to all your data in the app\n\nCONTACT\n\nFor privacy questions, contact: privacy@zeroclick.app';

  @override
  String get termsOfServiceContent =>
      'TERMS OF SERVICE\n\nBy using Zero Click (\'the app\'), you agree to these terms.\n\nSERVICE DESCRIPTION\n\nZero Click is a personal trip tracking app that automatically detects when you drive and registers trips. The app uses motion detection, GPS, and optionally your car\'s API for mileage data.\n\nUSER RESPONSIBILITIES\n\n• Accurate setup: You are responsible for correctly configuring your cars and accounts\n• Lawful use: Use the app only for legal purposes\n• Data accuracy: Verify important trip data before using it for tax or business purposes\n\nDATA ACCURACY DISCLAIMER\n\n• GPS-based distances may vary from actual distances\n• Odometer readings depend on your car\'s API accuracy\n• Automatic trip detection may occasionally miss trips or create false positives\n• Always review your trips for accuracy\n\nSERVICE AVAILABILITY\n\n• Zero Click is a personal project and does not guarantee uptime\n• The service may be unavailable for maintenance or updates\n• Features may change or be removed at any time\n\nACCOUNT TERMINATION\n\n• You can delete your account at any time in Settings\n• Account deletion permanently removes all your data\n• We may terminate accounts that violate these terms\n\nLIMITATION OF LIABILITY\n\n• The app is provided \'as is\' without warranties\n• We are not liable for inaccurate trip data or missed trips\n• We are not liable for any damages arising from use of the app\n• Maximum liability is limited to the amount you paid (which is zero, as the app is free)\n\nCHANGES TO TERMS\n\nWe may update these terms at any time. Continued use after changes constitutes acceptance.\n\nCONTACT\n\nFor questions about these terms, contact: support@zeroclick.app';

  @override
  String get retry => 'Prøv igen';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Ingen forbindelse';

  @override
  String get checkInternetConnection =>
      'Tjek din internetforbindelse og prøv igen.';

  @override
  String get sessionExpired => 'Session udløbet';

  @override
  String get loginAgainToContinue => 'Log ind igen for at fortsætte.';

  @override
  String get serverError => 'Serverfejl';

  @override
  String get tryAgainLater => 'Noget gik galt. Prøv igen senere.';

  @override
  String get invalidInput => 'Ugyldigt input';

  @override
  String get timeout => 'Timeout';

  @override
  String get serverNotResponding => 'Serveren svarer ikke. Prøv igen.';

  @override
  String get error => 'Fejl';

  @override
  String get unexpectedError => 'Der opstod en uventet fejl.';

  @override
  String get setupCarTitle => 'Konfigurer din bil for den bedste oplevelse:';

  @override
  String get setupCarApiStep => 'Tilslut Bil-API';

  @override
  String get setupCarApiDescription =>
      'Gå til Biler → vælg din bil → tilknyt din konto. Dette giver dig adgang til kilometertal og mere.';

  @override
  String get setupBluetoothStep => 'Tilslut Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Tilslut din telefon via Bluetooth til din bil, åbn denne app og tilknyt i notifikationen. Dette sikrer pålidelig turegistrering.';

  @override
  String get setupTip => 'Tip: Konfigurer begge for bedste pålidelighed!';

  @override
  String get developer => 'Udvikler';

  @override
  String get debugLogs => 'Fejlsøgningslogs';

  @override
  String get viewNativeLogs => 'Vis iOS-systemlogs';

  @override
  String get copyAllLogs => 'Kopier alle logs';

  @override
  String get logsCopied => 'Logs kopieret til udklipsholder';

  @override
  String get loggedOut => 'Logget ud';

  @override
  String get loginWithAudiId => 'Log ind med Audi ID';

  @override
  String get loginWithAudiDescription => 'Log ind med din myAudi-konto';

  @override
  String get loginWithVolkswagenId => 'Log ind med Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Log ind med din Volkswagen ID-konto';

  @override
  String get loginWithSkodaId => 'Log ind med Skoda ID';

  @override
  String get loginWithSkodaDescription => 'Log ind med din Skoda ID-konto';

  @override
  String get loginWithSeatId => 'Log ind med SEAT ID';

  @override
  String get loginWithSeatDescription => 'Log ind med din SEAT ID-konto';

  @override
  String get loginWithCupraId => 'Log ind med CUPRA ID';

  @override
  String get loginWithCupraDescription => 'Log ind med din CUPRA ID-konto';

  @override
  String get loginWithRenaultId => 'Log ind med Renault ID';

  @override
  String get loginWithRenaultDescription => 'Log ind med din MY Renault-konto';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault tilsluttet';

  @override
  String get accountLinkedSuccess => 'Din konto er blevet tilknyttet';

  @override
  String brandConnected(String brand) {
    return '$brand tilsluttet';
  }

  @override
  String connectBrand(String brand) {
    return 'Tilslut $brand';
  }

  @override
  String get email => 'E-mail';

  @override
  String get countryNetherlands => 'Holland';

  @override
  String get countryBelgium => 'Belgien';

  @override
  String get countryGermany => 'Tyskland';

  @override
  String get countryFrance => 'Frankrig';

  @override
  String get countryUnitedKingdom => 'Storbritannien';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get enterEmailAndPassword => 'Indtast din e-mail og adgangskode';

  @override
  String get couldNotGetLoginUrl => 'Kunne ikke hente login-URL';

  @override
  String brandLinked(String brand) {
    return '$brand tilknyttet';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand tilknyttet (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand-tilknytning mislykkedes';
  }

  @override
  String get changesInNameColorIcon =>
      'Ændringer til navn/farve/ikon? Tryk tilbage og rediger.';

  @override
  String get notificationChannelCarDetection => 'Bilregistrering';

  @override
  String get notificationChannelDescription =>
      'Notifikationer for bilregistrering og turregistrering';

  @override
  String get notificationNewCarDetected => 'Ny bil registreret';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'Er \"$deviceName\" en bil du vil spore?';
  }

  @override
  String get notificationTripStarted => 'Tur startet';

  @override
  String get notificationTripTracking => 'Din tur spores nu';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Din tur med $carName spores nu';
  }

  @override
  String get notificationCarLinked => 'Bil tilknyttet';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" er nu tilknyttet $carName';
  }

  @override
  String locationError(String error) {
    return 'Placeringsfejl: $error';
  }
}
