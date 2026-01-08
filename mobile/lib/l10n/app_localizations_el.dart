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
}
