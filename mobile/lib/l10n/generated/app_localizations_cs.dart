// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Kniha jízd';

  @override
  String get tabStatus => 'Stav';

  @override
  String get tabTrips => 'Jízdy';

  @override
  String get tabSettings => 'Nastavení';

  @override
  String get tabCharging => 'Nabíjení';

  @override
  String get chargingStations => 'nabíjecích stanic';

  @override
  String get logout => 'Odhlásit se';

  @override
  String get importantTitle => 'Důležité';

  @override
  String get backgroundWarningMessage =>
      'Tato aplikace automaticky detekuje, když nastoupíte do auta přes Bluetooth.\n\nFunguje to pouze když aplikace běží na pozadí. Pokud aplikaci zavřete (přejetím nahoru), automatická detekce přestane fungovat.\n\nTip: Nechte aplikaci otevřenou a vše bude fungovat automaticky.';

  @override
  String get understood => 'Rozumím';

  @override
  String get loginPrompt => 'Přihlaste se pro začátek';

  @override
  String get loginSubtitle =>
      'Přihlaste se účtem Google a nakonfigurujte API auta';

  @override
  String get goToSettings => 'Jít do Nastavení';

  @override
  String get carPlayConnected => 'CarPlay připojeno';

  @override
  String get offlineWarning => 'Offline - akce budou zařazeny do fronty';

  @override
  String get recentTrips => 'Nedávné jízdy';

  @override
  String get configureFirst => 'Nejprve nakonfigurujte aplikaci v Nastavení';

  @override
  String get noTripsYet => 'Zatím žádné jízdy';

  @override
  String routeLongerPercent(int percent) {
    return 'Trasa +$percent% delší';
  }

  @override
  String get route => 'Trasa';

  @override
  String get from => 'Odkud';

  @override
  String get to => 'Kam';

  @override
  String get details => 'Podrobnosti';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Čas';

  @override
  String get distance => 'Vzdálenost';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Pracovní';

  @override
  String get tripTypePrivate => 'Soukromá';

  @override
  String get tripTypeMixed => 'Smíšená';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Odchylka trasy';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Trasa je o $percent% delší než očekávaná podle Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Upravit jízdu';

  @override
  String get addTrip => 'Přidat jízdu';

  @override
  String get dateAndTime => 'Datum a čas';

  @override
  String get start => 'Start';

  @override
  String get end => 'Konec';

  @override
  String get fromPlaceholder => 'Odkud';

  @override
  String get toPlaceholder => 'Kam';

  @override
  String get distanceAndType => 'Vzdálenost a typ';

  @override
  String get distanceKm => 'Vzdálenost (km)';

  @override
  String get businessKm => 'Pracovní km';

  @override
  String get privateKm => 'Soukromé km';

  @override
  String get save => 'Uložit';

  @override
  String get add => 'Přidat';

  @override
  String get deleteTrip => 'Smazat jízdu?';

  @override
  String get deleteTripConfirmation => 'Opravdu chcete smazat tuto jízdu?';

  @override
  String get cancel => 'Zrušit';

  @override
  String get delete => 'Smazat';

  @override
  String get somethingWentWrong => 'Něco se pokazilo';

  @override
  String get couldNotDelete => 'Nepodařilo se smazat';

  @override
  String get statistics => 'Statistiky';

  @override
  String get trips => 'Jízdy';

  @override
  String get total => 'Celkem';

  @override
  String get business => 'Pracovní';

  @override
  String get private => 'Soukromé';

  @override
  String get account => 'Účet';

  @override
  String get loggedIn => 'Přihlášen';

  @override
  String get googleAccount => 'Účet Google';

  @override
  String get loginWithGoogle => 'Přihlásit se přes Google';

  @override
  String get myCars => 'Moje Auta';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aut',
      few: '$count auta',
      one: '1 auto',
      zero: '0 aut',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Spravujte svá vozidla';

  @override
  String get location => 'Poloha';

  @override
  String get requestLocationPermission => 'Požádat o Oprávnění k poloze';

  @override
  String get openIOSSettings => 'Otevřít nastavení iOS';

  @override
  String get locationPermissionGranted => 'Oprávnění k poloze uděleno!';

  @override
  String get locationPermissionDenied =>
      'Oprávnění k poloze zamítnuto - jděte do Nastavení';

  @override
  String get enableLocationServices =>
      'Nejprve povolte Polohové služby v nastavení iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatická detekce';

  @override
  String get autoDetectionSubtitle =>
      'Automaticky zahajovat/ukončovat jízdy při připojení CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay je připojeno';

  @override
  String get queue => 'Fronta';

  @override
  String queueItems(int count) {
    return '$count položek ve frontě';
  }

  @override
  String get queueSubtitle => 'Budou odeslány po připojení';

  @override
  String get sendNow => 'Odeslat nyní';

  @override
  String get aboutApp => 'O této aplikaci';

  @override
  String get aboutDescription =>
      'Tato aplikace nahrazuje automatizaci iPhone Zkratek pro knihu jízd. Automaticky detekuje, když nastoupíte do auta přes Bluetooth/CarPlay a zaznamenává jízdy.';

  @override
  String loggedInAs(String email) {
    return 'Přihlášen jako $email';
  }

  @override
  String errorSaving(String error) {
    return 'Chyba při ukládání: $error';
  }

  @override
  String get carSettingsSaved => 'Nastavení auta uloženo';

  @override
  String get enterUsernamePassword => 'Zadejte uživatelské jméno a heslo';

  @override
  String get cars => 'Auta';

  @override
  String get addCar => 'Přidat auto';

  @override
  String get noCarsAdded => 'Zatím žádná auta';

  @override
  String get defaultBadge => 'Výchozí';

  @override
  String get editCar => 'Upravit auto';

  @override
  String get name => 'Název';

  @override
  String get nameHint => 'Např. Audi Q4 e-tron';

  @override
  String get enterName => 'Zadejte název';

  @override
  String get brand => 'Značka';

  @override
  String get color => 'Barva';

  @override
  String get icon => 'Ikona';

  @override
  String get defaultCar => 'Výchozí auto';

  @override
  String get defaultCarSubtitle => 'Nové jízdy budou přiřazeny tomuto autu';

  @override
  String get bluetoothDevice => 'Bluetooth zařízení';

  @override
  String get autoSetOnConnect => 'Nastaví se automaticky při připojení';

  @override
  String get autoSetOnConnectFull =>
      'Nastaví se automaticky při připojení k CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'API připojení auta';

  @override
  String connectWithBrand(String brand) {
    return 'Připojte se k $brand pro tachometr a stav baterie';
  }

  @override
  String get brandAudi => 'Audi';

  @override
  String get brandVolkswagen => 'Volkswagen';

  @override
  String get brandSkoda => 'Škoda';

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
  String get brandOther => 'Ostatní';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Dodávka';

  @override
  String get loginWithTesla => 'Přihlásit se přes Tesla';

  @override
  String get teslaLoginInfo =>
      'Budete přesměrováni na Tesla pro přihlášení. Poté můžete zobrazit data svého auta.';

  @override
  String get usernameEmail => 'Uživatelské jméno / E-mail';

  @override
  String get password => 'Heslo';

  @override
  String get country => 'Země';

  @override
  String get countryHint => 'CZ';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Auto aktualizováno';

  @override
  String get carAdded => 'Auto přidáno';

  @override
  String errorMessage(String error) {
    return 'Chyba: $error';
  }

  @override
  String get carDeleted => 'Auto smazáno';

  @override
  String get deleteCar => 'Smazat auto?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Opravdu chcete smazat \"$carName\"? Všechny jízdy přiřazené tomuto autu si zachovají svá data.';
  }

  @override
  String get apiSettingsSaved => 'Nastavení API uloženo';

  @override
  String get teslaAlreadyLinked => 'Tesla je již propojena!';

  @override
  String get teslaLinked => 'Tesla propojena!';

  @override
  String get teslaLinkFailed => 'Propojení Tesla se nezdařilo';

  @override
  String get startTrip => 'Zahájit jízdu';

  @override
  String get stopTrip => 'Ukončit jízdu';

  @override
  String get gpsActiveTracking => 'GPS aktivní - automatické sledování';

  @override
  String get activeTrip => 'Aktivní jízda';

  @override
  String startedAt(String time) {
    return 'Zahájeno: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS bodů';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Aktualizováno: $time';
  }

  @override
  String get battery => 'Baterie';

  @override
  String get status => 'Stav';

  @override
  String get odometer => 'Tachometr';

  @override
  String get stateParked => 'Zaparkováno';

  @override
  String get stateDriving => 'Jede';

  @override
  String get stateCharging => 'Nabíjí se';

  @override
  String get stateUnknown => 'Neznámý';

  @override
  String chargingPower(double power) {
    return 'Nabíjení: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Hotovo za: $time';
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
  String get addFirstCar => 'Přidejte své první auto';

  @override
  String get toTrackPerCar => 'Pro sledování jízd podle auta';

  @override
  String get selectCar => 'Vyberte auto';

  @override
  String get manageCars => 'Spravovat auta';

  @override
  String get unknownDevice => 'Neznámé zařízení';

  @override
  String deviceName(String name) {
    return 'Zařízení: $name';
  }

  @override
  String get linkToCar => 'Propojit s autem:';

  @override
  String get noCarsFound => 'Žádná auta nenalezena. Nejprve přidejte auto.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName propojeno s $deviceName - Jízda zahájena!';
  }

  @override
  String linkError(String error) {
    return 'Chyba propojení: $error';
  }

  @override
  String get required => 'Povinné';

  @override
  String get invalidDistance => 'Neplatná vzdálenost';

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
}
