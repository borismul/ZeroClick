// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Καταγραφή Χιλιομέτρων';

  @override
  String get tabStatus => 'Κατάσταση';

  @override
  String get tabTrips => 'Διαδρομές';

  @override
  String get tabSettings => 'Ρυθμίσεις';

  @override
  String get tabCharging => 'Φόρτιση';

  @override
  String get chargingStations => 'σταθμοί φόρτισης';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String get importantTitle => 'Σημαντικό';

  @override
  String get backgroundWarningMessage =>
      'Αυτή η εφαρμογή ανιχνεύει αυτόματα όταν μπαίνετε στο αυτοκίνητο μέσω Bluetooth.\n\nΑυτό λειτουργεί μόνο αν η εφαρμογή τρέχει στο παρασκήνιο. Αν κλείσετε την εφαρμογή (σύρετε προς τα πάνω), η αυτόματη ανίχνευση θα σταματήσει.\n\nΣυμβουλή: Απλά αφήστε την εφαρμογή ανοιχτή και όλα θα λειτουργούν αυτόματα.';

  @override
  String get understood => 'Κατάλαβα';

  @override
  String get loginPrompt => 'Συνδεθείτε για να ξεκινήσετε';

  @override
  String get loginSubtitle =>
      'Συνδεθείτε με τον λογαριασμό Google και ρυθμίστε το API του αυτοκινήτου';

  @override
  String get goToSettings => 'Μετάβαση στις Ρυθμίσεις';

  @override
  String get carPlayConnected => 'CarPlay συνδεδεμένο';

  @override
  String get offlineWarning => 'Εκτός σύνδεσης - οι ενέργειες θα μπουν σε ουρά';

  @override
  String get recentTrips => 'Πρόσφατες διαδρομές';

  @override
  String get configureFirst => 'Ρυθμίστε πρώτα την εφαρμογή στις Ρυθμίσεις';

  @override
  String get noTripsYet => 'Δεν υπάρχουν διαδρομές ακόμα';

  @override
  String routeLongerPercent(int percent) {
    return 'Διαδρομή +$percent% μεγαλύτερη';
  }

  @override
  String get route => 'Διαδρομή';

  @override
  String get from => 'Από';

  @override
  String get to => 'Προς';

  @override
  String get details => 'Λεπτομέρειες';

  @override
  String get date => 'Ημερομηνία';

  @override
  String get time => 'Ώρα';

  @override
  String get distance => 'Απόσταση';

  @override
  String get type => 'Τύπος';

  @override
  String get tripTypeBusiness => 'Επαγγελματική';

  @override
  String get tripTypePrivate => 'Προσωπική';

  @override
  String get tripTypeMixed => 'Μικτή';

  @override
  String get googleMaps => 'Google Maps';

  @override
  String get routeDeviation => 'Απόκλιση διαδρομής';

  @override
  String get car => 'Αυτοκίνητο';

  @override
  String routeDeviationWarning(int percent) {
    return 'Η διαδρομή είναι $percent% μεγαλύτερη από την αναμενόμενη μέσω Google Maps';
  }

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get editTrip => 'Επεξεργασία διαδρομής';

  @override
  String get addTrip => 'Προσθήκη διαδρομής';

  @override
  String get dateAndTime => 'Ημερομηνία & Ώρα';

  @override
  String get start => 'Έναρξη';

  @override
  String get end => 'Λήξη';

  @override
  String get fromPlaceholder => 'Από';

  @override
  String get toPlaceholder => 'Προς';

  @override
  String get distanceAndType => 'Απόσταση & Τύπος';

  @override
  String get distanceKm => 'Απόσταση (km)';

  @override
  String get businessKm => 'Επαγγελματικά km';

  @override
  String get privateKm => 'Προσωπικά km';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get add => 'Προσθήκη';

  @override
  String get deleteTrip => 'Διαγραφή διαδρομής;';

  @override
  String get deleteTripConfirmation =>
      'Είστε βέβαιοι ότι θέλετε να διαγράψετε αυτή τη διαδρομή;';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get somethingWentWrong => 'Κάτι πήγε στραβά';

  @override
  String get couldNotDelete => 'Αδυναμία διαγραφής';

  @override
  String get statistics => 'Στατιστικά';

  @override
  String get trips => 'Διαδρομές';

  @override
  String get total => 'Σύνολο';

  @override
  String get business => 'Επαγγελματικές';

  @override
  String get private => 'Προσωπικές';

  @override
  String get account => 'Λογαριασμός';

  @override
  String get loggedIn => 'Συνδεδεμένος';

  @override
  String get googleAccount => 'Λογαριασμός Google';

  @override
  String get loginWithGoogle => 'Σύνδεση με Google';

  @override
  String get myCars => 'Τα Αυτοκίνητά μου';

  @override
  String carsCount(int count) {
    return '$count αυτοκίνητα';
  }

  @override
  String get manageVehicles => 'Διαχειριστείτε τα οχήματά σας';

  @override
  String get location => 'Τοποθεσία';

  @override
  String get requestLocationPermission => 'Αίτημα Άδειας Τοποθεσίας';

  @override
  String get openIOSSettings => 'Άνοιγμα Ρυθμίσεων iOS';

  @override
  String get locationPermissionGranted => 'Δόθηκε άδεια τοποθεσίας!';

  @override
  String get locationPermissionDenied =>
      'Απορρίφθηκε η άδεια τοποθεσίας - πηγαίνετε στις Ρυθμίσεις';

  @override
  String get enableLocationServices =>
      'Ενεργοποιήστε πρώτα τις Υπηρεσίες Τοποθεσίας στις Ρυθμίσεις iOS';

  @override
  String get carPlay => 'CarPlay';

  @override
  String get automaticDetection => 'Αυτόματη ανίχνευση';

  @override
  String get autoDetectionSubtitle =>
      'Αυτόματη έναρξη/διακοπή διαδρομών με σύνδεση CarPlay';

  @override
  String get carPlayIsConnected => 'Το CarPlay είναι συνδεδεμένο';

  @override
  String get queue => 'Ουρά';

  @override
  String queueItems(int count) {
    return '$count στοιχεία στην ουρά';
  }

  @override
  String get queueSubtitle => 'Θα αποσταλούν όταν συνδεθείτε';

  @override
  String get sendNow => 'Αποστολή τώρα';

  @override
  String get aboutApp => 'Σχετικά με την εφαρμογή';

  @override
  String get aboutDescription =>
      'Αυτή η εφαρμογή αντικαθιστά την αυτοματοποίηση Συντομεύσεων iPhone για την καταγραφή χιλιομέτρων. Ανιχνεύει αυτόματα όταν μπαίνετε στο αυτοκίνητο μέσω Bluetooth/CarPlay και καταγράφει διαδρομές.';

  @override
  String loggedInAs(String email) {
    return 'Συνδεδεμένος ως $email';
  }

  @override
  String errorSaving(String error) {
    return 'Σφάλμα αποθήκευσης: $error';
  }

  @override
  String get carSettingsSaved => 'Αποθηκεύτηκαν οι ρυθμίσεις αυτοκινήτου';

  @override
  String get enterUsernamePassword => 'Εισάγετε όνομα χρήστη και κωδικό';

  @override
  String get cars => 'Αυτοκίνητα';

  @override
  String get addCar => 'Προσθήκη αυτοκινήτου';

  @override
  String get noCarsAdded => 'Δεν έχουν προστεθεί αυτοκίνητα';

  @override
  String get defaultBadge => 'Προεπιλογή';

  @override
  String get editCar => 'Επεξεργασία αυτοκινήτου';

  @override
  String get name => 'Όνομα';

  @override
  String get nameHint => 'π.χ. Audi Q4 e-tron';

  @override
  String get enterName => 'Εισάγετε όνομα';

  @override
  String get brand => 'Μάρκα';

  @override
  String get color => 'Χρώμα';

  @override
  String get icon => 'Εικονίδιο';

  @override
  String get defaultCar => 'Προεπιλεγμένο αυτοκίνητο';

  @override
  String get defaultCarSubtitle =>
      'Νέες διαδρομές θα συνδέονται με αυτό το αυτοκίνητο';

  @override
  String get bluetoothDevice => 'Συσκευή Bluetooth';

  @override
  String get autoSetOnConnect => 'Θα ρυθμιστεί αυτόματα με τη σύνδεση';

  @override
  String get autoSetOnConnectFull =>
      'Θα ρυθμιστεί αυτόματα με τη σύνδεση CarPlay/Bluetooth';

  @override
  String get carApiConnection => 'Σύνδεση API Αυτοκινήτου';

  @override
  String connectWithBrand(String brand) {
    return 'Συνδεθείτε με $brand για χιλιόμετρα και κατάσταση μπαταρίας';
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
  String get brandOther => 'Άλλο';

  @override
  String get iconSedan => 'Σεντάν';

  @override
  String get iconSUV => 'SUV';

  @override
  String get iconHatchback => 'Χάτσμπακ';

  @override
  String get iconSport => 'Σπορ';

  @override
  String get iconVan => 'Βαν';

  @override
  String get loginWithTesla => 'Σύνδεση με Tesla';

  @override
  String get teslaLoginInfo =>
      'Θα μεταφερθείτε στην Tesla για σύνδεση. Μετά μπορείτε να δείτε τα δεδομένα του αυτοκινήτου.';

  @override
  String get usernameEmail => 'Όνομα χρήστη / Email';

  @override
  String get password => 'Κωδικός';

  @override
  String get country => 'Χώρα';

  @override
  String get countryHint => 'GR';

  @override
  String get testApi => 'Δοκιμή API';

  @override
  String get carUpdated => 'Το αυτοκίνητο ενημερώθηκε';

  @override
  String get carAdded => 'Το αυτοκίνητο προστέθηκε';

  @override
  String errorMessage(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get carDeleted => 'Το αυτοκίνητο διαγράφηκε';

  @override
  String get deleteCar => 'Διαγραφή αυτοκινήτου;';

  @override
  String deleteCarConfirmation(String carName) {
    return 'Είστε βέβαιοι ότι θέλετε να διαγράψετε το \"$carName\"; Όλες οι διαδρομές που συνδέονται με αυτό το αυτοκίνητο θα διατηρήσουν τα δεδομένα τους.';
  }

  @override
  String get apiSettingsSaved => 'Αποθηκεύτηκαν οι ρυθμίσεις API';

  @override
  String get teslaAlreadyLinked => 'Η Tesla είναι ήδη συνδεδεμένη!';

  @override
  String get teslaLinked => 'Η Tesla συνδέθηκε!';

  @override
  String get teslaLinkFailed => 'Αποτυχία σύνδεσης Tesla';

  @override
  String get startTrip => 'Έναρξη Διαδρομής';

  @override
  String get stopTrip => 'Τέλος Διαδρομής';

  @override
  String get gpsActiveTracking => 'GPS ενεργό - αυτόματη παρακολούθηση';

  @override
  String get activeTrip => 'Ενεργή διαδρομή';

  @override
  String startedAt(String time) {
    return 'Έναρξη: $time';
  }

  @override
  String gpsPoints(int count) {
    return '$count σημεία GPS';
  }

  @override
  String get km => 'km';

  @override
  String updatedAt(String time) {
    return 'Ενημέρωση: $time';
  }

  @override
  String get battery => 'Μπαταρία';

  @override
  String get status => 'Κατάσταση';

  @override
  String get odometer => 'Χιλιόμετρα';

  @override
  String get stateParked => 'Σταθμευμένο';

  @override
  String get stateDriving => 'Σε κίνηση';

  @override
  String get stateCharging => 'Φόρτιση';

  @override
  String get stateUnknown => 'Άγνωστο';

  @override
  String chargingPower(double power) {
    return 'Φόρτιση: $power kW';
  }

  @override
  String readyIn(String time) {
    return 'Έτοιμο σε: $time';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes λεπτά';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hoursω $minutesλ';
  }

  @override
  String get addFirstCar => 'Προσθέστε το πρώτο σας αυτοκίνητο';

  @override
  String get toTrackPerCar => 'Για παρακολούθηση διαδρομών ανά αυτοκίνητο';

  @override
  String get selectCar => 'Επιλογή αυτοκινήτου';

  @override
  String get manageCars => 'Διαχείριση αυτοκινήτων';

  @override
  String get unknownDevice => 'Άγνωστη συσκευή';

  @override
  String deviceName(String name) {
    return 'Συσκευή: $name';
  }

  @override
  String get linkToCar => 'Σύνδεση με αυτοκίνητο:';

  @override
  String get noCarsFound =>
      'Δεν βρέθηκαν αυτοκίνητα. Προσθέστε πρώτα ένα αυτοκίνητο.';

  @override
  String carLinkedSuccess(String carName, String deviceName) {
    return '$carName συνδέθηκε με $deviceName - Η διαδρομή ξεκίνησε!';
  }

  @override
  String linkError(String error) {
    return 'Σφάλμα σύνδεσης: $error';
  }

  @override
  String get required => 'Απαιτείται';

  @override
  String get invalidDistance => 'Μη έγκυρη απόσταση';

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
}
