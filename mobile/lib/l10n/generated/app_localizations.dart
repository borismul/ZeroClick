import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// App title shown in app bar
  ///
  /// In en, this message translates to:
  /// **'Zero Click'**
  String get appTitle;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tabStatus;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tabTrips;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// Charging stations tab label
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get tabCharging;

  /// Charging stations count label
  ///
  /// In en, this message translates to:
  /// **'charging stations'**
  String get chargingStations;

  /// Logout menu option
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// First launch dialog title
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get importantTitle;

  /// First launch warning about background mode
  ///
  /// In en, this message translates to:
  /// **'This app automatically detects when you get in your car via Bluetooth.\n\nThis only works if the app is running in the background. If you close the app (swipe up), automatic detection will stop working.\n\nTip: Just leave the app open, and everything will work automatically.'**
  String get backgroundWarningMessage;

  /// Acknowledge button
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get understood;

  /// Dashboard prompt when not configured
  ///
  /// In en, this message translates to:
  /// **'Log in to get started'**
  String get loginPrompt;

  /// Dashboard subtitle when not configured
  ///
  /// In en, this message translates to:
  /// **'Log in with your Google account and configure the car API'**
  String get loginSubtitle;

  /// Button to navigate to settings
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// CarPlay connection status
  ///
  /// In en, this message translates to:
  /// **'CarPlay connected'**
  String get carPlayConnected;

  /// Offline status warning
  ///
  /// In en, this message translates to:
  /// **'Offline - actions will be queued'**
  String get offlineWarning;

  /// Section title for recent trips
  ///
  /// In en, this message translates to:
  /// **'Recent trips'**
  String get recentTrips;

  /// Error when not configured
  ///
  /// In en, this message translates to:
  /// **'Configure the app in Settings first'**
  String get configureFirst;

  /// Empty state for trips list
  ///
  /// In en, this message translates to:
  /// **'No trips yet'**
  String get noTripsYet;

  /// Route deviation warning
  ///
  /// In en, this message translates to:
  /// **'Route +{percent}% longer'**
  String routeLongerPercent(int percent);

  /// Route section title
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// Origin label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// Destination label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Details section title
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Date field label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Time field label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Distance field label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Trip type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Business trip type
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get tripTypeBusiness;

  /// Private trip type
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get tripTypePrivate;

  /// Mixed trip type
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get tripTypeMixed;

  /// Google Maps field label
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get googleMaps;

  /// Route deviation field label
  ///
  /// In en, this message translates to:
  /// **'Route deviation'**
  String get routeDeviation;

  /// Car field label
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// Route deviation warning message
  ///
  /// In en, this message translates to:
  /// **'Route is {percent}% longer than expected via Google Maps'**
  String routeDeviationWarning(int percent);

  /// Button to view trip route on map
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// Edit trip screen title
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get editTrip;

  /// Add trip screen title
  ///
  /// In en, this message translates to:
  /// **'Add trip'**
  String get addTrip;

  /// Date and time section
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// Origin placeholder
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromPlaceholder;

  /// Destination placeholder
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toPlaceholder;

  /// Distance and type section
  ///
  /// In en, this message translates to:
  /// **'Distance & Type'**
  String get distanceAndType;

  /// Distance field with unit
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get distanceKm;

  /// Business kilometers for mixed trips
  ///
  /// In en, this message translates to:
  /// **'Business km'**
  String get businessKm;

  /// Private kilometers for mixed trips
  ///
  /// In en, this message translates to:
  /// **'Private km'**
  String get privateKm;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Delete confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete trip?'**
  String get deleteTrip;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this trip?'**
  String get deleteTripConfirmation;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Delete error message
  ///
  /// In en, this message translates to:
  /// **'Could not delete'**
  String get couldNotDelete;

  /// Statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Trips stat label
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// Total stat label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Business stat label
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// Private stat label
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// Account section
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Logged in status
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// Google account subtitle
  ///
  /// In en, this message translates to:
  /// **'Google account'**
  String get googleAccount;

  /// Google login button
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get loginWithGoogle;

  /// Cars section title
  ///
  /// In en, this message translates to:
  /// **'My Cars'**
  String get myCars;

  /// Number of cars
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 cars} =1{1 car} other{{count} cars}}'**
  String carsCount(int count);

  /// Cars section subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your vehicles'**
  String get manageVehicles;

  /// Location section
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Location permission button
  ///
  /// In en, this message translates to:
  /// **'Request Location Permission'**
  String get requestLocationPermission;

  /// Open settings button
  ///
  /// In en, this message translates to:
  /// **'Open iOS Settings'**
  String get openIOSSettings;

  /// Permission success message
  ///
  /// In en, this message translates to:
  /// **'Location permission granted!'**
  String get locationPermissionGranted;

  /// Permission denied message
  ///
  /// In en, this message translates to:
  /// **'Location permission denied - go to Settings'**
  String get locationPermissionDenied;

  /// Location services disabled message
  ///
  /// In en, this message translates to:
  /// **'First enable Location Services in iOS Settings'**
  String get enableLocationServices;

  /// CarPlay section
  ///
  /// In en, this message translates to:
  /// **'CarPlay'**
  String get carPlay;

  /// Auto detection toggle
  ///
  /// In en, this message translates to:
  /// **'Automatic detection'**
  String get automaticDetection;

  /// Auto detection description
  ///
  /// In en, this message translates to:
  /// **'Start/stop trips automatically when CarPlay connects'**
  String get autoDetectionSubtitle;

  /// CarPlay connected status
  ///
  /// In en, this message translates to:
  /// **'CarPlay is connected'**
  String get carPlayIsConnected;

  /// Queue section
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// Queue item count
  ///
  /// In en, this message translates to:
  /// **'{count} items in queue'**
  String queueItems(int count);

  /// Queue status subtitle
  ///
  /// In en, this message translates to:
  /// **'Will be sent when online'**
  String get queueSubtitle;

  /// Send queue button
  ///
  /// In en, this message translates to:
  /// **'Send now'**
  String get sendNow;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get aboutApp;

  /// App description
  ///
  /// In en, this message translates to:
  /// **'Zero Click automatically detects when you get in the car via Bluetooth/CarPlay and tracks trips. No manual entry required.'**
  String get aboutDescription;

  /// Logged in confirmation
  ///
  /// In en, this message translates to:
  /// **'Logged in as {email}'**
  String loggedInAs(String email);

  /// Save error message
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String errorSaving(String error);

  /// Settings saved confirmation
  ///
  /// In en, this message translates to:
  /// **'Car settings saved'**
  String get carSettingsSaved;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Enter username and password'**
  String get enterUsernamePassword;

  /// Cars screen title
  ///
  /// In en, this message translates to:
  /// **'Cars'**
  String get cars;

  /// Add car button
  ///
  /// In en, this message translates to:
  /// **'Add car'**
  String get addCar;

  /// Empty cars state
  ///
  /// In en, this message translates to:
  /// **'No cars added yet'**
  String get noCarsAdded;

  /// Default car badge
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultBadge;

  /// Edit car screen title
  ///
  /// In en, this message translates to:
  /// **'Edit car'**
  String get editCar;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Name field hint
  ///
  /// In en, this message translates to:
  /// **'E.g. Audi Q4 e-tron'**
  String get nameHint;

  /// Name validation
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enterName;

  /// Brand field label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// Color section title
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// Icon section title
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// Default car toggle
  ///
  /// In en, this message translates to:
  /// **'Default car'**
  String get defaultCar;

  /// Default car description
  ///
  /// In en, this message translates to:
  /// **'New trips will be linked to this car'**
  String get defaultCarSubtitle;

  /// Bluetooth field label
  ///
  /// In en, this message translates to:
  /// **'Bluetooth device'**
  String get bluetoothDevice;

  /// Bluetooth field hint
  ///
  /// In en, this message translates to:
  /// **'Will be set automatically on connection'**
  String get autoSetOnConnect;

  /// Bluetooth info text
  ///
  /// In en, this message translates to:
  /// **'Will be set automatically when connecting to CarPlay/Bluetooth'**
  String get autoSetOnConnectFull;

  /// API connection section
  ///
  /// In en, this message translates to:
  /// **'Car API Connection'**
  String get carApiConnection;

  /// API connection description
  ///
  /// In en, this message translates to:
  /// **'Connect with {brand} for odometer and battery status'**
  String connectWithBrand(String brand);

  /// No description provided for @brandAudi.
  ///
  /// In en, this message translates to:
  /// **'Audi'**
  String get brandAudi;

  /// No description provided for @brandVolkswagen.
  ///
  /// In en, this message translates to:
  /// **'Volkswagen'**
  String get brandVolkswagen;

  /// No description provided for @brandSkoda.
  ///
  /// In en, this message translates to:
  /// **'Skoda'**
  String get brandSkoda;

  /// No description provided for @brandSeat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get brandSeat;

  /// No description provided for @brandCupra.
  ///
  /// In en, this message translates to:
  /// **'Cupra'**
  String get brandCupra;

  /// No description provided for @brandRenault.
  ///
  /// In en, this message translates to:
  /// **'Renault'**
  String get brandRenault;

  /// No description provided for @brandTesla.
  ///
  /// In en, this message translates to:
  /// **'Tesla'**
  String get brandTesla;

  /// No description provided for @brandBMW.
  ///
  /// In en, this message translates to:
  /// **'BMW'**
  String get brandBMW;

  /// No description provided for @brandMercedes.
  ///
  /// In en, this message translates to:
  /// **'Mercedes'**
  String get brandMercedes;

  /// No description provided for @brandOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get brandOther;

  /// No description provided for @iconSedan.
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get iconSedan;

  /// No description provided for @iconSUV.
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get iconSUV;

  /// No description provided for @iconHatchback.
  ///
  /// In en, this message translates to:
  /// **'Hatchback'**
  String get iconHatchback;

  /// No description provided for @iconSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get iconSport;

  /// No description provided for @iconVan.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get iconVan;

  /// Tesla login button
  ///
  /// In en, this message translates to:
  /// **'Log in with Tesla'**
  String get loginWithTesla;

  /// Tesla login description
  ///
  /// In en, this message translates to:
  /// **'You will be redirected to Tesla to log in. Then you can view your car data.'**
  String get teslaLoginInfo;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username / Email'**
  String get usernameEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Country field label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Country field hint
  ///
  /// In en, this message translates to:
  /// **'NL'**
  String get countryHint;

  /// Test API button
  ///
  /// In en, this message translates to:
  /// **'Test API'**
  String get testApi;

  /// Update success message
  ///
  /// In en, this message translates to:
  /// **'Car updated'**
  String get carUpdated;

  /// Add success message
  ///
  /// In en, this message translates to:
  /// **'Car added'**
  String get carAdded;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// Delete success message
  ///
  /// In en, this message translates to:
  /// **'Car deleted'**
  String get carDeleted;

  /// Delete car confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete car?'**
  String get deleteCar;

  /// Delete car confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{carName}\"? All trips linked to this car will keep their data.'**
  String deleteCarConfirmation(String carName);

  /// API settings saved confirmation
  ///
  /// In en, this message translates to:
  /// **'API settings saved'**
  String get apiSettingsSaved;

  /// Tesla already connected message
  ///
  /// In en, this message translates to:
  /// **'Tesla is already linked!'**
  String get teslaAlreadyLinked;

  /// Tesla connection success
  ///
  /// In en, this message translates to:
  /// **'Tesla linked!'**
  String get teslaLinked;

  /// Tesla connection error
  ///
  /// In en, this message translates to:
  /// **'Tesla link failed'**
  String get teslaLinkFailed;

  /// Start trip button
  ///
  /// In en, this message translates to:
  /// **'Start Trip'**
  String get startTrip;

  /// Stop trip button
  ///
  /// In en, this message translates to:
  /// **'Stop Trip'**
  String get stopTrip;

  /// GPS tracking status
  ///
  /// In en, this message translates to:
  /// **'GPS active - automatic tracking'**
  String get gpsActiveTracking;

  /// Active trip banner title
  ///
  /// In en, this message translates to:
  /// **'Active trip'**
  String get activeTrip;

  /// Trip start time
  ///
  /// In en, this message translates to:
  /// **'Started: {time}'**
  String startedAt(String time);

  /// GPS point count
  ///
  /// In en, this message translates to:
  /// **'{count} GPS points'**
  String gpsPoints(int count);

  /// Kilometer unit
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// Last update timestamp
  ///
  /// In en, this message translates to:
  /// **'Updated: {time}'**
  String updatedAt(String time);

  /// Battery label
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Odometer label
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// Car state: parked
  ///
  /// In en, this message translates to:
  /// **'Parked'**
  String get stateParked;

  /// Car state: driving
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get stateDriving;

  /// Car state: charging
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get stateCharging;

  /// Car state: unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get stateUnknown;

  /// Charging power display
  ///
  /// In en, this message translates to:
  /// **'Charging: {power} kW'**
  String chargingPower(double power);

  /// Charging time remaining
  ///
  /// In en, this message translates to:
  /// **'Ready in: {time}'**
  String readyIn(String time);

  /// Minutes short format
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// Hours and minutes format
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(int hours, int minutes);

  /// Empty car selector prompt
  ///
  /// In en, this message translates to:
  /// **'Add your first car'**
  String get addFirstCar;

  /// Empty car selector subtitle
  ///
  /// In en, this message translates to:
  /// **'To track trips per car'**
  String get toTrackPerCar;

  /// Car selector placeholder
  ///
  /// In en, this message translates to:
  /// **'Select car'**
  String get selectCar;

  /// Manage cars tooltip
  ///
  /// In en, this message translates to:
  /// **'Manage cars'**
  String get manageCars;

  /// Unknown device dialog title
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// Device name display
  ///
  /// In en, this message translates to:
  /// **'Device: {name}'**
  String deviceName(String name);

  /// Link device prompt
  ///
  /// In en, this message translates to:
  /// **'Link to car:'**
  String get linkToCar;

  /// No cars for linking
  ///
  /// In en, this message translates to:
  /// **'No cars found. Add a car first.'**
  String get noCarsFound;

  /// Link success message
  ///
  /// In en, this message translates to:
  /// **'{carName} linked to {deviceName} - Trip started!'**
  String carLinkedSuccess(String carName, String deviceName);

  /// Link error message
  ///
  /// In en, this message translates to:
  /// **'Error linking: {error}'**
  String linkError(String error);

  /// Required field validation
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Distance validation error
  ///
  /// In en, this message translates to:
  /// **'Invalid distance'**
  String get invalidDistance;

  /// Language section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Use system language setting
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageDutch.
  ///
  /// In en, this message translates to:
  /// **'Nederlands'**
  String get languageDutch;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get languageJapanese;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get languageThai;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVietnamese;

  /// No description provided for @languageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Svenska'**
  String get languageSwedish;

  /// No description provided for @languageNorwegian.
  ///
  /// In en, this message translates to:
  /// **'Norsk'**
  String get languageNorwegian;

  /// No description provided for @languageDanish.
  ///
  /// In en, this message translates to:
  /// **'Dansk'**
  String get languageDanish;

  /// No description provided for @languageFinnish.
  ///
  /// In en, this message translates to:
  /// **'Suomi'**
  String get languageFinnish;

  /// No description provided for @languageCzech.
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get languageCzech;

  /// No description provided for @languageHungarian.
  ///
  /// In en, this message translates to:
  /// **'Magyar'**
  String get languageHungarian;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Українська'**
  String get languageUkrainian;

  /// No description provided for @languageGreek.
  ///
  /// In en, this message translates to:
  /// **'Ελληνικά'**
  String get languageGreek;

  /// No description provided for @languageRomanian.
  ///
  /// In en, this message translates to:
  /// **'Română'**
  String get languageRomanian;

  /// No description provided for @languageHebrew.
  ///
  /// In en, this message translates to:
  /// **'עברית'**
  String get languageHebrew;

  /// Distance from car odometer
  ///
  /// In en, this message translates to:
  /// **'Via odometer'**
  String get distanceSourceOdometer;

  /// Distance estimated via OSRM routing
  ///
  /// In en, this message translates to:
  /// **'Estimated via route'**
  String get distanceSourceOsrm;

  /// Distance estimated from GPS points
  ///
  /// In en, this message translates to:
  /// **'Estimated via GPS'**
  String get distanceSourceGps;

  /// Warning that distance is estimated
  ///
  /// In en, this message translates to:
  /// **'Distance estimated'**
  String get distanceEstimated;

  /// Save location dialog title
  ///
  /// In en, this message translates to:
  /// **'Save location'**
  String get saveLocation;

  /// Location name field label
  ///
  /// In en, this message translates to:
  /// **'Name for this location'**
  String get locationName;

  /// Location name field hint
  ///
  /// In en, this message translates to:
  /// **'E.g. Customer ABC'**
  String get locationNameHint;

  /// Delete account button
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// Delete account subtitle
  ///
  /// In en, this message translates to:
  /// **'Delete your account and all data'**
  String get deleteAccountSubtitle;

  /// Delete account dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// Delete account confirmation message
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all your trips and data. This action cannot be undone.'**
  String get deleteAccountConfirmation;

  /// Account deleted success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeleted;

  /// Delete account error message
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {error}'**
  String deleteAccountError(String error);

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Zero Click'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We need a few permissions to automatically track your trips. Let\'s set them up one by one.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onboardingDone;

  /// No description provided for @onboardingOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get onboardingOpenSettings;

  /// No description provided for @onboardingLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get onboardingLoginTitle;

  /// No description provided for @onboardingLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account to sync your trips across devices and access the web dashboard.'**
  String get onboardingLoginDescription;

  /// No description provided for @onboardingLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get onboardingLoginButton;

  /// No description provided for @onboardingLoggingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get onboardingLoggingIn;

  /// No description provided for @onboardingNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onboardingNotificationsTitle;

  /// No description provided for @onboardingNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when a trip starts or ends, so you know everything is being tracked.'**
  String get onboardingNotificationsDescription;

  /// No description provided for @onboardingNotificationsButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get onboardingNotificationsButton;

  /// No description provided for @onboardingLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get onboardingLocationTitle;

  /// No description provided for @onboardingLocationDescription.
  ///
  /// In en, this message translates to:
  /// **'We need your location to track where your trips start and end. This is essential for mileage registration.'**
  String get onboardingLocationDescription;

  /// No description provided for @onboardingLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Location'**
  String get onboardingLocationButton;

  /// No description provided for @onboardingLocationAlwaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Location'**
  String get onboardingLocationAlwaysTitle;

  /// No description provided for @onboardingLocationAlwaysDescription.
  ///
  /// In en, this message translates to:
  /// **'For automatic trip detection, we need \'Always\' access. This lets us track trips even when the app is in the background.'**
  String get onboardingLocationAlwaysDescription;

  /// No description provided for @onboardingLocationAlwaysInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Open Settings\', then go to Location and select \'Always\'.'**
  String get onboardingLocationAlwaysInstructions;

  /// No description provided for @onboardingLocationAlwaysGranted.
  ///
  /// In en, this message translates to:
  /// **'Background location enabled!'**
  String get onboardingLocationAlwaysGranted;

  /// No description provided for @onboardingMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Motion & Fitness'**
  String get onboardingMotionTitle;

  /// No description provided for @onboardingMotionDescription.
  ///
  /// In en, this message translates to:
  /// **'We use motion sensors to detect when you\'re driving. This helps start trips automatically without draining your battery.'**
  String get onboardingMotionDescription;

  /// No description provided for @onboardingMotionButton.
  ///
  /// In en, this message translates to:
  /// **'Allow Motion Access'**
  String get onboardingMotionButton;

  /// No description provided for @onboardingHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get onboardingHowItWorksTitle;

  /// No description provided for @onboardingHowItWorksDescription.
  ///
  /// In en, this message translates to:
  /// **'Zero Click uses motion sensors to detect when you\'re driving. Fully automatic!'**
  String get onboardingHowItWorksDescription;

  /// No description provided for @onboardingFeatureMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion Detection'**
  String get onboardingFeatureMotion;

  /// No description provided for @onboardingFeatureMotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Your phone detects driving motion and automatically starts tracking. Works fully in the background.'**
  String get onboardingFeatureMotionDesc;

  /// No description provided for @onboardingFeatureBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Car Recognition'**
  String get onboardingFeatureBluetooth;

  /// No description provided for @onboardingFeatureBluetoothDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect via Bluetooth to identify which car you\'re driving. Trips are linked to the right vehicle.'**
  String get onboardingFeatureBluetoothDesc;

  /// No description provided for @onboardingFeatureCarApi.
  ///
  /// In en, this message translates to:
  /// **'Car Account'**
  String get onboardingFeatureCarApi;

  /// No description provided for @onboardingFeatureCarApiDesc.
  ///
  /// In en, this message translates to:
  /// **'Link your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings at trip start and end.'**
  String get onboardingFeatureCarApiDesc;

  /// No description provided for @onboardingSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your car'**
  String get onboardingSetupTitle;

  /// No description provided for @onboardingSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow these steps to get the best experience.'**
  String get onboardingSetupDescription;

  /// No description provided for @onboardingSetupStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Add your car'**
  String get onboardingSetupStep1Title;

  /// No description provided for @onboardingSetupStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Give your car a name and choose a color. This helps you recognize trips later.'**
  String get onboardingSetupStep1Desc;

  /// No description provided for @onboardingSetupStep1Button.
  ///
  /// In en, this message translates to:
  /// **'Add car now'**
  String get onboardingSetupStep1Button;

  /// No description provided for @onboardingSetupStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Go to your car'**
  String get onboardingSetupStep2Title;

  /// No description provided for @onboardingSetupStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Walk to your car and turn it on. Make sure Bluetooth is enabled on your phone.'**
  String get onboardingSetupStep2Desc;

  /// No description provided for @onboardingSetupStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Connect Bluetooth'**
  String get onboardingSetupStep3Title;

  /// No description provided for @onboardingSetupStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Pair your phone with your car\'s Bluetooth. A notification will appear to link it to your car in the app.'**
  String get onboardingSetupStep3Desc;

  /// No description provided for @onboardingSetupStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Link car account'**
  String get onboardingSetupStep4Title;

  /// No description provided for @onboardingSetupStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Connect your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings. You can do this later in Settings.'**
  String get onboardingSetupStep4Desc;

  /// No description provided for @onboardingSetupLater.
  ///
  /// In en, this message translates to:
  /// **'I\'ll do this later'**
  String get onboardingSetupLater;

  /// No description provided for @onboardingAllSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get onboardingAllSet;

  /// No description provided for @onboardingAllSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Permissions are configured. Your trips will now be tracked automatically when you connect to your car.'**
  String get onboardingAllSetDescription;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @tutorialDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your car'**
  String get tutorialDialogTitle;

  /// No description provided for @tutorialDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Add your car to get the most out of Zero Click. We\'ll link your trips to the right vehicle and read your odometer automatically.'**
  String get tutorialDialogContent;

  /// No description provided for @tutorialDialogSetup.
  ///
  /// In en, this message translates to:
  /// **'Add car now'**
  String get tutorialDialogSetup;

  /// No description provided for @tutorialDialogLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get tutorialDialogLater;

  /// No description provided for @tutorialMyCarsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cars'**
  String get tutorialMyCarsTitle;

  /// No description provided for @tutorialMyCarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add and manage your cars'**
  String get tutorialMyCarsDesc;

  /// No description provided for @tutorialAddCarTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a car'**
  String get tutorialAddCarTitle;

  /// No description provided for @tutorialAddCarDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add your first car'**
  String get tutorialAddCarDesc;

  /// Title for missing permissions banner
  ///
  /// In en, this message translates to:
  /// **'Permissions Required'**
  String get permissionsMissingTitle;

  /// Message explaining permissions are needed
  ///
  /// In en, this message translates to:
  /// **'Some permissions are not granted. The app may not work properly without them.'**
  String get permissionsMissingMessage;

  /// Button to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get permissionsOpenSettings;

  /// Label before list of missing permissions
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get permissionsMissing;

  /// Location permission name
  ///
  /// In en, this message translates to:
  /// **'Background Location'**
  String get permissionLocation;

  /// Motion permission name
  ///
  /// In en, this message translates to:
  /// **'Motion & Fitness'**
  String get permissionMotion;

  /// Notifications permission name
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get permissionNotifications;

  /// Legal section title
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Link to legal screen
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy & Terms'**
  String get privacyPolicyAndTerms;

  /// Privacy policy tab title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service tab title
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Button to open full legal document
  ///
  /// In en, this message translates to:
  /// **'Read full version online'**
  String get readFullVersion;

  /// Last update date for legal documents
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(String date);

  /// Full privacy policy text
  ///
  /// In en, this message translates to:
  /// **'PRIVACY POLICY\n\nZero Click (\'the app\') is a personal trip tracking application. Your privacy is important to us.\n\nDATA WE COLLECT\n\n• Location data: GPS coordinates during trips to calculate distances and routes\n• Email address: For account identification via Google Sign-In\n• Car odometer readings: Retrieved from your car\'s API (Audi, Tesla, etc.) when linked\n• Device information: For crash reporting and app improvements\n\nWHY WE COLLECT THIS DATA\n\n• Trip tracking: To automatically register your business and private trips\n• Mileage calculation: Using odometer data or GPS coordinates\n• Authentication: To secure your account and sync across devices\n• App improvement: To fix bugs and improve reliability\n\nHOW DATA IS STORED\n\n• All data is stored in Firebase (Google Cloud Platform) in EU region (europe-west4)\n• Data is encrypted in transit and at rest\n• Only you can access your trip data\n\nTHIRD-PARTY SERVICES\n\n• Google Sign-In: For authentication\n• Firebase Analytics: For anonymous usage statistics\n• Car APIs (Audi, Tesla, Renault, etc.): For odometer readings\n• Google Maps: For route visualization\n\nYOUR RIGHTS\n\n• Export: You can export all your trips to Google Sheets via the web dashboard\n• Deletion: You can delete your account and all data in Settings\n• Access: You have full access to all your data in the app\n\nCONTACT\n\nFor privacy questions, contact: privacy@zeroclick.app'**
  String get privacyPolicyContent;

  /// Full terms of service text
  ///
  /// In en, this message translates to:
  /// **'TERMS OF SERVICE\n\nBy using Zero Click (\'the app\'), you agree to these terms.\n\nSERVICE DESCRIPTION\n\nZero Click is a personal trip tracking app that automatically detects when you drive and registers trips. The app uses motion detection, GPS, and optionally your car\'s API for mileage data.\n\nUSER RESPONSIBILITIES\n\n• Accurate setup: You are responsible for correctly configuring your cars and accounts\n• Lawful use: Use the app only for legal purposes\n• Data accuracy: Verify important trip data before using it for tax or business purposes\n\nDATA ACCURACY DISCLAIMER\n\n• GPS-based distances may vary from actual distances\n• Odometer readings depend on your car\'s API accuracy\n• Automatic trip detection may occasionally miss trips or create false positives\n• Always review your trips for accuracy\n\nSERVICE AVAILABILITY\n\n• Zero Click is a personal project and does not guarantee uptime\n• The service may be unavailable for maintenance or updates\n• Features may change or be removed at any time\n\nACCOUNT TERMINATION\n\n• You can delete your account at any time in Settings\n• Account deletion permanently removes all your data\n• We may terminate accounts that violate these terms\n\nLIMITATION OF LIABILITY\n\n• The app is provided \'as is\' without warranties\n• We are not liable for inaccurate trip data or missed trips\n• We are not liable for any damages arising from use of the app\n• Maximum liability is limited to the amount you paid (which is zero, as the app is free)\n\nCHANGES TO TERMS\n\nWe may update these terms at any time. Continued use after changes constitutes acceptance.\n\nCONTACT\n\nFor questions about these terms, contact: support@zeroclick.app'**
  String get termsOfServiceContent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'he',
    'hi',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
