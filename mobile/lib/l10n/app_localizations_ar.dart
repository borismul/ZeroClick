// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سجل المسافات';

  @override
  String get tabStatus => 'الحالة';

  @override
  String get tabTrips => 'الرحلات';

  @override
  String get tabSettings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get importantTitle => 'مهم';

  @override
  String get backgroundWarningMessage =>
      'يكتشف هذا التطبيق تلقائيًا عند ركوبك السيارة عبر البلوتوث.\n\nيعمل هذا فقط عندما يعمل التطبيق في الخلفية. إذا أغلقت التطبيق (السحب للأعلى)، سيتوقف الاكتشاف التلقائي.\n\nنصيحة: اترك التطبيق مفتوحًا وسيعمل كل شيء تلقائيًا.';

  @override
  String get understood => 'فهمت';

  @override
  String get loginPrompt => 'سجل الدخول للبدء';

  @override
  String get loginSubtitle =>
      'سجل الدخول بحساب Google وقم بتكوين واجهة برمجة السيارة';

  @override
  String get goToSettings => 'الذهاب للإعدادات';

  @override
  String get carPlayConnected => 'CarPlay متصل';

  @override
  String get offlineWarning => 'غير متصل - ستتم إضافة الإجراءات للقائمة';

  @override
  String get recentTrips => 'الرحلات الأخيرة';

  @override
  String get configureFirst => 'قم بتكوين التطبيق في الإعدادات أولاً';

  @override
  String get noTripsYet => 'لا توجد رحلات بعد';

  @override
  String routeLongerPercent(int percent) {
    return 'المسار أطول بـ +$percent%';
  }

  @override
  String get route => 'المسار';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get details => 'التفاصيل';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get distance => 'المسافة';

  @override
  String get type => 'النوع';

  @override
  String get tripTypeBusiness => 'عمل';

  @override
  String get tripTypePrivate => 'شخصي';

  @override
  String get tripTypeMixed => 'مختلط';

  @override
  String get googleMaps => 'خرائط Google';

  @override
  String get routeDeviation => 'انحراف المسار';

  @override
  String get car => 'السيارة';

  @override
  String routeDeviationWarning(int percent) {
    return 'المسار أطول بـ $percent% من المتوقع عبر خرائط Google';
  }

  @override
  String get editTrip => 'تعديل الرحلة';

  @override
  String get addTrip => 'إضافة رحلة';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get start => 'البداية';

  @override
  String get end => 'النهاية';

  @override
  String get fromPlaceholder => 'من';

  @override
  String get toPlaceholder => 'إلى';

  @override
  String get distanceAndType => 'المسافة والنوع';

  @override
  String get distanceKm => 'المسافة (كم)';

  @override
  String get businessKm => 'كم عمل';

  @override
  String get privateKm => 'كم شخصي';

  @override
  String get save => 'حفظ';

  @override
  String get add => 'إضافة';

  @override
  String get deleteTrip => 'حذف الرحلة؟';

  @override
  String get deleteTripConfirmation => 'هل أنت متأكد من حذف هذه الرحلة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get couldNotDelete => 'تعذر الحذف';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get trips => 'الرحلات';

  @override
  String get total => 'الإجمالي';

  @override
  String get business => 'عمل';

  @override
  String get private => 'شخصي';

  @override
  String get account => 'الحساب';

  @override
  String get loggedIn => 'تم تسجيل الدخول';

  @override
  String get googleAccount => 'حساب Google';

  @override
  String get loginWithGoogle => 'تسجيل الدخول بـ Google';

  @override
  String get myCars => 'سياراتي';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سيارة',
      few: '$count سيارات',
      two: 'سيارتان',
      one: 'سيارة واحدة',
      zero: '0 سيارات',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'إدارة مركباتك';

  @override
  String get location => 'الموقع';

  @override
  String get requestLocationPermission => 'طلب إذن الموقع';

  @override
  String get openIOSSettings => 'فتح إعدادات iOS';

  @override
  String get locationPermissionGranted => 'تم منح إذن الموقع!';

  @override
  String get locationPermissionDenied => 'تم رفض إذن الموقع - اذهب للإعدادات';

  @override
  String get enableLocationServices =>
      'قم بتفعيل خدمات الموقع في إعدادات iOS أولاً';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'الاكتشاف التلقائي';

  @override
  String get autoDetectionSubtitle =>
      'بدء/إيقاف الرحلات تلقائيًا عند اتصال CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay متصل';

  @override
  String get queue => 'قائمة الانتظار';

  @override
  String queueItems(int count) {
    return '$count عناصر في الانتظار';
  }

  @override
  String get queueSubtitle => 'سيتم إرسالها عند الاتصال';

  @override
  String get sendNow => 'إرسال الآن';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get aboutDescription =>
      'يحل هذا التطبيق محل أتمتة اختصارات iPhone لتسجيل المسافات. يكتشف تلقائيًا عند ركوبك السيارة عبر البلوتوث/CarPlay ويسجل الرحلات.';

  @override
  String loggedInAs(String email) {
    return 'تم تسجيل الدخول كـ $email';
  }

  @override
  String errorSaving(String error) {
    return 'خطأ في الحفظ: $error';
  }

  @override
  String get carSettingsSaved => 'تم حفظ إعدادات السيارة';

  @override
  String get enterUsernamePassword => 'أدخل اسم المستخدم وكلمة المرور';

  @override
  String get cars => 'السيارات';

  @override
  String get addCar => 'إضافة سيارة';

  @override
  String get noCarsAdded => 'لم تتم إضافة سيارات بعد';

  @override
  String get defaultBadge => 'افتراضي';

  @override
  String get editCar => 'تعديل السيارة';

  @override
  String get name => 'الاسم';

  @override
  String get nameHint => 'مثال: Audi Q4 e-tron';

  @override
  String get enterName => 'أدخل اسمًا';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get color => 'اللون';

  @override
  String get icon => 'الأيقونة';

  @override
  String get defaultCar => 'السيارة الافتراضية';

  @override
  String get defaultCarSubtitle => 'ستُربط الرحلات الجديدة بهذه السيارة';

  @override
  String get bluetoothDevice => 'جهاز البلوتوث';

  @override
  String get autoSetOnConnect => 'سيتم ضبطه تلقائيًا عند الاتصال';

  @override
  String get autoSetOnConnectFull =>
      'سيتم ضبطه تلقائيًا عند الاتصال بـ CarPlay/البلوتوث';

  @override
  String get carApiConnection => 'اتصال API السيارة';

  @override
  String connectWithBrand(String brand) {
    return 'اتصل بـ $brand للمسافة وحالة البطارية';
  }

  @override
  String get brandAudi => 'أودي';

  @override
  String get brandVolkswagen => 'فولكس فاجن';

  @override
  String get brandSkoda => 'سكودا';

  @override
  String get brandSeat => 'سيات';

  @override
  String get brandCupra => 'كوبرا';

  @override
  String get brandRenault => 'رينو';

  @override
  String get brandTesla => 'تسلا';

  @override
  String get brandBMW => 'بي إم دبليو';

  @override
  String get brandMercedes => 'مرسيدس';

  @override
  String get brandOther => 'أخرى';

  @override
  String get iconSedan => 'سيدان';

  @override
  String get iconSUV => 'دفع رباعي';

  @override
  String get iconHatchback => 'هاتشباك';

  @override
  String get iconSport => 'رياضية';

  @override
  String get iconVan => 'فان';

  @override
  String get loginWithTesla => 'تسجيل الدخول بـ Tesla';

  @override
  String get teslaLoginInfo =>
      'سيتم توجيهك إلى Tesla لتسجيل الدخول. بعد ذلك يمكنك عرض بيانات سيارتك.';

  @override
  String get usernameEmail => 'اسم المستخدم / البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get country => 'البلد';

  @override
  String get countryHint => 'SA';

  @override
  String get testApi => 'اختبار API';

  @override
  String get carUpdated => 'تم تحديث السيارة';

  @override
  String get carAdded => 'تمت إضافة السيارة';

  @override
  String errorMessage(String error) {
    return 'خطأ: $error';
  }

  @override
  String get carDeleted => 'تم حذف السيارة';

  @override
  String get deleteCar => 'حذف السيارة؟';

  @override
  String deleteCarConfirmation(String carName) {
    return 'هل أنت متأكد من حذف \"$carName\"؟ ستحتفظ جميع الرحلات المرتبطة بهذه السيارة ببياناتها.';
  }

  @override
  String get apiSettingsSaved => 'تم حفظ إعدادات API';

  @override
  String get teslaAlreadyLinked => 'Tesla مرتبطة بالفعل!';

  @override
  String get teslaLinked => 'تم ربط Tesla!';

  @override
  String get teslaLinkFailed => 'فشل ربط Tesla';

  @override
  String get startTrip => 'بدء الرحلة';

  @override
  String get stopTrip => 'إنهاء الرحلة';

  @override
  String get gpsActiveTracking => 'GPS نشط - تتبع تلقائي';

  @override
  String get activeTrip => 'رحلة نشطة';

  @override
  String startedAt(String time) {
    return 'البداية: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count نقطة GPS';
  }

  @override
  String get km => 'كم';

  @override
  String updatedAt(String time) {
    return 'آخر تحديث: $time';
  }

  @override
  String get battery => 'البطارية';

  @override
  String get status => 'الحالة';

  @override
  String get odometer => 'عداد المسافات';

  @override
  String get stateParked => 'متوقفة';

  @override
  String get stateDriving => 'تسير';

  @override
  String get stateCharging => 'تشحن';

  @override
  String get stateUnknown => 'غير معروف';

  @override
  String chargingPower(double power) {
    return 'الشحن: $power كيلوواط';
  }

  @override
  String readyIn(String time) {
    return 'جاهز خلال: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String get addFirstCar => 'أضف سيارتك الأولى';

  @override
  String get toTrackPerCar => 'لتتبع الرحلات لكل سيارة';

  @override
  String get selectCar => 'اختر سيارة';

  @override
  String get manageCars => 'إدارة السيارات';

  @override
  String get unknownDevice => 'جهاز غير معروف';

  @override
  String deviceName(String name) {
    return 'الجهاز: $name';
  }

  @override
  String get linkToCar => 'ربط بالسيارة:';

  @override
  String get noCarsFound => 'لم يتم العثور على سيارات. أضف سيارة أولاً.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return 'تم ربط $carName بـ $deviceName - بدأت الرحلة!';
  }

  @override
  String linkError(String error) {
    return 'خطأ في الربط: $error';
  }

  @override
  String get required => 'مطلوب';

  @override
  String get invalidDistance => 'مسافة غير صالحة';
}
