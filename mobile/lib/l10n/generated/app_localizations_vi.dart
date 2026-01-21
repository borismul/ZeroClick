// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ghi Số Km';

  @override
  String get tabStatus => 'Trạng thái';

  @override
  String get tabTrips => 'Chuyến đi';

  @override
  String get tabSettings => 'Cài đặt';

  @override
  String get tabCharging => 'Sạc';

  @override
  String get chargingStations => 'trạm sạc';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get importantTitle => 'Quan trọng';

  @override
  String get backgroundWarningMessage =>
      'Ứng dụng này tự động phát hiện khi bạn lên xe qua Bluetooth.\n\nĐiều này chỉ hoạt động nếu ứng dụng đang chạy nền. Nếu bạn đóng ứng dụng (vuốt lên), tự động phát hiện sẽ ngừng hoạt động.\n\nMẹo: Chỉ cần để ứng dụng mở, mọi thứ sẽ tự động hoạt động.';

  @override
  String get understood => 'Đã hiểu';

  @override
  String get loginPrompt => 'Đăng nhập để bắt đầu';

  @override
  String get loginSubtitle =>
      'Đăng nhập bằng tài khoản Google và cấu hình API xe';

  @override
  String get goToSettings => 'Đi đến Cài đặt';

  @override
  String get carPlayConnected => 'CarPlay đã kết nối';

  @override
  String get offlineWarning => 'Ngoại tuyến - các hành động sẽ được xếp hàng';

  @override
  String get recentTrips => 'Chuyến đi gần đây';

  @override
  String get configureFirst => 'Cấu hình ứng dụng trong Cài đặt trước';

  @override
  String get noTripsYet => 'Chưa có chuyến đi';

  @override
  String routeLongerPercent(int percent) {
    return 'Lộ trình dài hơn +$percent%';
  }

  @override
  String get route => 'Lộ trình';

  @override
  String get from => 'Từ';

  @override
  String get to => 'Đến';

  @override
  String get details => 'Chi tiết';

  @override
  String get date => 'Ngày';

  @override
  String get time => 'Giờ';

  @override
  String get distance => 'Khoảng cách';

  @override
  String get type => 'Loại';

  @override
  String get tripTypeBusiness => 'Công việc';

  @override
  String get tripTypePrivate => 'Cá nhân';

  @override
  String get tripTypeMixed => 'Hỗn hợp';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Độ lệch lộ trình';

  @override
  String get car => 'Xe';

  @override
  String routeDeviationWarning(int percent) {
    return 'Lộ trình dài hơn $percent% so với dự kiến từ Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Sửa chuyến đi';

  @override
  String get addTrip => 'Thêm chuyến đi';

  @override
  String get dateAndTime => 'Ngày & Giờ';

  @override
  String get start => 'Bắt đầu';

  @override
  String get end => 'Kết thúc';

  @override
  String get fromPlaceholder => 'Từ';

  @override
  String get toPlaceholder => 'Đến';

  @override
  String get distanceAndType => 'Khoảng cách & Loại';

  @override
  String get distanceKm => 'Khoảng cách (km)';

  @override
  String get businessKm => 'Km công việc';

  @override
  String get privateKm => 'Km cá nhân';

  @override
  String get save => 'Lưu';

  @override
  String get add => 'Thêm';

  @override
  String get deleteTrip => 'Xóa chuyến đi?';

  @override
  String get deleteTripConfirmation => 'Bạn có chắc muốn xóa chuyến đi này?';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get couldNotDelete => 'Không thể xóa';

  @override
  String get statistics => 'Thống kê';

  @override
  String get trips => 'Chuyến đi';

  @override
  String get total => 'Tổng';

  @override
  String get business => 'Công việc';

  @override
  String get private => 'Cá nhân';

  @override
  String get account => 'Tài khoản';

  @override
  String get loggedIn => 'Đã đăng nhập';

  @override
  String get googleAccount => 'Tài khoản Google';

  @override
  String get loginWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get myCars => 'Xe của tôi';

  @override
  String carsCount(int count) {
    return '$count xe';
  }

  @override
  String get manageVehicles => 'Quản lý phương tiện của bạn';

  @override
  String get location => 'Vị trí';

  @override
  String get requestLocationPermission => 'Yêu cầu Quyền Vị trí';

  @override
  String get openIOSSettings => 'Mở Cài đặt iOS';

  @override
  String get locationPermissionGranted => 'Đã cấp quyền vị trí!';

  @override
  String get locationPermissionDenied =>
      'Quyền vị trí bị từ chối - đi đến Cài đặt';

  @override
  String get enableLocationServices =>
      'Bật Dịch vụ Vị trí trong Cài đặt iOS trước';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Tự động phát hiện';

  @override
  String get autoDetectionSubtitle =>
      'Tự động bắt đầu/dừng chuyến đi khi CarPlay kết nối';

  @override
  String get carPlayIsConnected => 'CarPlay đã kết nối';

  @override
  String get queue => 'Hàng đợi';

  @override
  String queueItems(int count) {
    return '$count mục trong hàng đợi';
  }

  @override
  String get queueSubtitle => 'Sẽ được gửi khi trực tuyến';

  @override
  String get sendNow => 'Gửi ngay';

  @override
  String get aboutApp => 'Về ứng dụng này';

  @override
  String get aboutDescription =>
      'Ứng dụng này thay thế tự động hóa Phím tắt iPhone cho ghi số km. Tự động phát hiện khi bạn lên xe qua Bluetooth/CarPlay và ghi lại chuyến đi.';

  @override
  String loggedInAs(String email) {
    return 'Đăng nhập với $email';
  }

  @override
  String errorSaving(String error) {
    return 'Lỗi khi lưu: $error';
  }

  @override
  String get carSettingsSaved => 'Đã lưu cài đặt xe';

  @override
  String get enterUsernamePassword => 'Nhập tên người dùng và mật khẩu';

  @override
  String get cars => 'Xe';

  @override
  String get addCar => 'Thêm xe';

  @override
  String get noCarsAdded => 'Chưa thêm xe nào';

  @override
  String get defaultBadge => 'Mặc định';

  @override
  String get editCar => 'Sửa xe';

  @override
  String get name => 'Tên';

  @override
  String get nameHint => 'VD: Audi Q4 e-tron';

  @override
  String get enterName => 'Nhập tên';

  @override
  String get brand => 'Hãng';

  @override
  String get color => 'Màu';

  @override
  String get icon => 'Biểu tượng';

  @override
  String get defaultCar => 'Xe mặc định';

  @override
  String get defaultCarSubtitle => 'Chuyến đi mới sẽ được liên kết với xe này';

  @override
  String get bluetoothDevice => 'Thiết bị Bluetooth';

  @override
  String get autoSetOnConnect => 'Sẽ được đặt tự động khi kết nối';

  @override
  String get autoSetOnConnectFull =>
      'Sẽ được đặt tự động khi kết nối với CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Kết nối API Xe';

  @override
  String connectWithBrand(String brand) {
    return 'Kết nối với $brand để xem số km và tình trạng pin';
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
  String get brandOther => 'Khác';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Thể thao';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Đăng nhập bằng Tesla';

  @override
  String get teslaLoginInfo =>
      'Bạn sẽ được chuyển hướng đến Tesla để đăng nhập. Sau đó bạn có thể xem dữ liệu xe.';

  @override
  String get usernameEmail => 'Tên người dùng / Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get country => 'Quốc gia';

  @override
  String get countryHint => 'VN';

  @override
  String get testApi => 'Kiểm tra API';

  @override
  String get carUpdated => 'Đã cập nhật xe';

  @override
  String get carAdded => 'Đã thêm xe';

  @override
  String errorMessage(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get carDeleted => 'Đã xóa xe';

  @override
  String get deleteCar => 'Xóa xe?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Bạn có chắc muốn xóa \"$carName\"? Tất cả chuyến đi liên kết với xe này sẽ giữ lại dữ liệu.';
  }

  @override
  String get apiSettingsSaved => 'Đã lưu cài đặt API';

  @override
  String get teslaAlreadyLinked => 'Tesla đã được liên kết!';

  @override
  String get teslaLinked => 'Đã liên kết Tesla!';

  @override
  String get teslaLinkFailed => 'Liên kết Tesla thất bại';

  @override
  String get startTrip => 'Bắt đầu Chuyến đi';

  @override
  String get stopTrip => 'Kết thúc Chuyến đi';

  @override
  String get gpsActiveTracking => 'GPS đang hoạt động - theo dõi tự động';

  @override
  String get activeTrip => 'Chuyến đi đang diễn ra';

  @override
  String startedAt(String time) {
    return 'Bắt đầu: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count điểm GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Cập nhật: $time';
  }

  @override
  String get battery => 'Pin';

  @override
  String get status => 'Trạng thái';

  @override
  String get odometer => 'Đồng hồ km';

  @override
  String get stateParked => 'Đang đỗ';

  @override
  String get stateDriving => 'Đang lái';

  @override
  String get stateCharging => 'Đang sạc';

  @override
  String get stateUnknown => 'Không rõ';

  @override
  String chargingPower(double power) {
    return 'Sạc: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Hoàn thành trong: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes phút';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}g ${minutes}p';
  }

  @override
  String get addFirstCar => 'Thêm xe đầu tiên của bạn';

  @override
  String get toTrackPerCar => 'Để theo dõi chuyến đi theo xe';

  @override
  String get selectCar => 'Chọn xe';

  @override
  String get manageCars => 'Quản lý xe';

  @override
  String get unknownDevice => 'Thiết bị không xác định';

  @override
  String deviceName(String name) {
    return 'Thiết bị: $name';
  }

  @override
  String get linkToCar => 'Liên kết với xe:';

  @override
  String get noCarsFound => 'Không tìm thấy xe. Thêm xe trước.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName đã liên kết với $deviceName - Chuyến đi bắt đầu!';
  }

  @override
  String linkError(String error) {
    return 'Lỗi liên kết: $error';
  }

  @override
  String get required => 'Bắt buộc';

  @override
  String get invalidDistance => 'Khoảng cách không hợp lệ';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get systemDefault => 'Mặc định hệ thống';

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
  String get retry => 'Thử lại';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Không có kết nối';

  @override
  String get checkInternetConnection => 'Kiểm tra kết nối internet và thử lại.';

  @override
  String get sessionExpired => 'Phiên đã hết hạn';

  @override
  String get loginAgainToContinue => 'Đăng nhập lại để tiếp tục.';

  @override
  String get serverError => 'Lỗi máy chủ';

  @override
  String get tryAgainLater => 'Đã xảy ra lỗi. Vui lòng thử lại sau.';

  @override
  String get invalidInput => 'Đầu vào không hợp lệ';

  @override
  String get timeout => 'Hết thời gian';

  @override
  String get serverNotResponding => 'Máy chủ không phản hồi. Vui lòng thử lại.';

  @override
  String get error => 'Lỗi';

  @override
  String get unexpectedError => 'Đã xảy ra lỗi không mong muốn.';

  @override
  String get setupCarTitle => 'Thiết lập xe để có trải nghiệm tốt nhất:';

  @override
  String get setupCarApiStep => 'Kết nối API Xe';

  @override
  String get setupCarApiDescription =>
      'Đi đến Xe → chọn xe của bạn → liên kết tài khoản. Điều này cho phép bạn truy cập số km và nhiều hơn nữa.';

  @override
  String get setupBluetoothStep => 'Kết nối Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Kết nối điện thoại qua Bluetooth với xe, mở ứng dụng này và liên kết trong thông báo. Điều này đảm bảo phát hiện chuyến đi đáng tin cậy.';

  @override
  String get setupTip => 'Mẹo: Thiết lập cả hai để có độ tin cậy tốt nhất!';

  @override
  String get developer => 'Nhà phát triển';

  @override
  String get debugLogs => 'Nhật ký Debug';

  @override
  String get viewNativeLogs => 'Xem nhật ký iOS gốc';

  @override
  String get copyAllLogs => 'Sao chép tất cả nhật ký';

  @override
  String get logsCopied => 'Đã sao chép nhật ký vào clipboard';

  @override
  String get loggedOut => 'Đã đăng xuất';

  @override
  String get loginWithAudiId => 'Đăng nhập bằng Audi ID';

  @override
  String get loginWithAudiDescription =>
      'Đăng nhập bằng tài khoản myAudi của bạn';

  @override
  String get loginWithVolkswagenId => 'Đăng nhập bằng Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Đăng nhập bằng tài khoản Volkswagen ID của bạn';

  @override
  String get loginWithSkodaId => 'Đăng nhập bằng Skoda ID';

  @override
  String get loginWithSkodaDescription =>
      'Đăng nhập bằng tài khoản Skoda ID của bạn';

  @override
  String get loginWithSeatId => 'Đăng nhập bằng SEAT ID';

  @override
  String get loginWithSeatDescription =>
      'Đăng nhập bằng tài khoản SEAT ID của bạn';

  @override
  String get loginWithCupraId => 'Đăng nhập bằng CUPRA ID';

  @override
  String get loginWithCupraDescription =>
      'Đăng nhập bằng tài khoản CUPRA ID của bạn';

  @override
  String get loginWithRenaultId => 'Đăng nhập bằng Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'Đăng nhập bằng tài khoản MY Renault của bạn';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault đã kết nối';

  @override
  String get accountLinkedSuccess =>
      'Tài khoản của bạn đã được liên kết thành công';

  @override
  String brandConnected(String brand) {
    return '$brand đã kết nối';
  }

  @override
  String connectBrand(String brand) {
    return 'Kết nối $brand';
  }

  @override
  String get email => 'Email';

  @override
  String get countryNetherlands => 'Hà Lan';

  @override
  String get countryBelgium => 'Bỉ';

  @override
  String get countryGermany => 'Đức';

  @override
  String get countryFrance => 'Pháp';

  @override
  String get countryUnitedKingdom => 'Vương quốc Anh';

  @override
  String get countrySpain => 'Tây Ban Nha';

  @override
  String get countryItaly => 'Ý';

  @override
  String get countryPortugal => 'Bồ Đào Nha';

  @override
  String get enterEmailAndPassword => 'Nhập email và mật khẩu của bạn';

  @override
  String get couldNotGetLoginUrl => 'Không thể lấy URL đăng nhập';

  @override
  String brandLinked(String brand) {
    return '$brand đã liên kết';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand đã liên kết (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return 'Liên kết $brand thất bại';
  }

  @override
  String get changesInNameColorIcon =>
      'Thay đổi tên/màu/biểu tượng? Nhấn quay lại và chỉnh sửa.';

  @override
  String get notificationChannelCarDetection => 'Phát hiện Xe';

  @override
  String get notificationChannelDescription =>
      'Thông báo cho phát hiện xe và đăng ký chuyến đi';

  @override
  String get notificationNewCarDetected => 'Phát hiện xe mới';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return '\"$deviceName\" có phải là xe bạn muốn theo dõi không?';
  }

  @override
  String get notificationTripStarted => 'Chuyến đi Bắt đầu';

  @override
  String get notificationTripTracking => 'Chuyến đi của bạn đang được theo dõi';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Chuyến đi với $carName đang được theo dõi';
  }

  @override
  String get notificationCarLinked => 'Xe Đã Liên kết';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" đã được liên kết với $carName';
  }

  @override
  String locationError(String error) {
    return 'Lỗi vị trí: $error';
  }
}
