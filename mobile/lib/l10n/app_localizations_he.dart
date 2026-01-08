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
}
