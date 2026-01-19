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
}
