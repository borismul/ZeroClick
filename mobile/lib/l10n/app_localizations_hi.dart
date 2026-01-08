// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'माइलेज ट्रैकर';

  @override
  String get tabStatus => 'स्थिति';

  @override
  String get tabTrips => 'यात्राएं';

  @override
  String get tabSettings => 'सेटिंग्स';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get importantTitle => 'महत्वपूर्ण';

  @override
  String get backgroundWarningMessage =>
      'यह ऐप ब्लूटूथ के माध्यम से स्वचालित रूप से पता लगाता है कि आप कार में कब बैठते हैं।\n\nयह तभी काम करता है जब ऐप बैकग्राउंड में चल रहा हो। यदि आप ऐप बंद करते हैं (ऊपर स्वाइप करें), तो स्वचालित पहचान काम करना बंद कर देगी।\n\nसुझाव: ऐप को खुला रखें और सब कुछ स्वचालित रूप से काम करेगा।';

  @override
  String get understood => 'समझ गया';

  @override
  String get loginPrompt => 'शुरू करने के लिए लॉग इन करें';

  @override
  String get loginSubtitle =>
      'अपने Google खाते से लॉग इन करें और कार API कॉन्फ़िगर करें';

  @override
  String get goToSettings => 'सेटिंग्स में जाएं';

  @override
  String get carPlayConnected => 'CarPlay कनेक्टेड';

  @override
  String get offlineWarning => 'ऑफ़लाइन - क्रियाएं कतार में जोड़ी जाएंगी';

  @override
  String get recentTrips => 'हाल की यात्राएं';

  @override
  String get configureFirst => 'पहले सेटिंग्स में ऐप कॉन्फ़िगर करें';

  @override
  String get noTripsYet => 'अभी तक कोई यात्रा नहीं';

  @override
  String routeLongerPercent(int percent) {
    return 'रूट +$percent% लंबा';
  }

  @override
  String get route => 'रूट';

  @override
  String get from => 'से';

  @override
  String get to => 'तक';

  @override
  String get details => 'विवरण';

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get distance => 'दूरी';

  @override
  String get type => 'प्रकार';

  @override
  String get tripTypeBusiness => 'व्यवसाय';

  @override
  String get tripTypePrivate => 'निजी';

  @override
  String get tripTypeMixed => 'मिश्रित';

  @override
  String get googleMaps => 'Google मैप्स';

  @override
  String get routeDeviation => 'रूट विचलन';

  @override
  String get car => 'कार';

  @override
  String routeDeviationWarning(int percent) {
    return 'रूट Google मैप्स की अपेक्षा से $percent% लंबा है';
  }

  @override
  String get editTrip => 'यात्रा संपादित करें';

  @override
  String get addTrip => 'यात्रा जोड़ें';

  @override
  String get dateAndTime => 'तारीख और समय';

  @override
  String get start => 'शुरू';

  @override
  String get end => 'समाप्त';

  @override
  String get fromPlaceholder => 'से';

  @override
  String get toPlaceholder => 'तक';

  @override
  String get distanceAndType => 'दूरी और प्रकार';

  @override
  String get distanceKm => 'दूरी (किमी)';

  @override
  String get businessKm => 'व्यवसाय किमी';

  @override
  String get privateKm => 'निजी किमी';

  @override
  String get save => 'सहेजें';

  @override
  String get add => 'जोड़ें';

  @override
  String get deleteTrip => 'यात्रा हटाएं?';

  @override
  String get deleteTripConfirmation =>
      'क्या आप वाकई इस यात्रा को हटाना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get couldNotDelete => 'हटा नहीं सका';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get trips => 'यात्राएं';

  @override
  String get total => 'कुल';

  @override
  String get business => 'व्यवसाय';

  @override
  String get private => 'निजी';

  @override
  String get account => 'खाता';

  @override
  String get loggedIn => 'लॉग इन';

  @override
  String get googleAccount => 'Google खाता';

  @override
  String get loginWithGoogle => 'Google से लॉग इन करें';

  @override
  String get myCars => 'मेरी कारें';

  @override
  String carsCount(int count) {
    return '$count कारें';
  }

  @override
  String get manageVehicles => 'अपने वाहनों का प्रबंधन करें';

  @override
  String get location => 'स्थान';

  @override
  String get requestLocationPermission => 'स्थान अनुमति का अनुरोध करें';

  @override
  String get openIOSSettings => 'iOS सेटिंग्स खोलें';

  @override
  String get locationPermissionGranted => 'स्थान अनुमति दी गई!';

  @override
  String get locationPermissionDenied =>
      'स्थान अनुमति अस्वीकृत - सेटिंग्स में जाएं';

  @override
  String get enableLocationServices =>
      'पहले iOS सेटिंग्स में स्थान सेवाएं सक्षम करें';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'स्वचालित पहचान';

  @override
  String get autoDetectionSubtitle =>
      'CarPlay कनेक्ट होने पर यात्राएं स्वचालित शुरू/बंद करें';

  @override
  String get carPlayIsConnected => 'CarPlay कनेक्टेड है';

  @override
  String get queue => 'कतार';

  @override
  String queueItems(int count) {
    return 'कतार में $count आइटम';
  }

  @override
  String get queueSubtitle => 'ऑनलाइन होने पर भेजे जाएंगे';

  @override
  String get sendNow => 'अभी भेजें';

  @override
  String get aboutApp => 'इस ऐप के बारे में';

  @override
  String get aboutDescription =>
      'यह ऐप माइलेज ट्रैकिंग के लिए iPhone शॉर्टकट ऑटोमेशन की जगह लेता है। यह ब्लूटूथ/CarPlay के माध्यम से स्वचालित रूप से पता लगाता है कि आप कार में कब बैठते हैं और यात्राएं रिकॉर्ड करता है।';

  @override
  String loggedInAs(String email) {
    return '$email के रूप में लॉग इन';
  }

  @override
  String errorSaving(String error) {
    return 'सहेजने में त्रुटि: $error';
  }

  @override
  String get carSettingsSaved => 'कार सेटिंग्स सहेजी गईं';

  @override
  String get enterUsernamePassword => 'उपयोगकर्ता नाम और पासवर्ड दर्ज करें';

  @override
  String get cars => 'कारें';

  @override
  String get addCar => 'कार जोड़ें';

  @override
  String get noCarsAdded => 'अभी तक कोई कार नहीं जोड़ी गई';

  @override
  String get defaultBadge => 'डिफ़ॉल्ट';

  @override
  String get editCar => 'कार संपादित करें';

  @override
  String get name => 'नाम';

  @override
  String get nameHint => 'उदा. Audi Q4 e-tron';

  @override
  String get enterName => 'नाम दर्ज करें';

  @override
  String get brand => 'ब्रांड';

  @override
  String get color => 'रंग';

  @override
  String get icon => 'आइकन';

  @override
  String get defaultCar => 'डिफ़ॉल्ट कार';

  @override
  String get defaultCarSubtitle => 'नई यात्राएं इस कार से जुड़ी होंगी';

  @override
  String get bluetoothDevice => 'ब्लूटूथ डिवाइस';

  @override
  String get autoSetOnConnect => 'कनेक्ट होने पर स्वचालित सेट होगा';

  @override
  String get autoSetOnConnectFull =>
      'CarPlay/ब्लूटूथ से कनेक्ट होने पर स्वचालित सेट होगा';

  @override
  String get carApiConnection => 'कार API कनेक्शन';

  @override
  String connectWithBrand(String brand) {
    return 'माइलेज और बैटरी स्थिति के लिए $brand से कनेक्ट करें';
  }

  @override
  String get brandAudi => 'ऑडी';

  @override
  String get brandVolkswagen => 'फॉक्सवैगन';

  @override
  String get brandSkoda => 'स्कोडा';

  @override
  String get brandSeat => 'सीट';

  @override
  String get brandCupra => 'कुप्रा';

  @override
  String get brandRenault => 'रेनॉल्ट';

  @override
  String get brandTesla => 'टेस्ला';

  @override
  String get brandBMW => 'बीएमडब्ल्यू';

  @override
  String get brandMercedes => 'मर्सिडीज';

  @override
  String get brandOther => 'अन्य';

  @override
  String get iconSedan => 'सेडान';

  @override
  String get iconSUV => 'एसयूवी';

  @override
  String get iconHatchback => 'हैचबैक';

  @override
  String get iconSport => 'स्पोर्ट';

  @override
  String get iconVan => 'वैन';

  @override
  String get loginWithTesla => 'Tesla से लॉग इन करें';

  @override
  String get teslaLoginInfo =>
      'आपको लॉग इन करने के लिए Tesla पर रीडायरेक्ट किया जाएगा। उसके बाद आप अपनी कार डेटा देख सकते हैं।';

  @override
  String get usernameEmail => 'उपयोगकर्ता नाम / ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get country => 'देश';

  @override
  String get countryHint => 'IN';

  @override
  String get testApi => 'API टेस्ट करें';

  @override
  String get carUpdated => 'कार अपडेट की गई';

  @override
  String get carAdded => 'कार जोड़ी गई';

  @override
  String errorMessage(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get carDeleted => 'कार हटाई गई';

  @override
  String get deleteCar => 'कार हटाएं?';

  @override
  String deleteCarConfirmation(String carName) {
    return 'क्या आप वाकई \"$carName\" हटाना चाहते हैं? इस कार से जुड़ी सभी यात्राएं अपना डेटा रखेंगी।';
  }

  @override
  String get apiSettingsSaved => 'API सेटिंग्स सहेजी गईं';

  @override
  String get teslaAlreadyLinked => 'Tesla पहले से लिंक है!';

  @override
  String get teslaLinked => 'Tesla लिंक हो गई!';

  @override
  String get teslaLinkFailed => 'Tesla लिंक विफल';

  @override
  String get startTrip => 'यात्रा शुरू करें';

  @override
  String get stopTrip => 'यात्रा समाप्त करें';

  @override
  String get gpsActiveTracking => 'GPS सक्रिय - स्वचालित ट्रैकिंग';

  @override
  String get activeTrip => 'सक्रिय यात्रा';

  @override
  String startedAt(String time) {
    return 'शुरू: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count GPS पॉइंट';
  }

  @override
  String get km => 'किमी';

  @override
  String updatedAt(String time) {
    return 'अपडेट: $time';
  }

  @override
  String get battery => 'बैटरी';

  @override
  String get status => 'स्थिति';

  @override
  String get odometer => 'ओडोमीटर';

  @override
  String get stateParked => 'पार्क';

  @override
  String get stateDriving => 'ड्राइविंग';

  @override
  String get stateCharging => 'चार्जिंग';

  @override
  String get stateUnknown => 'अज्ञात';

  @override
  String chargingPower(double power) {
    return 'चार्जिंग: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'तैयार: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursघं $minutesमि';
  }

  @override
  String get addFirstCar => 'अपनी पहली कार जोड़ें';

  @override
  String get toTrackPerCar => 'कार के अनुसार यात्राएं ट्रैक करने के लिए';

  @override
  String get selectCar => 'कार चुनें';

  @override
  String get manageCars => 'कारें प्रबंधित करें';

  @override
  String get unknownDevice => 'अज्ञात डिवाइस';

  @override
  String deviceName(String name) {
    return 'डिवाइस: $name';
  }

  @override
  String get linkToCar => 'कार से लिंक करें:';

  @override
  String get noCarsFound => 'कोई कार नहीं मिली। पहले एक कार जोड़ें।';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName को $deviceName से लिंक किया गया - यात्रा शुरू!';
  }

  @override
  String linkError(String error) {
    return 'लिंक त्रुटि: $error';
  }

  @override
  String get required => 'आवश्यक';

  @override
  String get invalidDistance => 'अमान्य दूरी';
}
