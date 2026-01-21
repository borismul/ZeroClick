// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Registro Chilometri';

  @override
  String get tabStatus => 'Stato';

  @override
  String get tabTrips => 'Viaggi';

  @override
  String get tabSettings => 'Impostazioni';

  @override
  String get tabCharging => 'Ricarica';

  @override
  String get chargingStations => 'stazioni di ricarica';

  @override
  String get logout => 'Esci';

  @override
  String get importantTitle => 'Importante';

  @override
  String get backgroundWarningMessage =>
      'Questa app rileva automaticamente quando sali in auto tramite Bluetooth.\n\nQuesto funziona solo se l\'app è in esecuzione in background. Se chiudi l\'app (scorri verso l\'alto), il rilevamento automatico smetterà di funzionare.\n\nSuggerimento: Lascia semplicemente l\'app aperta e tutto funzionerà automaticamente.';

  @override
  String get understood => 'Capito';

  @override
  String get loginPrompt => 'Accedi per iniziare';

  @override
  String get loginSubtitle =>
      'Accedi con il tuo account Google e configura l\'API dell\'auto';

  @override
  String get goToSettings => 'Vai alle Impostazioni';

  @override
  String get carPlayConnected => 'CarPlay connesso';

  @override
  String get offlineWarning => 'Offline - le azioni verranno messe in coda';

  @override
  String get recentTrips => 'Viaggi recenti';

  @override
  String get configureFirst => 'Prima configura l\'app nelle Impostazioni';

  @override
  String get noTripsYet => 'Ancora nessun viaggio';

  @override
  String routeLongerPercent(int percent) {
    return 'Percorso +$percent% più lungo';
  }

  @override
  String get route => 'Percorso';

  @override
  String get from => 'Da';

  @override
  String get to => 'A';

  @override
  String get details => 'Dettagli';

  @override
  String get date => 'Data';

  @override
  String get time => 'Ora';

  @override
  String get distance => 'Distanza';

  @override
  String get type => 'Tipo';

  @override
  String get tripTypeBusiness => 'Lavoro';

  @override
  String get tripTypePrivate => 'Privato';

  @override
  String get tripTypeMixed => 'Misto';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Deviazione percorso';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Il percorso è $percent% più lungo del previsto secondo Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Modifica viaggio';

  @override
  String get addTrip => 'Aggiungi viaggio';

  @override
  String get dateAndTime => 'Data e Ora';

  @override
  String get start => 'Inizio';

  @override
  String get end => 'Fine';

  @override
  String get fromPlaceholder => 'Da';

  @override
  String get toPlaceholder => 'A';

  @override
  String get distanceAndType => 'Distanza e Tipo';

  @override
  String get distanceKm => 'Distanza (km)';

  @override
  String get businessKm => 'Km lavoro';

  @override
  String get privateKm => 'Km privato';

  @override
  String get save => 'Salva';

  @override
  String get add => 'Aggiungi';

  @override
  String get deleteTrip => 'Eliminare viaggio?';

  @override
  String get deleteTripConfirmation =>
      'Sei sicuro di voler eliminare questo viaggio?';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get couldNotDelete => 'Impossibile eliminare';

  @override
  String get statistics => 'Statistiche';

  @override
  String get trips => 'Viaggi';

  @override
  String get total => 'Totale';

  @override
  String get business => 'Lavoro';

  @override
  String get private => 'Privato';

  @override
  String get account => 'Account';

  @override
  String get loggedIn => 'Connesso';

  @override
  String get googleAccount => 'Account Google';

  @override
  String get loginWithGoogle => 'Accedi con Google';

  @override
  String get myCars => 'Le Mie Auto';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count auto',
      one: '1 auto',
      zero: '0 auto',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Gestisci i tuoi veicoli';

  @override
  String get location => 'Posizione';

  @override
  String get requestLocationPermission => 'Richiedi Permesso Posizione';

  @override
  String get openIOSSettings => 'Apri Impostazioni iOS';

  @override
  String get locationPermissionGranted => 'Permesso posizione concesso!';

  @override
  String get locationPermissionDenied =>
      'Permesso posizione negato - vai in Impostazioni';

  @override
  String get enableLocationServices =>
      'Prima attiva i Servizi di localizzazione nelle Impostazioni iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Rilevamento automatico';

  @override
  String get autoDetectionSubtitle =>
      'Avvia/ferma viaggi automaticamente quando CarPlay si connette';

  @override
  String get carPlayIsConnected => 'CarPlay è connesso';

  @override
  String get queue => 'Coda';

  @override
  String queueItems(int count) {
    return '$count elementi in coda';
  }

  @override
  String get queueSubtitle => 'Verranno inviati quando online';

  @override
  String get sendNow => 'Invia ora';

  @override
  String get aboutApp => 'Informazioni su questa app';

  @override
  String get aboutDescription =>
      'Questa app sostituisce l\'automazione Comandi Rapidi di iPhone per il registro chilometri. Rileva automaticamente quando sali in auto tramite Bluetooth/CarPlay e registra i viaggi.';

  @override
  String loggedInAs(String email) {
    return 'Connesso come $email';
  }

  @override
  String errorSaving(String error) {
    return 'Errore durante il salvataggio: $error';
  }

  @override
  String get carSettingsSaved => 'Impostazioni auto salvate';

  @override
  String get enterUsernamePassword => 'Inserisci nome utente e password';

  @override
  String get cars => 'Auto';

  @override
  String get addCar => 'Aggiungi auto';

  @override
  String get noCarsAdded => 'Nessuna auto aggiunta ancora';

  @override
  String get defaultBadge => 'Predefinita';

  @override
  String get editCar => 'Modifica auto';

  @override
  String get name => 'Nome';

  @override
  String get nameHint => 'Es. Audi Q4 e-tron';

  @override
  String get enterName => 'Inserisci un nome';

  @override
  String get brand => 'Marca';

  @override
  String get color => 'Colore';

  @override
  String get icon => 'Icona';

  @override
  String get defaultCar => 'Auto predefinita';

  @override
  String get defaultCarSubtitle =>
      'I nuovi viaggi saranno collegati a questa auto';

  @override
  String get bluetoothDevice => 'Dispositivo Bluetooth';

  @override
  String get autoSetOnConnect =>
      'Verrà impostato automaticamente alla connessione';

  @override
  String get autoSetOnConnectFull =>
      'Verrà impostato automaticamente quando si connette a CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Connessione API Auto';

  @override
  String connectWithBrand(String brand) {
    return 'Connetti con $brand per chilometraggio e stato batteria';
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
  String get brandOther => 'Altro';

  @override
  String get iconSedan => 'Berlina';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Utilitaria';

  @override
  String get iconSport => 'Sportiva';

  @override
  String get iconVan => 'Furgone';

  @override
  String get loginWithTesla => 'Accedi con Tesla';

  @override
  String get teslaLoginInfo =>
      'Verrai reindirizzato a Tesla per accedere. Poi potrai vedere i dati della tua auto.';

  @override
  String get usernameEmail => 'Nome utente / Email';

  @override
  String get password => 'Password';

  @override
  String get country => 'Paese';

  @override
  String get countryHint => 'IT';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Auto aggiornata';

  @override
  String get carAdded => 'Auto aggiunta';

  @override
  String errorMessage(String error) {
    return 'Errore: $error';
  }

  @override
  String get carDeleted => 'Auto eliminata';

  @override
  String get deleteCar => 'Eliminare auto?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Sei sicuro di voler eliminare \"$carName\"? Tutti i viaggi collegati a questa auto manterranno i loro dati.';
  }

  @override
  String get apiSettingsSaved => 'Impostazioni API salvate';

  @override
  String get teslaAlreadyLinked => 'Tesla è già collegata!';

  @override
  String get teslaLinked => 'Tesla collegata!';

  @override
  String get teslaLinkFailed => 'Collegamento Tesla fallito';

  @override
  String get startTrip => 'Inizia Viaggio';

  @override
  String get stopTrip => 'Termina Viaggio';

  @override
  String get gpsActiveTracking => 'GPS attivo - tracciamento automatico';

  @override
  String get activeTrip => 'Viaggio attivo';

  @override
  String startedAt(String time) {
    return 'Iniziato: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count punti GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Aggiornato: $time';
  }

  @override
  String get battery => 'Batteria';

  @override
  String get status => 'Stato';

  @override
  String get odometer => 'Chilometraggio';

  @override
  String get stateParked => 'Parcheggiata';

  @override
  String get stateDriving => 'In movimento';

  @override
  String get stateCharging => 'In carica';

  @override
  String get stateUnknown => 'Sconosciuto';

  @override
  String chargingPower(double power) {
    return 'Ricarica: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Pronta tra: $time';
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
  String get addFirstCar => 'Aggiungi la tua prima auto';

  @override
  String get toTrackPerCar => 'Per tracciare i viaggi per auto';

  @override
  String get selectCar => 'Seleziona auto';

  @override
  String get manageCars => 'Gestisci auto';

  @override
  String get unknownDevice => 'Dispositivo sconosciuto';

  @override
  String deviceName(String name) {
    return 'Dispositivo: $name';
  }

  @override
  String get linkToCar => 'Collega all\'auto:';

  @override
  String get noCarsFound => 'Nessuna auto trovata. Aggiungi prima un\'auto.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName collegata a $deviceName - Viaggio iniziato!';
  }

  @override
  String linkError(String error) {
    return 'Errore di collegamento: $error';
  }

  @override
  String get required => 'Obbligatorio';

  @override
  String get invalidDistance => 'Distanza non valida';

  @override
  String get language => 'Lingua';

  @override
  String get systemDefault => 'Predefinito di sistema';

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
  String get retry => 'Riprova';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Nessuna connessione';

  @override
  String get checkInternetConnection =>
      'Controlla la tua connessione internet e riprova.';

  @override
  String get sessionExpired => 'Sessione scaduta';

  @override
  String get loginAgainToContinue => 'Accedi di nuovo per continuare.';

  @override
  String get serverError => 'Errore del server';

  @override
  String get tryAgainLater => 'Qualcosa è andato storto. Riprova più tardi.';

  @override
  String get invalidInput => 'Input non valido';

  @override
  String get timeout => 'Tempo scaduto';

  @override
  String get serverNotResponding => 'Il server non risponde. Riprova.';

  @override
  String get error => 'Errore';

  @override
  String get unexpectedError => 'Si è verificato un errore imprevisto.';

  @override
  String get setupCarTitle =>
      'Configura la tua auto per la migliore esperienza:';

  @override
  String get setupCarApiStep => 'Connetti API Auto';

  @override
  String get setupCarApiDescription =>
      'Vai su Auto → scegli la tua auto → collega il tuo account. Questo ti dà accesso al chilometraggio e altro.';

  @override
  String get setupBluetoothStep => 'Connetti Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Collega il telefono via Bluetooth alla tua auto, apri questa app e collega nella notifica. Questo garantisce un rilevamento affidabile dei viaggi.';

  @override
  String get setupTip =>
      'Suggerimento: Configura entrambi per la massima affidabilità!';

  @override
  String get developer => 'Sviluppatore';

  @override
  String get debugLogs => 'Log di debug';

  @override
  String get viewNativeLogs => 'Visualizza log nativi iOS';

  @override
  String get copyAllLogs => 'Copia tutti i log';

  @override
  String get logsCopied => 'Log copiati negli appunti';

  @override
  String get loggedOut => 'Disconnesso';

  @override
  String get loginWithAudiId => 'Accedi con Audi ID';

  @override
  String get loginWithAudiDescription => 'Accedi con il tuo account myAudi';

  @override
  String get loginWithVolkswagenId => 'Accedi con Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Accedi con il tuo account Volkswagen ID';

  @override
  String get loginWithSkodaId => 'Accedi con Skoda ID';

  @override
  String get loginWithSkodaDescription => 'Accedi con il tuo account Skoda ID';

  @override
  String get loginWithSeatId => 'Accedi con SEAT ID';

  @override
  String get loginWithSeatDescription => 'Accedi con il tuo account SEAT ID';

  @override
  String get loginWithCupraId => 'Accedi con CUPRA ID';

  @override
  String get loginWithCupraDescription => 'Accedi con il tuo account CUPRA ID';

  @override
  String get loginWithRenaultId => 'Accedi con Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'Accedi con il tuo account MY Renault';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault connesso';

  @override
  String get accountLinkedSuccess =>
      'Il tuo account è stato collegato con successo';

  @override
  String brandConnected(String brand) {
    return '$brand connesso';
  }

  @override
  String connectBrand(String brand) {
    return 'Connetti $brand';
  }

  @override
  String get email => 'Email';

  @override
  String get countryNetherlands => 'Paesi Bassi';

  @override
  String get countryBelgium => 'Belgio';

  @override
  String get countryGermany => 'Germania';

  @override
  String get countryFrance => 'Francia';

  @override
  String get countryUnitedKingdom => 'Regno Unito';

  @override
  String get countrySpain => 'Spagna';

  @override
  String get countryItaly => 'Italia';

  @override
  String get countryPortugal => 'Portogallo';

  @override
  String get enterEmailAndPassword => 'Inserisci email e password';

  @override
  String get couldNotGetLoginUrl => 'Impossibile recuperare l\'URL di accesso';

  @override
  String brandLinked(String brand) {
    return '$brand collegato';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand collegato (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return 'Collegamento $brand fallito';
  }

  @override
  String get changesInNameColorIcon =>
      'Modifiche a nome/colore/icona? Premi indietro e modifica.';

  @override
  String get notificationChannelCarDetection => 'Rilevamento Auto';

  @override
  String get notificationChannelDescription =>
      'Notifiche per rilevamento auto e registrazione viaggi';

  @override
  String get notificationNewCarDetected => 'Nuova auto rilevata';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return '\"$deviceName\" è un\'auto che vuoi tracciare?';
  }

  @override
  String get notificationTripStarted => 'Viaggio iniziato';

  @override
  String get notificationTripTracking => 'Il tuo viaggio è ora tracciato';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Il tuo viaggio con $carName è ora tracciato';
  }

  @override
  String get notificationCarLinked => 'Auto collegata';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" è ora collegato a $carName';
  }

  @override
  String locationError(String error) {
    return 'Errore di posizione: $error';
  }
}
