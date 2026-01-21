// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '走行距離記録';

  @override
  String get tabStatus => 'ステータス';

  @override
  String get tabTrips => '走行履歴';

  @override
  String get tabSettings => '設定';

  @override
  String get tabCharging => '充電';

  @override
  String get chargingStations => '件の充電スタンド';

  @override
  String get logout => 'ログアウト';

  @override
  String get importantTitle => '重要';

  @override
  String get backgroundWarningMessage =>
      'このアプリはBluetoothで車に乗ったことを自動検出します。\n\nこれはアプリがバックグラウンドで実行されている場合にのみ機能します。アプリを閉じると（上にスワイプ）、自動検出は機能しなくなります。\n\nヒント：アプリを開いたままにしておけば、すべて自動的に動作します。';

  @override
  String get understood => '了解';

  @override
  String get loginPrompt => 'ログインして開始';

  @override
  String get loginSubtitle => 'Googleアカウントでログインし、車のAPIを設定してください';

  @override
  String get goToSettings => '設定へ移動';

  @override
  String get carPlayConnected => 'CarPlay接続済み';

  @override
  String get offlineWarning => 'オフライン - アクションはキューに追加されます';

  @override
  String get recentTrips => '最近の走行';

  @override
  String get configureFirst => 'まず設定でアプリを構成してください';

  @override
  String get noTripsYet => '走行履歴はありません';

  @override
  String routeLongerPercent(int percent) {
    return 'ルート +$percent% 長い';
  }

  @override
  String get route => 'ルート';

  @override
  String get from => '出発地';

  @override
  String get to => '目的地';

  @override
  String get details => '詳細';

  @override
  String get date => '日付';

  @override
  String get time => '時間';

  @override
  String get distance => '距離';

  @override
  String get type => 'タイプ';

  @override
  String get tripTypeBusiness => '業務';

  @override
  String get tripTypePrivate => 'プライベート';

  @override
  String get tripTypeMixed => '混合';

  @override
  String get googleMaps => 'Google マップ';

  @override
  String get routeDeviation => 'ルート偏差';

  @override
  String get car => '車';

  @override
  String routeDeviationWarning(int percent) {
    return 'ルートはGoogleマップの予想より$percent%長いです';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => '走行を編集';

  @override
  String get addTrip => '走行を追加';

  @override
  String get dateAndTime => '日付と時間';

  @override
  String get start => '開始';

  @override
  String get end => '終了';

  @override
  String get fromPlaceholder => '出発地';

  @override
  String get toPlaceholder => '目的地';

  @override
  String get distanceAndType => '距離とタイプ';

  @override
  String get distanceKm => '距離（km）';

  @override
  String get businessKm => '業務 km';

  @override
  String get privateKm => 'プライベート km';

  @override
  String get save => '保存';

  @override
  String get add => '追加';

  @override
  String get deleteTrip => '走行を削除しますか？';

  @override
  String get deleteTripConfirmation => 'この走行を削除してもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get somethingWentWrong => 'エラーが発生しました';

  @override
  String get couldNotDelete => '削除できませんでした';

  @override
  String get statistics => '統計';

  @override
  String get trips => '走行';

  @override
  String get total => '合計';

  @override
  String get business => '業務';

  @override
  String get private => 'プライベート';

  @override
  String get account => 'アカウント';

  @override
  String get loggedIn => 'ログイン済み';

  @override
  String get googleAccount => 'Googleアカウント';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get myCars => 'マイカー';

  @override
  String carsCount(int count) {
    return '$count台';
  }

  @override
  String get manageVehicles => '車両を管理';

  @override
  String get location => '位置情報';

  @override
  String get requestLocationPermission => '位置情報の許可をリクエスト';

  @override
  String get openIOSSettings => 'iOS設定を開く';

  @override
  String get locationPermissionGranted => '位置情報の許可が付与されました！';

  @override
  String get locationPermissionDenied => '位置情報の許可が拒否されました - 設定に移動してください';

  @override
  String get enableLocationServices => 'まずiOS設定で位置情報サービスを有効にしてください';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => '自動検出';

  @override
  String get autoDetectionSubtitle => 'CarPlay接続時に自動的に走行を開始/停止';

  @override
  String get carPlayIsConnected => 'CarPlayが接続されています';

  @override
  String get queue => 'キュー';

  @override
  String queueItems(int count) {
    return '$count件がキューにあります';
  }

  @override
  String get queueSubtitle => 'オンライン時に送信されます';

  @override
  String get sendNow => '今すぐ送信';

  @override
  String get aboutApp => 'このアプリについて';

  @override
  String get aboutDescription =>
      'このアプリはiPhoneショートカットの自動化に代わる走行距離記録アプリです。Bluetooth/CarPlayで車に乗ったことを自動検出し、走行を記録します。';

  @override
  String loggedInAs(String email) {
    return '$emailとしてログイン中';
  }

  @override
  String errorSaving(String error) {
    return '保存エラー：$error';
  }

  @override
  String get carSettingsSaved => '車の設定が保存されました';

  @override
  String get enterUsernamePassword => 'ユーザー名とパスワードを入力してください';

  @override
  String get cars => '車';

  @override
  String get addCar => '車を追加';

  @override
  String get noCarsAdded => '車がまだ追加されていません';

  @override
  String get defaultBadge => 'デフォルト';

  @override
  String get editCar => '車を編集';

  @override
  String get name => '名前';

  @override
  String get nameHint => '例：Audi Q4 e-tron';

  @override
  String get enterName => '名前を入力してください';

  @override
  String get brand => 'ブランド';

  @override
  String get color => '色';

  @override
  String get icon => 'アイコン';

  @override
  String get defaultCar => 'デフォルト車両';

  @override
  String get defaultCarSubtitle => '新しい走行はこの車に関連付けられます';

  @override
  String get bluetoothDevice => 'Bluetoothデバイス';

  @override
  String get autoSetOnConnect => '接続時に自動設定されます';

  @override
  String get autoSetOnConnectFull => 'CarPlay/Bluetooth接続時に自動設定されます';

  @override
  String get carApiConnection => '車のAPI接続';

  @override
  String connectWithBrand(String brand) {
    return '$brandに接続して走行距離とバッテリー状態を取得';
  }

  @override
  String get brandAudi => 'アウディ';

  @override
  String get brandVolkswagen => 'フォルクスワーゲン';

  @override
  String get brandSkoda => 'シュコダ';

  @override
  String get brandSeat => 'セアト';

  @override
  String get brandCupra => 'クプラ';

  @override
  String get brandRenault => 'ルノー';

  @override
  String get brandTesla => 'テスラ';

  @override
  String get brandBMW => 'BMW';

  @override
  String get brandMercedes => 'メルセデス';

  @override
  String get brandOther => 'その他';

  @override
  String get iconSedan => 'セダン';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'ハッチバック';

  @override
  String get iconSport => 'スポーツ';

  @override
  String get iconVan => 'バン';

  @override
  String get loginWithTesla => 'Teslaでログイン';

  @override
  String get teslaLoginInfo => 'Teslaにリダイレクトされてログインします。その後、車のデータを表示できます。';

  @override
  String get usernameEmail => 'ユーザー名/メール';

  @override
  String get password => 'パスワード';

  @override
  String get country => '国';

  @override
  String get countryHint => 'JP';

  @override
  String get testApi => 'APIをテスト';

  @override
  String get carUpdated => '車が更新されました';

  @override
  String get carAdded => '車が追加されました';

  @override
  String errorMessage(String error) {
    return 'エラー：$error';
  }

  @override
  String get carDeleted => '車が削除されました';

  @override
  String get deleteCar => '車を削除しますか？';

  @override
  String deleteCarConfirmation(String carName) {
    return '「$carName」を削除してもよろしいですか？この車に関連付けられたすべての走行はデータを保持します。';
  }

  @override
  String get apiSettingsSaved => 'API設定が保存されました';

  @override
  String get teslaAlreadyLinked => 'Teslaは既にリンクされています！';

  @override
  String get teslaLinked => 'Teslaがリンクされました！';

  @override
  String get teslaLinkFailed => 'Teslaのリンクに失敗しました';

  @override
  String get startTrip => '走行を開始';

  @override
  String get stopTrip => '走行を終了';

  @override
  String get gpsActiveTracking => 'GPS有効 - 自動追跡中';

  @override
  String get activeTrip => '走行中';

  @override
  String startedAt(String time) {
    return '開始：$time';
  }

  @override
  String gpsPoints(int count) {
    return '$count個のGPSポイント';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return '更新：$time';
  }

  @override
  String get battery => 'バッテリー';

  @override
  String get status => 'ステータス';

  @override
  String get odometer => '走行距離計';

  @override
  String get stateParked => '駐車中';

  @override
  String get stateDriving => '走行中';

  @override
  String get stateCharging => '充電中';

  @override
  String get stateUnknown => '不明';

  @override
  String chargingPower(double power) {
    return '充電中：$power kW';
  }

  @override
  String readyIn(String time) {
    return '完了予定：$time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get addFirstCar => '最初の車を追加';

  @override
  String get toTrackPerCar => '車ごとに走行を追跡';

  @override
  String get selectCar => '車を選択';

  @override
  String get manageCars => '車を管理';

  @override
  String get unknownDevice => '不明なデバイス';

  @override
  String deviceName(String name) {
    return 'デバイス：$name';
  }

  @override
  String get linkToCar => '車にリンク：';

  @override
  String get noCarsFound => '車が見つかりません。まず車を追加してください。';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carNameが$deviceNameにリンクされました - 走行開始！';
  }

  @override
  String linkError(String error) {
    return 'リンクエラー：$error';
  }

  @override
  String get required => '必須';

  @override
  String get invalidDistance => '無効な距離';

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

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'No connection';

  @override
  String get checkInternetConnection =>
      'Check your internet connection and try again.';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get loginAgainToContinue => 'Log in again to continue.';

  @override
  String get serverError => 'Server error';

  @override
  String get tryAgainLater => 'Something went wrong. Please try again later.';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get timeout => 'Timeout';

  @override
  String get serverNotResponding =>
      'The server is not responding. Please try again.';

  @override
  String get error => 'Error';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get setupCarTitle => 'Set up your car for the best experience:';

  @override
  String get setupCarApiStep => 'Connect Car API';

  @override
  String get setupCarApiDescription =>
      'Go to Cars → choose your car → link your account. This gives you access to odometer readings and more.';

  @override
  String get setupBluetoothStep => 'Connect Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Connect your phone via Bluetooth to your car, open this app and link in the notification. This ensures reliable trip detection.';

  @override
  String get setupTip => 'Tip: Set up both for the best reliability!';

  @override
  String get developer => 'Developer';

  @override
  String get debugLogs => 'Debug Logs';

  @override
  String get viewNativeLogs => 'View native iOS logs';

  @override
  String get copyAllLogs => 'Copy all logs';

  @override
  String get logsCopied => 'Logs copied to clipboard';

  @override
  String get loggedOut => 'Logged out';

  @override
  String get loginWithAudiId => 'Log in with Audi ID';

  @override
  String get loginWithAudiDescription => 'Log in with your myAudi account';

  @override
  String get loginWithVolkswagenId => 'Log in with Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Log in with your Volkswagen ID account';

  @override
  String get loginWithSkodaId => 'Log in with Skoda ID';

  @override
  String get loginWithSkodaDescription => 'Log in with your Skoda ID account';

  @override
  String get loginWithSeatId => 'Log in with SEAT ID';

  @override
  String get loginWithSeatDescription => 'Log in with your SEAT ID account';

  @override
  String get loginWithCupraId => 'Log in with CUPRA ID';

  @override
  String get loginWithCupraDescription => 'Log in with your CUPRA ID account';

  @override
  String get loginWithRenaultId => 'Log in with Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'Log in with your MY Renault account';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault connected';

  @override
  String get accountLinkedSuccess =>
      'Your account has been successfully linked';

  @override
  String brandConnected(String brand) {
    return '$brand connected';
  }

  @override
  String connectBrand(String brand) {
    return 'Connect $brand';
  }

  @override
  String get email => 'Email';

  @override
  String get countryNetherlands => 'Netherlands';

  @override
  String get countryBelgium => 'Belgium';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryFrance => 'France';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryItaly => 'Italy';

  @override
  String get countryPortugal => 'Portugal';

  @override
  String get enterEmailAndPassword => 'Enter your email and password';

  @override
  String get couldNotGetLoginUrl => 'Could not retrieve login URL';

  @override
  String brandLinked(String brand) {
    return '$brand linked';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand linked (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand linking failed';
  }

  @override
  String get changesInNameColorIcon =>
      'Changes to name/color/icon? Press back and edit.';

  @override
  String get notificationChannelCarDetection => 'Car Detection';

  @override
  String get notificationChannelDescription =>
      'Notifications for car detection and trip registration';

  @override
  String get notificationNewCarDetected => 'New car detected';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'Is \"$deviceName\" a car you want to track?';
  }

  @override
  String get notificationTripStarted => 'Trip Started';

  @override
  String get notificationTripTracking => 'Your trip is now being tracked';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Your trip with $carName is now being tracked';
  }

  @override
  String get notificationCarLinked => 'Car Linked';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" is now linked to $carName';
  }

  @override
  String locationError(String error) {
    return 'Location error: $error';
  }
}
