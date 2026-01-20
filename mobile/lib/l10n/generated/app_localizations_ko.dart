// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '주행 기록';

  @override
  String get tabStatus => '상태';

  @override
  String get tabTrips => '주행';

  @override
  String get tabSettings => '설정';

  @override
  String get tabCharging => '충전';

  @override
  String get chargingStations => '개의 충전소';

  @override
  String get logout => '로그아웃';

  @override
  String get importantTitle => '중요';

  @override
  String get backgroundWarningMessage =>
      '이 앱은 블루투스를 통해 차에 탑승했을 때 자동으로 감지합니다.\n\n이 기능은 앱이 백그라운드에서 실행 중일 때만 작동합니다. 앱을 닫으면(위로 스와이프) 자동 감지가 작동하지 않습니다.\n\n팁: 앱을 열어두면 모든 것이 자동으로 작동합니다.';

  @override
  String get understood => '확인';

  @override
  String get loginPrompt => '시작하려면 로그인하세요';

  @override
  String get loginSubtitle => 'Google 계정으로 로그인하고 차량 API를 설정하세요';

  @override
  String get goToSettings => '설정으로 이동';

  @override
  String get carPlayConnected => 'CarPlay 연결됨';

  @override
  String get offlineWarning => '오프라인 - 작업이 대기열에 추가됩니다';

  @override
  String get recentTrips => '최근 주행';

  @override
  String get configureFirst => '먼저 설정에서 앱을 구성하세요';

  @override
  String get noTripsYet => '아직 주행 기록이 없습니다';

  @override
  String routeLongerPercent(int percent) {
    return '경로 +$percent% 더 김';
  }

  @override
  String get route => '경로';

  @override
  String get from => '출발';

  @override
  String get to => '도착';

  @override
  String get details => '상세정보';

  @override
  String get date => '날짜';

  @override
  String get time => '시간';

  @override
  String get distance => '거리';

  @override
  String get type => '유형';

  @override
  String get tripTypeBusiness => '업무';

  @override
  String get tripTypePrivate => '개인';

  @override
  String get tripTypeMixed => '혼합';

  @override
  String get googleMaps => 'Google 지도';

  @override
  String get routeDeviation => '경로 편차';

  @override
  String get car => '차량';

  @override
  String routeDeviationWarning(int percent) {
    return '경로가 Google 지도 예상보다 $percent% 깁니다';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => '주행 편집';

  @override
  String get addTrip => '주행 추가';

  @override
  String get dateAndTime => '날짜 및 시간';

  @override
  String get start => '시작';

  @override
  String get end => '종료';

  @override
  String get fromPlaceholder => '출발지';

  @override
  String get toPlaceholder => '도착지';

  @override
  String get distanceAndType => '거리 및 유형';

  @override
  String get distanceKm => '거리 (km)';

  @override
  String get businessKm => '업무 km';

  @override
  String get privateKm => '개인 km';

  @override
  String get save => '저장';

  @override
  String get add => '추가';

  @override
  String get deleteTrip => '주행을 삭제하시겠습니까?';

  @override
  String get deleteTripConfirmation => '이 주행 기록을 삭제하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get somethingWentWrong => '문제가 발생했습니다';

  @override
  String get couldNotDelete => '삭제할 수 없습니다';

  @override
  String get statistics => '통계';

  @override
  String get trips => '주행';

  @override
  String get total => '총계';

  @override
  String get business => '업무';

  @override
  String get private => '개인';

  @override
  String get account => '계정';

  @override
  String get loggedIn => '로그인됨';

  @override
  String get googleAccount => 'Google 계정';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get myCars => '내 차량';

  @override
  String carsCount(int count) {
    return '$count대';
  }

  @override
  String get manageVehicles => '차량 관리';

  @override
  String get location => '위치';

  @override
  String get requestLocationPermission => '위치 권한 요청';

  @override
  String get openIOSSettings => 'iOS 설정 열기';

  @override
  String get locationPermissionGranted => '위치 권한이 허용되었습니다!';

  @override
  String get locationPermissionDenied => '위치 권한이 거부됨 - 설정으로 이동하세요';

  @override
  String get enableLocationServices => '먼저 iOS 설정에서 위치 서비스를 활성화하세요';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => '자동 감지';

  @override
  String get autoDetectionSubtitle => 'CarPlay 연결 시 자동으로 주행 시작/종료';

  @override
  String get carPlayIsConnected => 'CarPlay가 연결되어 있습니다';

  @override
  String get queue => '대기열';

  @override
  String queueItems(int count) {
    return '$count개 항목이 대기 중';
  }

  @override
  String get queueSubtitle => '온라인 시 전송됩니다';

  @override
  String get sendNow => '지금 전송';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get aboutDescription =>
      '이 앱은 iPhone 단축어 자동화를 대체하여 주행 기록을 관리합니다. 블루투스/CarPlay를 통해 차량 탑승을 자동 감지하고 주행을 기록합니다.';

  @override
  String loggedInAs(String email) {
    return '$email(으)로 로그인됨';
  }

  @override
  String errorSaving(String error) {
    return '저장 오류: $error';
  }

  @override
  String get carSettingsSaved => '차량 설정이 저장되었습니다';

  @override
  String get enterUsernamePassword => '사용자 이름과 비밀번호를 입력하세요';

  @override
  String get cars => '차량';

  @override
  String get addCar => '차량 추가';

  @override
  String get noCarsAdded => '아직 추가된 차량이 없습니다';

  @override
  String get defaultBadge => '기본';

  @override
  String get editCar => '차량 편집';

  @override
  String get name => '이름';

  @override
  String get nameHint => '예: Audi Q4 e-tron';

  @override
  String get enterName => '이름을 입력하세요';

  @override
  String get brand => '브랜드';

  @override
  String get color => '색상';

  @override
  String get icon => '아이콘';

  @override
  String get defaultCar => '기본 차량';

  @override
  String get defaultCarSubtitle => '새 주행이 이 차량에 연결됩니다';

  @override
  String get bluetoothDevice => '블루투스 장치';

  @override
  String get autoSetOnConnect => '연결 시 자동 설정됩니다';

  @override
  String get autoSetOnConnectFull => 'CarPlay/블루투스 연결 시 자동 설정됩니다';

  @override
  String get carApiConnection => '차량 API 연결';

  @override
  String connectWithBrand(String brand) {
    return '$brand에 연결하여 주행거리 및 배터리 상태 확인';
  }

  @override
  String get brandAudi => '아우디';

  @override
  String get brandVolkswagen => '폭스바겐';

  @override
  String get brandSkoda => '스코다';

  @override
  String get brandSeat => '세아트';

  @override
  String get brandCupra => '쿠프라';

  @override
  String get brandRenault => '르노';

  @override
  String get brandTesla => '테슬라';

  @override
  String get brandBMW => 'BMW';

  @override
  String get brandMercedes => '메르세데스';

  @override
  String get brandOther => '기타';

  @override
  String get iconSedan => '세단';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => '해치백';

  @override
  String get iconSport => '스포츠';

  @override
  String get iconVan => '밴';

  @override
  String get loginWithTesla => 'Tesla로 로그인';

  @override
  String get teslaLoginInfo => 'Tesla로 리디렉션되어 로그인합니다. 그 후 차량 데이터를 볼 수 있습니다.';

  @override
  String get usernameEmail => '사용자 이름 / 이메일';

  @override
  String get password => '비밀번호';

  @override
  String get country => '국가';

  @override
  String get countryHint => 'KR';

  @override
  String get testApi => 'API 테스트';

  @override
  String get carUpdated => '차량이 업데이트되었습니다';

  @override
  String get carAdded => '차량이 추가되었습니다';

  @override
  String errorMessage(String error) {
    return '오류: $error';
  }

  @override
  String get carDeleted => '차량이 삭제되었습니다';

  @override
  String get deleteCar => '차량을 삭제하시겠습니까?';

  @override
  String deleteCarConfirmation(String carName) {
    return '\"$carName\"을(를) 삭제하시겠습니까? 이 차량에 연결된 모든 주행 기록은 데이터를 유지합니다.';
  }

  @override
  String get apiSettingsSaved => 'API 설정이 저장되었습니다';

  @override
  String get teslaAlreadyLinked => 'Tesla가 이미 연결되어 있습니다!';

  @override
  String get teslaLinked => 'Tesla가 연결되었습니다!';

  @override
  String get teslaLinkFailed => 'Tesla 연결 실패';

  @override
  String get startTrip => '주행 시작';

  @override
  String get stopTrip => '주행 종료';

  @override
  String get gpsActiveTracking => 'GPS 활성 - 자동 추적 중';

  @override
  String get activeTrip => '진행 중인 주행';

  @override
  String startedAt(String time) {
    return '시작: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count개 GPS 포인트';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return '업데이트: $time';
  }

  @override
  String get battery => '배터리';

  @override
  String get status => '상태';

  @override
  String get odometer => '주행거리계';

  @override
  String get stateParked => '주차됨';

  @override
  String get stateDriving => '주행 중';

  @override
  String get stateCharging => '충전 중';

  @override
  String get stateUnknown => '알 수 없음';

  @override
  String chargingPower(double power) {
    return '충전: $power kW';
  }

  @override
  String readyIn(String time) {
    return '완료 예정: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes분';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String get addFirstCar => '첫 번째 차량 추가';

  @override
  String get toTrackPerCar => '차량별 주행 추적';

  @override
  String get selectCar => '차량 선택';

  @override
  String get manageCars => '차량 관리';

  @override
  String get unknownDevice => '알 수 없는 장치';

  @override
  String deviceName(String name) {
    return '장치: $name';
  }

  @override
  String get linkToCar => '차량에 연결:';

  @override
  String get noCarsFound => '차량을 찾을 수 없습니다. 먼저 차량을 추가하세요.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName이(가) $deviceName에 연결됨 - 주행 시작!';
  }

  @override
  String linkError(String error) {
    return '연결 오류: $error';
  }

  @override
  String get required => '필수';

  @override
  String get invalidDistance => '잘못된 거리';

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
}
