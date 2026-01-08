// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Rejestr Kilometrów';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Podróże';

  @override
  String get tabSettings => 'Ustawienia';

  @override
  String get logout => 'Wyloguj';

  @override
  String get importantTitle => 'Ważne';

  @override
  String get backgroundWarningMessage =>
      'Ta aplikacja automatycznie wykrywa, kiedy wsiadasz do samochodu przez Bluetooth.\n\nDziała to tylko, gdy aplikacja działa w tle. Jeśli zamkniesz aplikację (przesunięcie w górę), automatyczne wykrywanie przestanie działać.\n\nWskazówka: Po prostu zostaw aplikację otwartą, a wszystko będzie działać automatycznie.';

  @override
  String get understood => 'Rozumiem';

  @override
  String get loginPrompt => 'Zaloguj się, aby rozpocząć';

  @override
  String get loginSubtitle =>
      'Zaloguj się kontem Google i skonfiguruj API samochodu';

  @override
  String get goToSettings => 'Przejdź do Ustawień';

  @override
  String get carPlayConnected => 'CarPlay połączony';

  @override
  String get offlineWarning => 'Offline - akcje zostaną dodane do kolejki';

  @override
  String get recentTrips => 'Ostatnie podróże';

  @override
  String get configureFirst => 'Najpierw skonfiguruj aplikację w Ustawieniach';

  @override
  String get noTripsYet => 'Brak podróży';

  @override
  String routeLongerPercent(int percent) {
    return 'Trasa +$percent% dłuższa';
  }

  @override
  String get route => 'Trasa';

  @override
  String get from => 'Z';

  @override
  String get to => 'Do';

  @override
  String get details => 'Szczegóły';

  @override
  String get date => 'Data';

  @override
  String get time => 'Czas';

  @override
  String get distance => 'Odległość';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Służbowy';

  @override
  String get tripTypePrivate => 'Prywatny';

  @override
  String get tripTypeMixed => 'Mieszany';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Odchylenie trasy';

  @override
  String get car => 'Samochód';

  @override
  String routeDeviationWarning(int percent) {
    return 'Trasa jest $percent% dłuższa niż oczekiwano według Google Maps';
  }

  @override
  String get editTrip => 'Edytuj podróż';

  @override
  String get addTrip => 'Dodaj podróż';

  @override
  String get dateAndTime => 'Data i Czas';

  @override
  String get start => 'Start';

  @override
  String get end => 'Koniec';

  @override
  String get fromPlaceholder => 'Z';

  @override
  String get toPlaceholder => 'Do';

  @override
  String get distanceAndType => 'Odległość i Typ';

  @override
  String get distanceKm => 'Odległość (km)';

  @override
  String get businessKm => 'Km służbowe';

  @override
  String get privateKm => 'Km prywatne';

  @override
  String get save => 'Zapisz';

  @override
  String get add => 'Dodaj';

  @override
  String get deleteTrip => 'Usunąć podróż?';

  @override
  String get deleteTripConfirmation => 'Czy na pewno chcesz usunąć tę podróż?';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get somethingWentWrong => 'Coś poszło nie tak';

  @override
  String get couldNotDelete => 'Nie można usunąć';

  @override
  String get statistics => 'Statystyki';

  @override
  String get trips => 'Podróże';

  @override
  String get total => 'Razem';

  @override
  String get business => 'Służbowe';

  @override
  String get private => 'Prywatne';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Zalogowano';

  @override
  String get googleAccount => 'Konto Google';

  @override
  String get loginWithGoogle => 'Zaloguj przez Google';

  @override
  String get myCars => 'Moje Samochody';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count samochodów',
      few: '$count samochody',
      one: '1 samochód',
      zero: '0 samochodów',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Zarządzaj swoimi pojazdami';

  @override
  String get location => 'Lokalizacja';

  @override
  String get requestLocationPermission => 'Poproś o Uprawnienia Lokalizacji';

  @override
  String get openIOSSettings => 'Otwórz Ustawienia iOS';

  @override
  String get locationPermissionGranted => 'Uprawnienie lokalizacji przyznane!';

  @override
  String get locationPermissionDenied =>
      'Uprawnienie lokalizacji odrzucone - przejdź do Ustawień';

  @override
  String get enableLocationServices =>
      'Najpierw włącz Usługi lokalizacji w Ustawieniach iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatyczne wykrywanie';

  @override
  String get autoDetectionSubtitle =>
      'Rozpoczynaj/kończ podróże automatycznie przy połączeniu CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay jest połączony';

  @override
  String get queue => 'Kolejka';

  @override
  String queueItems(int count) {
    return '$count elementów w kolejce';
  }

  @override
  String get queueSubtitle => 'Zostaną wysłane po połączeniu';

  @override
  String get sendNow => 'Wyślij teraz';

  @override
  String get aboutApp => 'O tej aplikacji';

  @override
  String get aboutDescription =>
      'Ta aplikacja zastępuje automatyzację Skrótów iPhone\'a do rejestracji kilometrów. Automatycznie wykrywa, kiedy wsiadasz do samochodu przez Bluetooth/CarPlay i rejestruje podróże.';

  @override
  String loggedInAs(String email) {
    return 'Zalogowano jako $email';
  }

  @override
  String errorSaving(String error) {
    return 'Błąd zapisu: $error';
  }

  @override
  String get carSettingsSaved => 'Ustawienia samochodu zapisane';

  @override
  String get enterUsernamePassword => 'Wprowadź nazwę użytkownika i hasło';

  @override
  String get cars => 'Samochody';

  @override
  String get addCar => 'Dodaj samochód';

  @override
  String get noCarsAdded => 'Brak dodanych samochodów';

  @override
  String get defaultBadge => 'Domyślny';

  @override
  String get editCar => 'Edytuj samochód';

  @override
  String get name => 'Nazwa';

  @override
  String get nameHint => 'Np. Audi Q4 e-tron';

  @override
  String get enterName => 'Wprowadź nazwę';

  @override
  String get brand => 'Marka';

  @override
  String get color => 'Kolor';

  @override
  String get icon => 'Ikona';

  @override
  String get defaultCar => 'Domyślny samochód';

  @override
  String get defaultCarSubtitle =>
      'Nowe podróże będą przypisywane do tego samochodu';

  @override
  String get bluetoothDevice => 'Urządzenie Bluetooth';

  @override
  String get autoSetOnConnect =>
      'Zostanie ustawione automatycznie przy połączeniu';

  @override
  String get autoSetOnConnectFull =>
      'Zostanie ustawione automatycznie przy połączeniu z CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Połączenie API Samochodu';

  @override
  String connectWithBrand(String brand) {
    return 'Połącz z $brand dla przebiegu i stanu baterii';
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
  String get brandOther => 'Inny';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sportowy';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Zaloguj przez Tesla';

  @override
  String get teslaLoginInfo =>
      'Zostaniesz przekierowany do Tesla, aby się zalogować. Potem możesz zobaczyć dane swojego samochodu.';

  @override
  String get usernameEmail => 'Nazwa użytkownika / Email';

  @override
  String get password => 'Hasło';

  @override
  String get country => 'Kraj';

  @override
  String get countryHint => 'PL';

  @override
  String get testApi => 'Testuj API';

  @override
  String get carUpdated => 'Samochód zaktualizowany';

  @override
  String get carAdded => 'Samochód dodany';

  @override
  String errorMessage(String error) {
    return 'Błąd: $error';
  }

  @override
  String get carDeleted => 'Samochód usunięty';

  @override
  String get deleteCar => 'Usunąć samochód?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Czy na pewno chcesz usunąć \"$carName\"? Wszystkie podróże przypisane do tego samochodu zachowają swoje dane.';
  }

  @override
  String get apiSettingsSaved => 'Ustawienia API zapisane';

  @override
  String get teslaAlreadyLinked => 'Tesla jest już połączona!';

  @override
  String get teslaLinked => 'Tesla połączona!';

  @override
  String get teslaLinkFailed => 'Połączenie z Tesla nie powiodło się';

  @override
  String get startTrip => 'Rozpocznij Podróż';

  @override
  String get stopTrip => 'Zakończ Podróż';

  @override
  String get gpsActiveTracking => 'GPS aktywny - automatyczne śledzenie';

  @override
  String get activeTrip => 'Aktywna podróż';

  @override
  String startedAt(String time) {
    return 'Rozpoczęto: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count punktów GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Zaktualizowano: $time';
  }

  @override
  String get battery => 'Bateria';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Przebieg';

  @override
  String get stateParked => 'Zaparkowany';

  @override
  String get stateDriving => 'W ruchu';

  @override
  String get stateCharging => 'Ładowanie';

  @override
  String get stateUnknown => 'Nieznany';

  @override
  String chargingPower(double power) {
    return 'Ładowanie: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Gotowy za: $time';
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
  String get addFirstCar => 'Dodaj swój pierwszy samochód';

  @override
  String get toTrackPerCar => 'Aby śledzić podróże dla każdego samochodu';

  @override
  String get selectCar => 'Wybierz samochód';

  @override
  String get manageCars => 'Zarządzaj samochodami';

  @override
  String get unknownDevice => 'Nieznane urządzenie';

  @override
  String deviceName(String name) {
    return 'Urządzenie: $name';
  }

  @override
  String get linkToCar => 'Przypisz do samochodu:';

  @override
  String get noCarsFound =>
      'Nie znaleziono samochodów. Najpierw dodaj samochód.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName przypisany do $deviceName - Podróż rozpoczęta!';
  }

  @override
  String linkError(String error) {
    return 'Błąd przypisania: $error';
  }

  @override
  String get required => 'Wymagane';

  @override
  String get invalidDistance => 'Nieprawidłowa odległość';
}
