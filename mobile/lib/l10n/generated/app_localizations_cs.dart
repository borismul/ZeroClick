// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Kniha jízd';

  @override
  String get tabStatus => 'Stav';

  @override
  String get tabTrips => 'Jízdy';

  @override
  String get tabSettings => 'Nastavení';

  @override
  String get tabCharging => 'Nabíjení';

  @override
  String get chargingStations => 'nabíjecích stanic';

  @override
  String get logout => 'Odhlásit se';

  @override
  String get importantTitle => 'Důležité';

  @override
  String get backgroundWarningMessage =>
      'Tato aplikace automaticky detekuje, když nastoupíte do auta přes Bluetooth.\n\nFunguje to pouze když aplikace běží na pozadí. Pokud aplikaci zavřete (přejetím nahoru), automatická detekce přestane fungovat.\n\nTip: Nechte aplikaci otevřenou a vše bude fungovat automaticky.';

  @override
  String get understood => 'Rozumím';

  @override
  String get loginPrompt => 'Přihlaste se pro začátek';

  @override
  String get loginSubtitle =>
      'Přihlaste se účtem Google a nakonfigurujte API auta';

  @override
  String get goToSettings => 'Jít do Nastavení';

  @override
  String get carPlayConnected => 'CarPlay připojeno';

  @override
  String get offlineWarning => 'Offline - akce budou zařazeny do fronty';

  @override
  String get recentTrips => 'Nedávné jízdy';

  @override
  String get configureFirst => 'Nejprve nakonfigurujte aplikaci v Nastavení';

  @override
  String get noTripsYet => 'Zatím žádné jízdy';

  @override
  String routeLongerPercent(int percent) {
    return 'Trasa +$percent% delší';
  }

  @override
  String get route => 'Trasa';

  @override
  String get from => 'Odkud';

  @override
  String get to => 'Kam';

  @override
  String get details => 'Podrobnosti';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Čas';

  @override
  String get distance => 'Vzdálenost';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Pracovní';

  @override
  String get tripTypePrivate => 'Soukromá';

  @override
  String get tripTypeMixed => 'Smíšená';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Odchylka trasy';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Trasa je o $percent% delší než očekávaná podle Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Upravit jízdu';

  @override
  String get addTrip => 'Přidat jízdu';

  @override
  String get dateAndTime => 'Datum a čas';

  @override
  String get start => 'Start';

  @override
  String get end => 'Konec';

  @override
  String get fromPlaceholder => 'Odkud';

  @override
  String get toPlaceholder => 'Kam';

  @override
  String get distanceAndType => 'Vzdálenost a typ';

  @override
  String get distanceKm => 'Vzdálenost (km)';

  @override
  String get businessKm => 'Pracovní km';

  @override
  String get privateKm => 'Soukromé km';

  @override
  String get save => 'Uložit';

  @override
  String get add => 'Přidat';

  @override
  String get deleteTrip => 'Smazat jízdu?';

  @override
  String get deleteTripConfirmation => 'Opravdu chcete smazat tuto jízdu?';

  @override
  String get cancel => 'Zrušit';

  @override
  String get delete => 'Smazat';

  @override
  String get somethingWentWrong => 'Něco se pokazilo';

  @override
  String get couldNotDelete => 'Nepodařilo se smazat';

  @override
  String get statistics => 'Statistiky';

  @override
  String get trips => 'Jízdy';

  @override
  String get total => 'Celkem';

  @override
  String get business => 'Pracovní';

  @override
  String get private => 'Soukromé';

  @override
  String get account => 'Účet';

  @override
  String get loggedIn => 'Přihlášen';

  @override
  String get googleAccount => 'Účet Google';

  @override
  String get loginWithGoogle => 'Přihlásit se přes Google';

  @override
  String get myCars => 'Moje Auta';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aut',
      few: '$count auta',
      one: '1 auto',
      zero: '0 aut',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Spravujte svá vozidla';

  @override
  String get location => 'Poloha';

  @override
  String get requestLocationPermission => 'Požádat o Oprávnění k poloze';

  @override
  String get openIOSSettings => 'Otevřít nastavení iOS';

  @override
  String get locationPermissionGranted => 'Oprávnění k poloze uděleno!';

  @override
  String get locationPermissionDenied =>
      'Oprávnění k poloze zamítnuto - jděte do Nastavení';

  @override
  String get enableLocationServices =>
      'Nejprve povolte Polohové služby v nastavení iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatická detekce';

  @override
  String get autoDetectionSubtitle =>
      'Automaticky zahajovat/ukončovat jízdy při připojení CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay je připojeno';

  @override
  String get queue => 'Fronta';

  @override
  String queueItems(int count) {
    return '$count položek ve frontě';
  }

  @override
  String get queueSubtitle => 'Budou odeslány po připojení';

  @override
  String get sendNow => 'Odeslat nyní';

  @override
  String get aboutApp => 'O této aplikaci';

  @override
  String get aboutDescription =>
      'Tato aplikace nahrazuje automatizaci iPhone Zkratek pro knihu jízd. Automaticky detekuje, když nastoupíte do auta přes Bluetooth/CarPlay a zaznamenává jízdy.';

  @override
  String loggedInAs(String email) {
    return 'Přihlášen jako $email';
  }

  @override
  String errorSaving(String error) {
    return 'Chyba při ukládání: $error';
  }

  @override
  String get carSettingsSaved => 'Nastavení auta uloženo';

  @override
  String get enterUsernamePassword => 'Zadejte uživatelské jméno a heslo';

  @override
  String get cars => 'Auta';

  @override
  String get addCar => 'Přidat auto';

  @override
  String get noCarsAdded => 'Zatím žádná auta';

  @override
  String get defaultBadge => 'Výchozí';

  @override
  String get editCar => 'Upravit auto';

  @override
  String get name => 'Název';

  @override
  String get nameHint => 'Např. Audi Q4 e-tron';

  @override
  String get enterName => 'Zadejte název';

  @override
  String get brand => 'Značka';

  @override
  String get color => 'Barva';

  @override
  String get icon => 'Ikona';

  @override
  String get defaultCar => 'Výchozí auto';

  @override
  String get defaultCarSubtitle => 'Nové jízdy budou přiřazeny tomuto autu';

  @override
  String get bluetoothDevice => 'Bluetooth zařízení';

  @override
  String get autoSetOnConnect => 'Nastaví se automaticky při připojení';

  @override
  String get autoSetOnConnectFull =>
      'Nastaví se automaticky při připojení k CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'API připojení auta';

  @override
  String connectWithBrand(String brand) {
    return 'Připojte se k $brand pro tachometr a stav baterie';
  }

  @override
  String get brandAudi => 'Audi';

  @override
  String get brandVolkswagen => 'Volkswagen';

  @override
  String get brandSkoda => 'Škoda';

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
  String get brandOther => 'Ostatní';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Dodávka';

  @override
  String get loginWithTesla => 'Přihlásit se přes Tesla';

  @override
  String get teslaLoginInfo =>
      'Budete přesměrováni na Tesla pro přihlášení. Poté můžete zobrazit data svého auta.';

  @override
  String get usernameEmail => 'Uživatelské jméno / E-mail';

  @override
  String get password => 'Heslo';

  @override
  String get country => 'Země';

  @override
  String get countryHint => 'CZ';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Auto aktualizováno';

  @override
  String get carAdded => 'Auto přidáno';

  @override
  String errorMessage(String error) {
    return 'Chyba: $error';
  }

  @override
  String get carDeleted => 'Auto smazáno';

  @override
  String get deleteCar => 'Smazat auto?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Opravdu chcete smazat \"$carName\"? Všechny jízdy přiřazené tomuto autu si zachovají svá data.';
  }

  @override
  String get apiSettingsSaved => 'Nastavení API uloženo';

  @override
  String get teslaAlreadyLinked => 'Tesla je již propojena!';

  @override
  String get teslaLinked => 'Tesla propojena!';

  @override
  String get teslaLinkFailed => 'Propojení Tesla se nezdařilo';

  @override
  String get startTrip => 'Zahájit jízdu';

  @override
  String get stopTrip => 'Ukončit jízdu';

  @override
  String get gpsActiveTracking => 'GPS aktivní - automatické sledování';

  @override
  String get activeTrip => 'Aktivní jízda';

  @override
  String startedAt(String time) {
    return 'Zahájeno: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS bodů';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Aktualizováno: $time';
  }

  @override
  String get battery => 'Baterie';

  @override
  String get status => 'Stav';

  @override
  String get odometer => 'Tachometr';

  @override
  String get stateParked => 'Zaparkováno';

  @override
  String get stateDriving => 'Jede';

  @override
  String get stateCharging => 'Nabíjí se';

  @override
  String get stateUnknown => 'Neznámý';

  @override
  String chargingPower(double power) {
    return 'Nabíjení: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Hotovo za: $time';
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
  String get addFirstCar => 'Přidejte své první auto';

  @override
  String get toTrackPerCar => 'Pro sledování jízd podle auta';

  @override
  String get selectCar => 'Vyberte auto';

  @override
  String get manageCars => 'Spravovat auta';

  @override
  String get unknownDevice => 'Neznámé zařízení';

  @override
  String deviceName(String name) {
    return 'Zařízení: $name';
  }

  @override
  String get linkToCar => 'Propojit s autem:';

  @override
  String get noCarsFound => 'Žádná auta nenalezena. Nejprve přidejte auto.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName propojeno s $deviceName - Jízda zahájena!';
  }

  @override
  String linkError(String error) {
    return 'Chyba propojení: $error';
  }

  @override
  String get required => 'Povinné';

  @override
  String get invalidDistance => 'Neplatná vzdálenost';

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
}
