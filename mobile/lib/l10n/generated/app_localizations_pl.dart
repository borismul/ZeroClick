// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Rejestr Kilometrów';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Podróże';

  @override
  String get tabSettings => 'Ustawienia';

  @override
  String get tabCharging => 'Ładowanie';

  @override
  String get chargingStations => 'stacji ładowania';

  @override
  String get logout => 'Wyloguj';

  @override
  String get importantTitle => 'Ważne';

  @override
  String get backgroundWarningMessage =>
      'Ta aplikacja automatycznie wykrywa, kiedy wsiadasz do samochodu przez Bluetooth.\n\nDziała to tylko, gdy aplikacja działa w tle. Jeśli zamkniesz aplikację (przesunięcie w górę), automatyczne wykrywanie przestanie działać.\n\nWskazówka: Po prostu zostaw aplikację otwartą, a wszystko będzie działać automatycznie.';

  @override
  String get understood => 'Rozumiem';

  @override
  String get loginPrompt => 'Zaloguj się, aby rozpocząć';

  @override
  String get loginSubtitle =>
      'Zaloguj się kontem Google i skonfiguruj API samochodu';

  @override
  String get goToSettings => 'Przejdź do Ustawień';

  @override
  String get carPlayConnected => 'CarPlay połączony';

  @override
  String get offlineWarning => 'Offline - akcje zostaną dodane do kolejki';

  @override
  String get recentTrips => 'Ostatnie podróże';

  @override
  String get configureFirst => 'Najpierw skonfiguruj aplikację w Ustawieniach';

  @override
  String get noTripsYet => 'Brak podróży';

  @override
  String routeLongerPercent(int percent) {
    return 'Trasa +$percent% dłuższa';
  }

  @override
  String get route => 'Trasa';

  @override
  String get from => 'Z';

  @override
  String get to => 'Do';

  @override
  String get details => 'Szczegóły';

  @override
  String get date => 'Data';

  @override
  String get time => 'Czas';

  @override
  String get distance => 'Odległość';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Służbowy';

  @override
  String get tripTypePrivate => 'Prywatny';

  @override
  String get tripTypeMixed => 'Mieszany';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Odchylenie trasy';

  @override
  String get car => 'Samochód';

  @override
  String routeDeviationWarning(int percent) {
    return 'Trasa jest $percent% dłuższa niż oczekiwano według Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Edytuj podróż';

  @override
  String get addTrip => 'Dodaj podróż';

  @override
  String get dateAndTime => 'Data i Czas';

  @override
  String get start => 'Start';

  @override
  String get end => 'Koniec';

  @override
  String get fromPlaceholder => 'Z';

  @override
  String get toPlaceholder => 'Do';

  @override
  String get distanceAndType => 'Odległość i Typ';

  @override
  String get distanceKm => 'Odległość (km)';

  @override
  String get businessKm => 'Km służbowe';

  @override
  String get privateKm => 'Km prywatne';

  @override
  String get save => 'Zapisz';

  @override
  String get add => 'Dodaj';

  @override
  String get deleteTrip => 'Usunąć podróż?';

  @override
  String get deleteTripConfirmation => 'Czy na pewno chcesz usunąć tę podróż?';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get somethingWentWrong => 'Coś poszło nie tak';

  @override
  String get couldNotDelete => 'Nie można usunąć';

  @override
  String get statistics => 'Statystyki';

  @override
  String get trips => 'Podróże';

  @override
  String get total => 'Razem';

  @override
  String get business => 'Służbowe';

  @override
  String get private => 'Prywatne';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Zalogowano';

  @override
  String get googleAccount => 'Konto Google';

  @override
  String get loginWithGoogle => 'Zaloguj przez Google';

  @override
  String get myCars => 'Moje Samochody';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count samochodów',
      few: '$count samochody',
      one: '1 samochód',
      zero: '0 samochodów',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Zarządzaj swoimi pojazdami';

  @override
  String get location => 'Lokalizacja';

  @override
  String get requestLocationPermission => 'Poproś o Uprawnienia Lokalizacji';

  @override
  String get openIOSSettings => 'Otwórz Ustawienia iOS';

  @override
  String get locationPermissionGranted => 'Uprawnienie lokalizacji przyznane!';

  @override
  String get locationPermissionDenied =>
      'Uprawnienie lokalizacji odrzucone - przejdź do Ustawień';

  @override
  String get enableLocationServices =>
      'Najpierw włącz Usługi lokalizacji w Ustawieniach iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatyczne wykrywanie';

  @override
  String get autoDetectionSubtitle =>
      'Rozpoczynaj/kończ podróże automatycznie przy połączeniu CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay jest połączony';

  @override
  String get queue => 'Kolejka';

  @override
  String queueItems(int count) {
    return '$count elementów w kolejce';
  }

  @override
  String get queueSubtitle => 'Zostaną wysłane po połączeniu';

  @override
  String get sendNow => 'Wyślij teraz';

  @override
  String get aboutApp => 'O tej aplikacji';

  @override
  String get aboutDescription =>
      'Ta aplikacja zastępuje automatyzację Skrótów iPhone\'a do rejestracji kilometrów. Automatycznie wykrywa, kiedy wsiadasz do samochodu przez Bluetooth/CarPlay i rejestruje podróże.';

  @override
  String loggedInAs(String email) {
    return 'Zalogowano jako $email';
  }

  @override
  String errorSaving(String error) {
    return 'Błąd zapisu: $error';
  }

  @override
  String get carSettingsSaved => 'Ustawienia samochodu zapisane';

  @override
  String get enterUsernamePassword => 'Wprowadź nazwę użytkownika i hasło';

  @override
  String get cars => 'Samochody';

  @override
  String get addCar => 'Dodaj samochód';

  @override
  String get noCarsAdded => 'Brak dodanych samochodów';

  @override
  String get defaultBadge => 'Domyślny';

  @override
  String get editCar => 'Edytuj samochód';

  @override
  String get name => 'Nazwa';

  @override
  String get nameHint => 'Np. Audi Q4 e-tron';

  @override
  String get enterName => 'Wprowadź nazwę';

  @override
  String get brand => 'Marka';

  @override
  String get color => 'Kolor';

  @override
  String get icon => 'Ikona';

  @override
  String get defaultCar => 'Domyślny samochód';

  @override
  String get defaultCarSubtitle =>
      'Nowe podróże będą przypisywane do tego samochodu';

  @override
  String get bluetoothDevice => 'Urządzenie Bluetooth';

  @override
  String get autoSetOnConnect =>
      'Zostanie ustawione automatycznie przy połączeniu';

  @override
  String get autoSetOnConnectFull =>
      'Zostanie ustawione automatycznie przy połączeniu z CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Połączenie API Samochodu';

  @override
  String connectWithBrand(String brand) {
    return 'Połącz z $brand dla przebiegu i stanu baterii';
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
  String get brandOther => 'Inny';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sportowy';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Zaloguj przez Tesla';

  @override
  String get teslaLoginInfo =>
      'Zostaniesz przekierowany do Tesla, aby się zalogować. Potem możesz zobaczyć dane swojego samochodu.';

  @override
  String get usernameEmail => 'Nazwa użytkownika / Email';

  @override
  String get password => 'Hasło';

  @override
  String get country => 'Kraj';

  @override
  String get countryHint => 'PL';

  @override
  String get testApi => 'Testuj API';

  @override
  String get carUpdated => 'Samochód zaktualizowany';

  @override
  String get carAdded => 'Samochód dodany';

  @override
  String errorMessage(String error) {
    return 'Błąd: $error';
  }

  @override
  String get carDeleted => 'Samochód usunięty';

  @override
  String get deleteCar => 'Usunąć samochód?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Czy na pewno chcesz usunąć \"$carName\"? Wszystkie podróże przypisane do tego samochodu zachowają swoje dane.';
  }

  @override
  String get apiSettingsSaved => 'Ustawienia API zapisane';

  @override
  String get teslaAlreadyLinked => 'Tesla jest już połączona!';

  @override
  String get teslaLinked => 'Tesla połączona!';

  @override
  String get teslaLinkFailed => 'Połączenie z Tesla nie powiodło się';

  @override
  String get startTrip => 'Rozpocznij Podróż';

  @override
  String get stopTrip => 'Zakończ Podróż';

  @override
  String get gpsActiveTracking => 'GPS aktywny - automatyczne śledzenie';

  @override
  String get activeTrip => 'Aktywna podróż';

  @override
  String startedAt(String time) {
    return 'Rozpoczęto: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count punktów GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Zaktualizowano: $time';
  }

  @override
  String get battery => 'Bateria';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Przebieg';

  @override
  String get stateParked => 'Zaparkowany';

  @override
  String get stateDriving => 'W ruchu';

  @override
  String get stateCharging => 'Ładowanie';

  @override
  String get stateUnknown => 'Nieznany';

  @override
  String chargingPower(double power) {
    return 'Ładowanie: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Gotowy za: $time';
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
  String get addFirstCar => 'Dodaj swój pierwszy samochód';

  @override
  String get toTrackPerCar => 'Aby śledzić podróże dla każdego samochodu';

  @override
  String get selectCar => 'Wybierz samochód';

  @override
  String get manageCars => 'Zarządzaj samochodami';

  @override
  String get unknownDevice => 'Nieznane urządzenie';

  @override
  String deviceName(String name) {
    return 'Urządzenie: $name';
  }

  @override
  String get linkToCar => 'Przypisz do samochodu:';

  @override
  String get noCarsFound =>
      'Nie znaleziono samochodów. Najpierw dodaj samochód.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName przypisany do $deviceName - Podróż rozpoczęta!';
  }

  @override
  String linkError(String error) {
    return 'Błąd przypisania: $error';
  }

  @override
  String get required => 'Wymagane';

  @override
  String get invalidDistance => 'Nieprawidłowa odległość';

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
