// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Registro de Quilometragem';

  @override
  String get tabStatus => 'Estado';

  @override
  String get tabTrips => 'Viagens';

  @override
  String get tabSettings => 'Configurações';

  @override
  String get tabCharging => 'Carregamento';

  @override
  String get chargingStations => 'estações de carregamento';

  @override
  String get logout => 'Sair';

  @override
  String get importantTitle => 'Importante';

  @override
  String get backgroundWarningMessage =>
      'Este aplicativo detecta automaticamente quando você entra no carro via Bluetooth.\n\nIsso só funciona se o aplicativo estiver rodando em segundo plano. Se você fechar o aplicativo (deslizar para cima), a detecção automática deixará de funcionar.\n\nDica: Basta deixar o aplicativo aberto e tudo funcionará automaticamente.';

  @override
  String get understood => 'Entendi';

  @override
  String get loginPrompt => 'Entre para começar';

  @override
  String get loginSubtitle =>
      'Entre com sua conta Google e configure a API do carro';

  @override
  String get goToSettings => 'Ir para Configurações';

  @override
  String get carPlayConnected => 'CarPlay conectado';

  @override
  String get offlineWarning => 'Offline - ações serão enfileiradas';

  @override
  String get recentTrips => 'Viagens recentes';

  @override
  String get configureFirst =>
      'Configure primeiro o aplicativo em Configurações';

  @override
  String get noTripsYet => 'Ainda não há viagens';

  @override
  String routeLongerPercent(int percent) {
    return 'Rota +$percent% mais longa';
  }

  @override
  String get route => 'Rota';

  @override
  String get from => 'De';

  @override
  String get to => 'Para';

  @override
  String get details => 'Detalhes';

  @override
  String get date => 'Data';

  @override
  String get time => 'Hora';

  @override
  String get distance => 'Distância';

  @override
  String get type => 'Tipo';

  @override
  String get tripTypeBusiness => 'Trabalho';

  @override
  String get tripTypePrivate => 'Pessoal';

  @override
  String get tripTypeMixed => 'Misto';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Desvio de rota';

  @override
  String get car => 'Carro';

  @override
  String routeDeviationWarning(int percent) {
    return 'A rota é $percent% mais longa do que o esperado pelo Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Editar viagem';

  @override
  String get addTrip => 'Adicionar viagem';

  @override
  String get dateAndTime => 'Data e Hora';

  @override
  String get start => 'Início';

  @override
  String get end => 'Fim';

  @override
  String get fromPlaceholder => 'De';

  @override
  String get toPlaceholder => 'Para';

  @override
  String get distanceAndType => 'Distância e Tipo';

  @override
  String get distanceKm => 'Distância (km)';

  @override
  String get businessKm => 'Km trabalho';

  @override
  String get privateKm => 'Km pessoal';

  @override
  String get save => 'Salvar';

  @override
  String get add => 'Adicionar';

  @override
  String get deleteTrip => 'Excluir viagem?';

  @override
  String get deleteTripConfirmation =>
      'Tem certeza de que deseja excluir esta viagem?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get couldNotDelete => 'Não foi possível excluir';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get trips => 'Viagens';

  @override
  String get total => 'Total';

  @override
  String get business => 'Trabalho';

  @override
  String get private => 'Pessoal';

  @override
  String get account => 'Conta';

  @override
  String get loggedIn => 'Conectado';

  @override
  String get googleAccount => 'Conta Google';

  @override
  String get loginWithGoogle => 'Entrar com Google';

  @override
  String get myCars => 'Meus Carros';

  @override
  String carsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count carros',
      one: '1 carro',
      zero: '0 carros',
    );
    return '$_temp0';
  }

  @override
  String get manageVehicles => 'Gerencie seus veículos';

  @override
  String get location => 'Localização';

  @override
  String get requestLocationPermission => 'Solicitar Permissão de Localização';

  @override
  String get openIOSSettings => 'Abrir Configurações do iOS';

  @override
  String get locationPermissionGranted => 'Permissão de localização concedida!';

  @override
  String get locationPermissionDenied =>
      'Permissão de localização negada - vá para Configurações';

  @override
  String get enableLocationServices =>
      'Primeiro ative os Serviços de Localização nas Configurações do iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Detecção automática';

  @override
  String get autoDetectionSubtitle =>
      'Iniciar/parar viagens automaticamente ao conectar CarPlay';

  @override
  String get carPlayIsConnected => 'CarPlay está conectado';

  @override
  String get queue => 'Fila';

  @override
  String queueItems(int count) {
    return '$count itens na fila';
  }

  @override
  String get queueSubtitle => 'Serão enviados quando online';

  @override
  String get sendNow => 'Enviar agora';

  @override
  String get aboutApp => 'Sobre este aplicativo';

  @override
  String get aboutDescription =>
      'Este aplicativo substitui a automação de Atalhos do iPhone para registro de quilometragem. Ele detecta automaticamente quando você entra no carro via Bluetooth/CarPlay e registra as viagens.';

  @override
  String loggedInAs(String email) {
    return 'Conectado como $email';
  }

  @override
  String errorSaving(String error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get carSettingsSaved => 'Configurações do carro salvas';

  @override
  String get enterUsernamePassword => 'Digite usuário e senha';

  @override
  String get cars => 'Carros';

  @override
  String get addCar => 'Adicionar carro';

  @override
  String get noCarsAdded => 'Ainda não há carros adicionados';

  @override
  String get defaultBadge => 'Padrão';

  @override
  String get editCar => 'Editar carro';

  @override
  String get name => 'Nome';

  @override
  String get nameHint => 'Ex. Audi Q4 e-tron';

  @override
  String get enterName => 'Digite um nome';

  @override
  String get brand => 'Marca';

  @override
  String get color => 'Cor';

  @override
  String get icon => 'Ícone';

  @override
  String get defaultCar => 'Carro padrão';

  @override
  String get defaultCarSubtitle =>
      'Novas viagens serão vinculadas a este carro';

  @override
  String get bluetoothDevice => 'Dispositivo Bluetooth';

  @override
  String get autoSetOnConnect => 'Será definido automaticamente ao conectar';

  @override
  String get autoSetOnConnectFull =>
      'Será definido automaticamente ao conectar ao CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Conexão API do Carro';

  @override
  String connectWithBrand(String brand) {
    return 'Conecte com $brand para quilometragem e status da bateria';
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
  String get brandOther => 'Outro';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatch';

  @override
  String get iconSport => 'Esportivo';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Entrar com Tesla';

  @override
  String get teslaLoginInfo =>
      'Você será redirecionado para a Tesla para fazer login. Depois poderá ver os dados do seu carro.';

  @override
  String get usernameEmail => 'Usuário / Email';

  @override
  String get password => 'Senha';

  @override
  String get country => 'País';

  @override
  String get countryHint => 'BR';

  @override
  String get testApi => 'Testar API';

  @override
  String get carUpdated => 'Carro atualizado';

  @override
  String get carAdded => 'Carro adicionado';

  @override
  String errorMessage(String error) {
    return 'Erro: $error';
  }

  @override
  String get carDeleted => 'Carro excluído';

  @override
  String get deleteCar => 'Excluir carro?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Tem certeza de que deseja excluir \"$carName\"? Todas as viagens vinculadas a este carro manterão seus dados.';
  }

  @override
  String get apiSettingsSaved => 'Configurações da API salvas';

  @override
  String get teslaAlreadyLinked => 'Tesla já está vinculado!';

  @override
  String get teslaLinked => 'Tesla vinculado!';

  @override
  String get teslaLinkFailed => 'Falha ao vincular Tesla';

  @override
  String get startTrip => 'Iniciar Viagem';

  @override
  String get stopTrip => 'Encerrar Viagem';

  @override
  String get gpsActiveTracking => 'GPS ativo - rastreamento automático';

  @override
  String get activeTrip => 'Viagem ativa';

  @override
  String startedAt(String time) {
    return 'Iniciado: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count pontos GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Atualizado: $time';
  }

  @override
  String get battery => 'Bateria';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Hodômetro';

  @override
  String get stateParked => 'Estacionado';

  @override
  String get stateDriving => 'Dirigindo';

  @override
  String get stateCharging => 'Carregando';

  @override
  String get stateUnknown => 'Desconhecido';

  @override
  String chargingPower(double power) {
    return 'Carregando: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Pronto em: $time';
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
  String get addFirstCar => 'Adicione seu primeiro carro';

  @override
  String get toTrackPerCar => 'Para registrar viagens por carro';

  @override
  String get selectCar => 'Selecionar carro';

  @override
  String get manageCars => 'Gerenciar carros';

  @override
  String get unknownDevice => 'Dispositivo desconhecido';

  @override
  String deviceName(String name) {
    return 'Dispositivo: $name';
  }

  @override
  String get linkToCar => 'Vincular ao carro:';

  @override
  String get noCarsFound =>
      'Nenhum carro encontrado. Adicione um carro primeiro.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName vinculado a $deviceName - Viagem iniciada!';
  }

  @override
  String linkError(String error) {
    return 'Erro ao vincular: $error';
  }

  @override
  String get required => 'Obrigatório';

  @override
  String get invalidDistance => 'Distância inválida';

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
