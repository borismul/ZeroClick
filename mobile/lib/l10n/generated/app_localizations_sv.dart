// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Körjournal';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Resor';

  @override
  String get tabSettings => 'Inställningar';

  @override
  String get tabCharging => 'Laddning';

  @override
  String get chargingStations => 'laddstationer';

  @override
  String get logout => 'Logga ut';

  @override
  String get importantTitle => 'Viktigt';

  @override
  String get backgroundWarningMessage =>
      'Denna app upptäcker automatiskt när du sätter dig i bilen via Bluetooth.\n\nDetta fungerar endast om appen körs i bakgrunden. Om du stänger appen (svep uppåt) slutar automatisk upptäckt att fungera.\n\nTips: Låt appen vara öppen så fungerar allt automatiskt.';

  @override
  String get understood => 'Uppfattat';

  @override
  String get loginPrompt => 'Logga in för att börja';

  @override
  String get loginSubtitle =>
      'Logga in med ditt Google-konto och konfigurera bil-API:et';

  @override
  String get goToSettings => 'Gå till Inställningar';

  @override
  String get carPlayConnected => 'CarPlay ansluten';

  @override
  String get offlineWarning => 'Offline - åtgärder köas';

  @override
  String get recentTrips => 'Senaste resor';

  @override
  String get configureFirst => 'Konfigurera appen i Inställningar först';

  @override
  String get noTripsYet => 'Inga resor ännu';

  @override
  String routeLongerPercent(int percent) {
    return 'Rutt +$percent% längre';
  }

  @override
  String get route => 'Rutt';

  @override
  String get from => 'Från';

  @override
  String get to => 'Till';

  @override
  String get details => 'Detaljer';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Tid';

  @override
  String get distance => 'Avstånd';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Tjänst';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Blandat';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Ruttavvikelse';

  @override
  String get car => 'Bil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Rutten är $percent% längre än förväntat enligt Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Redigera resa';

  @override
  String get addTrip => 'Lägg till resa';

  @override
  String get dateAndTime => 'Datum & Tid';

  @override
  String get start => 'Start';

  @override
  String get end => 'Slut';

  @override
  String get fromPlaceholder => 'Från';

  @override
  String get toPlaceholder => 'Till';

  @override
  String get distanceAndType => 'Avstånd & Typ';

  @override
  String get distanceKm => 'Avstånd (km)';

  @override
  String get businessKm => 'Tjänste-km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Spara';

  @override
  String get add => 'Lägg till';

  @override
  String get deleteTrip => 'Ta bort resa?';

  @override
  String get deleteTripConfirmation =>
      'Är du säker på att du vill ta bort denna resa?';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Ta bort';

  @override
  String get somethingWentWrong => 'Något gick fel';

  @override
  String get couldNotDelete => 'Kunde inte ta bort';

  @override
  String get statistics => 'Statistik';

  @override
  String get trips => 'Resor';

  @override
  String get total => 'Totalt';

  @override
  String get business => 'Tjänst';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Inloggad';

  @override
  String get googleAccount => 'Google-konto';

  @override
  String get loginWithGoogle => 'Logga in med Google';

  @override
  String get myCars => 'Mina Bilar';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilar',
      one: '1 bil',
      zero: '0 bilar',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Hantera dina fordon';

  @override
  String get location => 'Plats';

  @override
  String get requestLocationPermission => 'Begär Platsbehörighet';

  @override
  String get openIOSSettings => 'Öppna iOS-inställningar';

  @override
  String get locationPermissionGranted => 'Platsbehörighet beviljad!';

  @override
  String get locationPermissionDenied =>
      'Platsbehörighet nekad - gå till Inställningar';

  @override
  String get enableLocationServices =>
      'Aktivera Platstjänster i iOS-inställningar först';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatisk upptäckt';

  @override
  String get autoDetectionSubtitle =>
      'Starta/stoppa resor automatiskt vid CarPlay-anslutning';

  @override
  String get carPlayIsConnected => 'CarPlay är ansluten';

  @override
  String get queue => 'Kö';

  @override
  String queueItems(int count) {
    return '$count objekt i kön';
  }

  @override
  String get queueSubtitle => 'Skickas när online';

  @override
  String get sendNow => 'Skicka nu';

  @override
  String get aboutApp => 'Om denna app';

  @override
  String get aboutDescription =>
      'Denna app ersätter iPhone Genvägar-automatisering för körjournal. Den upptäcker automatiskt när du sätter dig i bilen via Bluetooth/CarPlay och registrerar resor.';

  @override
  String loggedInAs(String email) {
    return 'Inloggad som $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fel vid sparande: $error';
  }

  @override
  String get carSettingsSaved => 'Bilinställningar sparade';

  @override
  String get enterUsernamePassword => 'Ange användarnamn och lösenord';

  @override
  String get cars => 'Bilar';

  @override
  String get addCar => 'Lägg till bil';

  @override
  String get noCarsAdded => 'Inga bilar tillagda ännu';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Redigera bil';

  @override
  String get name => 'Namn';

  @override
  String get nameHint => 'T.ex. Audi Q4 e-tron';

  @override
  String get enterName => 'Ange ett namn';

  @override
  String get brand => 'Märke';

  @override
  String get color => 'Färg';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Standardbil';

  @override
  String get defaultCarSubtitle => 'Nya resor kopplas till denna bil';

  @override
  String get bluetoothDevice => 'Bluetooth-enhet';

  @override
  String get autoSetOnConnect => 'Ställs in automatiskt vid anslutning';

  @override
  String get autoSetOnConnectFull =>
      'Ställs in automatiskt vid anslutning till CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Bil-API-anslutning';

  @override
  String connectWithBrand(String brand) {
    return 'Anslut till $brand för mätarställning och batteristatus';
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
  String get brandOther => 'Övrig';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Halvkombi';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Skåpbil';

  @override
  String get loginWithTesla => 'Logga in med Tesla';

  @override
  String get teslaLoginInfo =>
      'Du omdirigeras till Tesla för att logga in. Sedan kan du se din bildata.';

  @override
  String get usernameEmail => 'Användarnamn / E-post';

  @override
  String get password => 'Lösenord';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'SE';

  @override
  String get testApi => 'Testa API';

  @override
  String get carUpdated => 'Bil uppdaterad';

  @override
  String get carAdded => 'Bil tillagd';

  @override
  String errorMessage(String error) {
    return 'Fel: $error';
  }

  @override
  String get carDeleted => 'Bil borttagen';

  @override
  String get deleteCar => 'Ta bort bil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Är du säker på att du vill ta bort \"$carName\"? Alla resor kopplade till denna bil behåller sin data.';
  }

  @override
  String get apiSettingsSaved => 'API-inställningar sparade';

  @override
  String get teslaAlreadyLinked => 'Tesla är redan kopplad!';

  @override
  String get teslaLinked => 'Tesla kopplad!';

  @override
  String get teslaLinkFailed => 'Tesla-koppling misslyckades';

  @override
  String get startTrip => 'Starta Resa';

  @override
  String get stopTrip => 'Avsluta Resa';

  @override
  String get gpsActiveTracking => 'GPS aktiv - automatisk spårning';

  @override
  String get activeTrip => 'Aktiv resa';

  @override
  String startedAt(String time) {
    return 'Startad: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-punkter';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Uppdaterad: $time';
  }

  @override
  String get battery => 'Batteri';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Mätarställning';

  @override
  String get stateParked => 'Parkerad';

  @override
  String get stateDriving => 'Kör';

  @override
  String get stateCharging => 'Laddar';

  @override
  String get stateUnknown => 'Okänd';

  @override
  String chargingPower(double power) {
    return 'Laddar: $power kW';
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
  String get addFirstCar => 'Lägg till din första bil';

  @override
  String get toTrackPerCar => 'För att spåra resor per bil';

  @override
  String get selectCar => 'Välj bil';

  @override
  String get manageCars => 'Hantera bilar';

  @override
  String get unknownDevice => 'Okänd enhet';

  @override
  String deviceName(String name) {
    return 'Enhet: $name';
  }

  @override
  String get linkToCar => 'Koppla till bil:';

  @override
  String get noCarsFound => 'Inga bilar hittades. Lägg till en bil först.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName kopplad till $deviceName - Resa startad!';
  }

  @override
  String linkError(String error) {
    return 'Kopplingsfel: $error';
  }

  @override
  String get required => 'Obligatoriskt';

  @override
  String get invalidDistance => 'Ogiltigt avstånd';

  @override
  String get language => 'Språk';

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
  String get retry => 'Försök igen';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Ingen anslutning';

  @override
  String get checkInternetConnection =>
      'Kontrollera din internetanslutning och försök igen.';

  @override
  String get sessionExpired => 'Sessionen har gått ut';

  @override
  String get loginAgainToContinue => 'Logga in igen för att fortsätta.';

  @override
  String get serverError => 'Serverfel';

  @override
  String get tryAgainLater => 'Något gick fel. Försök igen senare.';

  @override
  String get invalidInput => 'Ogiltig inmatning';

  @override
  String get timeout => 'Timeout';

  @override
  String get serverNotResponding => 'Servern svarar inte. Försök igen.';

  @override
  String get error => 'Fel';

  @override
  String get unexpectedError => 'Ett oväntat fel inträffade.';

  @override
  String get setupCarTitle => 'Konfigurera din bil för bästa upplevelse:';

  @override
  String get setupCarApiStep => 'Anslut Bil-API';

  @override
  String get setupCarApiDescription =>
      'Gå till Bilar → välj din bil → koppla ditt konto. Detta ger dig tillgång till mätarställning och mer.';

  @override
  String get setupBluetoothStep => 'Anslut Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Anslut din telefon via Bluetooth till din bil, öppna denna app och koppla i notifikationen. Detta säkerställer tillförlitlig resedetektering.';

  @override
  String get setupTip => 'Tips: Konfigurera båda för bästa tillförlitlighet!';

  @override
  String get developer => 'Utvecklare';

  @override
  String get debugLogs => 'Felsökningsloggar';

  @override
  String get viewNativeLogs => 'Visa iOS-systemloggar';

  @override
  String get copyAllLogs => 'Kopiera alla loggar';

  @override
  String get logsCopied => 'Loggar kopierade till urklipp';

  @override
  String get loggedOut => 'Utloggad';

  @override
  String get loginWithAudiId => 'Logga in med Audi ID';

  @override
  String get loginWithAudiDescription => 'Logga in med ditt myAudi-konto';

  @override
  String get loginWithVolkswagenId => 'Logga in med Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Logga in med ditt Volkswagen ID-konto';

  @override
  String get loginWithSkodaId => 'Logga in med Skoda ID';

  @override
  String get loginWithSkodaDescription => 'Logga in med ditt Skoda ID-konto';

  @override
  String get loginWithSeatId => 'Logga in med SEAT ID';

  @override
  String get loginWithSeatDescription => 'Logga in med ditt SEAT ID-konto';

  @override
  String get loginWithCupraId => 'Logga in med CUPRA ID';

  @override
  String get loginWithCupraDescription => 'Logga in med ditt CUPRA ID-konto';

  @override
  String get loginWithRenaultId => 'Logga in med Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'Logga in med ditt MY Renault-konto';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault ansluten';

  @override
  String get accountLinkedSuccess => 'Ditt konto har kopplats';

  @override
  String brandConnected(String brand) {
    return '$brand ansluten';
  }

  @override
  String connectBrand(String brand) {
    return 'Anslut $brand';
  }

  @override
  String get email => 'E-post';

  @override
  String get countryNetherlands => 'Nederländerna';

  @override
  String get countryBelgium => 'Belgien';

  @override
  String get countryGermany => 'Tyskland';

  @override
  String get countryFrance => 'Frankrike';

  @override
  String get countryUnitedKingdom => 'Storbritannien';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get enterEmailAndPassword => 'Ange din e-post och lösenord';

  @override
  String get couldNotGetLoginUrl => 'Kunde inte hämta inloggnings-URL';

  @override
  String brandLinked(String brand) {
    return '$brand kopplad';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand kopplad (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand-koppling misslyckades';
  }

  @override
  String get changesInNameColorIcon =>
      'Ändringar av namn/färg/ikon? Tryck tillbaka och redigera.';

  @override
  String get notificationChannelCarDetection => 'Bildetektering';

  @override
  String get notificationChannelDescription =>
      'Notifikationer för bildetektering och reseregistrering';

  @override
  String get notificationNewCarDetected => 'Ny bil upptäckt';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'Är \"$deviceName\" en bil du vill spåra?';
  }

  @override
  String get notificationTripStarted => 'Resa startad';

  @override
  String get notificationTripTracking => 'Din resa spåras nu';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Din resa med $carName spåras nu';
  }

  @override
  String get notificationCarLinked => 'Bil kopplad';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" är nu kopplad till $carName';
  }

  @override
  String locationError(String error) {
    return 'Platsfel: $error';
  }
}
