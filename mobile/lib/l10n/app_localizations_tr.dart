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
}
