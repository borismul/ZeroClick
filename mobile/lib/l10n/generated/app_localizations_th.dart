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
