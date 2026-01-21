// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '里程记录';

  @override
  String get tabStatus => '状态';

  @override
  String get tabTrips => '行程';

  @override
  String get tabSettings => '设置';

  @override
  String get tabCharging => '充电';

  @override
  String get chargingStations => '个充电站';

  @override
  String get logout => '退出登录';

  @override
  String get importantTitle => '重要提示';

  @override
  String get backgroundWarningMessage =>
      '此应用通过蓝牙自动检测您何时上车。\n\n此功能仅在应用后台运行时有效。如果您关闭应用（上滑），自动检测将停止工作。\n\n提示：只需保持应用打开，一切将自动运行。';

  @override
  String get understood => '知道了';

  @override
  String get loginPrompt => '登录以开始';

  @override
  String get loginSubtitle => '使用Google账号登录并配置汽车API';

  @override
  String get goToSettings => '前往设置';

  @override
  String get carPlayConnected => 'CarPlay已连接';

  @override
  String get offlineWarning => '离线 - 操作将排队处理';

  @override
  String get recentTrips => '最近行程';

  @override
  String get configureFirst => '请先在设置中配置应用';

  @override
  String get noTripsYet => '暂无行程';

  @override
  String routeLongerPercent(int percent) {
    return '路线长$percent%';
  }

  @override
  String get route => '路线';

  @override
  String get from => '从';

  @override
  String get to => '到';

  @override
  String get details => '详情';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get distance => '距离';

  @override
  String get type => '类型';

  @override
  String get tripTypeBusiness => '商务';

  @override
  String get tripTypePrivate => '私人';

  @override
  String get tripTypeMixed => '混合';

  @override
  String get googleMaps => 'Google地图';

  @override
  String get routeDeviation => '路线偏差';

  @override
  String get car => '车辆';

  @override
  String routeDeviationWarning(int percent) {
    return '路线比Google地图预期长$percent%';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => '编辑行程';

  @override
  String get addTrip => '添加行程';

  @override
  String get dateAndTime => '日期和时间';

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get fromPlaceholder => '起点';

  @override
  String get toPlaceholder => '终点';

  @override
  String get distanceAndType => '距离和类型';

  @override
  String get distanceKm => '距离（公里）';

  @override
  String get businessKm => '商务公里';

  @override
  String get privateKm => '私人公里';

  @override
  String get save => '保存';

  @override
  String get add => '添加';

  @override
  String get deleteTrip => '删除行程？';

  @override
  String get deleteTripConfirmation => '确定要删除这次行程吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get somethingWentWrong => '出错了';

  @override
  String get couldNotDelete => '无法删除';

  @override
  String get statistics => '统计';

  @override
  String get trips => '行程';

  @override
  String get total => '总计';

  @override
  String get business => '商务';

  @override
  String get private => '私人';

  @override
  String get account => '账户';

  @override
  String get loggedIn => '已登录';

  @override
  String get googleAccount => 'Google账号';

  @override
  String get loginWithGoogle => '使用Google登录';

  @override
  String get myCars => '我的车辆';

  @override
  String carsCount(int count) {
    return '$count辆车';
  }

  @override
  String get manageVehicles => '管理您的车辆';

  @override
  String get location => '位置';

  @override
  String get requestLocationPermission => '请求位置权限';

  @override
  String get openIOSSettings => '打开iOS设置';

  @override
  String get locationPermissionGranted => '位置权限已授予！';

  @override
  String get locationPermissionDenied => '位置权限被拒绝 - 请前往设置';

  @override
  String get enableLocationServices => '请先在iOS设置中开启位置服务';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => '自动检测';

  @override
  String get autoDetectionSubtitle => '连接CarPlay时自动开始/结束行程';

  @override
  String get carPlayIsConnected => 'CarPlay已连接';

  @override
  String get queue => '队列';

  @override
  String queueItems(int count) {
    return '$count个待处理项目';
  }

  @override
  String get queueSubtitle => '联网后将自动发送';

  @override
  String get sendNow => '立即发送';

  @override
  String get aboutApp => '关于此应用';

  @override
  String get aboutDescription =>
      '此应用取代iPhone快捷指令自动化进行里程记录。它通过蓝牙/CarPlay自动检测您何时上车并记录行程。';

  @override
  String loggedInAs(String email) {
    return '已登录为 $email';
  }

  @override
  String errorSaving(String error) {
    return '保存错误：$error';
  }

  @override
  String get carSettingsSaved => '车辆设置已保存';

  @override
  String get enterUsernamePassword => '请输入用户名和密码';

  @override
  String get cars => '车辆';

  @override
  String get addCar => '添加车辆';

  @override
  String get noCarsAdded => '尚未添加车辆';

  @override
  String get defaultBadge => '默认';

  @override
  String get editCar => '编辑车辆';

  @override
  String get name => '名称';

  @override
  String get nameHint => '例如：奥迪Q4 e-tron';

  @override
  String get enterName => '请输入名称';

  @override
  String get brand => '品牌';

  @override
  String get color => '颜色';

  @override
  String get icon => '图标';

  @override
  String get defaultCar => '默认车辆';

  @override
  String get defaultCarSubtitle => '新行程将关联到此车辆';

  @override
  String get bluetoothDevice => '蓝牙设备';

  @override
  String get autoSetOnConnect => '连接时自动设置';

  @override
  String get autoSetOnConnectFull => '连接CarPlay/蓝牙时自动设置';

  @override
  String get carApiConnection => '车辆API连接';

  @override
  String connectWithBrand(String brand) {
    return '连接$brand以获取里程和电池状态';
  }

  @override
  String get brandAudi => '奥迪';

  @override
  String get brandVolkswagen => '大众';

  @override
  String get brandSkoda => '斯柯达';

  @override
  String get brandSeat => '西雅特';

  @override
  String get brandCupra => '库普拉';

  @override
  String get brandRenault => '雷诺';

  @override
  String get brandTesla => '特斯拉';

  @override
  String get brandBMW => '宝马';

  @override
  String get brandMercedes => '奔驰';

  @override
  String get brandOther => '其他';

  @override
  String get iconSedan => '轿车';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => '掀背车';

  @override
  String get iconSport => '跑车';

  @override
  String get iconVan => '面包车';

  @override
  String get loginWithTesla => '使用Tesla登录';

  @override
  String get teslaLoginInfo => '您将被重定向到Tesla登录。之后您可以查看车辆数据。';

  @override
  String get usernameEmail => '用户名/邮箱';

  @override
  String get password => '密码';

  @override
  String get country => '国家';

  @override
  String get countryHint => 'CN';

  @override
  String get testApi => '测试API';

  @override
  String get carUpdated => '车辆已更新';

  @override
  String get carAdded => '车辆已添加';

  @override
  String errorMessage(String error) {
    return '错误：$error';
  }

  @override
  String get carDeleted => '车辆已删除';

  @override
  String get deleteCar => '删除车辆？';

  @override
  String deleteCarConfirmation(String carName) {
    return '确定要删除「$carName」吗？与此车辆关联的所有行程将保留其数据。';
  }

  @override
  String get apiSettingsSaved => 'API设置已保存';

  @override
  String get teslaAlreadyLinked => 'Tesla已关联！';

  @override
  String get teslaLinked => 'Tesla已关联！';

  @override
  String get teslaLinkFailed => 'Tesla关联失败';

  @override
  String get startTrip => '开始行程';

  @override
  String get stopTrip => '结束行程';

  @override
  String get gpsActiveTracking => 'GPS已激活 - 自动追踪中';

  @override
  String get activeTrip => '进行中的行程';

  @override
  String startedAt(String time) {
    return '开始时间：$time';
  }

  @override
  String gpsPoints(int count) {
    return '$count个GPS点';
  }

  @override
  String get km => '公里';

  @override
  String updatedAt(String time) {
    return '更新时间：$time';
  }

  @override
  String get battery => '电池';

  @override
  String get status => '状态';

  @override
  String get odometer => '里程表';

  @override
  String get stateParked => '已停放';

  @override
  String get stateDriving => '行驶中';

  @override
  String get stateCharging => '充电中';

  @override
  String get stateUnknown => '未知';

  @override
  String chargingPower(double power) {
    return '充电功率：$power kW';
  }

  @override
  String readyIn(String time) {
    return '预计完成：$time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes分钟';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分';
  }

  @override
  String get addFirstCar => '添加您的第一辆车';

  @override
  String get toTrackPerCar => '按车辆追踪行程';

  @override
  String get selectCar => '选择车辆';

  @override
  String get manageCars => '管理车辆';

  @override
  String get unknownDevice => '未知设备';

  @override
  String deviceName(String name) {
    return '设备：$name';
  }

  @override
  String get linkToCar => '关联到车辆：';

  @override
  String get noCarsFound => '未找到车辆。请先添加车辆。';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName已关联到$deviceName - 行程已开始！';
  }

  @override
  String linkError(String error) {
    return '关联错误：$error';
  }

  @override
  String get required => '必填';

  @override
  String get invalidDistance => '无效距离';

  @override
  String get language => '语言';

  @override
  String get systemDefault => '系统默认';

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
  String get retry => '重试';

  @override
  String get ok => '确定';

  @override
  String get noConnection => '无网络连接';

  @override
  String get checkInternetConnection => '请检查网络连接后重试。';

  @override
  String get sessionExpired => '会话已过期';

  @override
  String get loginAgainToContinue => '请重新登录以继续。';

  @override
  String get serverError => '服务器错误';

  @override
  String get tryAgainLater => '出错了，请稍后重试。';

  @override
  String get invalidInput => '输入无效';

  @override
  String get timeout => '请求超时';

  @override
  String get serverNotResponding => '服务器无响应，请重试。';

  @override
  String get error => '错误';

  @override
  String get unexpectedError => '发生意外错误。';

  @override
  String get setupCarTitle => '设置您的车辆以获得最佳体验：';

  @override
  String get setupCarApiStep => '连接车辆API';

  @override
  String get setupCarApiDescription => '前往车辆 → 选择您的车辆 → 关联账户。这将让您访问里程表等信息。';

  @override
  String get setupBluetoothStep => '连接蓝牙';

  @override
  String get setupBluetoothDescription =>
      '通过蓝牙将手机连接到车辆，打开此应用并在通知中关联。这确保可靠的行程检测。';

  @override
  String get setupTip => '提示：两者都设置可获得最佳可靠性！';

  @override
  String get developer => '开发者';

  @override
  String get debugLogs => '调试日志';

  @override
  String get viewNativeLogs => '查看原生iOS日志';

  @override
  String get copyAllLogs => '复制所有日志';

  @override
  String get logsCopied => '日志已复制到剪贴板';

  @override
  String get loggedOut => '已退出登录';

  @override
  String get loginWithAudiId => '使用Audi ID登录';

  @override
  String get loginWithAudiDescription => '使用您的myAudi账户登录';

  @override
  String get loginWithVolkswagenId => '使用Volkswagen ID登录';

  @override
  String get loginWithVolkswagenDescription => '使用您的Volkswagen ID账户登录';

  @override
  String get loginWithSkodaId => '使用Skoda ID登录';

  @override
  String get loginWithSkodaDescription => '使用您的Skoda ID账户登录';

  @override
  String get loginWithSeatId => '使用SEAT ID登录';

  @override
  String get loginWithSeatDescription => '使用您的SEAT ID账户登录';

  @override
  String get loginWithCupraId => '使用CUPRA ID登录';

  @override
  String get loginWithCupraDescription => '使用您的CUPRA ID账户登录';

  @override
  String get loginWithRenaultId => '使用Renault ID登录';

  @override
  String get loginWithRenaultDescription => '使用您的MY Renault账户登录';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault已连接';

  @override
  String get accountLinkedSuccess => '您的账户已成功关联';

  @override
  String brandConnected(String brand) {
    return '$brand已连接';
  }

  @override
  String connectBrand(String brand) {
    return '连接$brand';
  }

  @override
  String get email => '邮箱';

  @override
  String get countryNetherlands => '荷兰';

  @override
  String get countryBelgium => '比利时';

  @override
  String get countryGermany => '德国';

  @override
  String get countryFrance => '法国';

  @override
  String get countryUnitedKingdom => '英国';

  @override
  String get countrySpain => '西班牙';

  @override
  String get countryItaly => '意大利';

  @override
  String get countryPortugal => '葡萄牙';

  @override
  String get enterEmailAndPassword => '请输入邮箱和密码';

  @override
  String get couldNotGetLoginUrl => '无法获取登录URL';

  @override
  String brandLinked(String brand) {
    return '$brand已关联';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand已关联（VIN：$vin）';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand关联失败';
  }

  @override
  String get changesInNameColorIcon => '需要修改名称/颜色/图标？请返回并编辑。';

  @override
  String get notificationChannelCarDetection => '车辆检测';

  @override
  String get notificationChannelDescription => '车辆检测和行程记录通知';

  @override
  String get notificationNewCarDetected => '检测到新车辆';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return '「$deviceName」是您要追踪的车辆吗？';
  }

  @override
  String get notificationTripStarted => '行程已开始';

  @override
  String get notificationTripTracking => '您的行程正在被追踪';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return '您使用$carName的行程正在被追踪';
  }

  @override
  String get notificationCarLinked => '车辆已关联';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '「$deviceName」已关联到$carName';
  }

  @override
  String locationError(String error) {
    return '位置错误：$error';
  }
}
