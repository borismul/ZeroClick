// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Registro de Kilómetros';

  @override
  String get tabStatus => 'Estado';

  @override
  String get tabTrips => 'Viajes';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get tabCharging => 'Carga';

  @override
  String get chargingStations => 'puntos de carga';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get importantTitle => 'Importante';

  @override
  String get backgroundWarningMessage =>
      'Esta aplicación detecta automáticamente cuándo subes al coche a través de Bluetooth.\n\nEsto solo funciona si la aplicación está en segundo plano. Si cierras la aplicación (deslizar hacia arriba), la detección automática dejará de funcionar.\n\nConsejo: Simplemente deja la aplicación abierta y todo funcionará automáticamente.';

  @override
  String get understood => 'Entendido';

  @override
  String get loginPrompt => 'Inicia sesión para comenzar';

  @override
  String get loginSubtitle =>
      'Inicia sesión con tu cuenta de Google y configura la API del coche';

  @override
  String get goToSettings => 'Ir a Ajustes';

  @override
  String get carPlayConnected => 'CarPlay conectado';

  @override
  String get offlineWarning => 'Sin conexión - las acciones se pondrán en cola';

  @override
  String get recentTrips => 'Viajes recientes';

  @override
  String get configureFirst => 'Configura primero la aplicación en Ajustes';

  @override
  String get noTripsYet => 'Aún no hay viajes';

  @override
  String routeLongerPercent(int percent) {
    return 'Ruta +$percent% más larga';
  }

  @override
  String get route => 'Ruta';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get details => 'Detalles';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'Hora';

  @override
  String get distance => 'Distancia';

  @override
  String get type => 'Tipo';

  @override
  String get tripTypeBusiness => 'Trabajo';

  @override
  String get tripTypePrivate => 'Personal';

  @override
  String get tripTypeMixed => 'Mixto';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Desviación de ruta';

  @override
  String get car => 'Coche';

  @override
  String routeDeviationWarning(int percent) {
    return 'La ruta es $percent% más larga de lo esperado según Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Editar viaje';

  @override
  String get addTrip => 'Añadir viaje';

  @override
  String get dateAndTime => 'Fecha y Hora';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get fromPlaceholder => 'Desde';

  @override
  String get toPlaceholder => 'Hasta';

  @override
  String get distanceAndType => 'Distancia y Tipo';

  @override
  String get distanceKm => 'Distancia (km)';

  @override
  String get businessKm => 'Km trabajo';

  @override
  String get privateKm => 'Km personal';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Añadir';

  @override
  String get deleteTrip => '¿Eliminar viaje?';

  @override
  String get deleteTripConfirmation =>
      '¿Estás seguro de que quieres eliminar este viaje?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get couldNotDelete => 'No se pudo eliminar';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get trips => 'Viajes';

  @override
  String get total => 'Total';

  @override
  String get business => 'Trabajo';

  @override
  String get private => 'Personal';

  @override
  String get account => 'Cuenta';

  @override
  String get loggedIn => 'Conectado';

  @override
  String get googleAccount => 'Cuenta de Google';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get myCars => 'Mis Coches';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coches',
      one: '1 coche',
      zero: '0 coches',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Gestiona tus vehículos';

  @override
  String get location => 'Ubicación';

  @override
  String get requestLocationPermission => 'Solicitar Permiso de Ubicación';

  @override
  String get openIOSSettings => 'Abrir Ajustes de iOS';

  @override
  String get locationPermissionGranted => '¡Permiso de ubicación concedido!';

  @override
  String get locationPermissionDenied =>
      'Permiso de ubicación denegado - ve a Ajustes';

  @override
  String get enableLocationServices =>
      'Primero activa los Servicios de ubicación en los Ajustes de iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Detección automática';

  @override
  String get autoDetectionSubtitle =>
      'Iniciar/parar viajes automáticamente al conectar CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay está conectado';

  @override
  String get queue => 'Cola';

  @override
  String queueItems(int count) {
    return '$count elementos en cola';
  }

  @override
  String get queueSubtitle => 'Se enviarán cuando haya conexión';

  @override
  String get sendNow => 'Enviar ahora';

  @override
  String get aboutApp => 'Acerca de esta aplicación';

  @override
  String get aboutDescription =>
      'Esta aplicación reemplaza la automatización de Atajos de iPhone para el registro de kilómetros. Detecta automáticamente cuándo subes al coche a través de Bluetooth/CarPlay y registra los viajes.';

  @override
  String loggedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String errorSaving(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get carSettingsSaved => 'Ajustes del coche guardados';

  @override
  String get enterUsernamePassword => 'Introduce usuario y contraseña';

  @override
  String get cars => 'Coches';

  @override
  String get addCar => 'Añadir coche';

  @override
  String get noCarsAdded => 'Aún no hay coches añadidos';

  @override
  String get defaultBadge => 'Predeterminado';

  @override
  String get editCar => 'Editar coche';

  @override
  String get name => 'Nombre';

  @override
  String get nameHint => 'Ej. Audi Q4 e-tron';

  @override
  String get enterName => 'Introduce un nombre';

  @override
  String get brand => 'Marca';

  @override
  String get color => 'Color';

  @override
  String get icon => 'Icono';

  @override
  String get defaultCar => 'Coche predeterminado';

  @override
  String get defaultCarSubtitle =>
      'Los nuevos viajes se vincularán a este coche';

  @override
  String get bluetoothDevice => 'Dispositivo Bluetooth';

  @override
  String get autoSetOnConnect => 'Se configurará automáticamente al conectar';

  @override
  String get autoSetOnConnectFull =>
      'Se configurará automáticamente al conectar a CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Conexión API del Coche';

  @override
  String connectWithBrand(String brand) {
    return 'Conecta con $brand para kilometraje y estado de batería';
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
  String get brandOther => 'Otro';

  @override
  String get iconSedan => 'Sedán';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Compacto';

  @override
  String get iconSport => 'Deportivo';

  @override
  String get iconVan => 'Furgoneta';

  @override
  String get loginWithTesla => 'Iniciar sesión con Tesla';

  @override
  String get teslaLoginInfo =>
      'Serás redirigido a Tesla para iniciar sesión. Después podrás ver los datos de tu coche.';

  @override
  String get usernameEmail => 'Usuario / Email';

  @override
  String get password => 'Contraseña';

  @override
  String get country => 'País';

  @override
  String get countryHint => 'ES';

  @override
  String get testApi => 'Probar API';

  @override
  String get carUpdated => 'Coche actualizado';

  @override
  String get carAdded => 'Coche añadido';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get carDeleted => 'Coche eliminado';

  @override
  String get deleteCar => '¿Eliminar coche?';

  @override
  String deleteCarConfirmation(String carName) {
    return '¿Estás seguro de que quieres eliminar \"$carName\"? Todos los viajes vinculados a este coche conservarán sus datos.';
  }

  @override
  String get apiSettingsSaved => 'Ajustes de API guardados';

  @override
  String get teslaAlreadyLinked => '¡Tesla ya está vinculado!';

  @override
  String get teslaLinked => '¡Tesla vinculado!';

  @override
  String get teslaLinkFailed => 'Error al vincular Tesla';

  @override
  String get startTrip => 'Iniciar Viaje';

  @override
  String get stopTrip => 'Terminar Viaje';

  @override
  String get gpsActiveTracking => 'GPS activo - seguimiento automático';

  @override
  String get activeTrip => 'Viaje activo';

  @override
  String startedAt(String time) {
    return 'Iniciado: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count puntos GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Actualizado: $time';
  }

  @override
  String get battery => 'Batería';

  @override
  String get status => 'Estado';

  @override
  String get odometer => 'Kilometraje';

  @override
  String get stateParked => 'Aparcado';

  @override
  String get stateDriving => 'Conduciendo';

  @override
  String get stateCharging => 'Cargando';

  @override
  String get stateUnknown => 'Desconocido';

  @override
  String chargingPower(double power) {
    return 'Cargando: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Listo en: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get addFirstCar => 'Añade tu primer coche';

  @override
  String get toTrackPerCar => 'Para registrar viajes por coche';

  @override
  String get selectCar => 'Seleccionar coche';

  @override
  String get manageCars => 'Gestionar coches';

  @override
  String get unknownDevice => 'Dispositivo desconocido';

  @override
  String deviceName(String name) {
    return 'Dispositivo: $name';
  }

  @override
  String get linkToCar => 'Vincular al coche:';

  @override
  String get noCarsFound => 'No se encontraron coches. Añade primero un coche.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName vinculado a $deviceName - ¡Viaje iniciado!';
  }

  @override
  String linkError(String error) {
    return 'Error al vincular: $error';
  }

  @override
  String get required => 'Obligatorio';

  @override
  String get invalidDistance => 'Distancia inválida';

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
