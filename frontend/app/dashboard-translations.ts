import { Locale } from './login/translations';

export interface DashboardTranslations {
  // App header
  appTitle: string;
  logout: string;

  // Tabs
  tabStatus: string;
  tabTrips: string;
  tabSettings: string;

  // Active trip banner
  activeTrip: string;
  started: string;
  kmDriven: string;

  // Car status
  car: string;
  battery: string;
  status: string;
  parked: string;
  driving: string;
  charging: string;
  chargingStatus: string;
  readyBy: string;
  chargingComplete: string;
  details: string;
  range: string;
  unknown: string;
  batteryTemp: string;
  plug: string;
  pluggedIn: string;
  notPluggedIn: string;
  chargingPower: string;
  readyIn: string;
  odometer: string;
  ac: string;
  on: string;
  off: string;
  seatHeating: string;
  windowHeating: string;
  connection: string;
  online: string;
  lights: string;
  viewLocation: string;
  loading: string;
  noDataAvailable: string;
  updated: string;

  // Statistics
  totalTrips: string;
  totalKm: string;
  businessKm: string;
  privateKm: string;

  // Trips section
  recentTrips: string;
  viewAllTrips: string;
  trips: string;
  addTrip: string;

  // Trip types
  business: string;
  private: string;
  mixed: string;

  // Table headers
  date: string;
  time: string;
  from: string;
  to: string;
  distance: string;
  route: string;
  type: string;
  action: string;

  // Trip details
  driven: string;
  googleMaps: string;
  removeFlag: string;
  markAsDeviant: string;

  // Pagination
  previous: string;
  next: string;
  page: string;

  // Debug section
  debug: string;
  odometerVerification: string;
  fetching: string;
  readOdometer: string;
  actualOdometer: string;
  calculatedFromTrips: string;
  difference: string;

  // Settings
  myCars: string;
  addCar: string;
  noCarsAdded: string;
  addFirstCar: string;
  defaultBadge: string;
  exportToSheets: string;
  spreadsheetId: string;
  allCars: string;
  separateSheets: string;
  exporting: string;
  export: string;

  // Edit trip modal
  editTrip: string;
  fromAddress: string;
  toAddress: string;
  distanceKm: string;
  save: string;
  cancel: string;

  // Add trip modal
  addTripTitle: string;
  exampleHome: string;
  exampleClient: string;
  add: string;

  // Add car modal
  addCarTitle: string;
  name: string;
  namePlaceholder: string;
  brand: string;
  color: string;
  apiCredentials: string;
  username: string;
  password: string;
  country: string;

  // Edit car modal
  editCar: string;
  defaultCar: string;
  startOdometer: string;
  startOdometerHint: string;
  apiConnection: string;
  emailUsername: string;
  saved: string;
  testing: string;
  testApi: string;
  saveApi: string;
  saveCar: string;
  close: string;
  delete: string;

  // Save location modal
  saveLocation: string;
  locationName: string;

  // Confirmation messages
  confirmDeleteCar: string;
  couldNotDeleteCar: string;
  saveFailed: string;
  testFailed: string;
  home: string;
  office: string;
  confirmDeleteTrip: string;
  exportSuccess: string;
  exportFailed: string;

  // Map
  map: string;
  edit: string;
  routeLoading: string;
  expected: string;
  drivenRoute: string;
}

export const dashboardTranslations: Record<Locale, DashboardTranslations> = {
  en: {
    appTitle: 'Mileage Registration',
    logout: 'Log out',
    tabStatus: 'Status',
    tabTrips: 'Trips',
    tabSettings: 'Settings',
    activeTrip: 'Active trip',
    started: 'Started:',
    kmDriven: 'km driven',
    car: 'Car',
    battery: 'Battery',
    status: 'Status',
    parked: 'Parked',
    driving: 'Driving',
    charging: 'Charging',
    chargingStatus: 'Charging',
    readyBy: 'Ready by',
    chargingComplete: 'Charging complete',
    details: 'Details',
    range: 'Range',
    unknown: 'Unknown',
    batteryTemp: 'Battery temp',
    plug: 'Plug',
    pluggedIn: 'Plugged in',
    notPluggedIn: 'Not plugged in',
    chargingPower: 'Charging power',
    readyIn: 'Ready in',
    odometer: 'Odometer',
    ac: 'AC',
    on: 'On',
    off: 'Off',
    seatHeating: 'Seat heating',
    windowHeating: 'Window heating',
    connection: 'Connection',
    online: 'Online',
    lights: 'Lights',
    viewLocation: 'View location →',
    loading: 'Loading...',
    noDataAvailable: 'No data available',
    updated: 'Updated:',
    totalTrips: 'Total trips',
    totalKm: 'Total km',
    businessKm: 'Business km',
    privateKm: 'Private km',
    recentTrips: 'Recent trips',
    viewAllTrips: 'View all trips →',
    trips: 'Trips',
    addTrip: '+ Add trip',
    business: 'Business',
    private: 'Private',
    mixed: 'Mixed',
    date: 'Date',
    time: 'Time',
    from: 'From',
    to: 'To',
    distance: 'Distance',
    route: 'Route',
    type: 'Type',
    action: 'Action',
    driven: 'Driven:',
    googleMaps: 'Google Maps:',
    removeFlag: 'Remove flag',
    markAsDeviant: 'Mark as deviant',
    previous: '← Previous',
    next: 'Next →',
    page: 'Page',
    debug: 'Debug',
    odometerVerification: 'Odometer Verification',
    fetching: 'Fetching...',
    readOdometer: 'Read odometer',
    actualOdometer: 'Actual odometer',
    calculatedFromTrips: 'Calculated from trips',
    difference: 'Difference',
    myCars: 'My Cars',
    addCar: '+ Add car',
    noCarsAdded: 'No cars added yet',
    addFirstCar: '+ Add first car',
    defaultBadge: 'Default',
    exportToSheets: 'Export to Google Sheets',
    spreadsheetId: 'Spreadsheet ID (from URL)',
    allCars: 'All cars',
    separateSheets: 'Separate sheets per car',
    exporting: 'Exporting...',
    export: 'Export',
    editTrip: 'Edit trip',
    fromAddress: 'From address',
    toAddress: 'To address',
    distanceKm: 'Distance (km)',
    save: 'Save',
    cancel: 'Cancel',
    addTripTitle: 'Add trip',
    exampleHome: 'E.g. Home',
    exampleClient: 'E.g. Client ABC',
    add: 'Add',
    addCarTitle: 'Add car',
    name: 'Name',
    namePlaceholder: 'E.g. Audi Q4 e-tron',
    brand: 'Brand',
    color: 'Color',
    apiCredentials: 'API Credentials (optional)',
    username: 'Username',
    password: 'Password',
    country: 'Country',
    editCar: 'Edit car',
    defaultCar: 'Default car',
    startOdometer: 'Start odometer',
    startOdometerHint: 'For km verification - odometer at first trip',
    apiConnection: 'API Connection',
    emailUsername: 'Email / Username',
    saved: 'Saved!',
    testing: 'Testing...',
    testApi: 'Test API',
    saveApi: 'Save API',
    saveCar: 'Save Car',
    close: 'Close',
    delete: 'Delete',
    saveLocation: 'Save location',
    locationName: 'Name for this location',
    confirmDeleteCar: 'Are you sure you want to delete this car?',
    couldNotDeleteCar: 'Could not delete car',
    saveFailed: 'Save failed',
    testFailed: 'Test failed',
    home: 'Home',
    office: 'Office',
    confirmDeleteTrip: 'Are you sure you want to delete this trip?',
    exportSuccess: 'Export successful! {count} trips exported to sheet "{sheet}"',
    exportFailed: 'Export failed',
    map: 'Map',
    edit: 'Edit',
    routeLoading: 'Loading route...',
    expected: 'Expected',
    drivenRoute: 'Driven',
  },
  nl: {
    appTitle: 'Kilometerregistratie',
    logout: 'Uitloggen',
    tabStatus: 'Status',
    tabTrips: 'Ritten',
    tabSettings: 'Instellingen',
    activeTrip: 'Actieve rit',
    started: 'Gestart:',
    kmDriven: 'km gereden',
    car: 'Auto',
    battery: 'Batterij',
    status: 'Status',
    parked: 'Geparkeerd',
    driving: 'Rijdend',
    charging: 'Laden',
    chargingStatus: 'Laden',
    readyBy: 'Klaar om',
    chargingComplete: 'Laden klaar',
    details: 'Details',
    range: 'Bereik',
    unknown: 'Onbekend',
    batteryTemp: 'Batterij temp',
    plug: 'Stekker',
    pluggedIn: 'Aangesloten',
    notPluggedIn: 'Niet aangesloten',
    chargingPower: 'Laadvermogen',
    readyIn: 'Klaar over',
    odometer: 'Kilometerstand',
    ac: 'Airco',
    on: 'Aan',
    off: 'Uit',
    seatHeating: 'Stoelverwarming',
    windowHeating: 'Ruitverwarming',
    connection: 'Connectie',
    online: 'Online',
    lights: 'Lampen',
    viewLocation: 'Bekijk locatie →',
    loading: 'Laden...',
    noDataAvailable: 'Geen data beschikbaar',
    updated: 'Bijgewerkt:',
    totalTrips: 'Totaal ritten',
    totalKm: 'Totaal km',
    businessKm: 'Zakelijk km',
    privateKm: 'Privé km',
    recentTrips: 'Laatste ritten',
    viewAllTrips: 'Alle ritten bekijken →',
    trips: 'Ritten',
    addTrip: '+ Rit toevoegen',
    business: 'Zakelijk',
    private: 'Privé',
    mixed: 'Gemengd',
    date: 'Datum',
    time: 'Tijd',
    from: 'Van',
    to: 'Naar',
    distance: 'Afstand',
    route: 'Route',
    type: 'Type',
    action: 'Actie',
    driven: 'Gereden:',
    googleMaps: 'Google Maps:',
    removeFlag: 'Vlag verwijderen',
    markAsDeviant: 'Markeer als afwijkend',
    previous: '← Vorige',
    next: 'Volgende →',
    page: 'Pagina',
    debug: 'Debug',
    odometerVerification: 'Kilometerstand Verificatie',
    fetching: 'Ophalen...',
    readOdometer: 'Uitlezen',
    actualOdometer: 'Werkelijke km-stand',
    calculatedFromTrips: 'Berekend uit ritten',
    difference: 'Verschil',
    myCars: 'Mijn Auto\'s',
    addCar: '+ Auto toevoegen',
    noCarsAdded: 'Nog geen auto\'s toegevoegd',
    addFirstCar: '+ Eerste auto toevoegen',
    defaultBadge: 'Standaard',
    exportToSheets: 'Exporteren naar Google Sheets',
    spreadsheetId: 'Spreadsheet ID (uit URL)',
    allCars: 'Alle auto\'s',
    separateSheets: 'Aparte sheets per auto',
    exporting: 'Bezig...',
    export: 'Exporteren',
    editTrip: 'Rit bewerken',
    fromAddress: 'Van adres',
    toAddress: 'Naar adres',
    distanceKm: 'Afstand (km)',
    save: 'Opslaan',
    cancel: 'Annuleren',
    addTripTitle: 'Rit toevoegen',
    exampleHome: 'Bijv. Thuis',
    exampleClient: 'Bijv. Klant ABC',
    add: 'Toevoegen',
    addCarTitle: 'Auto toevoegen',
    name: 'Naam',
    namePlaceholder: 'Bijv. Audi Q4 e-tron',
    brand: 'Merk',
    color: 'Kleur',
    apiCredentials: 'API Inloggegevens (optioneel)',
    username: 'Gebruikersnaam',
    password: 'Wachtwoord',
    country: 'Land',
    editCar: 'Auto bewerken',
    defaultCar: 'Standaard auto',
    startOdometer: 'Start kilometerstand',
    startOdometerHint: 'Voor km verificatie - kilometerstand bij eerste rit',
    apiConnection: 'API Koppeling',
    emailUsername: 'E-mail / Gebruikersnaam',
    saved: 'Opgeslagen!',
    testing: 'Testen...',
    testApi: 'Test API',
    saveApi: 'API Opslaan',
    saveCar: 'Auto Opslaan',
    close: 'Sluiten',
    delete: 'Verwijderen',
    saveLocation: 'Locatie opslaan',
    locationName: 'Naam voor deze locatie',
    confirmDeleteCar: 'Weet je zeker dat je deze auto wilt verwijderen?',
    couldNotDeleteCar: 'Kon auto niet verwijderen',
    saveFailed: 'Opslaan mislukt',
    testFailed: 'Test mislukt',
    home: 'Thuis',
    office: 'Kantoor',
    confirmDeleteTrip: 'Weet je zeker dat je deze rit wilt verwijderen?',
    exportSuccess: 'Export succesvol! {count} ritten geëxporteerd naar sheet "{sheet}"',
    exportFailed: 'Export mislukt',
    map: 'Kaart',
    edit: 'Bewerken',
    routeLoading: 'Route laden...',
    expected: 'Verwacht',
    drivenRoute: 'Gereden',
  },
  de: {
    appTitle: 'Kilometererfassung',
    logout: 'Abmelden',
    tabStatus: 'Status',
    tabTrips: 'Fahrten',
    tabSettings: 'Einstellungen',
    activeTrip: 'Aktive Fahrt',
    started: 'Gestartet:',
    kmDriven: 'km gefahren',
    car: 'Auto',
    battery: 'Batterie',
    status: 'Status',
    parked: 'Geparkt',
    driving: 'Fahrend',
    charging: 'Laden',
    chargingStatus: 'Laden',
    readyBy: 'Fertig um',
    chargingComplete: 'Laden abgeschlossen',
    details: 'Details',
    range: 'Reichweite',
    unknown: 'Unbekannt',
    batteryTemp: 'Batterietemperatur',
    plug: 'Stecker',
    pluggedIn: 'Angeschlossen',
    notPluggedIn: 'Nicht angeschlossen',
    chargingPower: 'Ladeleistung',
    readyIn: 'Fertig in',
    odometer: 'Kilometerstand',
    ac: 'Klimaanlage',
    on: 'An',
    off: 'Aus',
    seatHeating: 'Sitzheizung',
    windowHeating: 'Scheibenheizung',
    connection: 'Verbindung',
    online: 'Online',
    lights: 'Lichter',
    viewLocation: 'Standort anzeigen →',
    loading: 'Laden...',
    noDataAvailable: 'Keine Daten verfügbar',
    updated: 'Aktualisiert:',
    totalTrips: 'Fahrten gesamt',
    totalKm: 'Gesamt km',
    businessKm: 'Geschäftlich km',
    privateKm: 'Privat km',
    recentTrips: 'Letzte Fahrten',
    viewAllTrips: 'Alle Fahrten anzeigen →',
    trips: 'Fahrten',
    addTrip: '+ Fahrt hinzufügen',
    business: 'Geschäftlich',
    private: 'Privat',
    mixed: 'Gemischt',
    date: 'Datum',
    time: 'Zeit',
    from: 'Von',
    to: 'Nach',
    distance: 'Entfernung',
    route: 'Route',
    type: 'Typ',
    action: 'Aktion',
    driven: 'Gefahren:',
    googleMaps: 'Google Maps:',
    removeFlag: 'Markierung entfernen',
    markAsDeviant: 'Als abweichend markieren',
    previous: '← Zurück',
    next: 'Weiter →',
    page: 'Seite',
    debug: 'Debug',
    odometerVerification: 'Kilometerstand-Überprüfung',
    fetching: 'Abrufen...',
    readOdometer: 'Auslesen',
    actualOdometer: 'Tatsächlicher km-Stand',
    calculatedFromTrips: 'Berechnet aus Fahrten',
    difference: 'Differenz',
    myCars: 'Meine Autos',
    addCar: '+ Auto hinzufügen',
    noCarsAdded: 'Noch keine Autos hinzugefügt',
    addFirstCar: '+ Erstes Auto hinzufügen',
    defaultBadge: 'Standard',
    exportToSheets: 'Nach Google Sheets exportieren',
    spreadsheetId: 'Spreadsheet-ID (aus URL)',
    allCars: 'Alle Autos',
    separateSheets: 'Separate Sheets pro Auto',
    exporting: 'Exportieren...',
    export: 'Exportieren',
    editTrip: 'Fahrt bearbeiten',
    fromAddress: 'Von Adresse',
    toAddress: 'Nach Adresse',
    distanceKm: 'Entfernung (km)',
    save: 'Speichern',
    cancel: 'Abbrechen',
    addTripTitle: 'Fahrt hinzufügen',
    exampleHome: 'Z.B. Zuhause',
    exampleClient: 'Z.B. Kunde ABC',
    add: 'Hinzufügen',
    addCarTitle: 'Auto hinzufügen',
    name: 'Name',
    namePlaceholder: 'Z.B. Audi Q4 e-tron',
    brand: 'Marke',
    color: 'Farbe',
    apiCredentials: 'API-Anmeldedaten (optional)',
    username: 'Benutzername',
    password: 'Passwort',
    country: 'Land',
    editCar: 'Auto bearbeiten',
    defaultCar: 'Standardauto',
    startOdometer: 'Startkilometerstand',
    startOdometerHint: 'Für km-Überprüfung - Kilometerstand bei erster Fahrt',
    apiConnection: 'API-Verbindung',
    emailUsername: 'E-Mail / Benutzername',
    saved: 'Gespeichert!',
    testing: 'Testen...',
    testApi: 'API testen',
    saveApi: 'API speichern',
    saveCar: 'Auto speichern',
    close: 'Schließen',
    delete: 'Löschen',
    saveLocation: 'Standort speichern',
    locationName: 'Name für diesen Standort',
    confirmDeleteCar: 'Möchten Sie dieses Auto wirklich löschen?',
    couldNotDeleteCar: 'Auto konnte nicht gelöscht werden',
    saveFailed: 'Speichern fehlgeschlagen',
    testFailed: 'Test fehlgeschlagen',
    home: 'Zuhause',
    office: 'Büro',
    confirmDeleteTrip: 'Möchten Sie diese Fahrt wirklich löschen?',
    exportSuccess: 'Export erfolgreich! {count} Fahrten in Sheet "{sheet}" exportiert',
    exportFailed: 'Export fehlgeschlagen',
    map: 'Karte',
    edit: 'Bearbeiten',
    routeLoading: 'Route laden...',
    expected: 'Erwartet',
    drivenRoute: 'Gefahren',
  },
  fr: {
    appTitle: 'Suivi Kilométrique',
    logout: 'Déconnexion',
    tabStatus: 'Statut',
    tabTrips: 'Trajets',
    tabSettings: 'Paramètres',
    activeTrip: 'Trajet actif',
    started: 'Démarré:',
    kmDriven: 'km parcourus',
    car: 'Voiture',
    battery: 'Batterie',
    status: 'Statut',
    parked: 'Garé',
    driving: 'En route',
    charging: 'En charge',
    chargingStatus: 'En charge',
    readyBy: 'Prêt à',
    chargingComplete: 'Charge terminée',
    details: 'Détails',
    range: 'Autonomie',
    unknown: 'Inconnu',
    batteryTemp: 'Temp. batterie',
    plug: 'Prise',
    pluggedIn: 'Branché',
    notPluggedIn: 'Non branché',
    chargingPower: 'Puissance de charge',
    readyIn: 'Prêt dans',
    odometer: 'Compteur',
    ac: 'Climatisation',
    on: 'Activé',
    off: 'Désactivé',
    seatHeating: 'Sièges chauffants',
    windowHeating: 'Dégivrage',
    connection: 'Connexion',
    online: 'En ligne',
    lights: 'Feux',
    viewLocation: 'Voir la position →',
    loading: 'Chargement...',
    noDataAvailable: 'Aucune donnée disponible',
    updated: 'Mis à jour:',
    totalTrips: 'Total trajets',
    totalKm: 'Total km',
    businessKm: 'Km professionnels',
    privateKm: 'Km privés',
    recentTrips: 'Trajets récents',
    viewAllTrips: 'Voir tous les trajets →',
    trips: 'Trajets',
    addTrip: '+ Ajouter trajet',
    business: 'Professionnel',
    private: 'Privé',
    mixed: 'Mixte',
    date: 'Date',
    time: 'Heure',
    from: 'De',
    to: 'Vers',
    distance: 'Distance',
    route: 'Route',
    type: 'Type',
    action: 'Action',
    driven: 'Parcouru:',
    googleMaps: 'Google Maps:',
    removeFlag: 'Supprimer le marqueur',
    markAsDeviant: 'Marquer comme déviant',
    previous: '← Précédent',
    next: 'Suivant →',
    page: 'Page',
    debug: 'Debug',
    odometerVerification: 'Vérification du compteur',
    fetching: 'Récupération...',
    readOdometer: 'Lire compteur',
    actualOdometer: 'Compteur réel',
    calculatedFromTrips: 'Calculé à partir des trajets',
    difference: 'Différence',
    myCars: 'Mes Voitures',
    addCar: '+ Ajouter voiture',
    noCarsAdded: 'Aucune voiture ajoutée',
    addFirstCar: '+ Ajouter première voiture',
    defaultBadge: 'Par défaut',
    exportToSheets: 'Exporter vers Google Sheets',
    spreadsheetId: 'ID Spreadsheet (depuis URL)',
    allCars: 'Toutes les voitures',
    separateSheets: 'Feuilles séparées par voiture',
    exporting: 'Export en cours...',
    export: 'Exporter',
    editTrip: 'Modifier trajet',
    fromAddress: 'Adresse de départ',
    toAddress: 'Adresse d\'arrivée',
    distanceKm: 'Distance (km)',
    save: 'Enregistrer',
    cancel: 'Annuler',
    addTripTitle: 'Ajouter trajet',
    exampleHome: 'Ex. Domicile',
    exampleClient: 'Ex. Client ABC',
    add: 'Ajouter',
    addCarTitle: 'Ajouter voiture',
    name: 'Nom',
    namePlaceholder: 'Ex. Audi Q4 e-tron',
    brand: 'Marque',
    color: 'Couleur',
    apiCredentials: 'Identifiants API (optionnel)',
    username: 'Nom d\'utilisateur',
    password: 'Mot de passe',
    country: 'Pays',
    editCar: 'Modifier voiture',
    defaultCar: 'Voiture par défaut',
    startOdometer: 'Compteur de départ',
    startOdometerHint: 'Pour vérification km - compteur au premier trajet',
    apiConnection: 'Connexion API',
    emailUsername: 'E-mail / Nom d\'utilisateur',
    saved: 'Enregistré!',
    testing: 'Test en cours...',
    testApi: 'Tester API',
    saveApi: 'Enregistrer API',
    saveCar: 'Enregistrer Voiture',
    close: 'Fermer',
    delete: 'Supprimer',
    saveLocation: 'Enregistrer lieu',
    locationName: 'Nom pour ce lieu',
    confirmDeleteCar: 'Êtes-vous sûr de vouloir supprimer cette voiture?',
    couldNotDeleteCar: 'Impossible de supprimer la voiture',
    saveFailed: 'Échec de l\'enregistrement',
    testFailed: 'Échec du test',
    home: 'Domicile',
    office: 'Bureau',
    confirmDeleteTrip: 'Êtes-vous sûr de vouloir supprimer ce trajet?',
    exportSuccess: 'Export réussi! {count} trajets exportés vers la feuille "{sheet}"',
    exportFailed: 'Échec de l\'export',
    map: 'Carte',
    edit: 'Modifier',
    routeLoading: 'Chargement de la route...',
    expected: 'Prévu',
    drivenRoute: 'Parcouru',
  },
  // For remaining languages, use English as fallback initially
  // These will be properly translated
  es: {
    appTitle: 'Registro de Kilometraje',
    logout: 'Cerrar sesión',
    tabStatus: 'Estado',
    tabTrips: 'Viajes',
    tabSettings: 'Ajustes',
    activeTrip: 'Viaje activo',
    started: 'Iniciado:',
    kmDriven: 'km recorridos',
    car: 'Coche',
    battery: 'Batería',
    status: 'Estado',
    parked: 'Aparcado',
    driving: 'Conduciendo',
    charging: 'Cargando',
    chargingStatus: 'Cargando',
    readyBy: 'Listo a las',
    chargingComplete: 'Carga completa',
    details: 'Detalles',
    range: 'Autonomía',
    unknown: 'Desconocido',
    batteryTemp: 'Temp. batería',
    plug: 'Enchufe',
    pluggedIn: 'Conectado',
    notPluggedIn: 'No conectado',
    chargingPower: 'Potencia de carga',
    readyIn: 'Listo en',
    odometer: 'Cuentakilómetros',
    ac: 'Aire acondicionado',
    on: 'Encendido',
    off: 'Apagado',
    seatHeating: 'Asientos calefactados',
    windowHeating: 'Luneta térmica',
    connection: 'Conexión',
    online: 'En línea',
    lights: 'Luces',
    viewLocation: 'Ver ubicación →',
    loading: 'Cargando...',
    noDataAvailable: 'Sin datos disponibles',
    updated: 'Actualizado:',
    totalTrips: 'Total viajes',
    totalKm: 'Total km',
    businessKm: 'Km de negocios',
    privateKm: 'Km privados',
    recentTrips: 'Viajes recientes',
    viewAllTrips: 'Ver todos los viajes →',
    trips: 'Viajes',
    addTrip: '+ Añadir viaje',
    business: 'Negocios',
    private: 'Privado',
    mixed: 'Mixto',
    date: 'Fecha',
    time: 'Hora',
    from: 'Desde',
    to: 'Hasta',
    distance: 'Distancia',
    route: 'Ruta',
    type: 'Tipo',
    action: 'Acción',
    driven: 'Recorrido:',
    googleMaps: 'Google Maps:',
    removeFlag: 'Quitar marca',
    markAsDeviant: 'Marcar como desviado',
    previous: '← Anterior',
    next: 'Siguiente →',
    page: 'Página',
    debug: 'Debug',
    odometerVerification: 'Verificación del cuentakilómetros',
    fetching: 'Obteniendo...',
    readOdometer: 'Leer contador',
    actualOdometer: 'Contador real',
    calculatedFromTrips: 'Calculado de viajes',
    difference: 'Diferencia',
    myCars: 'Mis Coches',
    addCar: '+ Añadir coche',
    noCarsAdded: 'Sin coches añadidos',
    addFirstCar: '+ Añadir primer coche',
    defaultBadge: 'Por defecto',
    exportToSheets: 'Exportar a Google Sheets',
    spreadsheetId: 'ID de Spreadsheet (de URL)',
    allCars: 'Todos los coches',
    separateSheets: 'Hojas separadas por coche',
    exporting: 'Exportando...',
    export: 'Exportar',
    editTrip: 'Editar viaje',
    fromAddress: 'Dirección origen',
    toAddress: 'Dirección destino',
    distanceKm: 'Distancia (km)',
    save: 'Guardar',
    cancel: 'Cancelar',
    addTripTitle: 'Añadir viaje',
    exampleHome: 'Ej. Casa',
    exampleClient: 'Ej. Cliente ABC',
    add: 'Añadir',
    addCarTitle: 'Añadir coche',
    name: 'Nombre',
    namePlaceholder: 'Ej. Audi Q4 e-tron',
    brand: 'Marca',
    color: 'Color',
    apiCredentials: 'Credenciales API (opcional)',
    username: 'Usuario',
    password: 'Contraseña',
    country: 'País',
    editCar: 'Editar coche',
    defaultCar: 'Coche por defecto',
    startOdometer: 'Contador inicial',
    startOdometerHint: 'Para verificación km - contador en primer viaje',
    apiConnection: 'Conexión API',
    emailUsername: 'Email / Usuario',
    saved: '¡Guardado!',
    testing: 'Probando...',
    testApi: 'Probar API',
    saveApi: 'Guardar API',
    saveCar: 'Guardar Coche',
    close: 'Cerrar',
    delete: 'Eliminar',
    saveLocation: 'Guardar ubicación',
    locationName: 'Nombre para esta ubicación',
    confirmDeleteCar: '¿Seguro que quieres eliminar este coche?',
    couldNotDeleteCar: 'No se pudo eliminar el coche',
    saveFailed: 'Error al guardar',
    testFailed: 'Error en la prueba',
    home: 'Casa',
    office: 'Oficina',
    confirmDeleteTrip: '¿Seguro que quieres eliminar este viaje?',
    exportSuccess: '¡Exportación exitosa! {count} viajes exportados a la hoja "{sheet}"',
    exportFailed: 'Error en la exportación',
    map: 'Mapa',
    edit: 'Editar',
    routeLoading: 'Cargando ruta...',
    expected: 'Esperado',
    drivenRoute: 'Recorrido',
  },
  // Placeholders for other languages - copy from English
  it: {} as DashboardTranslations,
  pt: {} as DashboardTranslations,
  pl: {} as DashboardTranslations,
  ru: {} as DashboardTranslations,
  uk: {} as DashboardTranslations,
  cs: {} as DashboardTranslations,
  da: {} as DashboardTranslations,
  fi: {} as DashboardTranslations,
  sv: {} as DashboardTranslations,
  nb: {} as DashboardTranslations,
  hu: {} as DashboardTranslations,
  ro: {} as DashboardTranslations,
  el: {} as DashboardTranslations,
  tr: {} as DashboardTranslations,
  ar: {} as DashboardTranslations,
  he: {} as DashboardTranslations,
  hi: {} as DashboardTranslations,
  th: {} as DashboardTranslations,
  vi: {} as DashboardTranslations,
  id: {} as DashboardTranslations,
  ja: {} as DashboardTranslations,
  ko: {} as DashboardTranslations,
  zh: {} as DashboardTranslations,
};

// Fill in missing translations with English fallback
const fallbackLangs = ['it', 'pt', 'pl', 'ru', 'uk', 'cs', 'da', 'fi', 'sv', 'nb', 'hu', 'ro', 'el', 'tr', 'ar', 'he', 'hi', 'th', 'vi', 'id', 'ja', 'ko', 'zh'] as const;
for (const lang of fallbackLangs) {
  dashboardTranslations[lang] = { ...dashboardTranslations.en };
}

export function getDashboardTranslations(locale: Locale): DashboardTranslations {
  return dashboardTranslations[locale] || dashboardTranslations.en;
}
