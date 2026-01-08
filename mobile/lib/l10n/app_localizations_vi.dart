// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ghi Số Km';

  @override
  String get tabStatus => 'Trạng thái';

  @override
  String get tabTrips => 'Chuyến đi';

  @override
  String get tabSettings => 'Cài đặt';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get importantTitle => 'Quan trọng';

  @override
  String get backgroundWarningMessage =>
      'Ứng dụng này tự động phát hiện khi bạn lên xe qua Bluetooth.\n\nĐiều này chỉ hoạt động nếu ứng dụng đang chạy nền. Nếu bạn đóng ứng dụng (vuốt lên), tự động phát hiện sẽ ngừng hoạt động.\n\nMẹo: Chỉ cần để ứng dụng mở, mọi thứ sẽ tự động hoạt động.';

  @override
  String get understood => 'Đã hiểu';

  @override
  String get loginPrompt => 'Đăng nhập để bắt đầu';

  @override
  String get loginSubtitle =>
      'Đăng nhập bằng tài khoản Google và cấu hình API xe';

  @override
  String get goToSettings => 'Đi đến Cài đặt';

  @override
  String get carPlayConnected => 'CarPlay đã kết nối';

  @override
  String get offlineWarning => 'Ngoại tuyến - các hành động sẽ được xếp hàng';

  @override
  String get recentTrips => 'Chuyến đi gần đây';

  @override
  String get configureFirst => 'Cấu hình ứng dụng trong Cài đặt trước';

  @override
  String get noTripsYet => 'Chưa có chuyến đi';

  @override
  String routeLongerPercent(int percent) {
    return 'Lộ trình dài hơn +$percent%';
  }

  @override
  String get route => 'Lộ trình';

  @override
  String get from => 'Từ';

  @override
  String get to => 'Đến';

  @override
  String get details => 'Chi tiết';

  @override
  String get date => 'Ngày';

  @override
  String get time => 'Giờ';

  @override
  String get distance => 'Khoảng cách';

  @override
  String get type => 'Loại';

  @override
  String get tripTypeBusiness => 'Công việc';

  @override
  String get tripTypePrivate => 'Cá nhân';

  @override
  String get tripTypeMixed => 'Hỗn hợp';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Độ lệch lộ trình';

  @override
  String get car => 'Xe';

  @override
  String routeDeviationWarning(int percent) {
    return 'Lộ trình dài hơn $percent% so với dự kiến từ Google Maps';
  }

  @override
  String get editTrip => 'Sửa chuyến đi';

  @override
  String get addTrip => 'Thêm chuyến đi';

  @override
  String get dateAndTime => 'Ngày & Giờ';

  @override
  String get start => 'Bắt đầu';

  @override
  String get end => 'Kết thúc';

  @override
  String get fromPlaceholder => 'Từ';

  @override
  String get toPlaceholder => 'Đến';

  @override
  String get distanceAndType => 'Khoảng cách & Loại';

  @override
  String get distanceKm => 'Khoảng cách (km)';

  @override
  String get businessKm => 'Km công việc';

  @override
  String get privateKm => 'Km cá nhân';

  @override
  String get save => 'Lưu';

  @override
  String get add => 'Thêm';

  @override
  String get deleteTrip => 'Xóa chuyến đi?';

  @override
  String get deleteTripConfirmation => 'Bạn có chắc muốn xóa chuyến đi này?';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get couldNotDelete => 'Không thể xóa';

  @override
  String get statistics => 'Thống kê';

  @override
  String get trips => 'Chuyến đi';

  @override
  String get total => 'Tổng';

  @override
  String get business => 'Công việc';

  @override
  String get private => 'Cá nhân';

  @override
  String get account => 'Tài khoản';

  @override
  String get loggedIn => 'Đã đăng nhập';

  @override
  String get googleAccount => 'Tài khoản Google';

  @override
  String get loginWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get myCars => 'Xe của tôi';

  @override
  String carsCount(int count) {
    return '$count xe';
  }

  @override
  String get manageVehicles => 'Quản lý phương tiện của bạn';

  @override
  String get location => 'Vị trí';

  @override
  String get requestLocationPermission => 'Yêu cầu Quyền Vị trí';

  @override
  String get openIOSSettings => 'Mở Cài đặt iOS';

  @override
  String get locationPermissionGranted => 'Đã cấp quyền vị trí!';

  @override
  String get locationPermissionDenied =>
      'Quyền vị trí bị từ chối - đi đến Cài đặt';

  @override
  String get enableLocationServices =>
      'Bật Dịch vụ Vị trí trong Cài đặt iOS trước';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Tự động phát hiện';

  @override
  String get autoDetectionSubtitle =>
      'Tự động bắt đầu/dừng chuyến đi khi CarPlay kết nối';

  @override
  String get carPlayIsConnected => 'CarPlay đã kết nối';

  @override
  String get queue => 'Hàng đợi';

  @override
  String queueItems(int count) {
    return '$count mục trong hàng đợi';
  }

  @override
  String get queueSubtitle => 'Sẽ được gửi khi trực tuyến';

  @override
  String get sendNow => 'Gửi ngay';

  @override
  String get aboutApp => 'Về ứng dụng này';

  @override
  String get aboutDescription =>
      'Ứng dụng này thay thế tự động hóa Phím tắt iPhone cho ghi số km. Tự động phát hiện khi bạn lên xe qua Bluetooth/CarPlay và ghi lại chuyến đi.';

  @override
  String loggedInAs(String email) {
    return 'Đăng nhập với $email';
  }

  @override
  String errorSaving(String error) {
    return 'Lỗi khi lưu: $error';
  }

  @override
  String get carSettingsSaved => 'Đã lưu cài đặt xe';

  @override
  String get enterUsernamePassword => 'Nhập tên người dùng và mật khẩu';

  @override
  String get cars => 'Xe';

  @override
  String get addCar => 'Thêm xe';

  @override
  String get noCarsAdded => 'Chưa thêm xe nào';

  @override
  String get defaultBadge => 'Mặc định';

  @override
  String get editCar => 'Sửa xe';

  @override
  String get name => 'Tên';

  @override
  String get nameHint => 'VD: Audi Q4 e-tron';

  @override
  String get enterName => 'Nhập tên';

  @override
  String get brand => 'Hãng';

  @override
  String get color => 'Màu';

  @override
  String get icon => 'Biểu tượng';

  @override
  String get defaultCar => 'Xe mặc định';

  @override
  String get defaultCarSubtitle => 'Chuyến đi mới sẽ được liên kết với xe này';

  @override
  String get bluetoothDevice => 'Thiết bị Bluetooth';

  @override
  String get autoSetOnConnect => 'Sẽ được đặt tự động khi kết nối';

  @override
  String get autoSetOnConnectFull =>
      'Sẽ được đặt tự động khi kết nối với CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Kết nối API Xe';

  @override
  String connectWithBrand(String brand) {
    return 'Kết nối với $brand để xem số km và tình trạng pin';
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
  String get brandOther => 'Khác';

  @override
  String get iconSedan => 'Sedan';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Hatchback';

  @override
  String get iconSport => 'Thể thao';

  @override
  String get iconVan => 'Van';

  @override
  String get loginWithTesla => 'Đăng nhập bằng Tesla';

  @override
  String get teslaLoginInfo =>
      'Bạn sẽ được chuyển hướng đến Tesla để đăng nhập. Sau đó bạn có thể xem dữ liệu xe.';

  @override
  String get usernameEmail => 'Tên người dùng / Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get country => 'Quốc gia';

  @override
  String get countryHint => 'VN';

  @override
  String get testApi => 'Kiểm tra API';

  @override
  String get carUpdated => 'Đã cập nhật xe';

  @override
  String get carAdded => 'Đã thêm xe';

  @override
  String errorMessage(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get carDeleted => 'Đã xóa xe';

  @override
  String get deleteCar => 'Xóa xe?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Bạn có chắc muốn xóa \"$carName\"? Tất cả chuyến đi liên kết với xe này sẽ giữ lại dữ liệu.';
  }

  @override
  String get apiSettingsSaved => 'Đã lưu cài đặt API';

  @override
  String get teslaAlreadyLinked => 'Tesla đã được liên kết!';

  @override
  String get teslaLinked => 'Đã liên kết Tesla!';

  @override
  String get teslaLinkFailed => 'Liên kết Tesla thất bại';

  @override
  String get startTrip => 'Bắt đầu Chuyến đi';

  @override
  String get stopTrip => 'Kết thúc Chuyến đi';

  @override
  String get gpsActiveTracking => 'GPS đang hoạt động - theo dõi tự động';

  @override
  String get activeTrip => 'Chuyến đi đang diễn ra';

  @override
  String startedAt(String time) {
    return 'Bắt đầu: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count điểm GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Cập nhật: $time';
  }

  @override
  String get battery => 'Pin';

  @override
  String get status => 'Trạng thái';

  @override
  String get odometer => 'Đồng hồ km';

  @override
  String get stateParked => 'Đang đỗ';

  @override
  String get stateDriving => 'Đang lái';

  @override
  String get stateCharging => 'Đang sạc';

  @override
  String get stateUnknown => 'Không rõ';

  @override
  String chargingPower(double power) {
    return 'Sạc: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Hoàn thành trong: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes phút';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '${hours}g ${minutes}p';
  }

  @override
  String get addFirstCar => 'Thêm xe đầu tiên của bạn';

  @override
  String get toTrackPerCar => 'Để theo dõi chuyến đi theo xe';

  @override
  String get selectCar => 'Chọn xe';

  @override
  String get manageCars => 'Quản lý xe';

  @override
  String get unknownDevice => 'Thiết bị không xác định';

  @override
  String deviceName(String name) {
    return 'Thiết bị: $name';
  }

  @override
  String get linkToCar => 'Liên kết với xe:';

  @override
  String get noCarsFound => 'Không tìm thấy xe. Thêm xe trước.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName đã liên kết với $deviceName - Chuyến đi bắt đầu!';
  }

  @override
  String linkError(String error) {
    return 'Lỗi liên kết: $error';
  }

  @override
  String get required => 'Bắt buộc';

  @override
  String get invalidDistance => 'Khoảng cách không hợp lệ';
}
