// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '里程记录';

  @override
  String get tabStatus => '状态';

  @override
  String get tabTrips => '行程';

  @override
  String get tabSettings => '设置';

  @override
  String get logout => '退出登录';

  @override
  String get importantTitle => '重要提示';

  @override
  String get backgroundWarningMessage =>
      '此应用通过蓝牙自动检测您何时上车。\n\n此功能仅在应用后台运行时有效。如果您关闭应用（上滑），自动检测将停止工作。\n\n提示：只需保持应用打开，一切将自动运行。';

  @override
  String get understood => '知道了';

  @override
  String get loginPrompt => '登录以开始';

  @override
  String get loginSubtitle => '使用Google账号登录并配置汽车API';

  @override
  String get goToSettings => '前往设置';

  @override
  String get carPlayConnected => 'CarPlay已连接';

  @override
  String get offlineWarning => '离线 - 操作将排队处理';

  @override
  String get recentTrips => '最近行程';

  @override
  String get configureFirst => '请先在设置中配置应用';

  @override
  String get noTripsYet => '暂无行程';

  @override
  String routeLongerPercent(int percent) {
    return '路线长$percent%';
  }

  @override
  String get route => '路线';

  @override
  String get from => '从';

  @override
  String get to => '到';

  @override
  String get details => '详情';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get distance => '距离';

  @override
  String get type => '类型';

  @override
  String get tripTypeBusiness => '商务';

  @override
  String get tripTypePrivate => '私人';

  @override
  String get tripTypeMixed => '混合';

  @override
  String get googleMaps => 'Google地图';

  @override
  String get routeDeviation => '路线偏差';

  @override
  String get car => '车辆';

  @override
  String routeDeviationWarning(int percent) {
    return '路线比Google地图预期长$percent%';
  }

  @override
  String get editTrip => '编辑行程';

  @override
  String get addTrip => '添加行程';

  @override
  String get dateAndTime => '日期和时间';

  @override
  String get start => '开始';

  @override
  String get end => '结束';

  @override
  String get fromPlaceholder => '起点';

  @override
  String get toPlaceholder => '终点';

  @override
  String get distanceAndType => '距离和类型';

  @override
  String get distanceKm => '距离（公里）';

  @override
  String get businessKm => '商务公里';

  @override
  String get privateKm => '私人公里';

  @override
  String get save => '保存';

  @override
  String get add => '添加';

  @override
  String get deleteTrip => '删除行程？';

  @override
  String get deleteTripConfirmation => '确定要删除这次行程吗？';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get somethingWentWrong => '出错了';

  @override
  String get couldNotDelete => '无法删除';

  @override
  String get statistics => '统计';

  @override
  String get trips => '行程';

  @override
  String get total => '总计';

  @override
  String get business => '商务';

  @override
  String get private => '私人';

  @override
  String get account => '账户';

  @override
  String get loggedIn => '已登录';

  @override
  String get googleAccount => 'Google账号';

  @override
  String get loginWithGoogle => '使用Google登录';

  @override
  String get myCars => '我的车辆';

  @override
  String carsCount(int count) {
    return '$count辆车';
  }

  @override
  String get manageVehicles => '管理您的车辆';

  @override
  String get location => '位置';

  @override
  String get requestLocationPermission => '请求位置权限';

  @override
  String get openIOSSettings => '打开iOS设置';

  @override
  String get locationPermissionGranted => '位置权限已授予！';

  @override
  String get locationPermissionDenied => '位置权限被拒绝 - 请前往设置';

  @override
  String get enableLocationServices => '请先在iOS设置中开启位置服务';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => '自动检测';

  @override
  String get autoDetectionSubtitle => '连接CarPlay时自动开始/结束行程';

  @override
  String get carPlayIsConnected => 'CarPlay已连接';

  @override
  String get queue => '队列';

  @override
  String queueItems(int count) {
    return '$count个待处理项目';
  }

  @override
  String get queueSubtitle => '联网后将自动发送';

  @override
  String get sendNow => '立即发送';

  @override
  String get aboutApp => '关于此应用';

  @override
  String get aboutDescription =>
      '此应用取代iPhone快捷指令自动化进行里程记录。它通过蓝牙/CarPlay自动检测您何时上车并记录行程。';

  @override
  String loggedInAs(String email) {
    return '已登录为 $email';
  }

  @override
  String errorSaving(String error) {
    return '保存错误：$error';
  }

  @override
  String get carSettingsSaved => '车辆设置已保存';

  @override
  String get enterUsernamePassword => '请输入用户名和密码';

  @override
  String get cars => '车辆';

  @override
  String get addCar => '添加车辆';

  @override
  String get noCarsAdded => '尚未添加车辆';

  @override
  String get defaultBadge => '默认';

  @override
  String get editCar => '编辑车辆';

  @override
  String get name => '名称';

  @override
  String get nameHint => '例如：奥迪Q4 e-tron';

  @override
  String get enterName => '请输入名称';

  @override
  String get brand => '品牌';

  @override
  String get color => '颜色';

  @override
  String get icon => '图标';

  @override
  String get defaultCar => '默认车辆';

  @override
  String get defaultCarSubtitle => '新行程将关联到此车辆';

  @override
  String get bluetoothDevice => '蓝牙设备';

  @override
  String get autoSetOnConnect => '连接时自动设置';

  @override
  String get autoSetOnConnectFull => '连接CarPlay/蓝牙时自动设置';

  @override
  String get carApiConnection => '车辆API连接';

  @override
  String connectWithBrand(String brand) {
    return '连接$brand以获取里程和电池状态';
  }

  @override
  String get brandAudi => '奥迪';

  @override
  String get brandVolkswagen => '大众';

  @override
  String get brandSkoda => '斯柯达';

  @override
  String get brandSeat => '西雅特';

  @override
  String get brandCupra => '库普拉';

  @override
  String get brandRenault => '雷诺';

  @override
  String get brandTesla => '特斯拉';

  @override
  String get brandBMW => '宝马';

  @override
  String get brandMercedes => '奔驰';

  @override
  String get brandOther => '其他';

  @override
  String get iconSedan => '轿车';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => '掀背车';

  @override
  String get iconSport => '跑车';

  @override
  String get iconVan => '面包车';

  @override
  String get loginWithTesla => '使用Tesla登录';

  @override
  String get teslaLoginInfo => '您将被重定向到Tesla登录。之后您可以查看车辆数据。';

  @override
  String get usernameEmail => '用户名/邮箱';

  @override
  String get password => '密码';

  @override
  String get country => '国家';

  @override
  String get countryHint => 'CN';

  @override
  String get testApi => '测试API';

  @override
  String get carUpdated => '车辆已更新';

  @override
  String get carAdded => '车辆已添加';

  @override
  String errorMessage(String error) {
    return '错误：$error';
  }

  @override
  String get carDeleted => '车辆已删除';

  @override
  String get deleteCar => '删除车辆？';

  @override
  String deleteCarConfirmation(String carName) {
    return '确定要删除「$carName」吗？与此车辆关联的所有行程将保留其数据。';
  }

  @override
  String get apiSettingsSaved => 'API设置已保存';

  @override
  String get teslaAlreadyLinked => 'Tesla已关联！';

  @override
  String get teslaLinked => 'Tesla已关联！';

  @override
  String get teslaLinkFailed => 'Tesla关联失败';

  @override
  String get startTrip => '开始行程';

  @override
  String get stopTrip => '结束行程';

  @override
  String get gpsActiveTracking => 'GPS已激活 - 自动追踪中';

  @override
  String get activeTrip => '进行中的行程';

  @override
  String startedAt(String time) {
    return '开始时间：$time';
  }

  @override
  String gpsPoints(int count) {
    return '$count个GPS点';
  }

  @override
  String get km => '公里';

  @override
  String updatedAt(String time) {
    return '更新时间：$time';
  }

  @override
  String get battery => '电池';

  @override
  String get status => '状态';

  @override
  String get odometer => '里程表';

  @override
  String get stateParked => '已停放';

  @override
  String get stateDriving => '行驶中';

  @override
  String get stateCharging => '充电中';

  @override
  String get stateUnknown => '未知';

  @override
  String chargingPower(double power) {
    return '充电功率：$power kW';
  }

  @override
  String readyIn(String time) {
    return '预计完成：$time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes分钟';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分';
  }

  @override
  String get addFirstCar => '添加您的第一辆车';

  @override
  String get toTrackPerCar => '按车辆追踪行程';

  @override
  String get selectCar => '选择车辆';

  @override
  String get manageCars => '管理车辆';

  @override
  String get unknownDevice => '未知设备';

  @override
  String deviceName(String name) {
    return '设备：$name';
  }

  @override
  String get linkToCar => '关联到车辆：';

  @override
  String get noCarsFound => '未找到车辆。请先添加车辆。';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName已关联到$deviceName - 行程已开始！';
  }

  @override
  String linkError(String error) {
    return '关联错误：$error';
  }

  @override
  String get required => '必填';

  @override
  String get invalidDistance => '无效距离';
}
