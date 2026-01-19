// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Ajopäiväkirja';

  @override
  String get tabStatus => 'Tila';

  @override
  String get tabTrips => 'Matkat';

  @override
  String get tabSettings => 'Asetukset';

  @override
  String get tabCharging => 'Lataus';

  @override
  String get chargingStations => 'latausasemaa';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get importantTitle => 'Tärkeää';

  @override
  String get backgroundWarningMessage =>
      'Tämä sovellus tunnistaa automaattisesti, kun nouset autoon Bluetoothin kautta.\n\nTämä toimii vain, jos sovellus toimii taustalla. Jos suljet sovelluksen (pyyhkäise ylös), automaattinen tunnistus lakkaa toimimasta.\n\nVinkki: Jätä sovellus auki, niin kaikki toimii automaattisesti.';

  @override
  String get understood => 'Selvä';

  @override
  String get loginPrompt => 'Kirjaudu sisään aloittaaksesi';

  @override
  String get loginSubtitle => 'Kirjaudu Google-tililläsi ja määritä auton API';

  @override
  String get goToSettings => 'Siirry Asetuksiin';

  @override
  String get carPlayConnected => 'CarPlay yhdistetty';

  @override
  String get offlineWarning => 'Offline - toiminnot lisätään jonoon';

  @override
  String get recentTrips => 'Viimeisimmät matkat';

  @override
  String get configureFirst => 'Määritä sovellus ensin Asetuksissa';

  @override
  String get noTripsYet => 'Ei matkoja vielä';

  @override
  String routeLongerPercent(int percent) {
    return 'Reitti +$percent% pidempi';
  }

  @override
  String get route => 'Reitti';

  @override
  String get from => 'Mistä';

  @override
  String get to => 'Minne';

  @override
  String get details => 'Tiedot';

  @override
  String get date => 'Päivämäärä';

  @override
  String get time => 'Aika';

  @override
  String get distance => 'Matka';

  @override
  String get type => 'Tyyppi';

  @override
  String get tripTypeBusiness => 'Työ';

  @override
  String get tripTypePrivate => 'Yksityinen';

  @override
  String get tripTypeMixed => 'Sekoitettu';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Reittipoikkeama';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Reitti on $percent% pidempi kuin Google Mapsin odotettu';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Muokkaa matkaa';

  @override
  String get addTrip => 'Lisää matka';

  @override
  String get dateAndTime => 'Päivämäärä & Aika';

  @override
  String get start => 'Alku';

  @override
  String get end => 'Loppu';

  @override
  String get fromPlaceholder => 'Mistä';

  @override
  String get toPlaceholder => 'Minne';

  @override
  String get distanceAndType => 'Matka & Tyyppi';

  @override
  String get distanceKm => 'Matka (km)';

  @override
  String get businessKm => 'Työ km';

  @override
  String get privateKm => 'Yksityinen km';

  @override
  String get save => 'Tallenna';

  @override
  String get add => 'Lisää';

  @override
  String get deleteTrip => 'Poista matka?';

  @override
  String get deleteTripConfirmation =>
      'Haluatko varmasti poistaa tämän matkan?';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get somethingWentWrong => 'Jotain meni pieleen';

  @override
  String get couldNotDelete => 'Poistaminen epäonnistui';

  @override
  String get statistics => 'Tilastot';

  @override
  String get trips => 'Matkat';

  @override
  String get total => 'Yhteensä';

  @override
  String get business => 'Työ';

  @override
  String get private => 'Yksityinen';

  @override
  String get account => 'Tili';

  @override
  String get loggedIn => 'Kirjautunut';

  @override
  String get googleAccount => 'Google-tili';

  @override
  String get loginWithGoogle => 'Kirjaudu Googlella';

  @override
  String get myCars => 'Omat Autoni';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count autoa',
      one: '1 auto',
      zero: '0 autoa',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Hallitse ajoneuvoja';

  @override
  String get location => 'Sijainti';

  @override
  String get requestLocationPermission => 'Pyydä Sijaintilupa';

  @override
  String get openIOSSettings => 'Avaa iOS-asetukset';

  @override
  String get locationPermissionGranted => 'Sijaintilupa myönnetty!';

  @override
  String get locationPermissionDenied =>
      'Sijaintilupa evätty - siirry Asetuksiin';

  @override
  String get enableLocationServices =>
      'Ota ensin Sijaintipalvelut käyttöön iOS-asetuksissa';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automaattinen tunnistus';

  @override
  String get autoDetectionSubtitle =>
      'Aloita/lopeta matkat automaattisesti CarPlay-yhteyden aikana';

  @override
  String get carPlayIsConnected => 'CarPlay on yhdistetty';

  @override
  String get queue => 'Jono';

  @override
  String queueItems(int count) {
    return '$count kohdetta jonossa';
  }

  @override
  String get queueSubtitle => 'Lähetetään kun online';

  @override
  String get sendNow => 'Lähetä nyt';

  @override
  String get aboutApp => 'Tietoa sovelluksesta';

  @override
  String get aboutDescription =>
      'Tämä sovellus korvaa iPhone Oikotiet -automaation ajopäiväkirjalle. Se tunnistaa automaattisesti, kun nouset autoon Bluetoothin/CarPlayn kautta ja tallentaa matkat.';

  @override
  String loggedInAs(String email) {
    return 'Kirjautunut: $email';
  }

  @override
  String errorSaving(String error) {
    return 'Tallennusvirhe: $error';
  }

  @override
  String get carSettingsSaved => 'Auton asetukset tallennettu';

  @override
  String get enterUsernamePassword => 'Anna käyttäjätunnus ja salasana';

  @override
  String get cars => 'Autot';

  @override
  String get addCar => 'Lisää auto';

  @override
  String get noCarsAdded => 'Ei autoja vielä';

  @override
  String get defaultBadge => 'Oletus';

  @override
  String get editCar => 'Muokkaa autoa';

  @override
  String get name => 'Nimi';

  @override
  String get nameHint => 'Esim. Audi Q4 e-tron';

  @override
  String get enterName => 'Anna nimi';

  @override
  String get brand => 'Merkki';

  @override
  String get color => 'Väri';

  @override
  String get icon => 'Kuvake';

  @override
  String get defaultCar => 'Oletusauto';

  @override
  String get defaultCarSubtitle => 'Uudet matkat liitetään tähän autoon';

  @override
  String get bluetoothDevice => 'Bluetooth-laite';

  @override
  String get autoSetOnConnect => 'Asetetaan automaattisesti yhteyden aikana';

  @override
  String get autoSetOnConnectFull =>
      'Asetetaan automaattisesti CarPlay/Bluetooth-yhteyden aikana';

  @override
  String get carApiConnection => 'Auton API-yhteys';

  @override
  String connectWithBrand(String brand) {
    return 'Yhdistä $brand:iin mittarilukemalle ja akkutilalle';
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
  String get brandOther => 'Muu';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Viistoperä';

  @override
  String get iconSport => 'Urheiluauto';

  @override
  String get iconVan => 'Pakettiauto';

  @override
  String get loginWithTesla => 'Kirjaudu Teslalla';

  @override
  String get teslaLoginInfo =>
      'Sinut ohjataan Teslaan kirjautumaan. Sen jälkeen voit nähdä autosi tiedot.';

  @override
  String get usernameEmail => 'Käyttäjätunnus / Sähköposti';

  @override
  String get password => 'Salasana';

  @override
  String get country => 'Maa';

  @override
  String get countryHint => 'FI';

  @override
  String get testApi => 'Testaa API';

  @override
  String get carUpdated => 'Auto päivitetty';

  @override
  String get carAdded => 'Auto lisätty';

  @override
  String errorMessage(String error) {
    return 'Virhe: $error';
  }

  @override
  String get carDeleted => 'Auto poistettu';

  @override
  String get deleteCar => 'Poista auto?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Haluatko varmasti poistaa \"$carName\"? Kaikki tähän autoon liitetyt matkat säilyttävät tietonsa.';
  }

  @override
  String get apiSettingsSaved => 'API-asetukset tallennettu';

  @override
  String get teslaAlreadyLinked => 'Tesla on jo yhdistetty!';

  @override
  String get teslaLinked => 'Tesla yhdistetty!';

  @override
  String get teslaLinkFailed => 'Tesla-yhteys epäonnistui';

  @override
  String get startTrip => 'Aloita Matka';

  @override
  String get stopTrip => 'Lopeta Matka';

  @override
  String get gpsActiveTracking => 'GPS aktiivinen - automaattinen seuranta';

  @override
  String get activeTrip => 'Aktiivinen matka';

  @override
  String startedAt(String time) {
    return 'Aloitettu: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-pistettä';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Päivitetty: $time';
  }

  @override
  String get battery => 'Akku';

  @override
  String get status => 'Tila';

  @override
  String get odometer => 'Matkamittari';

  @override
  String get stateParked => 'Pysäköity';

  @override
  String get stateDriving => 'Ajossa';

  @override
  String get stateCharging => 'Latautuu';

  @override
  String get stateUnknown => 'Tuntematon';

  @override
  String chargingPower(double power) {
    return 'Lataus: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Valmis: $time';
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
  String get addFirstCar => 'Lisää ensimmäinen autosi';

  @override
  String get toTrackPerCar => 'Seurataksesi matkoja autokohtaisesti';

  @override
  String get selectCar => 'Valitse auto';

  @override
  String get manageCars => 'Hallitse autoja';

  @override
  String get unknownDevice => 'Tuntematon laite';

  @override
  String deviceName(String name) {
    return 'Laite: $name';
  }

  @override
  String get linkToCar => 'Yhdistä autoon:';

  @override
  String get noCarsFound => 'Autoja ei löytynyt. Lisää auto ensin.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName yhdistetty $deviceName - Matka aloitettu!';
  }

  @override
  String linkError(String error) {
    return 'Yhteysvirhe: $error';
  }

  @override
  String get required => 'Pakollinen';

  @override
  String get invalidDistance => 'Virheellinen matka';

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
