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
}
