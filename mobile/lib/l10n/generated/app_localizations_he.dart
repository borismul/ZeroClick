// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'יומן קילומטרים';

  @override
  String get tabStatus => 'סטטוס';

  @override
  String get tabTrips => 'נסיעות';

  @override
  String get tabSettings => 'הגדרות';

  @override
  String get tabCharging => 'טעינה';

  @override
  String get chargingStations => 'תחנות טעינה';

  @override
  String get logout => 'התנתק';

  @override
  String get importantTitle => 'חשוב';

  @override
  String get backgroundWarningMessage =>
      'האפליקציה הזו מזהה אוטומטית כשאתה נכנס לרכב דרך Bluetooth.\n\nזה עובד רק כשהאפליקציה פועלת ברקע. אם תסגור את האפליקציה (החלקה למעלה), הזיהוי האוטומטי יפסיק לעבוד.\n\nטיפ: פשוט השאר את האפליקציה פתוחה והכל יעבוד אוטומטית.';

  @override
  String get understood => 'הבנתי';

  @override
  String get loginPrompt => 'התחבר כדי להתחיל';

  @override
  String get loginSubtitle => 'התחבר עם חשבון Google והגדר את ה-API של הרכב';

  @override
  String get goToSettings => 'עבור להגדרות';

  @override
  String get carPlayConnected => 'CarPlay מחובר';

  @override
  String get offlineWarning => 'לא מקוון - פעולות יתווספו לתור';

  @override
  String get recentTrips => 'נסיעות אחרונות';

  @override
  String get configureFirst => 'הגדר קודם את האפליקציה בהגדרות';

  @override
  String get noTripsYet => 'עדיין אין נסיעות';

  @override
  String routeLongerPercent(int percent) {
    return 'מסלול ארוך ב-+$percent%';
  }

  @override
  String get route => 'מסלול';

  @override
  String get from => 'מ';

  @override
  String get to => 'אל';

  @override
  String get details => 'פרטים';

  @override
  String get date => 'תאריך';

  @override
  String get time => 'שעה';

  @override
  String get distance => 'מרחק';

  @override
  String get type => 'סוג';

  @override
  String get tripTypeBusiness => 'עסקי';

  @override
  String get tripTypePrivate => 'פרטי';

  @override
  String get tripTypeMixed => 'מעורב';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'סטייה מהמסלול';

  @override
  String get car => 'רכב';

  @override
  String routeDeviationWarning(int percent) {
    return 'המסלול ארוך ב-$percent% מהצפי לפי Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'ערוך נסיעה';

  @override
  String get addTrip => 'הוסף נסיעה';

  @override
  String get dateAndTime => 'תאריך ושעה';

  @override
  String get start => 'התחלה';

  @override
  String get end => 'סיום';

  @override
  String get fromPlaceholder => 'מ';

  @override
  String get toPlaceholder => 'אל';

  @override
  String get distanceAndType => 'מרחק וסוג';

  @override
  String get distanceKm => 'מרחק (ק\"מ)';

  @override
  String get businessKm => 'ק\"מ עסקי';

  @override
  String get privateKm => 'ק\"מ פרטי';

  @override
  String get save => 'שמור';

  @override
  String get add => 'הוסף';

  @override
  String get deleteTrip => 'למחוק את הנסיעה?';

  @override
  String get deleteTripConfirmation =>
      'האם אתה בטוח שברצונך למחוק את הנסיעה הזו?';

  @override
  String get cancel => 'ביטול';

  @override
  String get delete => 'מחק';

  @override
  String get somethingWentWrong => 'משהו השתבש';

  @override
  String get couldNotDelete => 'לא ניתן למחוק';

  @override
  String get statistics => 'סטטיסטיקה';

  @override
  String get trips => 'נסיעות';

  @override
  String get total => 'סה\"כ';

  @override
  String get business => 'עסקי';

  @override
  String get private => 'פרטי';

  @override
  String get account => 'חשבון';

  @override
  String get loggedIn => 'מחובר';

  @override
  String get googleAccount => 'חשבון Google';

  @override
  String get loginWithGoogle => 'התחבר עם Google';

  @override
  String get myCars => 'הרכבים שלי';

  @override
  String carsCount(int count) {
    return '$count רכבים';
  }

  @override
  String get manageVehicles => 'נהל את הרכבים שלך';

  @override
  String get location => 'מיקום';

  @override
  String get requestLocationPermission => 'בקש הרשאת מיקום';

  @override
  String get openIOSSettings => 'פתח הגדרות iOS';

  @override
  String get locationPermissionGranted => 'הרשאת מיקום אושרה!';

  @override
  String get locationPermissionDenied => 'הרשאת מיקום נדחתה - עבור להגדרות';

  @override
  String get enableLocationServices => 'הפעל קודם שירותי מיקום בהגדרות iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'זיהוי אוטומטי';

  @override
  String get autoDetectionSubtitle =>
      'התחל/עצור נסיעות אוטומטית בחיבור CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay מחובר';

  @override
  String get queue => 'תור';

  @override
  String queueItems(int count) {
    return '$count פריטים בתור';
  }

  @override
  String get queueSubtitle => 'יישלחו כשתהיה מקוון';

  @override
  String get sendNow => 'שלח עכשיו';

  @override
  String get aboutApp => 'אודות האפליקציה';

  @override
  String get aboutDescription =>
      'האפליקציה הזו מחליפה את האוטומציה של קיצורי דרך iPhone ליומן קילומטרים. היא מזהה אוטומטית כשאתה נכנס לרכב דרך Bluetooth/CarPlay ומתעדת נסיעות.';

  @override
  String loggedInAs(String email) {
    return 'מחובר כ-$email';
  }

  @override
  String errorSaving(String error) {
    return 'שגיאה בשמירה: $error';
  }

  @override
  String get carSettingsSaved => 'הגדרות הרכב נשמרו';

  @override
  String get enterUsernamePassword => 'הזן שם משתמש וסיסמה';

  @override
  String get cars => 'רכבים';

  @override
  String get addCar => 'הוסף רכב';

  @override
  String get noCarsAdded => 'עדיין לא נוספו רכבים';

  @override
  String get defaultBadge => 'ברירת מחדל';

  @override
  String get editCar => 'ערוך רכב';

  @override
  String get name => 'שם';

  @override
  String get nameHint => 'למשל Audi Q4 e-tron';

  @override
  String get enterName => 'הזן שם';

  @override
  String get brand => 'יצרן';

  @override
  String get color => 'צבע';

  @override
  String get icon => 'סמל';

  @override
  String get defaultCar => 'רכב ברירת מחדל';

  @override
  String get defaultCarSubtitle => 'נסיעות חדשות יקושרו לרכב זה';

  @override
  String get bluetoothDevice => 'מכשיר Bluetooth';

  @override
  String get autoSetOnConnect => 'יוגדר אוטומטית בחיבור';

  @override
  String get autoSetOnConnectFull =>
      'יוגדר אוטומטית בחיבור ל-CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'חיבור API רכב';

  @override
  String connectWithBrand(String brand) {
    return 'התחבר ל-$brand לקילומטרים וסטטוס סוללה';
  }

  @override
  String get brandAudi => 'אודי';

  @override
  String get brandVolkswagen => 'פולקסווגן';

  @override
  String get brandSkoda => 'סקודה';

  @override
  String get brandSeat => 'סאט';

  @override
  String get brandCupra => 'קופרה';

  @override
  String get brandRenault => 'רנו';

  @override
  String get brandTesla => 'טסלה';

  @override
  String get brandBMW => 'ב.מ.וו';

  @override
  String get brandMercedes => 'מרצדס';

  @override
  String get brandOther => 'אחר';

  @override
  String get iconSedan => 'סדאן';

  @override
  String get iconSUV => 'רכב שטח';

  @override
  String get iconHatchback => 'האצ\'בק';

  @override
  String get iconSport => 'ספורט';

  @override
  String get iconVan => 'מסחרי';

  @override
  String get loginWithTesla => 'התחבר עם Tesla';

  @override
  String get teslaLoginInfo =>
      'תועבר ל-Tesla להתחברות. אחר כך תוכל לראות את נתוני הרכב.';

  @override
  String get usernameEmail => 'שם משתמש / אימייל';

  @override
  String get password => 'סיסמה';

  @override
  String get country => 'מדינה';

  @override
  String get countryHint => 'IL';

  @override
  String get testApi => 'בדוק API';

  @override
  String get carUpdated => 'הרכב עודכן';

  @override
  String get carAdded => 'הרכב נוסף';

  @override
  String errorMessage(String error) {
    return 'שגיאה: $error';
  }

  @override
  String get carDeleted => 'הרכב נמחק';

  @override
  String get deleteCar => 'למחוק את הרכב?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'האם אתה בטוח שברצונך למחוק את \"$carName\"? כל הנסיעות הקשורות לרכב זה ישמרו את הנתונים שלהן.';
  }

  @override
  String get apiSettingsSaved => 'הגדרות API נשמרו';

  @override
  String get teslaAlreadyLinked => 'Tesla כבר מקושרת!';

  @override
  String get teslaLinked => 'Tesla מקושרת!';

  @override
  String get teslaLinkFailed => 'קישור Tesla נכשל';

  @override
  String get startTrip => 'התחל נסיעה';

  @override
  String get stopTrip => 'סיים נסיעה';

  @override
  String get gpsActiveTracking => 'GPS פעיל - מעקב אוטומטי';

  @override
  String get activeTrip => 'נסיעה פעילה';

  @override
  String startedAt(String time) {
    return 'התחלה: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count נקודות GPS';
  }

  @override
  String get km => 'ק\"מ';

  @override
  String updatedAt(String time) {
    return 'עודכן: $time';
  }

  @override
  String get battery => 'סוללה';

  @override
  String get status => 'סטטוס';

  @override
  String get odometer => 'מד אוץ';

  @override
  String get stateParked => 'חונה';

  @override
  String get stateDriving => 'נוסע';

  @override
  String get stateCharging => 'נטען';

  @override
  String get stateUnknown => 'לא ידוע';

  @override
  String chargingPower(double power) {
    return 'טעינה: $power קו\"ט';
  }

  @override
  String readyIn(String time) {
    return 'מוכן בעוד: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes דק\'';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursש\' $minutesד\'';
  }

  @override
  String get addFirstCar => 'הוסף את הרכב הראשון שלך';

  @override
  String get toTrackPerCar => 'למעקב נסיעות לפי רכב';

  @override
  String get selectCar => 'בחר רכב';

  @override
  String get manageCars => 'נהל רכבים';

  @override
  String get unknownDevice => 'מכשיר לא מזוהה';

  @override
  String deviceName(String name) {
    return 'מכשיר: $name';
  }

  @override
  String get linkToCar => 'קשר לרכב:';

  @override
  String get noCarsFound => 'לא נמצאו רכבים. הוסף רכב קודם.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName קושר ל-$deviceName - הנסיעה התחילה!';
  }

  @override
  String linkError(String error) {
    return 'שגיאה בקישור: $error';
  }

  @override
  String get required => 'שדה חובה';

  @override
  String get invalidDistance => 'מרחק לא תקין';

  @override
  String get language => 'שפה';

  @override
  String get systemDefault => 'ברירת מחדל של המערכת';

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

  @override
  String get saveLocation => 'Save location';

  @override
  String get locationName => 'Name for this location';

  @override
  String get locationNameHint => 'E.g. Customer ABC';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountSubtitle => 'Delete your account and all data';

  @override
  String get deleteAccountTitle => 'Delete account?';

  @override
  String get deleteAccountConfirmation =>
      'This permanently deletes all your trips and data. This action cannot be undone.';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String deleteAccountError(String error) {
    return 'Error deleting account: $error';
  }

  @override
  String get onboardingWelcome => 'Welcome to Zero Click';

  @override
  String get onboardingWelcomeSubtitle =>
      'We need a few permissions to automatically track your trips. Let\'s set them up one by one.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingDone => 'Done';

  @override
  String get onboardingOpenSettings => 'Open Settings';

  @override
  String get onboardingLoginTitle => 'Sign In';

  @override
  String get onboardingLoginDescription =>
      'Sign in with your Google account to sync your trips across devices and access the web dashboard.';

  @override
  String get onboardingLoginButton => 'Sign in with Google';

  @override
  String get onboardingLoggingIn => 'Signing in...';

  @override
  String get onboardingNotificationsTitle => 'Notifications';

  @override
  String get onboardingNotificationsDescription =>
      'We\'ll notify you when a trip starts or ends, so you know everything is being tracked.';

  @override
  String get onboardingNotificationsButton => 'Allow Notifications';

  @override
  String get onboardingLocationTitle => 'Location Access';

  @override
  String get onboardingLocationDescription =>
      'We need your location to track where your trips start and end. This is essential for mileage registration.';

  @override
  String get onboardingLocationButton => 'Allow Location';

  @override
  String get onboardingLocationAlwaysTitle => 'Background Location';

  @override
  String get onboardingLocationAlwaysDescription =>
      'For automatic trip detection, we need \'Always\' access. This lets us track trips even when the app is in the background.';

  @override
  String get onboardingLocationAlwaysInstructions =>
      'Tap \'Open Settings\', then go to Location and select \'Always\'.';

  @override
  String get onboardingLocationAlwaysGranted => 'Background location enabled!';

  @override
  String get onboardingMotionTitle => 'Motion & Fitness';

  @override
  String get onboardingMotionDescription =>
      'We use motion sensors to detect when you\'re driving. This helps start trips automatically without draining your battery.';

  @override
  String get onboardingMotionButton => 'Allow Motion Access';

  @override
  String get onboardingHowItWorksTitle => 'How it works';

  @override
  String get onboardingHowItWorksDescription =>
      'Zero Click uses motion sensors to detect when you\'re driving. Fully automatic!';

  @override
  String get onboardingFeatureMotion => 'Motion Detection';

  @override
  String get onboardingFeatureMotionDesc =>
      'Your phone detects driving motion and automatically starts tracking. Works fully in the background.';

  @override
  String get onboardingFeatureBluetooth => 'Car Recognition';

  @override
  String get onboardingFeatureBluetoothDesc =>
      'Connect via Bluetooth to identify which car you\'re driving. Trips are linked to the right vehicle.';

  @override
  String get onboardingFeatureCarApi => 'Car Account';

  @override
  String get onboardingFeatureCarApiDesc =>
      'Link your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings at trip start and end.';

  @override
  String get onboardingSetupTitle => 'Set up your car';

  @override
  String get onboardingSetupDescription =>
      'Follow these steps to get the best experience.';

  @override
  String get onboardingSetupStep1Title => 'Add your car';

  @override
  String get onboardingSetupStep1Desc =>
      'Give your car a name and choose a color. This helps you recognize trips later.';

  @override
  String get onboardingSetupStep1Button => 'Add car now';

  @override
  String get onboardingSetupStep2Title => 'Go to your car';

  @override
  String get onboardingSetupStep2Desc =>
      'Walk to your car and turn it on. Make sure Bluetooth is enabled on your phone.';

  @override
  String get onboardingSetupStep3Title => 'Connect Bluetooth';

  @override
  String get onboardingSetupStep3Desc =>
      'Pair your phone with your car\'s Bluetooth. A notification will appear to link it to your car in the app.';

  @override
  String get onboardingSetupStep4Title => 'Link car account';

  @override
  String get onboardingSetupStep4Desc =>
      'Connect your car\'s app (myAudi, Tesla, etc.) for automatic odometer readings. You can do this later in Settings.';

  @override
  String get onboardingSetupLater => 'I\'ll do this later';

  @override
  String get onboardingAllSet => 'You\'re all set!';

  @override
  String get onboardingAllSetDescription =>
      'Permissions are configured. Your trips will now be tracked automatically when you connect to your car.';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get tutorialDialogTitle => 'Set up your car';

  @override
  String get tutorialDialogContent =>
      'Add your car to get the most out of Zero Click. We\'ll link your trips to the right vehicle and read your odometer automatically.';

  @override
  String get tutorialDialogSetup => 'Add car now';

  @override
  String get tutorialDialogLater => 'Later';

  @override
  String get tutorialMyCarsTitle => 'My Cars';

  @override
  String get tutorialMyCarsDesc => 'Tap here to add and manage your cars';

  @override
  String get tutorialAddCarTitle => 'Add a car';

  @override
  String get tutorialAddCarDesc => 'Tap here to add your first car';

  @override
  String get permissionsMissingTitle => 'Permissions Required';

  @override
  String get permissionsMissingMessage =>
      'Some permissions are not granted. The app may not work properly without them.';

  @override
  String get permissionsOpenSettings => 'Open Settings';

  @override
  String get permissionsMissing => 'Missing';

  @override
  String get permissionLocation => 'Background Location';

  @override
  String get permissionMotion => 'Motion & Fitness';

  @override
  String get permissionNotifications => 'Notifications';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicyAndTerms => 'Privacy Policy & Terms';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get readFullVersion => 'Read full version online';

  @override
  String lastUpdated(String date) {
    return 'Last updated: $date';
  }

  @override
  String get privacyPolicyContent =>
      'PRIVACY POLICY\n\nZero Click (\'the app\') is a personal trip tracking application. Your privacy is important to us.\n\nDATA WE COLLECT\n\n• Location data: GPS coordinates during trips to calculate distances and routes\n• Email address: For account identification via Google Sign-In\n• Car odometer readings: Retrieved from your car\'s API (Audi, Tesla, etc.) when linked\n• Device information: For crash reporting and app improvements\n\nWHY WE COLLECT THIS DATA\n\n• Trip tracking: To automatically register your business and private trips\n• Mileage calculation: Using odometer data or GPS coordinates\n• Authentication: To secure your account and sync across devices\n• App improvement: To fix bugs and improve reliability\n\nHOW DATA IS STORED\n\n• All data is stored in Firebase (Google Cloud Platform) in EU region (europe-west4)\n• Data is encrypted in transit and at rest\n• Only you can access your trip data\n\nTHIRD-PARTY SERVICES\n\n• Google Sign-In: For authentication\n• Firebase Analytics: For anonymous usage statistics\n• Car APIs (Audi, Tesla, Renault, etc.): For odometer readings\n• Google Maps: For route visualization\n\nYOUR RIGHTS\n\n• Export: You can export all your trips to Google Sheets via the web dashboard\n• Deletion: You can delete your account and all data in Settings\n• Access: You have full access to all your data in the app\n\nCONTACT\n\nFor privacy questions, contact: privacy@zeroclick.app';

  @override
  String get termsOfServiceContent =>
      'TERMS OF SERVICE\n\nBy using Zero Click (\'the app\'), you agree to these terms.\n\nSERVICE DESCRIPTION\n\nZero Click is a personal trip tracking app that automatically detects when you drive and registers trips. The app uses motion detection, GPS, and optionally your car\'s API for mileage data.\n\nUSER RESPONSIBILITIES\n\n• Accurate setup: You are responsible for correctly configuring your cars and accounts\n• Lawful use: Use the app only for legal purposes\n• Data accuracy: Verify important trip data before using it for tax or business purposes\n\nDATA ACCURACY DISCLAIMER\n\n• GPS-based distances may vary from actual distances\n• Odometer readings depend on your car\'s API accuracy\n• Automatic trip detection may occasionally miss trips or create false positives\n• Always review your trips for accuracy\n\nSERVICE AVAILABILITY\n\n• Zero Click is a personal project and does not guarantee uptime\n• The service may be unavailable for maintenance or updates\n• Features may change or be removed at any time\n\nACCOUNT TERMINATION\n\n• You can delete your account at any time in Settings\n• Account deletion permanently removes all your data\n• We may terminate accounts that violate these terms\n\nLIMITATION OF LIABILITY\n\n• The app is provided \'as is\' without warranties\n• We are not liable for inaccurate trip data or missed trips\n• We are not liable for any damages arising from use of the app\n• Maximum liability is limited to the amount you paid (which is zero, as the app is free)\n\nCHANGES TO TERMS\n\nWe may update these terms at any time. Continued use after changes constitutes acceptance.\n\nCONTACT\n\nFor questions about these terms, contact: support@zeroclick.app';

  @override
  String get retry => 'נסה שוב';

  @override
  String get ok => 'אישור';

  @override
  String get noConnection => 'אין חיבור';

  @override
  String get checkInternetConnection => 'בדוק את חיבור האינטרנט ונסה שוב.';

  @override
  String get sessionExpired => 'תוקף הפעלה פג';

  @override
  String get loginAgainToContinue => 'התחבר שוב כדי להמשיך.';

  @override
  String get serverError => 'שגיאת שרת';

  @override
  String get tryAgainLater => 'משהו השתבש. נא לנסות שוב מאוחר יותר.';

  @override
  String get invalidInput => 'קלט לא תקין';

  @override
  String get timeout => 'פסק זמן';

  @override
  String get serverNotResponding => 'השרת לא מגיב. נא לנסות שוב.';

  @override
  String get error => 'שגיאה';

  @override
  String get unexpectedError => 'אירעה שגיאה לא צפויה.';

  @override
  String get setupCarTitle => 'הגדר את הרכב שלך לחוויה הטובה ביותר:';

  @override
  String get setupCarApiStep => 'חבר API של רכב';

  @override
  String get setupCarApiDescription =>
      'עבור לרכבים → בחר את הרכב שלך → קשר את החשבון שלך. זה נותן לך גישה לקריאות מד אוץ ועוד.';

  @override
  String get setupBluetoothStep => 'חבר Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'חבר את הטלפון שלך דרך Bluetooth לרכב, פתח את האפליקציה הזו וקשר בהתראה. זה מבטיח זיהוי נסיעות אמין.';

  @override
  String get setupTip => 'טיפ: הגדר את שניהם לאמינות הטובה ביותר!';

  @override
  String get developer => 'מפתח';

  @override
  String get debugLogs => 'יומני באגים';

  @override
  String get viewNativeLogs => 'הצג יומני iOS מקוריים';

  @override
  String get copyAllLogs => 'העתק את כל היומנים';

  @override
  String get logsCopied => 'היומנים הועתקו ללוח';

  @override
  String get loggedOut => 'התנתקת';

  @override
  String get loginWithAudiId => 'התחבר עם Audi ID';

  @override
  String get loginWithAudiDescription => 'התחבר עם חשבון myAudi שלך';

  @override
  String get loginWithVolkswagenId => 'התחבר עם Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'התחבר עם חשבון Volkswagen ID שלך';

  @override
  String get loginWithSkodaId => 'התחבר עם Skoda ID';

  @override
  String get loginWithSkodaDescription => 'התחבר עם חשבון Skoda ID שלך';

  @override
  String get loginWithSeatId => 'התחבר עם SEAT ID';

  @override
  String get loginWithSeatDescription => 'התחבר עם חשבון SEAT ID שלך';

  @override
  String get loginWithCupraId => 'התחבר עם CUPRA ID';

  @override
  String get loginWithCupraDescription => 'התחבר עם חשבון CUPRA ID שלך';

  @override
  String get loginWithRenaultId => 'התחבר עם Renault ID';

  @override
  String get loginWithRenaultDescription => 'התחבר עם חשבון MY Renault שלך';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault מחובר';

  @override
  String get accountLinkedSuccess => 'החשבון שלך קושר בהצלחה';

  @override
  String brandConnected(String brand) {
    return '$brand מחובר';
  }

  @override
  String connectBrand(String brand) {
    return 'חבר $brand';
  }

  @override
  String get email => 'אימייל';

  @override
  String get countryNetherlands => 'הולנד';

  @override
  String get countryBelgium => 'בלגיה';

  @override
  String get countryGermany => 'גרמניה';

  @override
  String get countryFrance => 'צרפת';

  @override
  String get countryUnitedKingdom => 'בריטניה';

  @override
  String get countrySpain => 'ספרד';

  @override
  String get countryItaly => 'איטליה';

  @override
  String get countryPortugal => 'פורטוגל';

  @override
  String get enterEmailAndPassword => 'הזן את האימייל והסיסמה שלך';

  @override
  String get couldNotGetLoginUrl => 'לא ניתן היה לאחזר כתובת התחברות';

  @override
  String brandLinked(String brand) {
    return '$brand מקושר';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand מקושר (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return 'קישור $brand נכשל';
  }

  @override
  String get changesInNameColorIcon => 'שינויים בשם/צבע/סמל? לחץ חזרה וערוך.';

  @override
  String get notificationChannelCarDetection => 'זיהוי רכב';

  @override
  String get notificationChannelDescription =>
      'התראות לזיהוי רכב ורישום נסיעות';

  @override
  String get notificationNewCarDetected => 'רכב חדש זוהה';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'האם \"$deviceName\" הוא רכב שברצונך לעקוב אחריו?';
  }

  @override
  String get notificationTripStarted => 'הנסיעה התחילה';

  @override
  String get notificationTripTracking => 'הנסיעה שלך נמצאת כעת במעקב';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'הנסיעה שלך עם $carName נמצאת כעת במעקב';
  }

  @override
  String get notificationCarLinked => 'רכב מקושר';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" מקושר כעת ל-$carName';
  }

  @override
  String locationError(String error) {
    return 'שגיאת מיקום: $error';
  }
}
