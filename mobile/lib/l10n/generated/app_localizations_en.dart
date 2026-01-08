// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mileage Tracker';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Trips';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabCharging => 'Charging';

  @override
  String get chargingStations => 'charging stations';

  @override
  String get logout => 'Log out';

  @override
  String get importantTitle => 'Important';

  @override
  String get backgroundWarningMessage =>
      'This app automatically detects when you get in your car via Bluetooth.\n\nThis only works if the app is running in the background. If you close the app (swipe up), automatic detection will stop working.\n\nTip: Just leave the app open, and everything will work automatically.';

  @override
  String get understood => 'Got it';

  @override
  String get loginPrompt => 'Log in to get started';

  @override
  String get loginSubtitle =>
      'Log in with your Google account and configure the car API';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get carPlayConnected => 'CarPlay connected';

  @override
  String get offlineWarning => 'Offline - actions will be queued';

  @override
  String get recentTrips => 'Recent trips';

  @override
  String get configureFirst => 'Configure the app in Settings first';

  @override
  String get noTripsYet => 'No trips yet';

  @override
  String routeLongerPercent(int percent) {
    return 'Route +$percent% longer';
  }

  @override
  String get route => 'Route';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get details => 'Details';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get distance => 'Distance';

  @override
  String get type => 'Type';

  @override
  String get tripTypeBusiness => 'Business';

  @override
  String get tripTypePrivate => 'Private';

  @override
  String get tripTypeMixed => 'Mixed';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Route deviation';

  @override
  String get car => 'Car';

  @override
  String routeDeviationWarning(int percent) {
    return 'Route is $percent% longer than expected via Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Edit trip';

  @override
  String get addTrip => 'Add trip';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get fromPlaceholder => 'From';

  @override
  String get toPlaceholder => 'To';

  @override
  String get distanceAndType => 'Distance & Type';

  @override
  String get distanceKm => 'Distance (km)';

  @override
  String get businessKm => 'Business km';

  @override
  String get privateKm => 'Private km';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get deleteTrip => 'Delete trip?';

  @override
  String get deleteTripConfirmation =>
      'Are you sure you want to delete this trip?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get couldNotDelete => 'Could not delete';

  @override
  String get statistics => 'Statistics';

  @override
  String get trips => 'Trips';

  @override
  String get total => 'Total';

  @override
  String get business => 'Business';

  @override
  String get private => 'Private';

  @override
  String get account => 'Account';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get googleAccount => 'Google account';

  @override
  String get loginWithGoogle => 'Log in with Google';

  @override
  String get myCars => 'My Cars';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cars',
      one: '1 car',
      zero: '0 cars',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Manage your vehicles';

  @override
  String get location => 'Location';

  @override
  String get requestLocationPermission => 'Request Location Permission';

  @override
  String get openIOSSettings => 'Open iOS Settings';

  @override
  String get locationPermissionGranted => 'Location permission granted!';

  @override
  String get locationPermissionDenied =>
      'Location permission denied - go to Settings';

  @override
  String get enableLocationServices =>
      'First enable Location Services in iOS Settings';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Automatic detection';

  @override
  String get autoDetectionSubtitle =>
      'Start/stop trips automatically when CarPlay connects';

  @override
  String get carPlayIsConnected => 'CarPlay is connected';

  @override
  String get queue => 'Queue';

  @override
  String queueItems(int count) {
    return '$count items in queue';
  }

  @override
  String get queueSubtitle => 'Will be sent when online';

  @override
  String get sendNow => 'Send now';

  @override
  String get aboutApp => 'About this app';

  @override
  String get aboutDescription =>
      'This app replaces the iPhone Shortcuts automation for mileage tracking. It automatically detects when you get in the car via Bluetooth/CarPlay and tracks trips.';

  @override
  String loggedInAs(String email) {
    return 'Logged in as $email';
  }

  @override
  String errorSaving(String error) {
    return 'Error saving: $error';
  }

  @override
  String get carSettingsSaved => 'Car settings saved';

  @override
  String get enterUsernamePassword => 'Enter username and password';

  @override
  String get cars => 'Cars';

  @override
  String get addCar => 'Add car';

  @override
  String get noCarsAdded => 'No cars added yet';

  @override
  String get defaultBadge => 'Default';

  @override
  String get editCar => 'Edit car';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'E.g. Audi Q4 e-tron';

  @override
  String get enterName => 'Enter a name';

  @override
  String get brand => 'Brand';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icon';

  @override
  String get defaultCar => 'Default car';

  @override
  String get defaultCarSubtitle => 'New trips will be linked to this car';

  @override
  String get bluetoothDevice => 'Bluetooth device';

  @override
  String get autoSetOnConnect => 'Will be set automatically on connection';

  @override
  String get autoSetOnConnectFull =>
      'Will be set automatically when connecting to CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Car API Connection';

  @override
  String connectWithBrand(String brand) {
    return 'Connect with $brand for odometer and battery status';
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
  String get brandOther => 'Other';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Log in with Tesla';

  @override
  String get teslaLoginInfo =>
      'You will be redirected to Tesla to log in. Then you can view your car data.';

  @override
  String get usernameEmail => 'Username / Email';

  @override
  String get password => 'Password';

  @override
  String get country => 'Country';

  @override
  String get countryHint => 'NL';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Car updated';

  @override
  String get carAdded => 'Car added';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get carDeleted => 'Car deleted';

  @override
  String get deleteCar => 'Delete car?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Are you sure you want to delete \"$carName\"? All trips linked to this car will keep their data.';
  }

  @override
  String get apiSettingsSaved => 'API settings saved';

  @override
  String get teslaAlreadyLinked => 'Tesla is already linked!';

  @override
  String get teslaLinked => 'Tesla linked!';

  @override
  String get teslaLinkFailed => 'Tesla link failed';

  @override
  String get startTrip => 'Start Trip';

  @override
  String get stopTrip => 'Stop Trip';

  @override
  String get gpsActiveTracking => 'GPS active - automatic tracking';

  @override
  String get activeTrip => 'Active trip';

  @override
  String startedAt(String time) {
    return 'Started: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS points';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Updated: $time';
  }

  @override
  String get battery => 'Battery';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Odometer';

  @override
  String get stateParked => 'Parked';

  @override
  String get stateDriving => 'Driving';

  @override
  String get stateCharging => 'Charging';

  @override
  String get stateUnknown => 'Unknown';

  @override
  String chargingPower(double power) {
    return 'Charging: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Ready in: $time';
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
  String get addFirstCar => 'Add your first car';

  @override
  String get toTrackPerCar => 'To track trips per car';

  @override
  String get selectCar => 'Select car';

  @override
  String get manageCars => 'Manage cars';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String deviceName(String name) {
    return 'Device: $name';
  }

  @override
  String get linkToCar => 'Link to car:';

  @override
  String get noCarsFound => 'No cars found. Add a car first.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName linked to $deviceName - Trip started!';
  }

  @override
  String linkError(String error) {
    return 'Error linking: $error';
  }

  @override
  String get required => 'Required';

  @override
  String get invalidDistance => 'Invalid distance';

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
