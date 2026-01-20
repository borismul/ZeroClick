// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Zero Click';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Ritten';

  @override
  String get tabSettings => 'Instellingen';

  @override
  String get tabCharging => 'Laden';

  @override
  String get chargingStations => 'laadstations';

  @override
  String get logout => 'Uitloggen';

  @override
  String get importantTitle => 'Belangrijk';

  @override
  String get backgroundWarningMessage =>
      'Deze app detecteert automatisch wanneer je in de auto stapt via Bluetooth.\n\nDit werkt alleen als de app op de achtergrond draait. Als je de app afsluit (omhoog swipen), werkt de automatische detectie niet meer.\n\nTip: Laat de app gewoon open staan, dan werkt alles automatisch.';

  @override
  String get understood => 'Begrepen';

  @override
  String get loginPrompt => 'Log in om te beginnen';

  @override
  String get loginSubtitle =>
      'Log in met je Google account en configureer de auto API';

  @override
  String get goToSettings => 'Naar instellingen';

  @override
  String get carPlayConnected => 'CarPlay verbonden';

  @override
  String get offlineWarning => 'Offline - acties worden in wachtrij geplaatst';

  @override
  String get recentTrips => 'Laatste ritten';

  @override
  String get configureFirst => 'Configureer eerst de app in Instellingen';

  @override
  String get noTripsYet => 'Nog geen ritten';

  @override
  String routeLongerPercent(int percent) {
    return 'Route +$percent% langer';
  }

  @override
  String get route => 'Route';

  @override
  String get from => 'Van';

  @override
  String get to => 'Naar';

  @override
  String get details => 'Details';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Tijd';

  @override
  String get distance => 'Afstand';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Zakelijk';

  @override
  String get tripTypePrivate => 'Privé';

  @override
  String get tripTypeMixed => 'Gemengd';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Route afwijking';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Route is $percent% langer dan verwacht via Google Maps';
  }

  @override
  String get viewOnMap => 'Bekijk op kaart';

  @override
  String get editTrip => 'Rit bewerken';

  @override
  String get addTrip => 'Rit toevoegen';

  @override
  String get dateAndTime => 'Datum & Tijd';

  @override
  String get start => 'Start';

  @override
  String get end => 'Eind';

  @override
  String get fromPlaceholder => 'Van';

  @override
  String get toPlaceholder => 'Naar';

  @override
  String get distanceAndType => 'Afstand & Type';

  @override
  String get distanceKm => 'Afstand (km)';

  @override
  String get businessKm => 'Zakelijk km';

  @override
  String get privateKm => 'Privé km';

  @override
  String get save => 'Opslaan';

  @override
  String get add => 'Toevoegen';

  @override
  String get deleteTrip => 'Rit verwijderen?';

  @override
  String get deleteTripConfirmation =>
      'Weet je zeker dat je deze rit wilt verwijderen?';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get somethingWentWrong => 'Er ging iets mis';

  @override
  String get couldNotDelete => 'Kon niet verwijderen';

  @override
  String get statistics => 'Statistieken';

  @override
  String get trips => 'Ritten';

  @override
  String get total => 'Totaal';

  @override
  String get business => 'Zakelijk';

  @override
  String get private => 'Privé';

  @override
  String get account => 'Account';

  @override
  String get loggedIn => 'Ingelogd';

  @override
  String get googleAccount => 'Google account';

  @override
  String get loginWithGoogle => 'Inloggen met Google';

  @override
  String get myCars => 'Mijn Auto\'s';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count auto\'s',
      one: '1 auto',
      zero: '0 auto\'s',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Beheer je voertuigen';

  @override
  String get location => 'Locatie';

  @override
  String get requestLocationPermission => 'Vraag Locatie Permissie';

  @override
  String get openIOSSettings => 'Open iOS Instellingen';

  @override
  String get locationPermissionGranted => 'Locatiepermissie toegestaan!';

  @override
  String get locationPermissionDenied =>
      'Locatiepermissie geweigerd - ga naar Instellingen';

  @override
  String get enableLocationServices =>
      'Zet eerst Locatieservices aan in iOS Instellingen';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatische detectie';

  @override
  String get autoDetectionSubtitle =>
      'Start/stop ritten automatisch bij CarPlay verbinding';

  @override
  String get carPlayIsConnected => 'CarPlay is verbonden';

  @override
  String get queue => 'Wachtrij';

  @override
  String queueItems(int count) {
    return '$count items in wachtrij';
  }

  @override
  String get queueSubtitle => 'Worden verzonden zodra online';

  @override
  String get sendNow => 'Nu verzenden';

  @override
  String get aboutApp => 'Over deze app';

  @override
  String get aboutDescription =>
      'Zero Click detecteert automatisch wanneer je in de auto stapt via Bluetooth/CarPlay en houdt ritten bij. Geen handmatige invoer nodig.';

  @override
  String loggedInAs(String email) {
    return 'Ingelogd als $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fout bij opslaan: $error';
  }

  @override
  String get carSettingsSaved => 'Auto instellingen opgeslagen';

  @override
  String get enterUsernamePassword => 'Vul gebruikersnaam en wachtwoord in';

  @override
  String get cars => 'Auto\'s';

  @override
  String get addCar => 'Auto toevoegen';

  @override
  String get noCarsAdded => 'Nog geen auto\'s toegevoegd';

  @override
  String get defaultBadge => 'Standaard';

  @override
  String get editCar => 'Auto bewerken';

  @override
  String get name => 'Naam';

  @override
  String get nameHint => 'Bijv. Audi Q4 e-tron';

  @override
  String get enterName => 'Vul een naam in';

  @override
  String get brand => 'Merk';

  @override
  String get color => 'Kleur';

  @override
  String get icon => 'Icoon';

  @override
  String get defaultCar => 'Standaard auto';

  @override
  String get defaultCarSubtitle =>
      'Nieuwe ritten worden aan deze auto gekoppeld';

  @override
  String get bluetoothDevice => 'Bluetooth apparaat';

  @override
  String get autoSetOnConnect => 'Wordt automatisch ingesteld';

  @override
  String get autoSetOnConnectFull =>
      'Wordt automatisch ingesteld bij verbinding met CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Auto API Koppeling';

  @override
  String connectWithBrand(String brand) {
    return 'Koppel met $brand voor kilometerstand en batterijstatus';
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
  String get brandOther => 'Overig';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Bus';

  @override
  String get loginWithTesla => 'Inloggen met Tesla';

  @override
  String get teslaLoginInfo =>
      'Je wordt doorgestuurd naar Tesla om in te loggen. Daarna kun je je auto-data bekijken.';

  @override
  String get usernameEmail => 'Gebruikersnaam / E-mail';

  @override
  String get password => 'Wachtwoord';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'NL';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Auto bijgewerkt';

  @override
  String get carAdded => 'Auto toegevoegd';

  @override
  String errorMessage(String error) {
    return 'Fout: $error';
  }

  @override
  String get carDeleted => 'Auto verwijderd';

  @override
  String get deleteCar => 'Auto verwijderen?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Weet je zeker dat je \"$carName\" wilt verwijderen? Alle ritten gekoppeld aan deze auto behouden hun data.';
  }

  @override
  String get apiSettingsSaved => 'API instellingen opgeslagen';

  @override
  String get teslaAlreadyLinked => 'Tesla is al gekoppeld!';

  @override
  String get teslaLinked => 'Tesla gekoppeld!';

  @override
  String get teslaLinkFailed => 'Tesla koppeling mislukt';

  @override
  String get startTrip => 'Start Rit';

  @override
  String get stopTrip => 'Stop Rit';

  @override
  String get gpsActiveTracking => 'GPS actief - automatische tracking';

  @override
  String get activeTrip => 'Actieve rit';

  @override
  String startedAt(String time) {
    return 'Gestart: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS punten';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Bijgewerkt: $time';
  }

  @override
  String get battery => 'Batterij';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Km-stand';

  @override
  String get stateParked => 'Geparkeerd';

  @override
  String get stateDriving => 'Rijdend';

  @override
  String get stateCharging => 'Laden';

  @override
  String get stateUnknown => 'Onbekend';

  @override
  String chargingPower(double power) {
    return 'Laden: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Klaar over: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}u ${minutes}m';
  }

  @override
  String get addFirstCar => 'Voeg je eerste auto toe';

  @override
  String get toTrackPerCar => 'Om ritten per auto te volgen';

  @override
  String get selectCar => 'Selecteer auto';

  @override
  String get manageCars => 'Auto\'s beheren';

  @override
  String get unknownDevice => 'Onbekend apparaat';

  @override
  String deviceName(String name) {
    return 'Apparaat: $name';
  }

  @override
  String get linkToCar => 'Koppel aan auto:';

  @override
  String get noCarsFound => 'Geen auto\'s gevonden. Voeg eerst een auto toe.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName gekoppeld aan $deviceName - Rit gestart!';
  }

  @override
  String linkError(String error) {
    return 'Fout bij koppelen: $error';
  }

  @override
  String get required => 'Verplicht';

  @override
  String get invalidDistance => 'Ongeldige afstand';

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
  String get distanceSourceOdometer => 'Via kilometerstand';

  @override
  String get distanceSourceOsrm => 'Geschat via route';

  @override
  String get distanceSourceGps => 'Geschat via GPS';

  @override
  String get distanceEstimated => 'Afstand geschat';

  @override
  String get saveLocation => 'Locatie opslaan';

  @override
  String get locationName => 'Naam voor deze locatie';

  @override
  String get locationNameHint => 'Bijv. Klant ABC';

  @override
  String get deleteAccount => 'Account verwijderen';

  @override
  String get deleteAccountSubtitle => 'Verwijder je account en alle gegevens';

  @override
  String get deleteAccountTitle => 'Account verwijderen?';

  @override
  String get deleteAccountConfirmation =>
      'Dit verwijdert permanent al je ritten en gegevens. Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get accountDeleted => 'Account verwijderd';

  @override
  String deleteAccountError(String error) {
    return 'Fout bij verwijderen: $error';
  }

  @override
  String get onboardingWelcome => 'Welkom bij Zero Click';

  @override
  String get onboardingWelcomeSubtitle =>
      'We hebben een paar permissies nodig om je ritten automatisch te volgen. Laten we ze één voor één instellen.';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get onboardingDone => 'Klaar';

  @override
  String get onboardingOpenSettings => 'Open Instellingen';

  @override
  String get onboardingLoginTitle => 'Inloggen';

  @override
  String get onboardingLoginDescription =>
      'Log in met je Google-account om je ritten te synchroniseren en toegang te krijgen tot het webdashboard.';

  @override
  String get onboardingLoginButton => 'Inloggen met Google';

  @override
  String get onboardingLoggingIn => 'Bezig met inloggen...';

  @override
  String get onboardingNotificationsTitle => 'Notificaties';

  @override
  String get onboardingNotificationsDescription =>
      'We sturen een melding als een rit begint of eindigt, zodat je weet dat alles wordt bijgehouden.';

  @override
  String get onboardingNotificationsButton => 'Sta notificaties toe';

  @override
  String get onboardingLocationTitle => 'Locatietoegang';

  @override
  String get onboardingLocationDescription =>
      'We hebben je locatie nodig om te registreren waar ritten starten en eindigen. Dit is essentieel voor kilometerregistratie.';

  @override
  String get onboardingLocationButton => 'Sta locatie toe';

  @override
  String get onboardingLocationAlwaysTitle => 'Achtergrondlocatie';

  @override
  String get onboardingLocationAlwaysDescription =>
      'Voor automatische ritdetectie hebben we \'Altijd\' toegang nodig. Hiermee kunnen we ritten volgen, ook als de app op de achtergrond draait.';

  @override
  String get onboardingLocationAlwaysInstructions =>
      'Tik op \'Open Instellingen\', ga naar Locatie en kies \'Altijd\'.';

  @override
  String get onboardingLocationAlwaysGranted =>
      'Achtergrondlocatie ingeschakeld!';

  @override
  String get onboardingMotionTitle => 'Beweging en fitness';

  @override
  String get onboardingMotionDescription =>
      'We gebruiken bewegingssensoren om te detecteren wanneer je rijdt. Dit helpt ritten automatisch te starten zonder je batterij leeg te trekken.';

  @override
  String get onboardingMotionButton => 'Sta bewegingstoegang toe';

  @override
  String get onboardingHowItWorksTitle => 'Zo werkt het';

  @override
  String get onboardingHowItWorksDescription =>
      'Zero Click gebruikt bewegingssensoren om te detecteren wanneer je rijdt. Volledig automatisch!';

  @override
  String get onboardingFeatureMotion => 'Bewegingsdetectie';

  @override
  String get onboardingFeatureMotionDesc =>
      'Je telefoon detecteert rijbewegingen en start automatisch met registreren. Werkt volledig op de achtergrond.';

  @override
  String get onboardingFeatureBluetooth => 'Auto herkenning';

  @override
  String get onboardingFeatureBluetoothDesc =>
      'Verbind via Bluetooth om te herkennen in welke auto je rijdt. Ritten worden aan de juiste auto gekoppeld.';

  @override
  String get onboardingFeatureCarApi => 'Auto account';

  @override
  String get onboardingFeatureCarApiDesc =>
      'Koppel de app van je auto (myAudi, Tesla, etc.) voor automatische kilometerstanden bij start en einde.';

  @override
  String get onboardingSetupTitle => 'Stel je auto in';

  @override
  String get onboardingSetupDescription =>
      'Volg deze stappen voor de beste ervaring.';

  @override
  String get onboardingSetupStep1Title => 'Voeg je auto toe';

  @override
  String get onboardingSetupStep1Desc =>
      'Geef je auto een naam en kies een kleur. Dit helpt je ritten later herkennen.';

  @override
  String get onboardingSetupStep1Button => 'Auto toevoegen';

  @override
  String get onboardingSetupStep2Title => 'Ga naar je auto';

  @override
  String get onboardingSetupStep2Desc =>
      'Loop naar je auto en start hem. Zorg dat Bluetooth aan staat op je telefoon.';

  @override
  String get onboardingSetupStep3Title => 'Verbind Bluetooth';

  @override
  String get onboardingSetupStep3Desc =>
      'Koppel je telefoon met de Bluetooth van je auto. Er verschijnt een melding om deze te koppelen aan je auto in de app.';

  @override
  String get onboardingSetupStep4Title => 'Koppel auto account';

  @override
  String get onboardingSetupStep4Desc =>
      'Verbind de app van je auto (myAudi, Tesla, etc.) voor automatische kilometerstanden. Dit kan ook later in Instellingen.';

  @override
  String get onboardingSetupLater => 'Doe ik later';

  @override
  String get onboardingAllSet => 'Je bent klaar!';

  @override
  String get onboardingAllSetDescription =>
      'Permissies zijn ingesteld. Je ritten worden nu automatisch bijgehouden wanneer je verbinding maakt met je auto.';

  @override
  String get onboardingGetStarted => 'Aan de slag';

  @override
  String get tutorialDialogTitle => 'Stel je auto in';

  @override
  String get tutorialDialogContent =>
      'Voeg je auto toe om het meeste uit Zero Click te halen. We koppelen je ritten aan het juiste voertuig en lezen je kilometerstand automatisch.';

  @override
  String get tutorialDialogSetup => 'Auto toevoegen';

  @override
  String get tutorialDialogLater => 'Later';

  @override
  String get tutorialMyCarsTitle => 'Mijn Auto\'s';

  @override
  String get tutorialMyCarsDesc => 'Tik hier om je auto\'s te beheren';

  @override
  String get tutorialAddCarTitle => 'Auto toevoegen';

  @override
  String get tutorialAddCarDesc => 'Tik hier om je eerste auto toe te voegen';

  @override
  String get permissionsMissingTitle => 'Permissies vereist';

  @override
  String get permissionsMissingMessage =>
      'Sommige permissies zijn niet toegestaan. De app werkt mogelijk niet goed zonder deze.';

  @override
  String get permissionsOpenSettings => 'Open Instellingen';

  @override
  String get permissionsMissing => 'Ontbrekend';

  @override
  String get permissionLocation => 'Achtergrondlocatie';

  @override
  String get permissionMotion => 'Beweging en fitness';

  @override
  String get permissionNotifications => 'Notificaties';

  @override
  String get legal => 'Juridisch';

  @override
  String get privacyPolicyAndTerms => 'Privacybeleid & Voorwaarden';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get termsOfService => 'Algemene voorwaarden';

  @override
  String get readFullVersion => 'Lees volledige versie online';

  @override
  String lastUpdated(String date) {
    return 'Laatst bijgewerkt: $date';
  }

  @override
  String get privacyPolicyContent =>
      'PRIVACYBELEID\n\nZero Click (\'de app\') is een persoonlijke ritregistratie-app. Je privacy is belangrijk voor ons.\n\nWELKE GEGEVENS WE VERZAMELEN\n\n• Locatiegegevens: GPS-coördinaten tijdens ritten om afstanden en routes te berekenen\n• E-mailadres: Voor accountidentificatie via Google Inloggen\n• Kilometerstanden: Opgehaald van de API van je auto (Audi, Tesla, etc.) indien gekoppeld\n• Apparaatinformatie: Voor crashrapportage en app-verbeteringen\n\nWAAROOM WE DEZE GEGEVENS VERZAMELEN\n\n• Ritregistratie: Om automatisch je zakelijke en privéritten te registreren\n• Kilometerberekening: Via kilometerstanden of GPS-coördinaten\n• Authenticatie: Om je account te beveiligen en te synchroniseren tussen apparaten\n• App-verbetering: Om bugs te repareren en betrouwbaarheid te verbeteren\n\nHOE GEGEVENS WORDEN OPGESLAGEN\n\n• Alle gegevens worden opgeslagen in Firebase (Google Cloud Platform) in de EU-regio (europe-west4)\n• Gegevens worden versleuteld tijdens verzending en in rust\n• Alleen jij hebt toegang tot je ritgegevens\n\nDERDE PARTIJEN\n\n• Google Inloggen: Voor authenticatie\n• Firebase Analytics: Voor anonieme gebruiksstatistieken\n• Auto-API\'s (Audi, Tesla, Renault, etc.): Voor kilometerstanden\n• Google Maps: Voor routevisualisatie\n\nJE RECHTEN\n\n• Export: Je kunt al je ritten exporteren naar Google Sheets via het webdashboard\n• Verwijdering: Je kunt je account en alle gegevens verwijderen in Instellingen\n• Toegang: Je hebt volledige toegang tot al je gegevens in de app\n\nCONTACT\n\nVoor privacyvragen, neem contact op: privacy@zeroclick.app';

  @override
  String get termsOfServiceContent =>
      'ALGEMENE VOORWAARDEN\n\nDoor Zero Click (\'de app\') te gebruiken, ga je akkoord met deze voorwaarden.\n\nSERVICEBESCHRIJVING\n\nZero Click is een persoonlijke ritregistratie-app die automatisch detecteert wanneer je rijdt en ritten registreert. De app gebruikt bewegingsdetectie, GPS en optioneel de API van je auto voor kilometergegevens.\n\nGEBRUIKERSVERANTWOORDELIJKHEDEN\n\n• Correcte setup: Je bent verantwoordelijk voor het correct configureren van je auto\'s en accounts\n• Rechtmatig gebruik: Gebruik de app alleen voor legale doeleinden\n• Gegevensnauwkeurigheid: Controleer belangrijke ritgegevens voordat je deze gebruikt voor belasting of zakelijke doeleinden\n\nGEGEVENSNAAUWKEURIGHEID DISCLAIMER\n\n• GPS-gebaseerde afstanden kunnen afwijken van werkelijke afstanden\n• Kilometerstanden zijn afhankelijk van de nauwkeurigheid van de API van je auto\n• Automatische ritdetectie kan af en toe ritten missen of valse positieven creëren\n• Controleer altijd je ritten op nauwkeurigheid\n\nSERVICEBESCHIKBAARHEID\n\n• Zero Click is een persoonlijk project en garandeert geen uptime\n• De service kan onbeschikbaar zijn voor onderhoud of updates\n• Functies kunnen op elk moment veranderen of worden verwijderd\n\nACCOUNTBEËINDIGING\n\n• Je kunt je account op elk moment verwijderen in Instellingen\n• Accountverwijdering verwijdert permanent al je gegevens\n• We kunnen accounts beëindigen die deze voorwaarden schenden\n\nAANSPRAKELIJKHEIDSBEPERKING\n\n• De app wordt geleverd \'zoals het is\' zonder garanties\n• We zijn niet aansprakelijk voor onnauwkeurige ritgegevens of gemiste ritten\n• We zijn niet aansprakelijk voor schade door gebruik van de app\n• Maximale aansprakelijkheid is beperkt tot het bedrag dat je hebt betaald (nul, de app is gratis)\n\nWIJZIGINGEN IN VOORWAARDEN\n\nWe kunnen deze voorwaarden op elk moment bijwerken. Voortgezet gebruik na wijzigingen betekent acceptatie.\n\nCONTACT\n\nVoor vragen over deze voorwaarden, neem contact op: support@zeroclick.app';
}
