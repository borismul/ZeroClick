// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Kørebog';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Ture';

  @override
  String get tabSettings => 'Indstillinger';

  @override
  String get logout => 'Log ud';

  @override
  String get importantTitle => 'Vigtigt';

  @override
  String get backgroundWarningMessage =>
      'Denne app registrerer automatisk, når du sætter dig ind i bilen via Bluetooth.\n\nDette virker kun, hvis appen kører i baggrunden. Hvis du lukker appen (swipe op), stopper automatisk registrering.\n\nTip: Lad bare appen være åben, så virker alt automatisk.';

  @override
  String get understood => 'Forstået';

  @override
  String get loginPrompt => 'Log ind for at begynde';

  @override
  String get loginSubtitle =>
      'Log ind med din Google-konto og konfigurer bil-API\'en';

  @override
  String get goToSettings => 'Gå til Indstillinger';

  @override
  String get carPlayConnected => 'CarPlay tilsluttet';

  @override
  String get offlineWarning => 'Offline - handlinger sættes i kø';

  @override
  String get recentTrips => 'Seneste ture';

  @override
  String get configureFirst => 'Konfigurer appen i Indstillinger først';

  @override
  String get noTripsYet => 'Ingen ture endnu';

  @override
  String routeLongerPercent(int percent) {
    return 'Rute +$percent% længere';
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
  String get distance => 'Afstand';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Erhverv';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Blandet';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Ruteafvigelse';

  @override
  String get car => 'Bil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Ruten er $percent% længere end forventet via Google Maps';
  }

  @override
  String get editTrip => 'Rediger tur';

  @override
  String get addTrip => 'Tilføj tur';

  @override
  String get dateAndTime => 'Dato & Tid';

  @override
  String get start => 'Start';

  @override
  String get end => 'Slut';

  @override
  String get fromPlaceholder => 'Fra';

  @override
  String get toPlaceholder => 'Til';

  @override
  String get distanceAndType => 'Afstand & Type';

  @override
  String get distanceKm => 'Afstand (km)';

  @override
  String get businessKm => 'Erhvervs-km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Gem';

  @override
  String get add => 'Tilføj';

  @override
  String get deleteTrip => 'Slet tur?';

  @override
  String get deleteTripConfirmation =>
      'Er du sikker på, at du vil slette denne tur?';

  @override
  String get cancel => 'Annuller';

  @override
  String get delete => 'Slet';

  @override
  String get somethingWentWrong => 'Noget gik galt';

  @override
  String get couldNotDelete => 'Kunne ikke slette';

  @override
  String get statistics => 'Statistik';

  @override
  String get trips => 'Ture';

  @override
  String get total => 'Total';

  @override
  String get business => 'Erhverv';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Logget ind';

  @override
  String get googleAccount => 'Google-konto';

  @override
  String get loginWithGoogle => 'Log ind med Google';

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
  String get manageVehicles => 'Administrer dine køretøjer';

  @override
  String get location => 'Placering';

  @override
  String get requestLocationPermission => 'Anmod om Placeringstilladelse';

  @override
  String get openIOSSettings => 'Åbn iOS-indstillinger';

  @override
  String get locationPermissionGranted => 'Placeringstilladelse givet!';

  @override
  String get locationPermissionDenied =>
      'Placeringstilladelse nægtet - gå til Indstillinger';

  @override
  String get enableLocationServices =>
      'Aktiver Placeringstjenester i iOS-indstillinger først';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatisk registrering';

  @override
  String get autoDetectionSubtitle =>
      'Start/stop ture automatisk ved CarPlay-tilslutning';

  @override
  String get carPlayIsConnected => 'CarPlay er tilsluttet';

  @override
  String get queue => 'Kø';

  @override
  String queueItems(int count) {
    return '$count elementer i køen';
  }

  @override
  String get queueSubtitle => 'Sendes når online';

  @override
  String get sendNow => 'Send nu';

  @override
  String get aboutApp => 'Om denne app';

  @override
  String get aboutDescription =>
      'Denne app erstatter iPhone Genveje-automatisering til kørebog. Den registrerer automatisk, når du sætter dig ind i bilen via Bluetooth/CarPlay og registrerer ture.';

  @override
  String loggedInAs(String email) {
    return 'Logget ind som $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fejl ved gemning: $error';
  }

  @override
  String get carSettingsSaved => 'Bilindstillinger gemt';

  @override
  String get enterUsernamePassword => 'Indtast brugernavn og adgangskode';

  @override
  String get cars => 'Biler';

  @override
  String get addCar => 'Tilføj bil';

  @override
  String get noCarsAdded => 'Ingen biler tilføjet endnu';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Rediger bil';

  @override
  String get name => 'Navn';

  @override
  String get nameHint => 'F.eks. Audi Q4 e-tron';

  @override
  String get enterName => 'Indtast et navn';

  @override
  String get brand => 'Mærke';

  @override
  String get color => 'Farve';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Standardbil';

  @override
  String get defaultCarSubtitle => 'Nye ture tilknyttes denne bil';

  @override
  String get bluetoothDevice => 'Bluetooth-enhed';

  @override
  String get autoSetOnConnect => 'Indstilles automatisk ved tilslutning';

  @override
  String get autoSetOnConnectFull =>
      'Indstilles automatisk ved tilslutning til CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Bil-API-forbindelse';

  @override
  String connectWithBrand(String brand) {
    return 'Tilslut til $brand for kilometertal og batteristatus';
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
  String get brandOther => 'Andet';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Varevogn';

  @override
  String get loginWithTesla => 'Log ind med Tesla';

  @override
  String get teslaLoginInfo =>
      'Du omdirigeres til Tesla for at logge ind. Derefter kan du se dine bildata.';

  @override
  String get usernameEmail => 'Brugernavn / E-mail';

  @override
  String get password => 'Adgangskode';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'DK';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Bil opdateret';

  @override
  String get carAdded => 'Bil tilføjet';

  @override
  String errorMessage(String error) {
    return 'Fejl: $error';
  }

  @override
  String get carDeleted => 'Bil slettet';

  @override
  String get deleteCar => 'Slet bil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Er du sikker på, at du vil slette \"$carName\"? Alle ture tilknyttet denne bil beholder deres data.';
  }

  @override
  String get apiSettingsSaved => 'API-indstillinger gemt';

  @override
  String get teslaAlreadyLinked => 'Tesla er allerede tilsluttet!';

  @override
  String get teslaLinked => 'Tesla tilsluttet!';

  @override
  String get teslaLinkFailed => 'Tesla-tilslutning mislykkedes';

  @override
  String get startTrip => 'Start Tur';

  @override
  String get stopTrip => 'Afslut Tur';

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
    return 'Opdateret: $time';
  }

  @override
  String get battery => 'Batteri';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Kilometertal';

  @override
  String get stateParked => 'Parkeret';

  @override
  String get stateDriving => 'Kører';

  @override
  String get stateCharging => 'Oplader';

  @override
  String get stateUnknown => 'Ukendt';

  @override
  String chargingPower(double power) {
    return 'Oplader: $power kW';
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
  String get addFirstCar => 'Tilføj din første bil';

  @override
  String get toTrackPerCar => 'For at spore ture pr. bil';

  @override
  String get selectCar => 'Vælg bil';

  @override
  String get manageCars => 'Administrer biler';

  @override
  String get unknownDevice => 'Ukendt enhed';

  @override
  String deviceName(String name) {
    return 'Enhed: $name';
  }

  @override
  String get linkToCar => 'Tilknyt til bil:';

  @override
  String get noCarsFound => 'Ingen biler fundet. Tilføj en bil først.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName tilknyttet $deviceName - Tur startet!';
  }

  @override
  String linkError(String error) {
    return 'Tilknytningsfejl: $error';
  }

  @override
  String get required => 'Påkrævet';

  @override
  String get invalidDistance => 'Ugyldig afstand';
}
