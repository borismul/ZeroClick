// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'Kilométer Napló';

  @override
  String get tabStatus => 'Állapot';

  @override
  String get tabTrips => 'Utak';

  @override
  String get tabSettings => 'Beállítások';

  @override
  String get logout => 'Kijelentkezés';

  @override
  String get importantTitle => 'Fontos';

  @override
  String get backgroundWarningMessage =>
      'Ez az alkalmazás automatikusan érzékeli, amikor beülsz az autóba Bluetooth-on keresztül.\n\nEz csak akkor működik, ha az alkalmazás a háttérben fut. Ha bezárod az alkalmazást (felfelé húzás), az automatikus érzékelés leáll.\n\nTipp: Hagyd nyitva az alkalmazást, és minden automatikusan működik.';

  @override
  String get understood => 'Értem';

  @override
  String get loginPrompt => 'Jelentkezz be a kezdéshez';

  @override
  String get loginSubtitle =>
      'Jelentkezz be Google-fiókkal és állítsd be az autó API-t';

  @override
  String get goToSettings => 'Beállítások';

  @override
  String get carPlayConnected => 'CarPlay csatlakoztatva';

  @override
  String get offlineWarning => 'Offline - műveletek sorba állítva';

  @override
  String get recentTrips => 'Legutóbbi utak';

  @override
  String get configureFirst =>
      'Először állítsd be az alkalmazást a Beállításokban';

  @override
  String get noTripsYet => 'Még nincsenek utak';

  @override
  String routeLongerPercent(int percent) {
    return 'Útvonal +$percent% hosszabb';
  }

  @override
  String get route => 'Útvonal';

  @override
  String get from => 'Honnan';

  @override
  String get to => 'Hová';

  @override
  String get details => 'Részletek';

  @override
  String get date => 'Dátum';

  @override
  String get time => 'Idő';

  @override
  String get distance => 'Távolság';

  @override
  String get type => 'Típus';

  @override
  String get tripTypeBusiness => 'Üzleti';

  @override
  String get tripTypePrivate => 'Magán';

  @override
  String get tripTypeMixed => 'Vegyes';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Útvonal eltérés';

  @override
  String get car => 'Autó';

  @override
  String routeDeviationWarning(int percent) {
    return 'Az útvonal $percent%-kal hosszabb a Google Maps által vártnál';
  }

  @override
  String get editTrip => 'Út szerkesztése';

  @override
  String get addTrip => 'Út hozzáadása';

  @override
  String get dateAndTime => 'Dátum és idő';

  @override
  String get start => 'Kezdés';

  @override
  String get end => 'Befejezés';

  @override
  String get fromPlaceholder => 'Honnan';

  @override
  String get toPlaceholder => 'Hová';

  @override
  String get distanceAndType => 'Távolság és típus';

  @override
  String get distanceKm => 'Távolság (km)';

  @override
  String get businessKm => 'Üzleti km';

  @override
  String get privateKm => 'Magán km';

  @override
  String get save => 'Mentés';

  @override
  String get add => 'Hozzáadás';

  @override
  String get deleteTrip => 'Út törlése?';

  @override
  String get deleteTripConfirmation =>
      'Biztosan törölni szeretnéd ezt az utat?';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get somethingWentWrong => 'Valami hiba történt';

  @override
  String get couldNotDelete => 'Nem sikerült törölni';

  @override
  String get statistics => 'Statisztikák';

  @override
  String get trips => 'Utak';

  @override
  String get total => 'Összesen';

  @override
  String get business => 'Üzleti';

  @override
  String get private => 'Magán';

  @override
  String get account => 'Fiók';

  @override
  String get loggedIn => 'Bejelentkezve';

  @override
  String get googleAccount => 'Google fiók';

  @override
  String get loginWithGoogle => 'Bejelentkezés Google-lal';

  @override
  String get myCars => 'Autóim';

  @override
  String carsCount(int count) {
    return '$count autó';
  }

  @override
  String get manageVehicles => 'Járműveid kezelése';

  @override
  String get location => 'Helyzet';

  @override
  String get requestLocationPermission => 'Helymeghatározási engedély kérése';

  @override
  String get openIOSSettings => 'iOS Beállítások megnyitása';

  @override
  String get locationPermissionGranted => 'Helymeghatározási engedély megadva!';

  @override
  String get locationPermissionDenied =>
      'Helymeghatározási engedély megtagadva - menj a Beállításokba';

  @override
  String get enableLocationServices =>
      'Először engedélyezd a Helymeghatározást az iOS Beállításokban';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatikus érzékelés';

  @override
  String get autoDetectionSubtitle =>
      'Utak automatikus indítása/leállítása CarPlay csatlakozáskor';

  @override
  String get carPlayIsConnected => 'CarPlay csatlakoztatva';

  @override
  String get queue => 'Sor';

  @override
  String queueItems(int count) {
    return '$count elem a sorban';
  }

  @override
  String get queueSubtitle => 'Online állapotban küldésre kerül';

  @override
  String get sendNow => 'Küldés most';

  @override
  String get aboutApp => 'Az alkalmazásról';

  @override
  String get aboutDescription =>
      'Ez az alkalmazás helyettesíti az iPhone Parancsok automatizálását a kilométer naplózáshoz. Automatikusan érzékeli, amikor beülsz az autóba Bluetooth/CarPlay-en keresztül és rögzíti az utakat.';

  @override
  String loggedInAs(String email) {
    return 'Bejelentkezve: $email';
  }

  @override
  String errorSaving(String error) {
    return 'Mentési hiba: $error';
  }

  @override
  String get carSettingsSaved => 'Autó beállítások mentve';

  @override
  String get enterUsernamePassword => 'Add meg a felhasználónevet és jelszót';

  @override
  String get cars => 'Autók';

  @override
  String get addCar => 'Autó hozzáadása';

  @override
  String get noCarsAdded => 'Még nincsenek autók';

  @override
  String get defaultBadge => 'Alapértelmezett';

  @override
  String get editCar => 'Autó szerkesztése';

  @override
  String get name => 'Név';

  @override
  String get nameHint => 'Pl. Audi Q4 e-tron';

  @override
  String get enterName => 'Adj meg egy nevet';

  @override
  String get brand => 'Márka';

  @override
  String get color => 'Szín';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Alapértelmezett autó';

  @override
  String get defaultCarSubtitle => 'Új utak ehhez az autóhoz lesznek kapcsolva';

  @override
  String get bluetoothDevice => 'Bluetooth eszköz';

  @override
  String get autoSetOnConnect => 'Automatikusan beállítva csatlakozáskor';

  @override
  String get autoSetOnConnectFull =>
      'Automatikusan beállítva CarPlay/Bluetooth csatlakozáskor';

  @override
  String get carApiConnection => 'Autó API kapcsolat';

  @override
  String connectWithBrand(String brand) {
    return 'Csatlakozz a $brand-hoz kilométeróra és akkumulátor állapotért';
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
  String get brandOther => 'Egyéb';

  @override
  String get iconSedan => 'Szedán';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Ferdehátú';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Furgon';

  @override
  String get loginWithTesla => 'Bejelentkezés Tesla-val';

  @override
  String get teslaLoginInfo =>
      'Átirányítunk a Tesla-hoz a bejelentkezéshez. Ezután megtekintheted az autó adatait.';

  @override
  String get usernameEmail => 'Felhasználónév / E-mail';

  @override
  String get password => 'Jelszó';

  @override
  String get country => 'Ország';

  @override
  String get countryHint => 'HU';

  @override
  String get testApi => 'API teszt';

  @override
  String get carUpdated => 'Autó frissítve';

  @override
  String get carAdded => 'Autó hozzáadva';

  @override
  String errorMessage(String error) {
    return 'Hiba: $error';
  }

  @override
  String get carDeleted => 'Autó törölve';

  @override
  String get deleteCar => 'Autó törlése?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Biztosan törölni szeretnéd a \"$carName\" autót? Az ehhez az autóhoz kapcsolt összes út megtartja adatait.';
  }

  @override
  String get apiSettingsSaved => 'API beállítások mentve';

  @override
  String get teslaAlreadyLinked => 'Tesla már csatlakoztatva!';

  @override
  String get teslaLinked => 'Tesla csatlakoztatva!';

  @override
  String get teslaLinkFailed => 'Tesla csatlakozás sikertelen';

  @override
  String get startTrip => 'Út indítása';

  @override
  String get stopTrip => 'Út befejezése';

  @override
  String get gpsActiveTracking => 'GPS aktív - automatikus követés';

  @override
  String get activeTrip => 'Aktív út';

  @override
  String startedAt(String time) {
    return 'Kezdés: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS pont';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Frissítve: $time';
  }

  @override
  String get battery => 'Akkumulátor';

  @override
  String get status => 'Állapot';

  @override
  String get odometer => 'Kilométeróra';

  @override
  String get stateParked => 'Parkolva';

  @override
  String get stateDriving => 'Vezetés';

  @override
  String get stateCharging => 'Töltés';

  @override
  String get stateUnknown => 'Ismeretlen';

  @override
  String chargingPower(double power) {
    return 'Töltés: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Kész: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes perc';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursó ${minutes}p';
  }

  @override
  String get addFirstCar => 'Add hozzá az első autódat';

  @override
  String get toTrackPerCar => 'Utak követéséhez autónként';

  @override
  String get selectCar => 'Autó kiválasztása';

  @override
  String get manageCars => 'Autók kezelése';

  @override
  String get unknownDevice => 'Ismeretlen eszköz';

  @override
  String deviceName(String name) {
    return 'Eszköz: $name';
  }

  @override
  String get linkToCar => 'Kapcsolás autóhoz:';

  @override
  String get noCarsFound => 'Nincs autó. Először adj hozzá egy autót.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName kapcsolva: $deviceName - Út elindítva!';
  }

  @override
  String linkError(String error) {
    return 'Kapcsolási hiba: $error';
  }

  @override
  String get required => 'Kötelező';

  @override
  String get invalidDistance => 'Érvénytelen távolság';
}
