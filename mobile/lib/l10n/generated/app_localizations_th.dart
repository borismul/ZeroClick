// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'บันทึกระยะทาง';

  @override
  String get tabStatus => 'สถานะ';

  @override
  String get tabTrips => 'การเดินทาง';

  @override
  String get tabSettings => 'ตั้งค่า';

  @override
  String get tabCharging => 'ชาร์จ';

  @override
  String get chargingStations => 'สถานีชาร์จ';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get importantTitle => 'สำคัญ';

  @override
  String get backgroundWarningMessage =>
      'แอปนี้ตรวจจับอัตโนมัติเมื่อคุณขึ้นรถผ่าน Bluetooth\n\nใช้งานได้เฉพาะเมื่อแอปทำงานอยู่เบื้องหลัง หากคุณปิดแอป (ปัดขึ้น) การตรวจจับอัตโนมัติจะหยุดทำงาน\n\nเคล็ดลับ: ปล่อยให้แอปเปิดอยู่ และทุกอย่างจะทำงานอัตโนมัติ';

  @override
  String get understood => 'เข้าใจแล้ว';

  @override
  String get loginPrompt => 'เข้าสู่ระบบเพื่อเริ่มต้น';

  @override
  String get loginSubtitle =>
      'เข้าสู่ระบบด้วยบัญชี Google และกำหนดค่า API รถยนต์';

  @override
  String get goToSettings => 'ไปที่ตั้งค่า';

  @override
  String get carPlayConnected => 'CarPlay เชื่อมต่อแล้ว';

  @override
  String get offlineWarning => 'ออฟไลน์ - การดำเนินการจะถูกเข้าคิว';

  @override
  String get recentTrips => 'การเดินทางล่าสุด';

  @override
  String get configureFirst => 'กรุณากำหนดค่าแอปในตั้งค่าก่อน';

  @override
  String get noTripsYet => 'ยังไม่มีการเดินทาง';

  @override
  String routeLongerPercent(int percent) {
    return 'เส้นทางยาวขึ้น +$percent%';
  }

  @override
  String get route => 'เส้นทาง';

  @override
  String get from => 'จาก';

  @override
  String get to => 'ถึง';

  @override
  String get details => 'รายละเอียด';

  @override
  String get date => 'วันที่';

  @override
  String get time => 'เวลา';

  @override
  String get distance => 'ระยะทาง';

  @override
  String get type => 'ประเภท';

  @override
  String get tripTypeBusiness => 'ธุรกิจ';

  @override
  String get tripTypePrivate => 'ส่วนตัว';

  @override
  String get tripTypeMixed => 'ผสม';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'ความเบี่ยงเบนของเส้นทาง';

  @override
  String get car => 'รถยนต์';

  @override
  String routeDeviationWarning(int percent) {
    return 'เส้นทางยาวกว่าที่คาดไว้จาก Google Maps $percent%';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'แก้ไขการเดินทาง';

  @override
  String get addTrip => 'เพิ่มการเดินทาง';

  @override
  String get dateAndTime => 'วันที่และเวลา';

  @override
  String get start => 'เริ่ม';

  @override
  String get end => 'สิ้นสุด';

  @override
  String get fromPlaceholder => 'จาก';

  @override
  String get toPlaceholder => 'ถึง';

  @override
  String get distanceAndType => 'ระยะทางและประเภท';

  @override
  String get distanceKm => 'ระยะทาง (กม.)';

  @override
  String get businessKm => 'กม. ธุรกิจ';

  @override
  String get privateKm => 'กม. ส่วนตัว';

  @override
  String get save => 'บันทึก';

  @override
  String get add => 'เพิ่ม';

  @override
  String get deleteTrip => 'ลบการเดินทาง?';

  @override
  String get deleteTripConfirmation => 'คุณแน่ใจหรือไม่ที่จะลบการเดินทางนี้?';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get somethingWentWrong => 'เกิดข้อผิดพลาด';

  @override
  String get couldNotDelete => 'ไม่สามารถลบได้';

  @override
  String get statistics => 'สถิติ';

  @override
  String get trips => 'การเดินทาง';

  @override
  String get total => 'รวม';

  @override
  String get business => 'ธุรกิจ';

  @override
  String get private => 'ส่วนตัว';

  @override
  String get account => 'บัญชี';

  @override
  String get loggedIn => 'เข้าสู่ระบบแล้ว';

  @override
  String get googleAccount => 'บัญชี Google';

  @override
  String get loginWithGoogle => 'เข้าสู่ระบบด้วย Google';

  @override
  String get myCars => 'รถของฉัน';

  @override
  String carsCount(int count) {
    return '$count คัน';
  }

  @override
  String get manageVehicles => 'จัดการยานพาหนะของคุณ';

  @override
  String get location => 'ตำแหน่ง';

  @override
  String get requestLocationPermission => 'ขอสิทธิ์เข้าถึงตำแหน่ง';

  @override
  String get openIOSSettings => 'เปิดตั้งค่า iOS';

  @override
  String get locationPermissionGranted => 'ได้รับสิทธิ์เข้าถึงตำแหน่งแล้ว!';

  @override
  String get locationPermissionDenied =>
      'สิทธิ์เข้าถึงตำแหน่งถูกปฏิเสธ - ไปที่ตั้งค่า';

  @override
  String get enableLocationServices => 'เปิดใช้บริการตำแหน่งในตั้งค่า iOS ก่อน';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'ตรวจจับอัตโนมัติ';

  @override
  String get autoDetectionSubtitle =>
      'เริ่ม/หยุดการเดินทางอัตโนมัติเมื่อ CarPlay เชื่อมต่อ';

  @override
  String get carPlayIsConnected => 'CarPlay เชื่อมต่อแล้ว';

  @override
  String get queue => 'คิว';

  @override
  String queueItems(int count) {
    return '$count รายการในคิว';
  }

  @override
  String get queueSubtitle => 'จะถูกส่งเมื่อออนไลน์';

  @override
  String get sendNow => 'ส่งตอนนี้';

  @override
  String get aboutApp => 'เกี่ยวกับแอปนี้';

  @override
  String get aboutDescription =>
      'แอปนี้แทนที่การทำงานอัตโนมัติของคำสั่งลัด iPhone สำหรับบันทึกระยะทาง ตรวจจับอัตโนมัติเมื่อคุณขึ้นรถผ่าน Bluetooth/CarPlay และบันทึกการเดินทาง';

  @override
  String loggedInAs(String email) {
    return 'เข้าสู่ระบบในชื่อ $email';
  }

  @override
  String errorSaving(String error) {
    return 'บันทึกผิดพลาด: $error';
  }

  @override
  String get carSettingsSaved => 'บันทึกการตั้งค่ารถยนต์แล้ว';

  @override
  String get enterUsernamePassword => 'กรอกชื่อผู้ใช้และรหัสผ่าน';

  @override
  String get cars => 'รถยนต์';

  @override
  String get addCar => 'เพิ่มรถยนต์';

  @override
  String get noCarsAdded => 'ยังไม่มีรถยนต์';

  @override
  String get defaultBadge => 'ค่าเริ่มต้น';

  @override
  String get editCar => 'แก้ไขรถยนต์';

  @override
  String get name => 'ชื่อ';

  @override
  String get nameHint => 'เช่น Audi Q4 e-tron';

  @override
  String get enterName => 'กรอกชื่อ';

  @override
  String get brand => 'ยี่ห้อ';

  @override
  String get color => 'สี';

  @override
  String get icon => 'ไอคอน';

  @override
  String get defaultCar => 'รถยนต์ค่าเริ่มต้น';

  @override
  String get defaultCarSubtitle => 'การเดินทางใหม่จะเชื่อมโยงกับรถคันนี้';

  @override
  String get bluetoothDevice => 'อุปกรณ์ Bluetooth';

  @override
  String get autoSetOnConnect => 'จะตั้งค่าอัตโนมัติเมื่อเชื่อมต่อ';

  @override
  String get autoSetOnConnectFull =>
      'จะตั้งค่าอัตโนมัติเมื่อเชื่อมต่อกับ CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'การเชื่อมต่อ API รถยนต์';

  @override
  String connectWithBrand(String brand) {
    return 'เชื่อมต่อกับ $brand เพื่อดูระยะทางและสถานะแบตเตอรี่';
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
  String get brandOther => 'อื่นๆ';

  @override
  String get iconSedan => 'ซีดาน';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'แฮทช์แบ็ก';

  @override
  String get iconSport => 'สปอร์ต';

  @override
  String get iconVan => 'รถตู้';

  @override
  String get loginWithTesla => 'เข้าสู่ระบบด้วย Tesla';

  @override
  String get teslaLoginInfo =>
      'คุณจะถูกนำไปที่ Tesla เพื่อเข้าสู่ระบบ จากนั้นคุณสามารถดูข้อมูลรถของคุณได้';

  @override
  String get usernameEmail => 'ชื่อผู้ใช้ / อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get country => 'ประเทศ';

  @override
  String get countryHint => 'TH';

  @override
  String get testApi => 'ทดสอบ API';

  @override
  String get carUpdated => 'อัปเดตรถยนต์แล้ว';

  @override
  String get carAdded => 'เพิ่มรถยนต์แล้ว';

  @override
  String errorMessage(String error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get carDeleted => 'ลบรถยนต์แล้ว';

  @override
  String get deleteCar => 'ลบรถยนต์?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'คุณแน่ใจหรือไม่ที่จะลบ \"$carName\"? การเดินทางทั้งหมดที่เชื่อมโยงกับรถคันนี้จะเก็บข้อมูลไว้';
  }

  @override
  String get apiSettingsSaved => 'บันทึกการตั้งค่า API แล้ว';

  @override
  String get teslaAlreadyLinked => 'Tesla เชื่อมต่อแล้ว!';

  @override
  String get teslaLinked => 'เชื่อมต่อ Tesla แล้ว!';

  @override
  String get teslaLinkFailed => 'เชื่อมต่อ Tesla ไม่สำเร็จ';

  @override
  String get startTrip => 'เริ่มการเดินทาง';

  @override
  String get stopTrip => 'สิ้นสุดการเดินทาง';

  @override
  String get gpsActiveTracking => 'GPS ทำงาน - ติดตามอัตโนมัติ';

  @override
  String get activeTrip => 'การเดินทางปัจจุบัน';

  @override
  String startedAt(String time) {
    return 'เริ่ม: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count จุด GPS';
  }

  @override
  String get km => 'กม.';

  @override
  String updatedAt(String time) {
    return 'อัปเดต: $time';
  }

  @override
  String get battery => 'แบตเตอรี่';

  @override
  String get status => 'สถานะ';

  @override
  String get odometer => 'มาตรวัดระยะทาง';

  @override
  String get stateParked => 'จอดอยู่';

  @override
  String get stateDriving => 'กำลังขับ';

  @override
  String get stateCharging => 'กำลังชาร์จ';

  @override
  String get stateUnknown => 'ไม่ทราบ';

  @override
  String chargingPower(double power) {
    return 'ชาร์จ: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'พร้อมใน: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes นาที';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursชม. $minutesน.';
  }

  @override
  String get addFirstCar => 'เพิ่มรถคันแรกของคุณ';

  @override
  String get toTrackPerCar => 'เพื่อติดตามการเดินทางต่อรถ';

  @override
  String get selectCar => 'เลือกรถยนต์';

  @override
  String get manageCars => 'จัดการรถยนต์';

  @override
  String get unknownDevice => 'อุปกรณ์ไม่รู้จัก';

  @override
  String deviceName(String name) {
    return 'อุปกรณ์: $name';
  }

  @override
  String get linkToCar => 'เชื่อมต่อกับรถยนต์:';

  @override
  String get noCarsFound => 'ไม่พบรถยนต์ เพิ่มรถยนต์ก่อน';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName เชื่อมต่อกับ $deviceName แล้ว - เริ่มการเดินทาง!';
  }

  @override
  String linkError(String error) {
    return 'เชื่อมต่อผิดพลาด: $error';
  }

  @override
  String get required => 'จำเป็น';

  @override
  String get invalidDistance => 'ระยะทางไม่ถูกต้อง';

  @override
  String get language => 'ภาษา';

  @override
  String get systemDefault => 'ค่าเริ่มต้นระบบ';

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
  String get retry => 'ลองอีกครั้ง';

  @override
  String get ok => 'ตกลง';

  @override
  String get noConnection => 'ไม่มีการเชื่อมต่อ';

  @override
  String get checkInternetConnection =>
      'ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและลองอีกครั้ง';

  @override
  String get sessionExpired => 'เซสชันหมดอายุ';

  @override
  String get loginAgainToContinue => 'เข้าสู่ระบบอีกครั้งเพื่อดำเนินการต่อ';

  @override
  String get serverError => 'ข้อผิดพลาดเซิร์ฟเวอร์';

  @override
  String get tryAgainLater => 'เกิดข้อผิดพลาด กรุณาลองใหม่ภายหลัง';

  @override
  String get invalidInput => 'ข้อมูลไม่ถูกต้อง';

  @override
  String get timeout => 'หมดเวลา';

  @override
  String get serverNotResponding => 'เซิร์ฟเวอร์ไม่ตอบสนอง กรุณาลองอีกครั้ง';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get unexpectedError => 'เกิดข้อผิดพลาดที่ไม่คาดคิด';

  @override
  String get setupCarTitle => 'ตั้งค่ารถของคุณเพื่อประสบการณ์ที่ดีที่สุด:';

  @override
  String get setupCarApiStep => 'เชื่อมต่อ API รถยนต์';

  @override
  String get setupCarApiDescription =>
      'ไปที่ รถยนต์ → เลือกรถของคุณ → เชื่อมต่อบัญชี ซึ่งจะให้คุณเข้าถึงการอ่านมาตรวัดและอื่นๆ';

  @override
  String get setupBluetoothStep => 'เชื่อมต่อ Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'เชื่อมต่อโทรศัพท์ผ่าน Bluetooth กับรถ เปิดแอปนี้และเชื่อมต่อในการแจ้งเตือน เพื่อให้ตรวจจับการเดินทางได้อย่างน่าเชื่อถือ';

  @override
  String get setupTip =>
      'เคล็ดลับ: ตั้งค่าทั้งสองอย่างเพื่อความน่าเชื่อถือสูงสุด!';

  @override
  String get developer => 'นักพัฒนา';

  @override
  String get debugLogs => 'บันทึกการดีบัก';

  @override
  String get viewNativeLogs => 'ดูบันทึก iOS แบบเนทีฟ';

  @override
  String get copyAllLogs => 'คัดลอกบันทึกทั้งหมด';

  @override
  String get logsCopied => 'คัดลอกบันทึกไปยังคลิปบอร์ดแล้ว';

  @override
  String get loggedOut => 'ออกจากระบบแล้ว';

  @override
  String get loginWithAudiId => 'เข้าสู่ระบบด้วย Audi ID';

  @override
  String get loginWithAudiDescription => 'เข้าสู่ระบบด้วยบัญชี myAudi ของคุณ';

  @override
  String get loginWithVolkswagenId => 'เข้าสู่ระบบด้วย Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'เข้าสู่ระบบด้วยบัญชี Volkswagen ID ของคุณ';

  @override
  String get loginWithSkodaId => 'เข้าสู่ระบบด้วย Skoda ID';

  @override
  String get loginWithSkodaDescription =>
      'เข้าสู่ระบบด้วยบัญชี Skoda ID ของคุณ';

  @override
  String get loginWithSeatId => 'เข้าสู่ระบบด้วย SEAT ID';

  @override
  String get loginWithSeatDescription => 'เข้าสู่ระบบด้วยบัญชี SEAT ID ของคุณ';

  @override
  String get loginWithCupraId => 'เข้าสู่ระบบด้วย CUPRA ID';

  @override
  String get loginWithCupraDescription =>
      'เข้าสู่ระบบด้วยบัญชี CUPRA ID ของคุณ';

  @override
  String get loginWithRenaultId => 'เข้าสู่ระบบด้วย Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'เข้าสู่ระบบด้วยบัญชี MY Renault ของคุณ';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault เชื่อมต่อแล้ว';

  @override
  String get accountLinkedSuccess => 'เชื่อมต่อบัญชีของคุณสำเร็จแล้ว';

  @override
  String brandConnected(String brand) {
    return '$brand เชื่อมต่อแล้ว';
  }

  @override
  String connectBrand(String brand) {
    return 'เชื่อมต่อ $brand';
  }

  @override
  String get email => 'อีเมล';

  @override
  String get countryNetherlands => 'เนเธอร์แลนด์';

  @override
  String get countryBelgium => 'เบลเยียม';

  @override
  String get countryGermany => 'เยอรมนี';

  @override
  String get countryFrance => 'ฝรั่งเศส';

  @override
  String get countryUnitedKingdom => 'สหราชอาณาจักร';

  @override
  String get countrySpain => 'สเปน';

  @override
  String get countryItaly => 'อิตาลี';

  @override
  String get countryPortugal => 'โปรตุเกส';

  @override
  String get enterEmailAndPassword => 'กรอกอีเมลและรหัสผ่านของคุณ';

  @override
  String get couldNotGetLoginUrl => 'ไม่สามารถดึง URL เข้าสู่ระบบได้';

  @override
  String brandLinked(String brand) {
    return '$brand เชื่อมต่อแล้ว';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand เชื่อมต่อแล้ว (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return 'เชื่อมต่อ $brand ไม่สำเร็จ';
  }

  @override
  String get changesInNameColorIcon =>
      'เปลี่ยนชื่อ/สี/ไอคอน? กดย้อนกลับและแก้ไข';

  @override
  String get notificationChannelCarDetection => 'ตรวจจับรถยนต์';

  @override
  String get notificationChannelDescription =>
      'การแจ้งเตือนสำหรับการตรวจจับรถยนต์และการลงทะเบียนการเดินทาง';

  @override
  String get notificationNewCarDetected => 'ตรวจพบรถยนต์ใหม่';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return '\"$deviceName\" เป็นรถที่คุณต้องการติดตามหรือไม่?';
  }

  @override
  String get notificationTripStarted => 'การเดินทางเริ่มแล้ว';

  @override
  String get notificationTripTracking => 'การเดินทางของคุณกำลังถูกติดตาม';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'การเดินทางของคุณกับ $carName กำลังถูกติดตาม';
  }

  @override
  String get notificationCarLinked => 'เชื่อมต่อรถยนต์แล้ว';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" เชื่อมต่อกับ $carName แล้ว';
  }

  @override
  String locationError(String error) {
    return 'ข้อผิดพลาดตำแหน่ง: $error';
  }
}
