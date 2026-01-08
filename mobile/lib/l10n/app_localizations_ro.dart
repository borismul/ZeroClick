// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Jurnal Kilometri';

  @override
  String get tabStatus => 'Stare';

  @override
  String get tabTrips => 'Călătorii';

  @override
  String get tabSettings => 'Setări';

  @override
  String get logout => 'Deconectare';

  @override
  String get importantTitle => 'Important';

  @override
  String get backgroundWarningMessage =>
      'Această aplicație detectează automat când urci în mașină prin Bluetooth.\n\nAceasta funcționează doar dacă aplicația rulează în fundal. Dacă închizi aplicația (glisează în sus), detectarea automată va înceta.\n\nSfat: Lasă aplicația deschisă și totul va funcționa automat.';

  @override
  String get understood => 'Am înțeles';

  @override
  String get loginPrompt => 'Conectează-te pentru a începe';

  @override
  String get loginSubtitle =>
      'Conectează-te cu contul Google și configurează API-ul mașinii';

  @override
  String get goToSettings => 'Mergi la Setări';

  @override
  String get carPlayConnected => 'CarPlay conectat';

  @override
  String get offlineWarning => 'Offline - acțiunile vor fi puse în coadă';

  @override
  String get recentTrips => 'Călătorii recente';

  @override
  String get configureFirst => 'Configurează mai întâi aplicația în Setări';

  @override
  String get noTripsYet => 'Încă nu există călătorii';

  @override
  String routeLongerPercent(int percent) {
    return 'Traseu +$percent% mai lung';
  }

  @override
  String get route => 'Traseu';

  @override
  String get from => 'De la';

  @override
  String get to => 'La';

  @override
  String get details => 'Detalii';

  @override
  String get date => 'Data';

  @override
  String get time => 'Ora';

  @override
  String get distance => 'Distanță';

  @override
  String get type => 'Tip';

  @override
  String get tripTypeBusiness => 'Serviciu';

  @override
  String get tripTypePrivate => 'Personal';

  @override
  String get tripTypeMixed => 'Mixt';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Deviație traseu';

  @override
  String get car => 'Mașină';

  @override
  String routeDeviationWarning(int percent) {
    return 'Traseul este cu $percent% mai lung decât se aștepta prin Google Maps';
  }

  @override
  String get editTrip => 'Editare călătorie';

  @override
  String get addTrip => 'Adaugă călătorie';

  @override
  String get dateAndTime => 'Data și Ora';

  @override
  String get start => 'Start';

  @override
  String get end => 'Sfârșit';

  @override
  String get fromPlaceholder => 'De la';

  @override
  String get toPlaceholder => 'La';

  @override
  String get distanceAndType => 'Distanță și Tip';

  @override
  String get distanceKm => 'Distanță (km)';

  @override
  String get businessKm => 'Km serviciu';

  @override
  String get privateKm => 'Km personal';

  @override
  String get save => 'Salvează';

  @override
  String get add => 'Adaugă';

  @override
  String get deleteTrip => 'Șterge călătoria?';

  @override
  String get deleteTripConfirmation =>
      'Ești sigur că vrei să ștergi această călătorie?';

  @override
  String get cancel => 'Anulează';

  @override
  String get delete => 'Șterge';

  @override
  String get somethingWentWrong => 'Ceva nu a mers bine';

  @override
  String get couldNotDelete => 'Nu s-a putut șterge';

  @override
  String get statistics => 'Statistici';

  @override
  String get trips => 'Călătorii';

  @override
  String get total => 'Total';

  @override
  String get business => 'Serviciu';

  @override
  String get private => 'Personal';

  @override
  String get account => 'Cont';

  @override
  String get loggedIn => 'Conectat';

  @override
  String get googleAccount => 'Cont Google';

  @override
  String get loginWithGoogle => 'Conectare cu Google';

  @override
  String get myCars => 'Mașinile Mele';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mașini',
      few: '$count mașini',
      one: '1 mașină',
      zero: '0 mașini',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Administrează vehiculele tale';

  @override
  String get location => 'Locație';

  @override
  String get requestLocationPermission => 'Solicită Permisiune Locație';

  @override
  String get openIOSSettings => 'Deschide Setări iOS';

  @override
  String get locationPermissionGranted => 'Permisiune locație acordată!';

  @override
  String get locationPermissionDenied =>
      'Permisiune locație refuzată - mergi la Setări';

  @override
  String get enableLocationServices =>
      'Activează mai întâi Serviciile de Localizare în Setări iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Detectare automată';

  @override
  String get autoDetectionSubtitle =>
      'Pornește/oprește automat călătoriile la conectarea CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay este conectat';

  @override
  String get queue => 'Coadă';

  @override
  String queueItems(int count) {
    return '$count elemente în coadă';
  }

  @override
  String get queueSubtitle => 'Vor fi trimise când ești online';

  @override
  String get sendNow => 'Trimite acum';

  @override
  String get aboutApp => 'Despre această aplicație';

  @override
  String get aboutDescription =>
      'Această aplicație înlocuiește automatizarea Comenzi Rapide iPhone pentru jurnal kilometri. Detectează automat când urci în mașină prin Bluetooth/CarPlay și înregistrează călătoriile.';

  @override
  String loggedInAs(String email) {
    return 'Conectat ca $email';
  }

  @override
  String errorSaving(String error) {
    return 'Eroare la salvare: $error';
  }

  @override
  String get carSettingsSaved => 'Setări mașină salvate';

  @override
  String get enterUsernamePassword => 'Introdu numele de utilizator și parola';

  @override
  String get cars => 'Mașini';

  @override
  String get addCar => 'Adaugă mașină';

  @override
  String get noCarsAdded => 'Nu există mașini adăugate';

  @override
  String get defaultBadge => 'Implicit';

  @override
  String get editCar => 'Editare mașină';

  @override
  String get name => 'Nume';

  @override
  String get nameHint => 'Ex. Audi Q4 e-tron';

  @override
  String get enterName => 'Introdu un nume';

  @override
  String get brand => 'Marcă';

  @override
  String get color => 'Culoare';

  @override
  String get icon => 'Pictogramă';

  @override
  String get defaultCar => 'Mașină implicită';

  @override
  String get defaultCarSubtitle =>
      'Călătoriile noi vor fi asociate acestei mașini';

  @override
  String get bluetoothDevice => 'Dispozitiv Bluetooth';

  @override
  String get autoSetOnConnect => 'Va fi setat automat la conectare';

  @override
  String get autoSetOnConnectFull =>
      'Va fi setat automat la conectarea CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Conexiune API Mașină';

  @override
  String connectWithBrand(String brand) {
    return 'Conectează-te la $brand pentru kilometraj și stare baterie';
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
  String get brandOther => 'Altele';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Dubă';

  @override
  String get loginWithTesla => 'Conectare cu Tesla';

  @override
  String get teslaLoginInfo =>
      'Vei fi redirecționat către Tesla pentru autentificare. Apoi poți vedea datele mașinii.';

  @override
  String get usernameEmail => 'Nume utilizator / Email';

  @override
  String get password => 'Parolă';

  @override
  String get country => 'Țară';

  @override
  String get countryHint => 'RO';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Mașină actualizată';

  @override
  String get carAdded => 'Mașină adăugată';

  @override
  String errorMessage(String error) {
    return 'Eroare: $error';
  }

  @override
  String get carDeleted => 'Mașină ștearsă';

  @override
  String get deleteCar => 'Șterge mașina?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Ești sigur că vrei să ștergi \"$carName\"? Toate călătoriile asociate acestei mașini își vor păstra datele.';
  }

  @override
  String get apiSettingsSaved => 'Setări API salvate';

  @override
  String get teslaAlreadyLinked => 'Tesla este deja conectată!';

  @override
  String get teslaLinked => 'Tesla conectată!';

  @override
  String get teslaLinkFailed => 'Conectare Tesla eșuată';

  @override
  String get startTrip => 'Începe Călătoria';

  @override
  String get stopTrip => 'Termină Călătoria';

  @override
  String get gpsActiveTracking => 'GPS activ - urmărire automată';

  @override
  String get activeTrip => 'Călătorie activă';

  @override
  String startedAt(String time) {
    return 'Început: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count puncte GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Actualizat: $time';
  }

  @override
  String get battery => 'Baterie';

  @override
  String get status => 'Stare';

  @override
  String get odometer => 'Kilometraj';

  @override
  String get stateParked => 'Parcat';

  @override
  String get stateDriving => 'În mișcare';

  @override
  String get stateCharging => 'Se încarcă';

  @override
  String get stateUnknown => 'Necunoscut';

  @override
  String chargingPower(double power) {
    return 'Încărcare: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Gata în: $time';
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
  String get addFirstCar => 'Adaugă prima ta mașină';

  @override
  String get toTrackPerCar => 'Pentru a urmări călătoriile per mașină';

  @override
  String get selectCar => 'Selectează mașina';

  @override
  String get manageCars => 'Administrează mașinile';

  @override
  String get unknownDevice => 'Dispozitiv necunoscut';

  @override
  String deviceName(String name) {
    return 'Dispozitiv: $name';
  }

  @override
  String get linkToCar => 'Asociază cu mașina:';

  @override
  String get noCarsFound => 'Nu s-au găsit mașini. Adaugă mai întâi o mașină.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName asociat cu $deviceName - Călătorie începută!';
  }

  @override
  String linkError(String error) {
    return 'Eroare la asociere: $error';
  }

  @override
  String get required => 'Obligatoriu';

  @override
  String get invalidDistance => 'Distanță invalidă';
}
