// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Kilometererfassung';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Fahrten';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get tabCharging => 'Laden';

  @override
  String get chargingStations => 'Ladestationen';

  @override
  String get logout => 'Abmelden';

  @override
  String get importantTitle => 'Wichtig';

  @override
  String get backgroundWarningMessage =>
      'Diese App erkennt automatisch, wenn du ins Auto steigst, via Bluetooth.\n\nDas funktioniert nur, wenn die App im Hintergrund läuft. Wenn du die App schließt (nach oben wischen), funktioniert die automatische Erkennung nicht mehr.\n\nTipp: Lass die App einfach offen, dann funktioniert alles automatisch.';

  @override
  String get understood => 'Verstanden';

  @override
  String get loginPrompt => 'Melde dich an, um zu beginnen';

  @override
  String get loginSubtitle =>
      'Melde dich mit deinem Google-Konto an und konfiguriere die Auto-API';

  @override
  String get goToSettings => 'Zu den Einstellungen';

  @override
  String get carPlayConnected => 'CarPlay verbunden';

  @override
  String get offlineWarning =>
      'Offline - Aktionen werden in die Warteschlange gestellt';

  @override
  String get recentTrips => 'Letzte Fahrten';

  @override
  String get configureFirst =>
      'Konfiguriere zuerst die App in den Einstellungen';

  @override
  String get noTripsYet => 'Noch keine Fahrten';

  @override
  String routeLongerPercent(int percent) {
    return 'Route +$percent% länger';
  }

  @override
  String get route => 'Route';

  @override
  String get from => 'Von';

  @override
  String get to => 'Nach';

  @override
  String get details => 'Details';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get distance => 'Entfernung';

  @override
  String get type => 'Typ';

  @override
  String get tripTypeBusiness => 'Geschäftlich';

  @override
  String get tripTypePrivate => 'Privat';

  @override
  String get tripTypeMixed => 'Gemischt';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Routenabweichung';

  @override
  String get car => 'Auto';

  @override
  String routeDeviationWarning(int percent) {
    return 'Route ist $percent% länger als über Google Maps erwartet';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Fahrt bearbeiten';

  @override
  String get addTrip => 'Fahrt hinzufügen';

  @override
  String get dateAndTime => 'Datum & Zeit';

  @override
  String get start => 'Start';

  @override
  String get end => 'Ende';

  @override
  String get fromPlaceholder => 'Von';

  @override
  String get toPlaceholder => 'Nach';

  @override
  String get distanceAndType => 'Entfernung & Typ';

  @override
  String get distanceKm => 'Entfernung (km)';

  @override
  String get businessKm => 'Geschäftlich km';

  @override
  String get privateKm => 'Privat km';

  @override
  String get save => 'Speichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get deleteTrip => 'Fahrt löschen?';

  @override
  String get deleteTripConfirmation =>
      'Bist du sicher, dass du diese Fahrt löschen möchtest?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get couldNotDelete => 'Konnte nicht löschen';

  @override
  String get statistics => 'Statistiken';

  @override
  String get trips => 'Fahrten';

  @override
  String get total => 'Gesamt';

  @override
  String get business => 'Geschäftlich';

  @override
  String get private => 'Privat';

  @override
  String get account => 'Konto';

  @override
  String get loggedIn => 'Angemeldet';

  @override
  String get googleAccount => 'Google-Konto';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get myCars => 'Meine Autos';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Autos',
      one: '1 Auto',
      zero: '0 Autos',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Verwalte deine Fahrzeuge';

  @override
  String get location => 'Standort';

  @override
  String get requestLocationPermission => 'Standortberechtigung anfordern';

  @override
  String get openIOSSettings => 'iOS-Einstellungen öffnen';

  @override
  String get locationPermissionGranted => 'Standortberechtigung erteilt!';

  @override
  String get locationPermissionDenied =>
      'Standortberechtigung verweigert - gehe zu Einstellungen';

  @override
  String get enableLocationServices =>
      'Aktiviere zuerst Ortungsdienste in den iOS-Einstellungen';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatische Erkennung';

  @override
  String get autoDetectionSubtitle =>
      'Fahrten automatisch starten/stoppen bei CarPlay-Verbindung';

  @override
  String get carPlayIsConnected => 'CarPlay ist verbunden';

  @override
  String get queue => 'Warteschlange';

  @override
  String queueItems(int count) {
    return '$count Elemente in Warteschlange';
  }

  @override
  String get queueSubtitle => 'Werden gesendet, sobald online';

  @override
  String get sendNow => 'Jetzt senden';

  @override
  String get aboutApp => 'Über diese App';

  @override
  String get aboutDescription =>
      'Diese App ersetzt die iPhone Kurzbefehle-Automatisierung für die Kilometererfassung. Sie erkennt automatisch, wenn du ins Auto steigst, via Bluetooth/CarPlay und zeichnet Fahrten auf.';

  @override
  String loggedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String errorSaving(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get carSettingsSaved => 'Auto-Einstellungen gespeichert';

  @override
  String get enterUsernamePassword => 'Benutzername und Passwort eingeben';

  @override
  String get cars => 'Autos';

  @override
  String get addCar => 'Auto hinzufügen';

  @override
  String get noCarsAdded => 'Noch keine Autos hinzugefügt';

  @override
  String get defaultBadge => 'Standard';

  @override
  String get editCar => 'Auto bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'z.B. Audi Q4 e-tron';

  @override
  String get enterName => 'Name eingeben';

  @override
  String get brand => 'Marke';

  @override
  String get color => 'Farbe';

  @override
  String get icon => 'Symbol';

  @override
  String get defaultCar => 'Standard-Auto';

  @override
  String get defaultCarSubtitle =>
      'Neue Fahrten werden mit diesem Auto verknüpft';

  @override
  String get bluetoothDevice => 'Bluetooth-Gerät';

  @override
  String get autoSetOnConnect => 'Wird automatisch bei Verbindung eingestellt';

  @override
  String get autoSetOnConnectFull =>
      'Wird automatisch bei Verbindung mit CarPlay/Bluetooth eingestellt';

  @override
  String get carApiConnection => 'Auto-API-Verbindung';

  @override
  String connectWithBrand(String brand) {
    return 'Mit $brand verbinden für Kilometerstand und Batteriestatus';
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
  String get brandOther => 'Sonstige';

  @override
  String get iconSedan => 'Limousine';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Schrägheck';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Mit Tesla anmelden';

  @override
  String get teslaLoginInfo =>
      'Du wirst zu Tesla weitergeleitet, um dich anzumelden. Danach kannst du deine Autodaten einsehen.';

  @override
  String get usernameEmail => 'Benutzername / E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get country => 'Land';

  @override
  String get countryHint => 'DE';

  @override
  String get testApi => 'API testen';

  @override
  String get carUpdated => 'Auto aktualisiert';

  @override
  String get carAdded => 'Auto hinzugefügt';

  @override
  String errorMessage(String error) {
    return 'Fehler: $error';
  }

  @override
  String get carDeleted => 'Auto gelöscht';

  @override
  String get deleteCar => 'Auto löschen?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Bist du sicher, dass du \"$carName\" löschen möchtest? Alle mit diesem Auto verknüpften Fahrten behalten ihre Daten.';
  }

  @override
  String get apiSettingsSaved => 'API-Einstellungen gespeichert';

  @override
  String get teslaAlreadyLinked => 'Tesla ist bereits verknüpft!';

  @override
  String get teslaLinked => 'Tesla verknüpft!';

  @override
  String get teslaLinkFailed => 'Tesla-Verknüpfung fehlgeschlagen';

  @override
  String get startTrip => 'Fahrt starten';

  @override
  String get stopTrip => 'Fahrt beenden';

  @override
  String get gpsActiveTracking => 'GPS aktiv - automatische Aufzeichnung';

  @override
  String get activeTrip => 'Aktive Fahrt';

  @override
  String startedAt(String time) {
    return 'Gestartet: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS-Punkte';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get battery => 'Batterie';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Kilometerstand';

  @override
  String get stateParked => 'Geparkt';

  @override
  String get stateDriving => 'Fahrend';

  @override
  String get stateCharging => 'Lädt';

  @override
  String get stateUnknown => 'Unbekannt';

  @override
  String chargingPower(double power) {
    return 'Laden: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Fertig in: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes Min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get addFirstCar => 'Füge dein erstes Auto hinzu';

  @override
  String get toTrackPerCar => 'Um Fahrten pro Auto zu verfolgen';

  @override
  String get selectCar => 'Auto auswählen';

  @override
  String get manageCars => 'Autos verwalten';

  @override
  String get unknownDevice => 'Unbekanntes Gerät';

  @override
  String deviceName(String name) {
    return 'Gerät: $name';
  }

  @override
  String get linkToCar => 'Mit Auto verknüpfen:';

  @override
  String get noCarsFound => 'Keine Autos gefunden. Füge zuerst ein Auto hinzu.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName mit $deviceName verknüpft - Fahrt gestartet!';
  }

  @override
  String linkError(String error) {
    return 'Fehler beim Verknüpfen: $error';
  }

  @override
  String get required => 'Erforderlich';

  @override
  String get invalidDistance => 'Ungültige Entfernung';

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
