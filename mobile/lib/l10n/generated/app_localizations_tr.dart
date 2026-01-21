// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Kilometre Kaydı';

  @override
  String get tabStatus => 'Durum';

  @override
  String get tabTrips => 'Seyahatler';

  @override
  String get tabSettings => 'Ayarlar';

  @override
  String get tabCharging => 'Şarj';

  @override
  String get chargingStations => 'şarj istasyonu';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get importantTitle => 'Önemli';

  @override
  String get backgroundWarningMessage =>
      'Bu uygulama, Bluetooth üzerinden arabaya bindiğinizi otomatik olarak algılar.\n\nBu yalnızca uygulama arka planda çalışırken çalışır. Uygulamayı kapatırsanız (yukarı kaydırma), otomatik algılama çalışmayı durduracaktır.\n\nİpucu: Uygulamayı açık bırakın ve her şey otomatik olarak çalışacaktır.';

  @override
  String get understood => 'Anladım';

  @override
  String get loginPrompt => 'Başlamak için giriş yapın';

  @override
  String get loginSubtitle =>
      'Google hesabınızla giriş yapın ve araba API\'sini yapılandırın';

  @override
  String get goToSettings => 'Ayarlara Git';

  @override
  String get carPlayConnected => 'CarPlay bağlı';

  @override
  String get offlineWarning => 'Çevrimdışı - eylemler kuyruğa alınacak';

  @override
  String get recentTrips => 'Son seyahatler';

  @override
  String get configureFirst => 'Önce Ayarlar\'da uygulamayı yapılandırın';

  @override
  String get noTripsYet => 'Henüz seyahat yok';

  @override
  String routeLongerPercent(int percent) {
    return 'Rota +%$percent daha uzun';
  }

  @override
  String get route => 'Rota';

  @override
  String get from => 'Nereden';

  @override
  String get to => 'Nereye';

  @override
  String get details => 'Detaylar';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String get distance => 'Mesafe';

  @override
  String get type => 'Tür';

  @override
  String get tripTypeBusiness => 'İş';

  @override
  String get tripTypePrivate => 'Özel';

  @override
  String get tripTypeMixed => 'Karışık';

  @override
  String get googleMaps => 'Google Haritalar';

  @override
  String get routeDeviation => 'Rota sapması';

  @override
  String get car => 'Araba';

  @override
  String routeDeviationWarning(int percent) {
    return 'Rota, Google Haritalar\'ın beklediğinden %$percent daha uzun';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Seyahati düzenle';

  @override
  String get addTrip => 'Seyahat ekle';

  @override
  String get dateAndTime => 'Tarih ve Saat';

  @override
  String get start => 'Başlangıç';

  @override
  String get end => 'Bitiş';

  @override
  String get fromPlaceholder => 'Nereden';

  @override
  String get toPlaceholder => 'Nereye';

  @override
  String get distanceAndType => 'Mesafe ve Tür';

  @override
  String get distanceKm => 'Mesafe (km)';

  @override
  String get businessKm => 'İş km';

  @override
  String get privateKm => 'Özel km';

  @override
  String get save => 'Kaydet';

  @override
  String get add => 'Ekle';

  @override
  String get deleteTrip => 'Seyahat silinsin mi?';

  @override
  String get deleteTripConfirmation =>
      'Bu seyahati silmek istediğinizden emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get somethingWentWrong => 'Bir şeyler yanlış gitti';

  @override
  String get couldNotDelete => 'Silinemedi';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get trips => 'Seyahatler';

  @override
  String get total => 'Toplam';

  @override
  String get business => 'İş';

  @override
  String get private => 'Özel';

  @override
  String get account => 'Hesap';

  @override
  String get loggedIn => 'Giriş yapıldı';

  @override
  String get googleAccount => 'Google hesabı';

  @override
  String get loginWithGoogle => 'Google ile giriş yap';

  @override
  String get myCars => 'Arabalarım';

  @override
  String carsCount(int count) {
    return '$count araba';
  }

  @override
  String get manageVehicles => 'Araçlarınızı yönetin';

  @override
  String get location => 'Konum';

  @override
  String get requestLocationPermission => 'Konum İzni İste';

  @override
  String get openIOSSettings => 'iOS Ayarlarını Aç';

  @override
  String get locationPermissionGranted => 'Konum izni verildi!';

  @override
  String get locationPermissionDenied =>
      'Konum izni reddedildi - Ayarlara gidin';

  @override
  String get enableLocationServices =>
      'Önce iOS Ayarlarında Konum Servislerini etkinleştirin';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Otomatik algılama';

  @override
  String get autoDetectionSubtitle =>
      'CarPlay bağlandığında seyahatleri otomatik başlat/durdur';

  @override
  String get carPlayIsConnected => 'CarPlay bağlı';

  @override
  String get queue => 'Kuyruk';

  @override
  String queueItems(int count) {
    return 'Kuyrukta $count öğe';
  }

  @override
  String get queueSubtitle => 'Çevrimiçi olunca gönderilecek';

  @override
  String get sendNow => 'Şimdi gönder';

  @override
  String get aboutApp => 'Bu uygulama hakkında';

  @override
  String get aboutDescription =>
      'Bu uygulama, kilometre kaydı için iPhone Kısayolları otomasyonunun yerini alır. Bluetooth/CarPlay üzerinden arabaya bindiğinizi otomatik olarak algılar ve seyahatleri kaydeder.';

  @override
  String loggedInAs(String email) {
    return '$email olarak giriş yapıldı';
  }

  @override
  String errorSaving(String error) {
    return 'Kaydetme hatası: $error';
  }

  @override
  String get carSettingsSaved => 'Araba ayarları kaydedildi';

  @override
  String get enterUsernamePassword => 'Kullanıcı adı ve şifre girin';

  @override
  String get cars => 'Arabalar';

  @override
  String get addCar => 'Araba ekle';

  @override
  String get noCarsAdded => 'Henüz araba eklenmedi';

  @override
  String get defaultBadge => 'Varsayılan';

  @override
  String get editCar => 'Arabayı düzenle';

  @override
  String get name => 'Ad';

  @override
  String get nameHint => 'Örn. Audi Q4 e-tron';

  @override
  String get enterName => 'Bir ad girin';

  @override
  String get brand => 'Marka';

  @override
  String get color => 'Renk';

  @override
  String get icon => 'Simge';

  @override
  String get defaultCar => 'Varsayılan araba';

  @override
  String get defaultCarSubtitle => 'Yeni seyahatler bu arabaya bağlanacak';

  @override
  String get bluetoothDevice => 'Bluetooth cihazı';

  @override
  String get autoSetOnConnect => 'Bağlantıda otomatik ayarlanacak';

  @override
  String get autoSetOnConnectFull =>
      'CarPlay/Bluetooth\'a bağlanınca otomatik ayarlanacak';

  @override
  String get carApiConnection => 'Araba API Bağlantısı';

  @override
  String connectWithBrand(String brand) {
    return 'Kilometre ve pil durumu için $brand\'a bağlan';
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
  String get brandOther => 'Diğer';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Spor';

  @override
  String get iconVan => 'Minivan';

  @override
  String get loginWithTesla => 'Tesla ile giriş yap';

  @override
  String get teslaLoginInfo =>
      'Giriş yapmak için Tesla\'ya yönlendirileceksiniz. Sonra araba verilerinizi görebilirsiniz.';

  @override
  String get usernameEmail => 'Kullanıcı adı / E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get country => 'Ülke';

  @override
  String get countryHint => 'TR';

  @override
  String get testApi => 'API Test Et';

  @override
  String get carUpdated => 'Araba güncellendi';

  @override
  String get carAdded => 'Araba eklendi';

  @override
  String errorMessage(String error) {
    return 'Hata: $error';
  }

  @override
  String get carDeleted => 'Araba silindi';

  @override
  String get deleteCar => 'Araba silinsin mi?';

  @override
  String deleteCarConfirmation(String carName) {
    return '\"$carName\" arabayı silmek istediğinizden emin misiniz? Bu arabaya bağlı tüm seyahatler verilerini koruyacak.';
  }

  @override
  String get apiSettingsSaved => 'API ayarları kaydedildi';

  @override
  String get teslaAlreadyLinked => 'Tesla zaten bağlı!';

  @override
  String get teslaLinked => 'Tesla bağlandı!';

  @override
  String get teslaLinkFailed => 'Tesla bağlantısı başarısız';

  @override
  String get startTrip => 'Seyahati Başlat';

  @override
  String get stopTrip => 'Seyahati Durdur';

  @override
  String get gpsActiveTracking => 'GPS aktif - otomatik takip';

  @override
  String get activeTrip => 'Aktif seyahat';

  @override
  String startedAt(String time) {
    return 'Başlangıç: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS noktası';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Güncellendi: $time';
  }

  @override
  String get battery => 'Pil';

  @override
  String get status => 'Durum';

  @override
  String get odometer => 'Kilometre sayacı';

  @override
  String get stateParked => 'Park halinde';

  @override
  String get stateDriving => 'Sürüşte';

  @override
  String get stateCharging => 'Şarj oluyor';

  @override
  String get stateUnknown => 'Bilinmiyor';

  @override
  String chargingPower(double power) {
    return 'Şarj: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Hazır olacak: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes dk';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}s ${minutes}d';
  }

  @override
  String get addFirstCar => 'İlk arabanızı ekleyin';

  @override
  String get toTrackPerCar => 'Araba başına seyahatleri takip etmek için';

  @override
  String get selectCar => 'Araba seç';

  @override
  String get manageCars => 'Arabaları yönet';

  @override
  String get unknownDevice => 'Bilinmeyen cihaz';

  @override
  String deviceName(String name) {
    return 'Cihaz: $name';
  }

  @override
  String get linkToCar => 'Arabaya bağla:';

  @override
  String get noCarsFound => 'Araba bulunamadı. Önce bir araba ekleyin.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName, $deviceName\'e bağlandı - Seyahat başladı!';
  }

  @override
  String linkError(String error) {
    return 'Bağlama hatası: $error';
  }

  @override
  String get required => 'Gerekli';

  @override
  String get invalidDistance => 'Geçersiz mesafe';

  @override
  String get language => 'Dil';

  @override
  String get systemDefault => 'Sistem varsayılanı';

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
  String get retry => 'Tekrar dene';

  @override
  String get ok => 'Tamam';

  @override
  String get noConnection => 'Bağlantı yok';

  @override
  String get checkInternetConnection =>
      'İnternet bağlantınızı kontrol edin ve tekrar deneyin.';

  @override
  String get sessionExpired => 'Oturum süresi doldu';

  @override
  String get loginAgainToContinue => 'Devam etmek için tekrar giriş yapın.';

  @override
  String get serverError => 'Sunucu hatası';

  @override
  String get tryAgainLater =>
      'Bir şeyler yanlış gitti. Lütfen daha sonra tekrar deneyin.';

  @override
  String get invalidInput => 'Geçersiz giriş';

  @override
  String get timeout => 'Zaman aşımı';

  @override
  String get serverNotResponding =>
      'Sunucu yanıt vermiyor. Lütfen tekrar deneyin.';

  @override
  String get error => 'Hata';

  @override
  String get unexpectedError => 'Beklenmeyen bir hata oluştu.';

  @override
  String get setupCarTitle => 'En iyi deneyim için arabanızı ayarlayın:';

  @override
  String get setupCarApiStep => 'Araba API\'sini bağla';

  @override
  String get setupCarApiDescription =>
      'Arabalar → arabanızı seçin → hesabınızı bağlayın. Bu, kilometre sayacı ve daha fazlasına erişim sağlar.';

  @override
  String get setupBluetoothStep => 'Bluetooth\'u bağla';

  @override
  String get setupBluetoothDescription =>
      'Telefonunuzu Bluetooth ile arabanıza bağlayın, bu uygulamayı açın ve bildirimden bağlayın. Bu, güvenilir seyahat algılama sağlar.';

  @override
  String get setupTip =>
      'İpucu: En iyi güvenilirlik için her ikisini de ayarlayın!';

  @override
  String get developer => 'Geliştirici';

  @override
  String get debugLogs => 'Hata ayıklama günlükleri';

  @override
  String get viewNativeLogs => 'Yerel iOS günlüklerini görüntüle';

  @override
  String get copyAllLogs => 'Tüm günlükleri kopyala';

  @override
  String get logsCopied => 'Günlükler panoya kopyalandı';

  @override
  String get loggedOut => 'Çıkış yapıldı';

  @override
  String get loginWithAudiId => 'Audi ID ile giriş yap';

  @override
  String get loginWithAudiDescription => 'myAudi hesabınızla giriş yapın';

  @override
  String get loginWithVolkswagenId => 'Volkswagen ID ile giriş yap';

  @override
  String get loginWithVolkswagenDescription =>
      'Volkswagen ID hesabınızla giriş yapın';

  @override
  String get loginWithSkodaId => 'Skoda ID ile giriş yap';

  @override
  String get loginWithSkodaDescription => 'Skoda ID hesabınızla giriş yapın';

  @override
  String get loginWithSeatId => 'SEAT ID ile giriş yap';

  @override
  String get loginWithSeatDescription => 'SEAT ID hesabınızla giriş yapın';

  @override
  String get loginWithCupraId => 'CUPRA ID ile giriş yap';

  @override
  String get loginWithCupraDescription => 'CUPRA ID hesabınızla giriş yapın';

  @override
  String get loginWithRenaultId => 'Renault ID ile giriş yap';

  @override
  String get loginWithRenaultDescription =>
      'MY Renault hesabınızla giriş yapın';

  @override
  String get myRenault => 'MY Renault';

  @override
  String get myRenaultConnected => 'MY Renault bağlı';

  @override
  String get accountLinkedSuccess => 'Hesabınız başarıyla bağlandı';

  @override
  String brandConnected(String brand) {
    return '$brand bağlı';
  }

  @override
  String connectBrand(String brand) {
    return '$brand bağla';
  }

  @override
  String get email => 'E-posta';

  @override
  String get countryNetherlands => 'Hollanda';

  @override
  String get countryBelgium => 'Belçika';

  @override
  String get countryGermany => 'Almanya';

  @override
  String get countryFrance => 'Fransa';

  @override
  String get countryUnitedKingdom => 'Birleşik Krallık';

  @override
  String get countrySpain => 'İspanya';

  @override
  String get countryItaly => 'İtalya';

  @override
  String get countryPortugal => 'Portekiz';

  @override
  String get enterEmailAndPassword => 'E-posta ve şifrenizi girin';

  @override
  String get couldNotGetLoginUrl => 'Giriş URL\'si alınamadı';

  @override
  String brandLinked(String brand) {
    return '$brand bağlandı';
  }

  @override
  String brandLinkedWithVin(String brand, String vin) {
    return '$brand bağlandı (VIN: $vin)';
  }

  @override
  String brandLinkFailed(String brand) {
    return '$brand bağlantısı başarısız';
  }

  @override
  String get changesInNameColorIcon =>
      'Ad/renk/simge değişiklikleri? Geri basın ve düzenleyin.';

  @override
  String get notificationChannelCarDetection => 'Araba Algılama';

  @override
  String get notificationChannelDescription =>
      'Araba algılama ve seyahat kaydı bildirimleri';

  @override
  String get notificationNewCarDetected => 'Yeni araba algılandı';

  @override
  String notificationIsCarToTrack(String deviceName) {
    return '\"$deviceName\" takip etmek istediğiniz bir araba mı?';
  }

  @override
  String get notificationTripStarted => 'Seyahat Başladı';

  @override
  String get notificationTripTracking => 'Seyahatiniz şimdi takip ediliyor';

  @override
  String notificationTripTrackingWithCar(String carName) {
    return '$carName ile seyahatiniz takip ediliyor';
  }

  @override
  String get notificationCarLinked => 'Araba Bağlandı';

  @override
  String notificationCarLinkedBody(String deviceName, String carName) {
    return '\"$deviceName\" artık $carName\'e bağlı';
  }

  @override
  String locationError(String error) {
    return 'Konum hatası: $error';
  }
}
