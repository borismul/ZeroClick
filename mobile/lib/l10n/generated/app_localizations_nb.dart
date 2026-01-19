// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Kjørebok';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Turer';

  @override
  String get tabSettings => 'Innstillinger';

  @override
  String get tabCharging => 'Lading';

  @override
  String get chargingStations => 'ladestasjoner';

  @override
  String get logout => 'Logg ut';

  @override
  String get importantTitle => 'Viktig';

  @override
  String get backgroundWarningMessage =>
      'Denne appen oppdager automatisk når du setter deg i bilen via Bluetooth.\n\nDette fungerer bare hvis appen kjører i bakgrunnen. Hvis du lukker appen (sveip opp), slutter automatisk oppdagelse å fungere.\n\nTips: La appen være åpen, så fungerer alt automatisk.';

  @override
  String get understood => 'Forstått';

  @override
  String get loginPrompt => 'Logg inn for å begynne';

  @override
  String get loginSubtitle =>
      'Logg inn med Google-kontoen din og konfigurer bil-API-et';

  @override
  String get goToSettings => 'Gå til Innstillinger';

  @override
  String get carPlayConnected => 'CarPlay tilkoblet';

  @override
  String get offlineWarning => 'Frakoblet - handlinger settes i kø';

  @override
  String get recentTrips => 'Siste turer';

  @override
  String get configureFirst => 'Konfigurer appen i Innstillinger først';

  @override
  String get noTripsYet => 'Ingen turer ennå';

  @override
  String routeLongerPercent(int percent) {
    return 'Rute +$percent% lengre';
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
  String get distance => 'Avstand';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Jobb';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Blandet';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Ruteavvik';

  @override
  String get car => 'Bil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Ruten er $percent% lengre enn forventet via Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Rediger tur';

  @override
  String get addTrip => 'Legg til tur';

  @override
  String get dateAndTime => 'Dato & Tid';

  @override
  String get start => 'Start';

  @override
  String get end => 'Slutt';

  @override
  String get fromPlaceholder => 'Fra';

  @override
  String get toPlaceholder => 'Til';

  @override
  String get distanceAndType => 'Avstand & Type';

  @override
  String get distanceKm => 'Avstand (km)';

  @override
  String get businessKm => 'Jobb km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Lagre';

  @override
  String get add => 'Legg til';

  @override
  String get deleteTrip => 'Slett tur?';

  @override
  String get deleteTripConfirmation =>
      'Er du sikker på at du vil slette denne turen?';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Slett';

  @override
  String get somethingWentWrong => 'Noe gikk galt';

  @override
  String get couldNotDelete => 'Kunne ikke slette';

  @override
  String get statistics => 'Statistikk';

  @override
  String get trips => 'Turer';

  @override
  String get total => 'Totalt';

  @override
  String get business => 'Jobb';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Innlogget';

  @override
  String get googleAccount => 'Google-konto';

  @override
  String get loginWithGoogle => 'Logg inn med Google';

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
  String get manageVehicles => 'Administrer kjøretøyene dine';

  @override
  String get location => 'Posisjon';

  @override
  String get requestLocationPermission => 'Be om Posisjonstillatelse';

  @override
  String get openIOSSettings => 'Åpne iOS-innstillinger';

  @override
  String get locationPermissionGranted => 'Posisjonstillatelse gitt!';

  @override
  String get locationPermissionDenied =>
      'Posisjonstillatelse nektet - gå til Innstillinger';

  @override
  String get enableLocationServices =>
      'Aktiver Posisjonstjenester i iOS-innstillinger først';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatisk oppdagelse';

  @override
  String get autoDetectionSubtitle =>
      'Start/stopp turer automatisk ved CarPlay-tilkobling';

  @override
  String get carPlayIsConnected => 'CarPlay er tilkoblet';

  @override
  String get queue => 'Kø';

  @override
  String queueItems(int count) {
    return '$count elementer i køen';
  }

  @override
  String get queueSubtitle => 'Sendes når tilkoblet';

  @override
  String get sendNow => 'Send nå';

  @override
  String get aboutApp => 'Om denne appen';

  @override
  String get aboutDescription =>
      'Denne appen erstatter iPhone Snarveier-automatisering for kjørebok. Den oppdager automatisk når du setter deg i bilen via Bluetooth/CarPlay og registrerer turer.';

  @override
  String loggedInAs(String email) {
    return 'Innlogget som $email';
  }

  @override
  String errorSaving(String error) {
    return 'Feil ved lagring: $error';
  }

  @override
  String get carSettingsSaved => 'Bilinnstillinger lagret';

  @override
  String get enterUsernamePassword => 'Skriv inn brukernavn og passord';

  @override
  String get cars => 'Biler';

  @override
  String get addCar => 'Legg til bil';

  @override
  String get noCarsAdded => 'Ingen biler lagt til ennå';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Rediger bil';

  @override
  String get name => 'Navn';

  @override
  String get nameHint => 'F.eks. Audi Q4 e-tron';

  @override
  String get enterName => 'Skriv inn et navn';

  @override
  String get brand => 'Merke';

  @override
  String get color => 'Farge';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Standardbil';

  @override
  String get defaultCarSubtitle => 'Nye turer kobles til denne bilen';

  @override
  String get bluetoothDevice => 'Bluetooth-enhet';

  @override
  String get autoSetOnConnect => 'Settes automatisk ved tilkobling';

  @override
  String get autoSetOnConnectFull =>
      'Settes automatisk ved tilkobling til CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Bil-API-tilkobling';

  @override
  String connectWithBrand(String brand) {
    return 'Koble til $brand for kilometerstand og batteristatus';
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
  String get brandOther => 'Annet';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Kombi';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Varebil';

  @override
  String get loginWithTesla => 'Logg inn med Tesla';

  @override
  String get teslaLoginInfo =>
      'Du blir omdirigert til Tesla for å logge inn. Deretter kan du se bildataene dine.';

  @override
  String get usernameEmail => 'Brukernavn / E-post';

  @override
  String get password => 'Passord';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'NO';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Bil oppdatert';

  @override
  String get carAdded => 'Bil lagt til';

  @override
  String errorMessage(String error) {
    return 'Feil: $error';
  }

  @override
  String get carDeleted => 'Bil slettet';

  @override
  String get deleteCar => 'Slett bil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Er du sikker på at du vil slette \"$carName\"? Alle turer koblet til denne bilen beholder dataene sine.';
  }

  @override
  String get apiSettingsSaved => 'API-innstillinger lagret';

  @override
  String get teslaAlreadyLinked => 'Tesla er allerede koblet til!';

  @override
  String get teslaLinked => 'Tesla koblet til!';

  @override
  String get teslaLinkFailed => 'Tesla-tilkobling mislyktes';

  @override
  String get startTrip => 'Start Tur';

  @override
  String get stopTrip => 'Avslutt Tur';

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
    return 'Oppdatert: $time';
  }

  @override
  String get battery => 'Batteri';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Kilometerstand';

  @override
  String get stateParked => 'Parkert';

  @override
  String get stateDriving => 'Kjører';

  @override
  String get stateCharging => 'Lader';

  @override
  String get stateUnknown => 'Ukjent';

  @override
  String chargingPower(double power) {
    return 'Lader: $power kW';
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
  String get addFirstCar => 'Legg til din første bil';

  @override
  String get toTrackPerCar => 'For å spore turer per bil';

  @override
  String get selectCar => 'Velg bil';

  @override
  String get manageCars => 'Administrer biler';

  @override
  String get unknownDevice => 'Ukjent enhet';

  @override
  String deviceName(String name) {
    return 'Enhet: $name';
  }

  @override
  String get linkToCar => 'Koble til bil:';

  @override
  String get noCarsFound => 'Ingen biler funnet. Legg til en bil først.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName koblet til $deviceName - Tur startet!';
  }

  @override
  String linkError(String error) {
    return 'Koblingsfeil: $error';
  }

  @override
  String get required => 'Påkrevd';

  @override
  String get invalidDistance => 'Ugyldig avstand';

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
