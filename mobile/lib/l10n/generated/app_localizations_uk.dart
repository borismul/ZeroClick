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
}
