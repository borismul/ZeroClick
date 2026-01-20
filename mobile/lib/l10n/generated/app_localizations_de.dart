// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Kilometererfassung';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Fahrten';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabCharging => 'Laden';

  @override
  String get chargingStations => 'Ladestationen';

  @override
  String get logout => 'Abmelden';

  @override
  String get importantTitle => 'Wichtig';

  @override
  String get backgroundWarningMessage =>
      'Diese App erkennt automatisch, wenn du ins Auto steigst, via Bluetooth.\n\nDas funktioniert nur, wenn die App im Hintergrund läuft. Wenn du die App schließt (nach oben wischen), funktioniert die automatische Erkennung nicht mehr.\n\nTipp: Lass die App einfach offen, dann funktioniert alles automatisch.';

  @override
  String get understood => 'Verstanden';

  @override
  String get loginPrompt => 'Melde dich an, um zu beginnen';

  @override
  String get loginSubtitle =>
      'Melde dich mit deinem Google-Konto an und konfiguriere die Auto-API';

  @override
  String get goToSettings => 'Zu den Einstellungen';

  @override
  String get carPlayConnected => 'CarPlay verbunden';

  @override
  String get offlineWarning =>
      'Offline - Aktionen werden in die Warteschlange gestellt';

  @override
  String get recentTrips => 'Letzte Fahrten';

  @override
  String get configureFirst =>
      'Konfiguriere zuerst die App in den Einstellungen';

  @override
  String get noTripsYet => 'Noch keine Fahrten';

  @override
  String routeLongerPercent(int percent) {
    return 'Route +$percent% länger';
  }

  @override
  String get route => 'Route';

  @override
  String get from => 'Von';

  @override
  String get to => 'Nach';

  @override
  String get details => 'Details';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get distance => 'Entfernung';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Geschäftlich';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Gemischt';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Routenabweichung';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Route ist $percent% länger als über Google Maps erwartet';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Fahrt bearbeiten';

  @override
  String get addTrip => 'Fahrt hinzufügen';

  @override
  String get dateAndTime => 'Datum & Zeit';

  @override
  String get start => 'Start';

  @override
  String get end => 'Ende';

  @override
  String get fromPlaceholder => 'Von';

  @override
  String get toPlaceholder => 'Nach';

  @override
  String get distanceAndType => 'Entfernung & Typ';

  @override
  String get distanceKm => 'Entfernung (km)';

  @override
  String get businessKm => 'Geschäftlich km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Speichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get deleteTrip => 'Fahrt löschen?';

  @override
  String get deleteTripConfirmation =>
      'Bist du sicher, dass du diese Fahrt löschen möchtest?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get couldNotDelete => 'Konnte nicht löschen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get trips => 'Fahrten';

  @override
  String get total => 'Gesamt';

  @override
  String get business => 'Geschäftlich';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Angemeldet';

  @override
  String get googleAccount => 'Google-Konto';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get myCars => 'Meine Autos';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Autos',
      one: '1 Auto',
      zero: '0 Autos',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Verwalte deine Fahrzeuge';

  @override
  String get location => 'Standort';

  @override
  String get requestLocationPermission => 'Standortberechtigung anfordern';

  @override
  String get openIOSSettings => 'iOS-Einstellungen öffnen';

  @override
  String get locationPermissionGranted => 'Standortberechtigung erteilt!';

  @override
  String get locationPermissionDenied =>
      'Standortberechtigung verweigert - gehe zu Einstellungen';

  @override
  String get enableLocationServices =>
      'Aktiviere zuerst Ortungsdienste in den iOS-Einstellungen';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatische Erkennung';

  @override
  String get autoDetectionSubtitle =>
      'Fahrten automatisch starten/stoppen bei CarPlay-Verbindung';

  @override
  String get carPlayIsConnected => 'CarPlay ist verbunden';

  @override
  String get queue => 'Warteschlange';

  @override
  String queueItems(int count) {
    return '$count Elemente in Warteschlange';
  }

  @override
  String get queueSubtitle => 'Werden gesendet, sobald online';

  @override
  String get sendNow => 'Jetzt senden';

  @override
  String get aboutApp => 'Über diese App';

  @override
  String get aboutDescription =>
      'Diese App ersetzt die iPhone Kurzbefehle-Automatisierung für die Kilometererfassung. Sie erkennt automatisch, wenn du ins Auto steigst, via Bluetooth/CarPlay und zeichnet Fahrten auf.';

  @override
  String loggedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get carSettingsSaved => 'Auto-Einstellungen gespeichert';

  @override
  String get enterUsernamePassword => 'Benutzername und Passwort eingeben';

  @override
  String get cars => 'Autos';

  @override
  String get addCar => 'Auto hinzufügen';

  @override
  String get noCarsAdded => 'Noch keine Autos hinzugefügt';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Auto bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'z.B. Audi Q4 e-tron';

  @override
  String get enterName => 'Name eingeben';

  @override
  String get brand => 'Marke';

  @override
  String get color => 'Farbe';

  @override
  String get icon => 'Symbol';

  @override
  String get defaultCar => 'Standard-Auto';

  @override
  String get defaultCarSubtitle =>
      'Neue Fahrten werden mit diesem Auto verknüpft';

  @override
  String get bluetoothDevice => 'Bluetooth-Gerät';

  @override
  String get autoSetOnConnect => 'Wird automatisch bei Verbindung eingestellt';

  @override
  String get autoSetOnConnectFull =>
      'Wird automatisch bei Verbindung mit CarPlay/Bluetooth eingestellt';

  @override
  String get carApiConnection => 'Auto-API-Verbindung';

  @override
  String connectWithBrand(String brand) {
    return 'Mit $brand verbinden für Kilometerstand und Batteriestatus';
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
  String get brandOther => 'Sonstige';

  @override
  String get iconSedan => 'Limousine';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Schrägheck';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Mit Tesla anmelden';

  @override
  String get teslaLoginInfo =>
      'Du wirst zu Tesla weitergeleitet, um dich anzumelden. Danach kannst du deine Autodaten einsehen.';

  @override
  String get usernameEmail => 'Benutzername / E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'DE';

  @override
  String get testApi => 'API testen';

  @override
  String get carUpdated => 'Auto aktualisiert';

  @override
  String get carAdded => 'Auto hinzugefügt';

  @override
  String errorMessage(String error) {
    return 'Fehler: $error';
  }

  @override
  String get carDeleted => 'Auto gelöscht';

  @override
  String get deleteCar => 'Auto löschen?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Bist du sicher, dass du \"$carName\" löschen möchtest? Alle mit diesem Auto verknüpften Fahrten behalten ihre Daten.';
  }

  @override
  String get apiSettingsSaved => 'API-Einstellungen gespeichert';

  @override
  String get teslaAlreadyLinked => 'Tesla ist bereits verknüpft!';

  @override
  String get teslaLinked => 'Tesla verknüpft!';

  @override
  String get teslaLinkFailed => 'Tesla-Verknüpfung fehlgeschlagen';

  @override
  String get startTrip => 'Fahrt starten';

  @override
  String get stopTrip => 'Fahrt beenden';

  @override
  String get gpsActiveTracking => 'GPS aktiv - automatische Aufzeichnung';

  @override
  String get activeTrip => 'Aktive Fahrt';

  @override
  String startedAt(String time) {
    return 'Gestartet: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-Punkte';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get battery => 'Batterie';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Kilometerstand';

  @override
  String get stateParked => 'Geparkt';

  @override
  String get stateDriving => 'Fahrend';

  @override
  String get stateCharging => 'Lädt';

  @override
  String get stateUnknown => 'Unbekannt';

  @override
  String chargingPower(double power) {
    return 'Laden: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Fertig in: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes Min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get addFirstCar => 'Füge dein erstes Auto hinzu';

  @override
  String get toTrackPerCar => 'Um Fahrten pro Auto zu verfolgen';

  @override
  String get selectCar => 'Auto auswählen';

  @override
  String get manageCars => 'Autos verwalten';

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String deviceName(String name) {
    return 'Gerät: $name';
  }

  @override
  String get linkToCar => 'Mit Auto verknüpfen:';

  @override
  String get noCarsFound => 'Keine Autos gefunden. Füge zuerst ein Auto hinzu.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName mit $deviceName verknüpft - Fahrt gestartet!';
  }

  @override
  String linkError(String error) {
    return 'Fehler beim Verknüpfen: $error';
  }

  @override
  String get required => 'Erforderlich';

  @override
  String get invalidDistance => 'Ungültige Entfernung';

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
