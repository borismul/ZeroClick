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
  String get tabCharging => 'चार्जिंग';

  @override
  String get chargingStations => 'चार्जिंग स्टेशन';

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
  String get viewOnMap => 'View on Map';

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
