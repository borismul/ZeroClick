// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Kilométer Napló';

  @override
  String get tabStatus => 'Állapot';

  @override
  String get tabTrips => 'Utak';

  @override
  String get tabSettings => 'Beállítások';

  @override
  String get tabCharging => 'Töltés';

  @override
  String get chargingStations => 'töltőállomás';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String get importantTitle => 'Fontos';

  @override
  String get backgroundWarningMessage =>
      'Ez az alkalmazás automatikusan érzékeli, amikor beülsz az autóba Bluetooth-on keresztül.\n\nEz csak akkor működik, ha az alkalmazás a háttérben fut. Ha bezárod az alkalmazást (felfelé húzás), az automatikus érzékelés leáll.\n\nTipp: Hagyd nyitva az alkalmazást, és minden automatikusan működik.';

  @override
  String get understood => 'Értem';

  @override
  String get loginPrompt => 'Jelentkezz be a kezdéshez';

  @override
  String get loginSubtitle =>
      'Jelentkezz be Google-fiókkal és állítsd be az autó API-t';

  @override
  String get goToSettings => 'Beállítások';

  @override
  String get carPlayConnected => 'CarPlay csatlakoztatva';

  @override
  String get offlineWarning => 'Offline - műveletek sorba állítva';

  @override
  String get recentTrips => 'Legutóbbi utak';

  @override
  String get configureFirst =>
      'Először állítsd be az alkalmazást a Beállításokban';

  @override
  String get noTripsYet => 'Még nincsenek utak';

  @override
  String routeLongerPercent(int percent) {
    return 'Útvonal +$percent% hosszabb';
  }

  @override
  String get route => 'Útvonal';

  @override
  String get from => 'Honnan';

  @override
  String get to => 'Hová';

  @override
  String get details => 'Részletek';

  @override
  String get date => 'Dátum';

  @override
  String get time => 'Idő';

  @override
  String get distance => 'Távolság';

  @override
  String get type => 'Típus';

  @override
  String get tripTypeBusiness => 'Üzleti';

  @override
  String get tripTypePrivate => 'Magán';

  @override
  String get tripTypeMixed => 'Vegyes';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Útvonal eltérés';

  @override
  String get car => 'Autó';

  @override
  String routeDeviationWarning(int percent) {
    return 'Az útvonal $percent%-kal hosszabb a Google Maps által vártnál';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Út szerkesztése';

  @override
  String get addTrip => 'Út hozzáadása';

  @override
  String get dateAndTime => 'Dátum és idő';

  @override
  String get start => 'Kezdés';

  @override
  String get end => 'Befejezés';

  @override
  String get fromPlaceholder => 'Honnan';

  @override
  String get toPlaceholder => 'Hová';

  @override
  String get distanceAndType => 'Távolság és típus';

  @override
  String get distanceKm => 'Távolság (km)';

  @override
  String get businessKm => 'Üzleti km';

  @override
  String get privateKm => 'Magán km';

  @override
  String get save => 'Mentés';

  @override
  String get add => 'Hozzáadás';

  @override
  String get deleteTrip => 'Út törlése?';

  @override
  String get deleteTripConfirmation =>
      'Biztosan törölni szeretnéd ezt az utat?';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get somethingWentWrong => 'Valami hiba történt';

  @override
  String get couldNotDelete => 'Nem sikerült törölni';

  @override
  String get statistics => 'Statisztikák';

  @override
  String get trips => 'Utak';

  @override
  String get total => 'Összesen';

  @override
  String get business => 'Üzleti';

  @override
  String get private => 'Magán';

  @override
  String get account => 'Fiók';

  @override
  String get loggedIn => 'Bejelentkezve';

  @override
  String get googleAccount => 'Google fiók';

  @override
  String get loginWithGoogle => 'Bejelentkezés Google-lal';

  @override
  String get myCars => 'Autóim';

  @override
  String carsCount(int count) {
    return '$count autó';
  }

  @override
  String get manageVehicles => 'Járműveid kezelése';

  @override
  String get location => 'Helyzet';

  @override
  String get requestLocationPermission => 'Helymeghatározási engedély kérése';

  @override
  String get openIOSSettings => 'iOS Beállítások megnyitása';

  @override
  String get locationPermissionGranted => 'Helymeghatározási engedély megadva!';

  @override
  String get locationPermissionDenied =>
      'Helymeghatározási engedély megtagadva - menj a Beállításokba';

  @override
  String get enableLocationServices =>
      'Először engedélyezd a Helymeghatározást az iOS Beállításokban';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatikus érzékelés';

  @override
  String get autoDetectionSubtitle =>
      'Utak automatikus indítása/leállítása CarPlay csatlakozáskor';

  @override
  String get carPlayIsConnected => 'CarPlay csatlakoztatva';

  @override
  String get queue => 'Sor';

  @override
  String queueItems(int count) {
    return '$count elem a sorban';
  }

  @override
  String get queueSubtitle => 'Online állapotban küldésre kerül';

  @override
  String get sendNow => 'Küldés most';

  @override
  String get aboutApp => 'Az alkalmazásról';

  @override
  String get aboutDescription =>
      'Ez az alkalmazás helyettesíti az iPhone Parancsok automatizálását a kilométer naplózáshoz. Automatikusan érzékeli, amikor beülsz az autóba Bluetooth/CarPlay-en keresztül és rögzíti az utakat.';

  @override
  String loggedInAs(String email) {
    return 'Bejelentkezve: $email';
  }

  @override
  String errorSaving(String error) {
    return 'Mentési hiba: $error';
  }

  @override
  String get carSettingsSaved => 'Autó beállítások mentve';

  @override
  String get enterUsernamePassword => 'Add meg a felhasználónevet és jelszót';

  @override
  String get cars => 'Autók';

  @override
  String get addCar => 'Autó hozzáadása';

  @override
  String get noCarsAdded => 'Még nincsenek autók';

  @override
  String get defaultBadge => 'Alapértelmezett';

  @override
  String get editCar => 'Autó szerkesztése';

  @override
  String get name => 'Név';

  @override
  String get nameHint => 'Pl. Audi Q4 e-tron';

  @override
  String get enterName => 'Adj meg egy nevet';

  @override
  String get brand => 'Márka';

  @override
  String get color => 'Szín';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Alapértelmezett autó';

  @override
  String get defaultCarSubtitle => 'Új utak ehhez az autóhoz lesznek kapcsolva';

  @override
  String get bluetoothDevice => 'Bluetooth eszköz';

  @override
  String get autoSetOnConnect => 'Automatikusan beállítva csatlakozáskor';

  @override
  String get autoSetOnConnectFull =>
      'Automatikusan beállítva CarPlay/Bluetooth csatlakozáskor';

  @override
  String get carApiConnection => 'Autó API kapcsolat';

  @override
  String connectWithBrand(String brand) {
    return 'Csatlakozz a $brand-hoz kilométeróra és akkumulátor állapotért';
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
  String get brandOther => 'Egyéb';

  @override
  String get iconSedan => 'Szedán';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Ferdehátú';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Furgon';

  @override
  String get loginWithTesla => 'Bejelentkezés Tesla-val';

  @override
  String get teslaLoginInfo =>
      'Átirányítunk a Tesla-hoz a bejelentkezéshez. Ezután megtekintheted az autó adatait.';

  @override
  String get usernameEmail => 'Felhasználónév / E-mail';

  @override
  String get password => 'Jelszó';

  @override
  String get country => 'Ország';

  @override
  String get countryHint => 'HU';

  @override
  String get testApi => 'API teszt';

  @override
  String get carUpdated => 'Autó frissítve';

  @override
  String get carAdded => 'Autó hozzáadva';

  @override
  String errorMessage(String error) {
    return 'Hiba: $error';
  }

  @override
  String get carDeleted => 'Autó törölve';

  @override
  String get deleteCar => 'Autó törlése?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Biztosan törölni szeretnéd a \"$carName\" autót? Az ehhez az autóhoz kapcsolt összes út megtartja adatait.';
  }

  @override
  String get apiSettingsSaved => 'API beállítások mentve';

  @override
  String get teslaAlreadyLinked => 'Tesla már csatlakoztatva!';

  @override
  String get teslaLinked => 'Tesla csatlakoztatva!';

  @override
  String get teslaLinkFailed => 'Tesla csatlakozás sikertelen';

  @override
  String get startTrip => 'Út indítása';

  @override
  String get stopTrip => 'Út befejezése';

  @override
  String get gpsActiveTracking => 'GPS aktív - automatikus követés';

  @override
  String get activeTrip => 'Aktív út';

  @override
  String startedAt(String time) {
    return 'Kezdés: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS pont';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Frissítve: $time';
  }

  @override
  String get battery => 'Akkumulátor';

  @override
  String get status => 'Állapot';

  @override
  String get odometer => 'Kilométeróra';

  @override
  String get stateParked => 'Parkolva';

  @override
  String get stateDriving => 'Vezetés';

  @override
  String get stateCharging => 'Töltés';

  @override
  String get stateUnknown => 'Ismeretlen';

  @override
  String chargingPower(double power) {
    return 'Töltés: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Kész: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes perc';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursó ${minutes}p';
  }

  @override
  String get addFirstCar => 'Add hozzá az első autódat';

  @override
  String get toTrackPerCar => 'Utak követéséhez autónként';

  @override
  String get selectCar => 'Autó kiválasztása';

  @override
  String get manageCars => 'Autók kezelése';

  @override
  String get unknownDevice => 'Ismeretlen eszköz';

  @override
  String deviceName(String name) {
    return 'Eszköz: $name';
  }

  @override
  String get linkToCar => 'Kapcsolás autóhoz:';

  @override
  String get noCarsFound => 'Nincs autó. Először adj hozzá egy autót.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName kapcsolva: $deviceName - Út elindítva!';
  }

  @override
  String linkError(String error) {
    return 'Kapcsolási hiba: $error';
  }

  @override
  String get required => 'Kötelező';

  @override
  String get invalidDistance => 'Érvénytelen távolság';

  @override
  String get language => 'Nyelv';

  @override
  String get systemDefault => 'Rendszer alapértelmezett';

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
  String get retry => 'Újra';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Nincs kapcsolat';

  @override
  String get checkInternetConnection =>
      'Ellenőrizd az internetkapcsolatot és próbáld újra.';

  @override
  String get sessionExpired => 'Munkamenet lejárt';

  @override
  String get loginAgainToContinue => 'A folytatáshoz jelentkezz be újra.';

  @override
  String get serverError => 'Szerverhiba';

  @override
  String get tryAgainLater =>
      'Valami hiba történt. Kérlek, próbáld újra később.';

  @override
  String get invalidInput => 'Érvénytelen bevitel';

  @override
  String get timeout => 'Időtúllépés';

  @override
  String get serverNotResponding =>
      'A szerver nem válaszol. Kérlek, próbáld újra.';

  @override
  String get error => 'Hiba';

  @override
  String get unexpectedError => 'Váratlan hiba történt.';

  @override
  String get setupCarTitle => 'Állítsd be az autódat a legjobb élményért:';

  @override
  String get setupCarApiStep => 'Autó API csatlakoztatása';

  @override
  String get setupCarApiDescription =>
      'Menj az Autók → válaszd ki az autódat → csatlakoztasd a fiókodat. Ez hozzáférést biztosít a kilométeróra adataihoz és többhöz.';

  @override
  String get setupBluetoothStep => 'Bluetooth csatlakoztatása';

  @override
  String get setupBluetoothDescription =>
      'Csatlakoztasd a telefonodat Bluetooth-on keresztül az autóhoz, nyisd meg ezt az alkalmazást és csatlakoztass az értesítésben. Ez biztosítja a megbízható út észlelést.';

  @override
  String get setupTip =>
      'Tipp: Állítsd be mindkettőt a legjobb megbízhatóságért!';

  @override
  String get developer => 'Fejlesztő';

  @override
  String get debugLogs => 'Hibakeresési naplók';

  @override
  String get viewNativeLogs => 'Natív iOS naplók megtekintése';

  @override
  String get copyAllLogs => 'Összes napló másolása';

  @override
  String get logsCopied => 'Naplók másolva a vágólapra';

  @override
  String get loggedOut => 'Kijelentkezve';

  @override
  String get loginWithAudiId => 'Bejelentkezés Audi ID-vel';

  @override
  String get loginWithAudiDescription => 'Jelentkezz be a myAudi fiókoddal';

  @override
  String get loginWithVolkswagenId => 'Bejelentkezés Volkswagen ID-vel';

  @override
  String get loginWithVolkswagenDescription =>
      'Jelentkezz be a Volkswagen ID fiókoddal';

  @override
  String get loginWithSkodaId => 'Bejelentkezés Skoda ID-vel';

  @override
  String get loginWithSkodaDescription => 'Jelentkezz be a Skoda ID fiókoddal';

  @override
  String get loginWithSeatId => 'Bejelentkezés SEAT ID-vel';

  @override
  String get loginWithSeatDescription => 'Jelentkezz be a SEAT ID fiókoddal';

  @override
  String get loginWithCupraId => 'Bejelentkezés CUPRA ID-vel';

  @override
  String get loginWithCupraDescription => 'Jelentkezz be a CUPRA ID fiókoddal';

  @override
  String get loginWithRenaultId => 'Bejelentkezés Renault ID-vel';

  @override
  String get loginWithRenaultDescription =>
      'Jelentkezz be a MY Renault fiókoddal';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault csatlakoztatva';

  @override
  String get accountLinkedSuccess => 'A fiókod sikeresen csatlakoztatva';

  @override
  String brandConnected(String brand) {
    return '$brand csatlakoztatva';
  }

  @override
  String connectBrand(String brand) {
    return '$brand csatlakoztatása';
  }

  @override
  String get email => 'E-mail';

  @override
  String get countryNetherlands => 'Hollandia';

  @override
  String get countryBelgium => 'Belgium';

  @override
  String get countryGermany => 'Németország';

  @override
  String get countryFrance => 'Franciaország';

  @override
  String get countryUnitedKingdom => 'Egyesült Királyság';

  @override
  String get countrySpain => 'Spanyolország';

  @override
  String get countryItaly => 'Olaszország';

  @override
  String get countryPortugal => 'Portugália';

  @override
  String get enterEmailAndPassword => 'Add meg az e-mail címed és jelszavad';

  @override
  String get couldNotGetLoginUrl =>
      'Nem sikerült lekérni a bejelentkezési URL-t';

  @override
  String brandLinked(String brand) {
    return '$brand csatlakoztatva';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand csatlakoztatva (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand csatlakoztatás sikertelen';
  }

  @override
  String get changesInNameColorIcon =>
      'Név/szín/ikon módosítása? Nyomd meg a vissza gombot és szerkeszd.';

  @override
  String get notificationChannelCarDetection => 'Autó észlelés';

  @override
  String get notificationChannelDescription =>
      'Értesítések autó észlelésről és út regisztrációról';

  @override
  String get notificationNewCarDetected => 'Új autó észlelve';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'A \"$deviceName\" egy autó, amit követni szeretnél?';
  }

  @override
  String get notificationTripStarted => 'Út elindítva';

  @override
  String get notificationTripTracking => 'Az utad nyomon követése folyamatban';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Az utad $carName autóval nyomon követése folyamatban';
  }

  @override
  String get notificationCarLinked => 'Autó csatlakoztatva';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return 'A \"$deviceName\" most csatlakoztatva van a $carName autóhoz';
  }

  @override
  String locationError(String error) {
    return 'Helymeghatározási hiba: $error';
  }
}
