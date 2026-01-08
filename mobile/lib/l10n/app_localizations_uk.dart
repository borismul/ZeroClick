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
}
