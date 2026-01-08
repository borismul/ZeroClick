// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '走行距離記録';

  @override
  String get tabStatus => 'ステータス';

  @override
  String get tabTrips => '走行履歴';

  @override
  String get tabSettings => '設定';

  @override
  String get logout => 'ログアウト';

  @override
  String get importantTitle => '重要';

  @override
  String get backgroundWarningMessage =>
      'このアプリはBluetoothで車に乗ったことを自動検出します。\n\nこれはアプリがバックグラウンドで実行されている場合にのみ機能します。アプリを閉じると（上にスワイプ）、自動検出は機能しなくなります。\n\nヒント：アプリを開いたままにしておけば、すべて自動的に動作します。';

  @override
  String get understood => '了解';

  @override
  String get loginPrompt => 'ログインして開始';

  @override
  String get loginSubtitle => 'Googleアカウントでログインし、車のAPIを設定してください';

  @override
  String get goToSettings => '設定へ移動';

  @override
  String get carPlayConnected => 'CarPlay接続済み';

  @override
  String get offlineWarning => 'オフライン - アクションはキューに追加されます';

  @override
  String get recentTrips => '最近の走行';

  @override
  String get configureFirst => 'まず設定でアプリを構成してください';

  @override
  String get noTripsYet => '走行履歴はありません';

  @override
  String routeLongerPercent(int percent) {
    return 'ルート +$percent% 長い';
  }

  @override
  String get route => 'ルート';

  @override
  String get from => '出発地';

  @override
  String get to => '目的地';

  @override
  String get details => '詳細';

  @override
  String get date => '日付';

  @override
  String get time => '時間';

  @override
  String get distance => '距離';

  @override
  String get type => 'タイプ';

  @override
  String get tripTypeBusiness => '業務';

  @override
  String get tripTypePrivate => 'プライベート';

  @override
  String get tripTypeMixed => '混合';

  @override
  String get googleMaps => 'Google マップ';

  @override
  String get routeDeviation => 'ルート偏差';

  @override
  String get car => '車';

  @override
  String routeDeviationWarning(int percent) {
    return 'ルートはGoogleマップの予想より$percent%長いです';
  }

  @override
  String get editTrip => '走行を編集';

  @override
  String get addTrip => '走行を追加';

  @override
  String get dateAndTime => '日付と時間';

  @override
  String get start => '開始';

  @override
  String get end => '終了';

  @override
  String get fromPlaceholder => '出発地';

  @override
  String get toPlaceholder => '目的地';

  @override
  String get distanceAndType => '距離とタイプ';

  @override
  String get distanceKm => '距離（km）';

  @override
  String get businessKm => '業務 km';

  @override
  String get privateKm => 'プライベート km';

  @override
  String get save => '保存';

  @override
  String get add => '追加';

  @override
  String get deleteTrip => '走行を削除しますか？';

  @override
  String get deleteTripConfirmation => 'この走行を削除してもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get somethingWentWrong => 'エラーが発生しました';

  @override
  String get couldNotDelete => '削除できませんでした';

  @override
  String get statistics => '統計';

  @override
  String get trips => '走行';

  @override
  String get total => '合計';

  @override
  String get business => '業務';

  @override
  String get private => 'プライベート';

  @override
  String get account => 'アカウント';

  @override
  String get loggedIn => 'ログイン済み';

  @override
  String get googleAccount => 'Googleアカウント';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get myCars => 'マイカー';

  @override
  String carsCount(int count) {
    return '$count台';
  }

  @override
  String get manageVehicles => '車両を管理';

  @override
  String get location => '位置情報';

  @override
  String get requestLocationPermission => '位置情報の許可をリクエスト';

  @override
  String get openIOSSettings => 'iOS設定を開く';

  @override
  String get locationPermissionGranted => '位置情報の許可が付与されました！';

  @override
  String get locationPermissionDenied => '位置情報の許可が拒否されました - 設定に移動してください';

  @override
  String get enableLocationServices => 'まずiOS設定で位置情報サービスを有効にしてください';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => '自動検出';

  @override
  String get autoDetectionSubtitle => 'CarPlay接続時に自動的に走行を開始/停止';

  @override
  String get carPlayIsConnected => 'CarPlayが接続されています';

  @override
  String get queue => 'キュー';

  @override
  String queueItems(int count) {
    return '$count件がキューにあります';
  }

  @override
  String get queueSubtitle => 'オンライン時に送信されます';

  @override
  String get sendNow => '今すぐ送信';

  @override
  String get aboutApp => 'このアプリについて';

  @override
  String get aboutDescription =>
      'このアプリはiPhoneショートカットの自動化に代わる走行距離記録アプリです。Bluetooth/CarPlayで車に乗ったことを自動検出し、走行を記録します。';

  @override
  String loggedInAs(String email) {
    return '$emailとしてログイン中';
  }

  @override
  String errorSaving(String error) {
    return '保存エラー：$error';
  }

  @override
  String get carSettingsSaved => '車の設定が保存されました';

  @override
  String get enterUsernamePassword => 'ユーザー名とパスワードを入力してください';

  @override
  String get cars => '車';

  @override
  String get addCar => '車を追加';

  @override
  String get noCarsAdded => '車がまだ追加されていません';

  @override
  String get defaultBadge => 'デフォルト';

  @override
  String get editCar => '車を編集';

  @override
  String get name => '名前';

  @override
  String get nameHint => '例：Audi Q4 e-tron';

  @override
  String get enterName => '名前を入力してください';

  @override
  String get brand => 'ブランド';

  @override
  String get color => '色';

  @override
  String get icon => 'アイコン';

  @override
  String get defaultCar => 'デフォルト車両';

  @override
  String get defaultCarSubtitle => '新しい走行はこの車に関連付けられます';

  @override
  String get bluetoothDevice => 'Bluetoothデバイス';

  @override
  String get autoSetOnConnect => '接続時に自動設定されます';

  @override
  String get autoSetOnConnectFull => 'CarPlay/Bluetooth接続時に自動設定されます';

  @override
  String get carApiConnection => '車のAPI接続';

  @override
  String connectWithBrand(String brand) {
    return '$brandに接続して走行距離とバッテリー状態を取得';
  }

  @override
  String get brandAudi => 'アウディ';

  @override
  String get brandVolkswagen => 'フォルクスワーゲン';

  @override
  String get brandSkoda => 'シュコダ';

  @override
  String get brandSeat => 'セアト';

  @override
  String get brandCupra => 'クプラ';

  @override
  String get brandRenault => 'ルノー';

  @override
  String get brandTesla => 'テスラ';

  @override
  String get brandBMW => 'BMW';

  @override
  String get brandMercedes => 'メルセデス';

  @override
  String get brandOther => 'その他';

  @override
  String get iconSedan => 'セダン';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'ハッチバック';

  @override
  String get iconSport => 'スポーツ';

  @override
  String get iconVan => 'バン';

  @override
  String get loginWithTesla => 'Teslaでログイン';

  @override
  String get teslaLoginInfo => 'Teslaにリダイレクトされてログインします。その後、車のデータを表示できます。';

  @override
  String get usernameEmail => 'ユーザー名/メール';

  @override
  String get password => 'パスワード';

  @override
  String get country => '国';

  @override
  String get countryHint => 'JP';

  @override
  String get testApi => 'APIをテスト';

  @override
  String get carUpdated => '車が更新されました';

  @override
  String get carAdded => '車が追加されました';

  @override
  String errorMessage(String error) {
    return 'エラー：$error';
  }

  @override
  String get carDeleted => '車が削除されました';

  @override
  String get deleteCar => '車を削除しますか？';

  @override
  String deleteCarConfirmation(String carName) {
    return '「$carName」を削除してもよろしいですか？この車に関連付けられたすべての走行はデータを保持します。';
  }

  @override
  String get apiSettingsSaved => 'API設定が保存されました';

  @override
  String get teslaAlreadyLinked => 'Teslaは既にリンクされています！';

  @override
  String get teslaLinked => 'Teslaがリンクされました！';

  @override
  String get teslaLinkFailed => 'Teslaのリンクに失敗しました';

  @override
  String get startTrip => '走行を開始';

  @override
  String get stopTrip => '走行を終了';

  @override
  String get gpsActiveTracking => 'GPS有効 - 自動追跡中';

  @override
  String get activeTrip => '走行中';

  @override
  String startedAt(String time) {
    return '開始：$time';
  }

  @override
  String gpsPoints(int count) {
    return '$count個のGPSポイント';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return '更新：$time';
  }

  @override
  String get battery => 'バッテリー';

  @override
  String get status => 'ステータス';

  @override
  String get odometer => '走行距離計';

  @override
  String get stateParked => '駐車中';

  @override
  String get stateDriving => '走行中';

  @override
  String get stateCharging => '充電中';

  @override
  String get stateUnknown => '不明';

  @override
  String chargingPower(double power) {
    return '充電中：$power kW';
  }

  @override
  String readyIn(String time) {
    return '完了予定：$time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes分';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get addFirstCar => '最初の車を追加';

  @override
  String get toTrackPerCar => '車ごとに走行を追跡';

  @override
  String get selectCar => '車を選択';

  @override
  String get manageCars => '車を管理';

  @override
  String get unknownDevice => '不明なデバイス';

  @override
  String deviceName(String name) {
    return 'デバイス：$name';
  }

  @override
  String get linkToCar => '車にリンク：';

  @override
  String get noCarsFound => '車が見つかりません。まず車を追加してください。';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carNameが$deviceNameにリンクされました - 走行開始！';
  }

  @override
  String linkError(String error) {
    return 'リンクエラー：$error';
  }

  @override
  String get required => '必須';

  @override
  String get invalidDistance => '無効な距離';
}
