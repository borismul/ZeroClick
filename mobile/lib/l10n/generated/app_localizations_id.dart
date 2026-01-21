// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Catatan Kilometer';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabTrips => 'Perjalanan';

  @override
  String get tabSettings => 'Pengaturan';

  @override
  String get tabCharging => 'Pengisian';

  @override
  String get chargingStations => 'stasiun pengisian';

  @override
  String get logout => 'Keluar';

  @override
  String get importantTitle => 'Penting';

  @override
  String get backgroundWarningMessage =>
      'Aplikasi ini secara otomatis mendeteksi saat Anda masuk ke mobil melalui Bluetooth.\n\nIni hanya berfungsi jika aplikasi berjalan di latar belakang. Jika Anda menutup aplikasi (geser ke atas), deteksi otomatis akan berhenti.\n\nTips: Biarkan aplikasi tetap terbuka, dan semuanya akan berfungsi otomatis.';

  @override
  String get understood => 'Mengerti';

  @override
  String get loginPrompt => 'Masuk untuk memulai';

  @override
  String get loginSubtitle =>
      'Masuk dengan akun Google Anda dan konfigurasikan API mobil';

  @override
  String get goToSettings => 'Ke Pengaturan';

  @override
  String get carPlayConnected => 'CarPlay terhubung';

  @override
  String get offlineWarning => 'Offline - tindakan akan diantrekan';

  @override
  String get recentTrips => 'Perjalanan terbaru';

  @override
  String get configureFirst =>
      'Konfigurasikan aplikasi di Pengaturan terlebih dahulu';

  @override
  String get noTripsYet => 'Belum ada perjalanan';

  @override
  String routeLongerPercent(int percent) {
    return 'Rute +$percent% lebih panjang';
  }

  @override
  String get route => 'Rute';

  @override
  String get from => 'Dari';

  @override
  String get to => 'Ke';

  @override
  String get details => 'Detail';

  @override
  String get date => 'Tanggal';

  @override
  String get time => 'Waktu';

  @override
  String get distance => 'Jarak';

  @override
  String get type => 'Tipe';

  @override
  String get tripTypeBusiness => 'Bisnis';

  @override
  String get tripTypePrivate => 'Pribadi';

  @override
  String get tripTypeMixed => 'Campuran';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Deviasi rute';

  @override
  String get car => 'Mobil';

  @override
  String routeDeviationWarning(int percent) {
    return 'Rute $percent% lebih panjang dari perkiraan Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Edit perjalanan';

  @override
  String get addTrip => 'Tambah perjalanan';

  @override
  String get dateAndTime => 'Tanggal & Waktu';

  @override
  String get start => 'Mulai';

  @override
  String get end => 'Selesai';

  @override
  String get fromPlaceholder => 'Dari';

  @override
  String get toPlaceholder => 'Ke';

  @override
  String get distanceAndType => 'Jarak & Tipe';

  @override
  String get distanceKm => 'Jarak (km)';

  @override
  String get businessKm => 'Km bisnis';

  @override
  String get privateKm => 'Km pribadi';

  @override
  String get save => 'Simpan';

  @override
  String get add => 'Tambah';

  @override
  String get deleteTrip => 'Hapus perjalanan?';

  @override
  String get deleteTripConfirmation => 'Yakin ingin menghapus perjalanan ini?';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan';

  @override
  String get couldNotDelete => 'Tidak dapat menghapus';

  @override
  String get statistics => 'Statistik';

  @override
  String get trips => 'Perjalanan';

  @override
  String get total => 'Total';

  @override
  String get business => 'Bisnis';

  @override
  String get private => 'Pribadi';

  @override
  String get account => 'Akun';

  @override
  String get loggedIn => 'Masuk';

  @override
  String get googleAccount => 'Akun Google';

  @override
  String get loginWithGoogle => 'Masuk dengan Google';

  @override
  String get myCars => 'Mobil Saya';

  @override
  String carsCount(int count) {
    return '$count mobil';
  }

  @override
  String get manageVehicles => 'Kelola kendaraan Anda';

  @override
  String get location => 'Lokasi';

  @override
  String get requestLocationPermission => 'Minta Izin Lokasi';

  @override
  String get openIOSSettings => 'Buka Pengaturan iOS';

  @override
  String get locationPermissionGranted => 'Izin lokasi diberikan!';

  @override
  String get locationPermissionDenied =>
      'Izin lokasi ditolak - buka Pengaturan';

  @override
  String get enableLocationServices =>
      'Aktifkan Layanan Lokasi di Pengaturan iOS terlebih dahulu';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Deteksi otomatis';

  @override
  String get autoDetectionSubtitle =>
      'Mulai/hentikan perjalanan otomatis saat CarPlay terhubung';

  @override
  String get carPlayIsConnected => 'CarPlay terhubung';

  @override
  String get queue => 'Antrean';

  @override
  String queueItems(int count) {
    return '$count item dalam antrean';
  }

  @override
  String get queueSubtitle => 'Akan dikirim saat online';

  @override
  String get sendNow => 'Kirim sekarang';

  @override
  String get aboutApp => 'Tentang aplikasi ini';

  @override
  String get aboutDescription =>
      'Aplikasi ini menggantikan otomatisasi Pintasan iPhone untuk pencatatan kilometer. Secara otomatis mendeteksi saat Anda masuk ke mobil melalui Bluetooth/CarPlay dan mencatat perjalanan.';

  @override
  String loggedInAs(String email) {
    return 'Masuk sebagai $email';
  }

  @override
  String errorSaving(String error) {
    return 'Error menyimpan: $error';
  }

  @override
  String get carSettingsSaved => 'Pengaturan mobil tersimpan';

  @override
  String get enterUsernamePassword => 'Masukkan nama pengguna dan kata sandi';

  @override
  String get cars => 'Mobil';

  @override
  String get addCar => 'Tambah mobil';

  @override
  String get noCarsAdded => 'Belum ada mobil ditambahkan';

  @override
  String get defaultBadge => 'Default';

  @override
  String get editCar => 'Edit mobil';

  @override
  String get name => 'Nama';

  @override
  String get nameHint => 'Cth. Audi Q4 e-tron';

  @override
  String get enterName => 'Masukkan nama';

  @override
  String get brand => 'Merek';

  @override
  String get color => 'Warna';

  @override
  String get icon => 'Ikon';

  @override
  String get defaultCar => 'Mobil default';

  @override
  String get defaultCarSubtitle =>
      'Perjalanan baru akan dikaitkan dengan mobil ini';

  @override
  String get bluetoothDevice => 'Perangkat Bluetooth';

  @override
  String get autoSetOnConnect => 'Akan diatur otomatis saat terhubung';

  @override
  String get autoSetOnConnectFull =>
      'Akan diatur otomatis saat terhubung ke CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Koneksi API Mobil';

  @override
  String connectWithBrand(String brand) {
    return 'Hubungkan dengan $brand untuk kilometer dan status baterai';
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
  String get brandOther => 'Lainnya';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Sport';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Masuk dengan Tesla';

  @override
  String get teslaLoginInfo =>
      'Anda akan dialihkan ke Tesla untuk masuk. Setelah itu Anda dapat melihat data mobil Anda.';

  @override
  String get usernameEmail => 'Nama pengguna / Email';

  @override
  String get password => 'Kata sandi';

  @override
  String get country => 'Negara';

  @override
  String get countryHint => 'ID';

  @override
  String get testApi => 'Test API';

  @override
  String get carUpdated => 'Mobil diperbarui';

  @override
  String get carAdded => 'Mobil ditambahkan';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get carDeleted => 'Mobil dihapus';

  @override
  String get deleteCar => 'Hapus mobil?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Yakin ingin menghapus \"$carName\"? Semua perjalanan yang dikaitkan dengan mobil ini akan tetap menyimpan datanya.';
  }

  @override
  String get apiSettingsSaved => 'Pengaturan API tersimpan';

  @override
  String get teslaAlreadyLinked => 'Tesla sudah terhubung!';

  @override
  String get teslaLinked => 'Tesla terhubung!';

  @override
  String get teslaLinkFailed => 'Gagal menghubungkan Tesla';

  @override
  String get startTrip => 'Mulai Perjalanan';

  @override
  String get stopTrip => 'Akhiri Perjalanan';

  @override
  String get gpsActiveTracking => 'GPS aktif - pelacakan otomatis';

  @override
  String get activeTrip => 'Perjalanan aktif';

  @override
  String startedAt(String time) {
    return 'Dimulai: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count titik GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Diperbarui: $time';
  }

  @override
  String get battery => 'Baterai';

  @override
  String get status => 'Status';

  @override
  String get odometer => 'Odometer';

  @override
  String get stateParked => 'Terparkir';

  @override
  String get stateDriving => 'Berkendara';

  @override
  String get stateCharging => 'Mengisi daya';

  @override
  String get stateUnknown => 'Tidak diketahui';

  @override
  String chargingPower(double power) {
    return 'Mengisi: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Selesai dalam: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes mnt';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}j ${minutes}m';
  }

  @override
  String get addFirstCar => 'Tambah mobil pertama Anda';

  @override
  String get toTrackPerCar => 'Untuk melacak perjalanan per mobil';

  @override
  String get selectCar => 'Pilih mobil';

  @override
  String get manageCars => 'Kelola mobil';

  @override
  String get unknownDevice => 'Perangkat tidak dikenal';

  @override
  String deviceName(String name) {
    return 'Perangkat: $name';
  }

  @override
  String get linkToCar => 'Hubungkan ke mobil:';

  @override
  String get noCarsFound => 'Tidak ada mobil. Tambah mobil terlebih dahulu.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName terhubung ke $deviceName - Perjalanan dimulai!';
  }

  @override
  String linkError(String error) {
    return 'Error menghubungkan: $error';
  }

  @override
  String get required => 'Wajib';

  @override
  String get invalidDistance => 'Jarak tidak valid';

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
