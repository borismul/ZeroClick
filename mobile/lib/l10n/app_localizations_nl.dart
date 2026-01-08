// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Kilometerregistratie';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Ritten';

  @override
  String get tabSettings => 'Instellingen';

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
      'Deze app vervangt de iPhone Opdrachten automatisering voor kilometerregistratie. Het detecteert automatisch wanneer je in de auto stapt via Bluetooth/CarPlay en houdt ritten bij.';

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
}
