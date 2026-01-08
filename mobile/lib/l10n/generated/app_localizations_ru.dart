// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Учёт Пробега';

  @override
  String get tabStatus => 'Статус';

  @override
  String get tabTrips => 'Поездки';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get tabCharging => 'Зарядка';

  @override
  String get chargingStations => 'зарядных станций';

  @override
  String get logout => 'Выйти';

  @override
  String get importantTitle => 'Важно';

  @override
  String get backgroundWarningMessage =>
      'Это приложение автоматически определяет, когда вы садитесь в автомобиль через Bluetooth.\n\nЭто работает только когда приложение работает в фоновом режиме. Если вы закроете приложение (смахнув вверх), автоматическое определение перестанет работать.\n\nСовет: Просто оставьте приложение открытым, и всё будет работать автоматически.';

  @override
  String get understood => 'Понятно';

  @override
  String get loginPrompt => 'Войдите, чтобы начать';

  @override
  String get loginSubtitle =>
      'Войдите с помощью аккаунта Google и настройте API автомобиля';

  @override
  String get goToSettings => 'Перейти в Настройки';

  @override
  String get carPlayConnected => 'CarPlay подключён';

  @override
  String get offlineWarning => 'Офлайн - действия будут добавлены в очередь';

  @override
  String get recentTrips => 'Последние поездки';

  @override
  String get configureFirst => 'Сначала настройте приложение в Настройках';

  @override
  String get noTripsYet => 'Пока нет поездок';

  @override
  String routeLongerPercent(int percent) {
    return 'Маршрут +$percent% длиннее';
  }

  @override
  String get route => 'Маршрут';

  @override
  String get from => 'Откуда';

  @override
  String get to => 'Куда';

  @override
  String get details => 'Детали';

  @override
  String get date => 'Дата';

  @override
  String get time => 'Время';

  @override
  String get distance => 'Расстояние';

  @override
  String get type => 'Тип';

  @override
  String get tripTypeBusiness => 'Рабочая';

  @override
  String get tripTypePrivate => 'Личная';

  @override
  String get tripTypeMixed => 'Смешанная';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Отклонение маршрута';

  @override
  String get car => 'Автомобиль';

  @override
  String routeDeviationWarning(int percent) {
    return 'Маршрут на $percent% длиннее, чем ожидалось по Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Редактировать поездку';

  @override
  String get addTrip => 'Добавить поездку';

  @override
  String get dateAndTime => 'Дата и Время';

  @override
  String get start => 'Начало';

  @override
  String get end => 'Конец';

  @override
  String get fromPlaceholder => 'Откуда';

  @override
  String get toPlaceholder => 'Куда';

  @override
  String get distanceAndType => 'Расстояние и Тип';

  @override
  String get distanceKm => 'Расстояние (км)';

  @override
  String get businessKm => 'Рабочие км';

  @override
  String get privateKm => 'Личные км';

  @override
  String get save => 'Сохранить';

  @override
  String get add => 'Добавить';

  @override
  String get deleteTrip => 'Удалить поездку?';

  @override
  String get deleteTripConfirmation =>
      'Вы уверены, что хотите удалить эту поездку?';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get couldNotDelete => 'Не удалось удалить';

  @override
  String get statistics => 'Статистика';

  @override
  String get trips => 'Поездки';

  @override
  String get total => 'Всего';

  @override
  String get business => 'Рабочие';

  @override
  String get private => 'Личные';

  @override
  String get account => 'Аккаунт';

  @override
  String get loggedIn => 'Выполнен вход';

  @override
  String get googleAccount => 'Аккаунт Google';

  @override
  String get loginWithGoogle => 'Войти через Google';

  @override
  String get myCars => 'Мои Автомобили';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count автомобилей',
      few: '$count автомобиля',
      one: '1 автомобиль',
      zero: '0 автомобилей',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Управляйте своими транспортными средствами';

  @override
  String get location => 'Местоположение';

  @override
  String get requestLocationPermission =>
      'Запросить Разрешение на Местоположение';

  @override
  String get openIOSSettings => 'Открыть Настройки iOS';

  @override
  String get locationPermissionGranted =>
      'Разрешение на местоположение получено!';

  @override
  String get locationPermissionDenied =>
      'Разрешение на местоположение отклонено - перейдите в Настройки';

  @override
  String get enableLocationServices =>
      'Сначала включите Службы геолокации в Настройках iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Автоматическое определение';

  @override
  String get autoDetectionSubtitle =>
      'Автоматически начинать/заканчивать поездки при подключении CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay подключён';

  @override
  String get queue => 'Очередь';

  @override
  String queueItems(int count) {
    return '$count элементов в очереди';
  }

  @override
  String get queueSubtitle => 'Будут отправлены при подключении к сети';

  @override
  String get sendNow => 'Отправить сейчас';

  @override
  String get aboutApp => 'О приложении';

  @override
  String get aboutDescription =>
      'Это приложение заменяет автоматизацию Команд iPhone для учёта пробега. Оно автоматически определяет, когда вы садитесь в автомобиль через Bluetooth/CarPlay и записывает поездки.';

  @override
  String loggedInAs(String email) {
    return 'Вход выполнен как $email';
  }

  @override
  String errorSaving(String error) {
    return 'Ошибка сохранения: $error';
  }

  @override
  String get carSettingsSaved => 'Настройки автомобиля сохранены';

  @override
  String get enterUsernamePassword => 'Введите имя пользователя и пароль';

  @override
  String get cars => 'Автомобили';

  @override
  String get addCar => 'Добавить автомобиль';

  @override
  String get noCarsAdded => 'Автомобили ещё не добавлены';

  @override
  String get defaultBadge => 'По умолчанию';

  @override
  String get editCar => 'Редактировать автомобиль';

  @override
  String get name => 'Название';

  @override
  String get nameHint => 'Напр. Audi Q4 e-tron';

  @override
  String get enterName => 'Введите название';

  @override
  String get brand => 'Марка';

  @override
  String get color => 'Цвет';

  @override
  String get icon => 'Иконка';

  @override
  String get defaultCar => 'Автомобиль по умолчанию';

  @override
  String get defaultCarSubtitle =>
      'Новые поездки будут привязаны к этому автомобилю';

  @override
  String get bluetoothDevice => 'Устройство Bluetooth';

  @override
  String get autoSetOnConnect =>
      'Будет установлено автоматически при подключении';

  @override
  String get autoSetOnConnectFull =>
      'Будет установлено автоматически при подключении к CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Подключение API Автомобиля';

  @override
  String connectWithBrand(String brand) {
    return 'Подключитесь к $brand для пробега и статуса батареи';
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
  String get brandOther => 'Другое';

  @override
  String get iconSedan => 'Седан';

  @override
  String get iconSUV => 'Внедорожник';

  @override
  String get iconHatchback => 'Хэтчбек';

  @override
  String get iconSport => 'Спортивный';

  @override
  String get iconVan => 'Фургон';

  @override
  String get loginWithTesla => 'Войти через Tesla';

  @override
  String get teslaLoginInfo =>
      'Вы будете перенаправлены в Tesla для входа. После этого вы сможете просматривать данные своего автомобиля.';

  @override
  String get usernameEmail => 'Имя пользователя / Email';

  @override
  String get password => 'Пароль';

  @override
  String get country => 'Страна';

  @override
  String get countryHint => 'RU';

  @override
  String get testApi => 'Тест API';

  @override
  String get carUpdated => 'Автомобиль обновлён';

  @override
  String get carAdded => 'Автомобиль добавлен';

  @override
  String errorMessage(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get carDeleted => 'Автомобиль удалён';

  @override
  String get deleteCar => 'Удалить автомобиль?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Вы уверены, что хотите удалить \"$carName\"? Все поездки, привязанные к этому автомобилю, сохранят свои данные.';
  }

  @override
  String get apiSettingsSaved => 'Настройки API сохранены';

  @override
  String get teslaAlreadyLinked => 'Tesla уже подключена!';

  @override
  String get teslaLinked => 'Tesla подключена!';

  @override
  String get teslaLinkFailed => 'Не удалось подключить Tesla';

  @override
  String get startTrip => 'Начать Поездку';

  @override
  String get stopTrip => 'Завершить Поездку';

  @override
  String get gpsActiveTracking => 'GPS активен - автоматическое отслеживание';

  @override
  String get activeTrip => 'Активная поездка';

  @override
  String startedAt(String time) {
    return 'Начало: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count точек GPS';
  }

  @override
  String get km => 'км';

  @override
  String updatedAt(String time) {
    return 'Обновлено: $time';
  }

  @override
  String get battery => 'Батарея';

  @override
  String get status => 'Статус';

  @override
  String get odometer => 'Пробег';

  @override
  String get stateParked => 'Припаркован';

  @override
  String get stateDriving => 'В движении';

  @override
  String get stateCharging => 'Заряжается';

  @override
  String get stateUnknown => 'Неизвестно';

  @override
  String chargingPower(double power) {
    return 'Зарядка: $power кВт';
  }

  @override
  String readyIn(String time) {
    return 'Готов через: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes мин';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursч $minutesм';
  }

  @override
  String get addFirstCar => 'Добавьте свой первый автомобиль';

  @override
  String get toTrackPerCar => 'Для отслеживания поездок по автомобилям';

  @override
  String get selectCar => 'Выбрать автомобиль';

  @override
  String get manageCars => 'Управление автомобилями';

  @override
  String get unknownDevice => 'Неизвестное устройство';

  @override
  String deviceName(String name) {
    return 'Устройство: $name';
  }

  @override
  String get linkToCar => 'Привязать к автомобилю:';

  @override
  String get noCarsFound =>
      'Автомобили не найдены. Сначала добавьте автомобиль.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName привязан к $deviceName - Поездка началась!';
  }

  @override
  String linkError(String error) {
    return 'Ошибка привязки: $error';
  }

  @override
  String get required => 'Обязательно';

  @override
  String get invalidDistance => 'Неверное расстояние';

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
