// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Körjournal';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Resor';

  @override
  String get tabSettings => 'Inställningar';

  @override
  String get tabCharging => 'Laddning';

  @override
  String get chargingStations => 'laddstationer';

  @override
  String get logout => 'Logga ut';

  @override
  String get importantTitle => 'Viktigt';

  @override
  String get backgroundWarningMessage =>
      'Denna app upptäcker automatiskt när du sätter dig i bilen via Bluetooth.\n\nDetta fungerar endast om appen körs i bakgrunden. Om du stänger appen (svep uppåt) slutar automatisk upptäckt att fungera.\n\nTips: Låt appen vara öppen så fungerar allt automatiskt.';

  @override
  String get understood => 'Uppfattat';

  @override
  String get loginPrompt => 'Logga in för att börja';

  @override
  String get loginSubtitle =>
      'Logga in med ditt Google-konto och konfigurera bil-API:et';

  @override
  String get goToSettings => 'Gå till Inställningar';

  @override
  String get carPlayConnected => 'CarPlay ansluten';

  @override
  String get offlineWarning => 'Offline - åtgärder köas';

  @override
  String get recentTrips => 'Senaste resor';

  @override
  String get configureFirst => 'Konfigurera appen i Inställningar först';

  @override
  String get noTripsYet => 'Inga resor ännu';

  @override
  String routeLongerPercent(int percent) {
    return 'Rutt +$percent% längre';
  }

  @override
  String get route => 'Rutt';

  @override
  String get from => 'Från';

  @override
  String get to => 'Till';

  @override
  String get details => 'Detaljer';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Tid';

  @override
  String get distance => 'Avstånd';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Tjänst';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Blandat';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Ruttavvikelse';

  @override
  String get car => 'Bil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Rutten är $percent% längre än förväntat enligt Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Redigera resa';

  @override
  String get addTrip => 'Lägg till resa';

  @override
  String get dateAndTime => 'Datum & Tid';

  @override
  String get start => 'Start';

  @override
  String get end => 'Slut';

  @override
  String get fromPlaceholder => 'Från';

  @override
  String get toPlaceholder => 'Till';

  @override
  String get distanceAndType => 'Avstånd & Typ';

  @override
  String get distanceKm => 'Avstånd (km)';

  @override
  String get businessKm => 'Tjänste-km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Spara';

  @override
  String get add => 'Lägg till';

  @override
  String get deleteTrip => 'Ta bort resa?';

  @override
  String get deleteTripConfirmation =>
      'Är du säker på att du vill ta bort denna resa?';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Ta bort';

  @override
  String get somethingWentWrong => 'Något gick fel';

  @override
  String get couldNotDelete => 'Kunde inte ta bort';

  @override
  String get statistics => 'Statistik';

  @override
  String get trips => 'Resor';

  @override
  String get total => 'Totalt';

  @override
  String get business => 'Tjänst';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Inloggad';

  @override
  String get googleAccount => 'Google-konto';

  @override
  String get loginWithGoogle => 'Logga in med Google';

  @override
  String get myCars => 'Mina Bilar';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bilar',
      one: '1 bil',
      zero: '0 bilar',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Hantera dina fordon';

  @override
  String get location => 'Plats';

  @override
  String get requestLocationPermission => 'Begär Platsbehörighet';

  @override
  String get openIOSSettings => 'Öppna iOS-inställningar';

  @override
  String get locationPermissionGranted => 'Platsbehörighet beviljad!';

  @override
  String get locationPermissionDenied =>
      'Platsbehörighet nekad - gå till Inställningar';

  @override
  String get enableLocationServices =>
      'Aktivera Platstjänster i iOS-inställningar först';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatisk upptäckt';

  @override
  String get autoDetectionSubtitle =>
      'Starta/stoppa resor automatiskt vid CarPlay-anslutning';

  @override
  String get carPlayIsConnected => 'CarPlay är ansluten';

  @override
  String get queue => 'Kö';

  @override
  String queueItems(int count) {
    return '$count objekt i kön';
  }

  @override
  String get queueSubtitle => 'Skickas när online';

  @override
  String get sendNow => 'Skicka nu';

  @override
  String get aboutApp => 'Om denna app';

  @override
  String get aboutDescription =>
      'Denna app ersätter iPhone Genvägar-automatisering för körjournal. Den upptäcker automatiskt när du sätter dig i bilen via Bluetooth/CarPlay och registrerar resor.';

  @override
  String loggedInAs(String email) {
    return 'Inloggad som $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fel vid sparande: $error';
  }

  @override
  String get carSettingsSaved => 'Bilinställningar sparade';

  @override
  String get enterUsernamePassword => 'Ange användarnamn och lösenord';

  @override
  String get cars => 'Bilar';

  @override
  String get addCar => 'Lägg till bil';

  @override
  String get noCarsAdded => 'Inga bilar tillagda ännu';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Redigera bil';

  @override
  String get name => 'Namn';

  @override
  String get nameHint => 'T.ex. Audi Q4 e-tron';

  @override
  String get enterName => 'Ange ett namn';

  @override
  String get brand => 'Märke';

  @override
  String get color => 'Färg';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Standardbil';

  @override
  String get defaultCarSubtitle => 'Nya resor kopplas till denna bil';

  @override
  String get bluetoothDevice => 'Bluetooth-enhet';

  @override
  String get autoSetOnConnect => 'Ställs in automatiskt vid anslutning';

  @override
  String get autoSetOnConnectFull =>
      'Ställs in automatiskt vid anslutning till CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Bil-API-anslutning';

  @override
  String connectWithBrand(String brand) {
    return 'Anslut till $brand för mätarställning och batteristatus';
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
  String get brandOther => 'Övrig';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Halvkombi';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Skåpbil';

  @override
  String get loginWithTesla => 'Logga in med Tesla';

  @override
  String get teslaLoginInfo =>
      'Du omdirigeras till Tesla för att logga in. Sedan kan du se din bildata.';

  @override
  String get usernameEmail => 'Användarnamn / E-post';

  @override
  String get password => 'Lösenord';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'SE';

  @override
  String get testApi => 'Testa API';

  @override
  String get carUpdated => 'Bil uppdaterad';

  @override
  String get carAdded => 'Bil tillagd';

  @override
  String errorMessage(String error) {
    return 'Fel: $error';
  }

  @override
  String get carDeleted => 'Bil borttagen';

  @override
  String get deleteCar => 'Ta bort bil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Är du säker på att du vill ta bort \"$carName\"? Alla resor kopplade till denna bil behåller sin data.';
  }

  @override
  String get apiSettingsSaved => 'API-inställningar sparade';

  @override
  String get teslaAlreadyLinked => 'Tesla är redan kopplad!';

  @override
  String get teslaLinked => 'Tesla kopplad!';

  @override
  String get teslaLinkFailed => 'Tesla-koppling misslyckades';

  @override
  String get startTrip => 'Starta Resa';

  @override
  String get stopTrip => 'Avsluta Resa';

  @override
  String get gpsActiveTracking => 'GPS aktiv - automatisk spårning';

  @override
  String get activeTrip => 'Aktiv resa';

  @override
  String startedAt(String time) {
    return 'Startad: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-punkter';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Uppdaterad: $time';
  }

  @override
  String get battery => 'Batteri';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Mätarställning';

  @override
  String get stateParked => 'Parkerad';

  @override
  String get stateDriving => 'Kör';

  @override
  String get stateCharging => 'Laddar';

  @override
  String get stateUnknown => 'Okänd';

  @override
  String chargingPower(double power) {
    return 'Laddar: $power kW';
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
  String get addFirstCar => 'Lägg till din första bil';

  @override
  String get toTrackPerCar => 'För att spåra resor per bil';

  @override
  String get selectCar => 'Välj bil';

  @override
  String get manageCars => 'Hantera bilar';

  @override
  String get unknownDevice => 'Okänd enhet';

  @override
  String deviceName(String name) {
    return 'Enhet: $name';
  }

  @override
  String get linkToCar => 'Koppla till bil:';

  @override
  String get noCarsFound => 'Inga bilar hittades. Lägg till en bil först.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName kopplad till $deviceName - Resa startad!';
  }

  @override
  String linkError(String error) {
    return 'Kopplingsfel: $error';
  }

  @override
  String get required => 'Obligatoriskt';

  @override
  String get invalidDistance => 'Ogiltigt avstånd';

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
