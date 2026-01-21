// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Облік Пробігу';

  @override
  String get tabStatus => 'Статус';

  @override
  String get tabTrips => 'Поїздки';

  @override
  String get tabSettings => 'Налаштування';

  @override
  String get tabCharging => 'Зарядка';

  @override
  String get chargingStations => 'зарядних станцій';

  @override
  String get logout => 'Вийти';

  @override
  String get importantTitle => 'Важливо';

  @override
  String get backgroundWarningMessage =>
      'Цей додаток автоматично визначає, коли ви сідаєте в автомобіль через Bluetooth.\n\nЦе працює лише коли додаток працює у фоновому режимі. Якщо ви закриєте додаток (свайп вгору), автоматичне визначення перестане працювати.\n\nПорада: Просто залиште додаток відкритим, і все працюватиме автоматично.';

  @override
  String get understood => 'Зрозуміло';

  @override
  String get loginPrompt => 'Увійдіть, щоб почати';

  @override
  String get loginSubtitle =>
      'Увійдіть за допомогою облікового запису Google та налаштуйте API автомобіля';

  @override
  String get goToSettings => 'Перейти до Налаштувань';

  @override
  String get carPlayConnected => 'CarPlay підключено';

  @override
  String get offlineWarning => 'Офлайн - дії будуть додані в чергу';

  @override
  String get recentTrips => 'Останні поїздки';

  @override
  String get configureFirst => 'Спочатку налаштуйте додаток в Налаштуваннях';

  @override
  String get noTripsYet => 'Поки що немає поїздок';

  @override
  String routeLongerPercent(int percent) {
    return 'Маршрут +$percent% довший';
  }

  @override
  String get route => 'Маршрут';

  @override
  String get from => 'Звідки';

  @override
  String get to => 'Куди';

  @override
  String get details => 'Деталі';

  @override
  String get date => 'Дата';

  @override
  String get time => 'Час';

  @override
  String get distance => 'Відстань';

  @override
  String get type => 'Тип';

  @override
  String get tripTypeBusiness => 'Робоча';

  @override
  String get tripTypePrivate => 'Особиста';

  @override
  String get tripTypeMixed => 'Змішана';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Відхилення маршруту';

  @override
  String get car => 'Автомобіль';

  @override
  String routeDeviationWarning(int percent) {
    return 'Маршрут на $percent% довший, ніж очікувалося за Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Редагувати поїздку';

  @override
  String get addTrip => 'Додати поїздку';

  @override
  String get dateAndTime => 'Дата і час';

  @override
  String get start => 'Початок';

  @override
  String get end => 'Кінець';

  @override
  String get fromPlaceholder => 'Звідки';

  @override
  String get toPlaceholder => 'Куди';

  @override
  String get distanceAndType => 'Відстань і тип';

  @override
  String get distanceKm => 'Відстань (км)';

  @override
  String get businessKm => 'Робочі км';

  @override
  String get privateKm => 'Особисті км';

  @override
  String get save => 'Зберегти';

  @override
  String get add => 'Додати';

  @override
  String get deleteTrip => 'Видалити поїздку?';

  @override
  String get deleteTripConfirmation =>
      'Ви впевнені, що хочете видалити цю поїздку?';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get somethingWentWrong => 'Щось пішло не так';

  @override
  String get couldNotDelete => 'Не вдалося видалити';

  @override
  String get statistics => 'Статистика';

  @override
  String get trips => 'Поїздки';

  @override
  String get total => 'Всього';

  @override
  String get business => 'Робочі';

  @override
  String get private => 'Особисті';

  @override
  String get account => 'Обліковий запис';

  @override
  String get loggedIn => 'Увійшли';

  @override
  String get googleAccount => 'Обліковий запис Google';

  @override
  String get loginWithGoogle => 'Увійти через Google';

  @override
  String get myCars => 'Мої Автомобілі';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count автомобілів',
      few: '$count автомобілі',
      one: '1 автомобіль',
      zero: '0 автомобілів',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Керуйте своїми транспортними засобами';

  @override
  String get location => 'Місцезнаходження';

  @override
  String get requestLocationPermission =>
      'Запросити Дозвіл на місцезнаходження';

  @override
  String get openIOSSettings => 'Відкрити Налаштування iOS';

  @override
  String get locationPermissionGranted => 'Дозвіл на місцезнаходження надано!';

  @override
  String get locationPermissionDenied =>
      'Дозвіл на місцезнаходження відхилено - перейдіть до Налаштувань';

  @override
  String get enableLocationServices =>
      'Спочатку увімкніть Служби геолокації в Налаштуваннях iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Автоматичне визначення';

  @override
  String get autoDetectionSubtitle =>
      'Автоматично починати/закінчувати поїздки при підключенні CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay підключено';

  @override
  String get queue => 'Черга';

  @override
  String queueItems(int count) {
    return '$count елементів у черзі';
  }

  @override
  String get queueSubtitle => 'Будуть надіслані при підключенні до мережі';

  @override
  String get sendNow => 'Надіслати зараз';

  @override
  String get aboutApp => 'Про додаток';

  @override
  String get aboutDescription =>
      'Цей додаток замінює автоматизацію Команд iPhone для обліку пробігу. Він автоматично визначає, коли ви сідаєте в автомобіль через Bluetooth/CarPlay і записує поїздки.';

  @override
  String loggedInAs(String email) {
    return 'Увійшли як $email';
  }

  @override
  String errorSaving(String error) {
    return 'Помилка збереження: $error';
  }

  @override
  String get carSettingsSaved => 'Налаштування автомобіля збережено';

  @override
  String get enterUsernamePassword => 'Введіть ім\'я користувача та пароль';

  @override
  String get cars => 'Автомобілі';

  @override
  String get addCar => 'Додати автомобіль';

  @override
  String get noCarsAdded => 'Автомобілі ще не додані';

  @override
  String get defaultBadge => 'За замовчуванням';

  @override
  String get editCar => 'Редагувати автомобіль';

  @override
  String get name => 'Назва';

  @override
  String get nameHint => 'Напр. Audi Q4 e-tron';

  @override
  String get enterName => 'Введіть назву';

  @override
  String get brand => 'Марка';

  @override
  String get color => 'Колір';

  @override
  String get icon => 'Іконка';

  @override
  String get defaultCar => 'Автомобіль за замовчуванням';

  @override
  String get defaultCarSubtitle =>
      'Нові поїздки будуть прив\'язані до цього автомобіля';

  @override
  String get bluetoothDevice => 'Пристрій Bluetooth';

  @override
  String get autoSetOnConnect => 'Буде встановлено автоматично при підключенні';

  @override
  String get autoSetOnConnectFull =>
      'Буде встановлено автоматично при підключенні до CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Підключення API автомобіля';

  @override
  String connectWithBrand(String brand) {
    return 'Підключіться до $brand для пробігу та стану батареї';
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
  String get brandOther => 'Інше';

  @override
  String get iconSedan => 'Седан';

  @override
  String get iconSUV => 'Позашляховик';

  @override
  String get iconHatchback => 'Хетчбек';

  @override
  String get iconSport => 'Спортивний';

  @override
  String get iconVan => 'Фургон';

  @override
  String get loginWithTesla => 'Увійти через Tesla';

  @override
  String get teslaLoginInfo =>
      'Вас буде перенаправлено на Tesla для входу. Після цього ви зможете переглядати дані свого автомобіля.';

  @override
  String get usernameEmail => 'Ім\'я користувача / Email';

  @override
  String get password => 'Пароль';

  @override
  String get country => 'Країна';

  @override
  String get countryHint => 'UA';

  @override
  String get testApi => 'Тест API';

  @override
  String get carUpdated => 'Автомобіль оновлено';

  @override
  String get carAdded => 'Автомобіль додано';

  @override
  String errorMessage(String error) {
    return 'Помилка: $error';
  }

  @override
  String get carDeleted => 'Автомобіль видалено';

  @override
  String get deleteCar => 'Видалити автомобіль?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Ви впевнені, що хочете видалити \"$carName\"? Усі поїздки, прив\'язані до цього автомобіля, збережуть свої дані.';
  }

  @override
  String get apiSettingsSaved => 'Налаштування API збережено';

  @override
  String get teslaAlreadyLinked => 'Tesla вже підключена!';

  @override
  String get teslaLinked => 'Tesla підключена!';

  @override
  String get teslaLinkFailed => 'Не вдалося підключити Tesla';

  @override
  String get startTrip => 'Почати Поїздку';

  @override
  String get stopTrip => 'Завершити Поїздку';

  @override
  String get gpsActiveTracking => 'GPS активний - автоматичне відстеження';

  @override
  String get activeTrip => 'Активна поїздка';

  @override
  String startedAt(String time) {
    return 'Початок: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count точок GPS';
  }

  @override
  String get km => 'км';

  @override
  String updatedAt(String time) {
    return 'Оновлено: $time';
  }

  @override
  String get battery => 'Батарея';

  @override
  String get status => 'Статус';

  @override
  String get odometer => 'Пробіг';

  @override
  String get stateParked => 'Припаркований';

  @override
  String get stateDriving => 'В русі';

  @override
  String get stateCharging => 'Заряджається';

  @override
  String get stateUnknown => 'Невідомо';

  @override
  String chargingPower(double power) {
    return 'Зарядка: $power кВт';
  }

  @override
  String readyIn(String time) {
    return 'Готовий через: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes хв';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursг $minutesхв';
  }

  @override
  String get addFirstCar => 'Додайте свій перший автомобіль';

  @override
  String get toTrackPerCar => 'Для відстеження поїздок по автомобілях';

  @override
  String get selectCar => 'Вибрати автомобіль';

  @override
  String get manageCars => 'Керування автомобілями';

  @override
  String get unknownDevice => 'Невідомий пристрій';

  @override
  String deviceName(String name) {
    return 'Пристрій: $name';
  }

  @override
  String get linkToCar => 'Прив\'язати до автомобіля:';

  @override
  String get noCarsFound =>
      'Автомобілі не знайдені. Спочатку додайте автомобіль.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName прив\'язано до $deviceName - Поїздка почалася!';
  }

  @override
  String linkError(String error) {
    return 'Помилка прив\'язки: $error';
  }

  @override
  String get required => 'Обов\'язково';

  @override
  String get invalidDistance => 'Невірна відстань';

  @override
  String get language => 'Мова';

  @override
  String get systemDefault => 'Системна за замовчуванням';

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
  String get retry => 'Повторити';

  @override
  String get ok => 'OK';

  @override
  String get noConnection => 'Немає з\'єднання';

  @override
  String get checkInternetConnection =>
      'Перевірте підключення до інтернету та спробуйте ще раз.';

  @override
  String get sessionExpired => 'Сесія закінчилась';

  @override
  String get loginAgainToContinue => 'Увійдіть знову, щоб продовжити.';

  @override
  String get serverError => 'Помилка сервера';

  @override
  String get tryAgainLater => 'Щось пішло не так. Спробуйте пізніше.';

  @override
  String get invalidInput => 'Невірний ввід';

  @override
  String get timeout => 'Час очікування вичерпано';

  @override
  String get serverNotResponding => 'Сервер не відповідає. Спробуйте ще раз.';

  @override
  String get error => 'Помилка';

  @override
  String get unexpectedError => 'Сталася неочікувана помилка.';

  @override
  String get setupCarTitle =>
      'Налаштуйте свій автомобіль для найкращого досвіду:';

  @override
  String get setupCarApiStep => 'Підключити API автомобіля';

  @override
  String get setupCarApiDescription =>
      'Перейдіть до Автомобілі → виберіть свій автомобіль → прив\'яжіть обліковий запис. Це дає доступ до показань пробігу та іншого.';

  @override
  String get setupBluetoothStep => 'Підключити Bluetooth';

  @override
  String get setupBluetoothDescription =>
      'Підключіть телефон через Bluetooth до автомобіля, відкрийте цей додаток і прив\'яжіть у сповіщенні. Це забезпечує надійне виявлення поїздок.';

  @override
  String get setupTip => 'Порада: Налаштуйте обидва для найкращої надійності!';

  @override
  String get developer => 'Розробник';

  @override
  String get debugLogs => 'Журнали налагодження';

  @override
  String get viewNativeLogs => 'Переглянути нативні логи iOS';

  @override
  String get copyAllLogs => 'Копіювати всі логи';

  @override
  String get logsCopied => 'Логи скопійовано в буфер обміну';

  @override
  String get loggedOut => 'Вийшли з системи';

  @override
  String get loginWithAudiId => 'Увійти через Audi ID';

  @override
  String get loginWithAudiDescription =>
      'Увійдіть за допомогою облікового запису myAudi';

  @override
  String get loginWithVolkswagenId => 'Увійти через Volkswagen ID';

  @override
  String get loginWithVolkswagenDescription =>
      'Увійдіть за допомогою облікового запису Volkswagen ID';

  @override
  String get loginWithSkodaId => 'Увійти через Skoda ID';

  @override
  String get loginWithSkodaDescription =>
      'Увійдіть за допомогою облікового запису Skoda ID';

  @override
  String get loginWithSeatId => 'Увійти через SEAT ID';

  @override
  String get loginWithSeatDescription =>
      'Увійдіть за допомогою облікового запису SEAT ID';

  @override
  String get loginWithCupraId => 'Увійти через CUPRA ID';

  @override
  String get loginWithCupraDescription =>
      'Увійдіть за допомогою облікового запису CUPRA ID';

  @override
  String get loginWithRenaultId => 'Увійти через Renault ID';

  @override
  String get loginWithRenaultDescription =>
      'Увійдіть за допомогою облікового запису MY Renault';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault підключено';

  @override
  String get accountLinkedSuccess => 'Ваш обліковий запис успішно прив\'язано';

  @override
  String brandConnected(String brand) {
    return '$brand підключено';
  }

  @override
  String connectBrand(String brand) {
    return 'Підключити $brand';
  }

  @override
  String get email => 'Електронна пошта';

  @override
  String get countryNetherlands => 'Нідерланди';

  @override
  String get countryBelgium => 'Бельгія';

  @override
  String get countryGermany => 'Німеччина';

  @override
  String get countryFrance => 'Франція';

  @override
  String get countryUnitedKingdom => 'Велика Британія';

  @override
  String get countrySpain => 'Іспанія';

  @override
  String get countryItaly => 'Італія';

  @override
  String get countryPortugal => 'Португалія';

  @override
  String get enterEmailAndPassword => 'Введіть вашу електронну пошту та пароль';

  @override
  String get couldNotGetLoginUrl => 'Не вдалося отримати URL для входу';

  @override
  String brandLinked(String brand) {
    return '$brand прив\'язано';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand прив\'язано (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return 'Не вдалося прив\'язати $brand';
  }

  @override
  String get changesInNameColorIcon =>
      'Зміни назви/кольору/іконки? Натисніть назад і відредагуйте.';

  @override
  String get notificationChannelCarDetection => 'Виявлення автомобіля';

  @override
  String get notificationChannelDescription =>
      'Сповіщення про виявлення автомобіля та реєстрацію поїздок';

  @override
  String get notificationNewCarDetected => 'Виявлено новий автомобіль';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return 'Чи \"$deviceName\" є автомобілем, який ви хочете відстежувати?';
  }

  @override
  String get notificationTripStarted => 'Поїздку розпочато';

  @override
  String get notificationTripTracking => 'Вашу поїздку зараз відстежують';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return 'Вашу поїздку на $carName зараз відстежують';
  }

  @override
  String get notificationCarLinked => 'Автомобіль прив\'язано';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" тепер прив\'язано до $carName';
  }

  @override
  String locationError(String error) {
    return 'Помилка місцезнаходження: $error';
  }
}
