// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Accesso al Dashboard';

  @override
  String get authenticationPageSubheadline =>
      'Accesso sicuro per amministratori e editori.';

  @override
  String get authenticationEmailSignInButton => 'Accedi con Email';

  @override
  String get emailSignInPageTitle => 'Accesso Email Sicuro';

  @override
  String get requestCodePageHeadline => 'Accesso Email Sicuro';

  @override
  String get requestCodePageSubheadline =>
      'Inserisci la tua email per ricevere un codice.';

  @override
  String get requestCodeEmailLabel => 'Email';

  @override
  String get requestCodeEmailHint => 'tua.email@esempio.com';

  @override
  String get accountLinkingEmailValidationError =>
      'Inserisci un indirizzo email valido.';

  @override
  String get requestCodeSendCodeButton => 'Invia Codice';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Reinvia tra ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Verifica Codice';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'Abbiamo inviato un codice a 6 cifre a $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'Controlla la tua posta e inserisci il codice.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'In modalità demo, usa il codice: $code';
  }

  @override
  String get emailCodeVerificationHint => 'Codice a 6 cifre';

  @override
  String get emailCodeValidationEmptyError => 'Il codice non può essere vuoto.';

  @override
  String get emailCodeValidationLengthError =>
      'Il codice deve essere di 6 cifre.';

  @override
  String get emailCodeVerificationButtonLabel => 'Verifica Codice';

  @override
  String get overview => 'Panoramica';

  @override
  String get contentManagement => 'Gestione Contenuti';

  @override
  String get contentManagementPageDescription =>
      'Gestisci titoli, argomenti e fonti.';

  @override
  String get headlines => 'Titoli';

  @override
  String get headline => 'Titolo';

  @override
  String get topics => 'Argomenti';

  @override
  String get topic => 'Argomento';

  @override
  String get sources => 'Fonti';

  @override
  String get source => 'Fonte';

  @override
  String get appConfiguration => 'Config. Remota';

  @override
  String get appConfigurationPageDescription =>
      'Gestisci le impostazioni globali dell\'app.';

  @override
  String get settings => 'Impostazioni';

  @override
  String get appConfigurationPageTitle => 'Configurazione Remota';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Pubblicità';

  @override
  String get systemTab => 'Sistema';

  @override
  String get userContentLimitsTitle => 'Limiti Contenuti Utente';

  @override
  String get userContentLimitsDescription =>
      'Imposta i limiti per ogni livello utente.';

  @override
  String get feedActionsTitle => 'Azioni Feed';

  @override
  String get feedActionsDescription =>
      'Configura la frequenza dei widget nel feed.';

  @override
  String get feedDecoratorsTitle => 'Decoratori Feed';

  @override
  String get feedDecoratorsDescription =>
      'Configura la presentazione visiva nel feed.';

  @override
  String get adSettingsTitle => 'Impostazioni Pubblicitarie';

  @override
  String get adSettingsDescription =>
      'Gestisci frequenza e posizionamento annunci.';

  @override
  String get maintenanceModeTitle => 'Modalità Manutenzione';

  @override
  String get maintenanceModeDescription =>
      'Mostra una schermata di manutenzione a tutti.';

  @override
  String get forceUpdateTitle => 'Aggiornamento Forzato';

  @override
  String get forceUpdateDescription =>
      'Configura gli aggiornamenti obbligatori.';

  @override
  String get forceUpdateTab => 'Aggiornamento';

  @override
  String get appConfigSaveSuccessMessage =>
      'Configurazione salvata con successo.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Errore: $errorMessage';
  }

  @override
  String get unknownError => 'Errore sconosciuto';

  @override
  String get loadingConfigurationHeadline => 'Caricamento Configurazione';

  @override
  String get loadingConfigurationSubheadline => 'Attendere prego...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Caricamento configurazione fallito.';

  @override
  String get loadAppSettingsSubheadline => 'Carica impostazioni dal backend.';

  @override
  String get discardChangesButton => 'Annulla Modifiche';

  @override
  String get saveChangesButton => 'Salva Modifiche';

  @override
  String get confirmConfigUpdateDialogTitle => 'Conferma Aggiornamento';

  @override
  String get confirmConfigUpdateDialogContent =>
      'Applicare le modifiche all\'app live?';

  @override
  String get cancelButton => 'Annulla';

  @override
  String get confirmSaveButton => 'Conferma Salvataggio';

  @override
  String get guestUserTab => 'Ospite';

  @override
  String get authenticatedUserTab => 'Autenticato';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Limite Seguiti (Ospite)';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Numero massimo di elementi seguiti.';

  @override
  String get guestSavedHeadlinesLimitLabel => 'Limite Salvati (Ospite)';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Numero massimo di titoli salvati.';

  @override
  String get standardUserFollowedItemsLimitLabel => 'Limite Seguiti (Standard)';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Limite per utenti standard.';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Limite Salvati (Standard)';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Limite per utenti standard.';

  @override
  String get premiumFollowedItemsLimitLabel => 'Limite Seguiti (Premium)';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Limite per utenti premium.';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Limite Salvati (Premium)';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Limite per utenti premium.';

  @override
  String get standardUserAdTab => 'Utente Standard';

  @override
  String get guestAdFrequencyLabel => 'Frequenza Annunci (Ospite)';

  @override
  String get guestAdFrequencyDescription => 'Annunci ogni X elementi del feed.';

  @override
  String get guestAdPlacementIntervalLabel => 'Intervallo Iniziale (Ospite)';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Elementi prima del primo annuncio.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Articoli per Interstiziale';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Letture prima dell\'annuncio.';

  @override
  String get standardUserAdFrequencyLabel => 'Frequenza (Standard)';

  @override
  String get standardUserAdFrequencyDescription =>
      'Frequenza per utenti standard.';

  @override
  String get standardUserAdPlacementIntervalLabel => 'Intervallo (Standard)';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Intervallo per standard.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Articoli (Standard)';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Letture per standard.';

  @override
  String get premiumAdFrequencyLabel => 'Frequenza (Premium)';

  @override
  String get premiumAdFrequencyDescription =>
      'Frecuenza per premium (0 = no ads).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Intervallo (Premium)';

  @override
  String get premiumAdPlacementIntervalDescription => 'Intervallo per premium.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Articoli (Premium)';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Letture per premium.';

  @override
  String get appOperationalStatusWarning =>
      'ATTENZIONE: Influisce su tutti gli utenti.';

  @override
  String get appOperationalStatusLabel => 'Stato Operativo App';

  @override
  String get appOperationalStatusDescription =>
      'Stato attuale (attivo, manutenzione).';

  @override
  String get maintenanceMessageLabel => 'Messaggio Manutenzione';

  @override
  String get maintenanceMessageDescription =>
      'Messaggio mostrato in manutenzione.';

  @override
  String get disabledMessageLabel => 'Messaggio Disattivazione';

  @override
  String get disabledMessageDescription => 'Messaggio se l\'app è disattivata.';

  @override
  String get forceUpdateConfigurationTitle => 'Configurazione Aggiornamento';

  @override
  String get minAllowedAppVersionLabel => 'Versione Minima Consentita';

  @override
  String get minAllowedAppVersionDescription => 'Versione minima (es. 1.2.0).';

  @override
  String get latestAppVersionLabel => 'Ultima Versione';

  @override
  String get latestAppVersionDescription => 'Versione più recente (es. 1.5.0).';

  @override
  String get updateRequiredMessageLabel =>
      'Messaggio Aggiornamento Obbligatorio';

  @override
  String get updateRequiredMessageDescription =>
      'Messaggio per aggiornamento forzato.';

  @override
  String get updateOptionalMessageLabel => 'Messaggio Aggiornamento Opzionale';

  @override
  String get updateOptionalMessageDescription =>
      'Messaggio per aggiornamento opzionale.';

  @override
  String get iosStoreUrlLabel => 'URL iOS Store';

  @override
  String get iosStoreUrlDescription => 'Link all\'app su Apple App Store.';

  @override
  String get androidStoreUrlLabel => 'URL Android Store';

  @override
  String get androidUpdateUrlDescription =>
      'Link all\'app su Google Play Store.';

  @override
  String get guestDaysBetweenInAppPromptsLabel => 'Giorni tra Prompt (Ospite)';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Giorni minimi tra i prompt.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Giorni tra Prompt (Standard)';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Giorni per standard.';

  @override
  String get signOut => 'Disconnetti';

  @override
  String get settingsSavedSuccessfully => 'Impostazioni salvate!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Errore salvataggio: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Caricamento Impostazioni';

  @override
  String get loadingSettingsSubheadline => 'Attendere prego...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Caricamento fallito: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Tema Base';

  @override
  String get baseThemeDescription => 'Scegli l\'aspetto chiaro o scuro.';

  @override
  String get lightTheme => 'Chiaro';

  @override
  String get darkTheme => 'Scuro';

  @override
  String get systemTheme => 'Predefinito di Sistema';

  @override
  String get accentThemeLabel => 'Colore Accento';

  @override
  String get accentThemeDescription =>
      'Colore primario per elementi interattivi.';

  @override
  String get defaultBlueTheme => 'Blu Predefinito';

  @override
  String get newsRedTheme => 'Rosso News';

  @override
  String get graphiteGrayTheme => 'Grigio Grafite';

  @override
  String get fontFamilyLabel => 'Carattere';

  @override
  String get fontFamilyDescription => 'Scegli il carattere dell\'applicazione.';

  @override
  String get systemDefaultFont => 'Predefinito';

  @override
  String get textScaleFactorLabel => 'Dimensione Testo';

  @override
  String get textScaleFactorDescription => 'Regola la dimensione del testo.';

  @override
  String get smallText => 'Piccolo';

  @override
  String get mediumText => 'Medio';

  @override
  String get largeText => 'Grande';

  @override
  String get extraLargeText => 'Molto Grande';

  @override
  String get fontWeightLabel => 'Spessore Carattere';

  @override
  String get fontWeightDescription => 'Scegli lo spessore del testo.';

  @override
  String get lightFontWeight => 'Leggero';

  @override
  String get regularFontWeight => 'Regolare';

  @override
  String get boldFontWeight => 'Grassetto';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get languageDescription => 'Seleziona la lingua del dashboard.';

  @override
  String get edit => 'Modifica';

  @override
  String get englishLanguage => 'Inglese';

  @override
  String get arabicLanguage => 'Arabo';

  @override
  String get appearanceSettingsLabel => 'Aspetto';

  @override
  String get languageSettingsLabel => 'Lingua';

  @override
  String get themeSettingsLabel => 'Impostazioni Tema';

  @override
  String get fontSettingsLabel => 'Impostazioni Carattere';

  @override
  String get settingsPageDescription =>
      'Configura le tue preferenze per il Dashboard.';

  @override
  String get appearanceSettingsDescription =>
      'Regola tema, colori e stili tipografici.';

  @override
  String get loadingHeadlines => 'Caricamento Titoli';

  @override
  String get pleaseWait => 'Attendere...';

  @override
  String get noHeadlinesFound => 'Nessun titolo trovato.';

  @override
  String get headlineTitle => 'Titolo';

  @override
  String get excerpt => 'Estratto';

  @override
  String get countryName => 'Paese';

  @override
  String get publishedAt => 'Pubblicato il';

  @override
  String get actions => 'Azioni';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get loadingTopics => 'Caricamento Argomenti';

  @override
  String get noTopicsFound => 'Nessun argomento trovato.';

  @override
  String get topicName => 'Argomento';

  @override
  String get description => 'Descrizione';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'Caricamento Fonti';

  @override
  String get noSourcesFound => 'Nessuna fonte trovata.';

  @override
  String get sourceName => 'Fonte';

  @override
  String get sourceType => 'Tipo';

  @override
  String get language => 'Lingua';

  @override
  String get editTopic => 'Modifica Argomento';

  @override
  String get saveChanges => 'Salva Modifiche';

  @override
  String get loadingTopic => 'Caricamento Argomento';

  @override
  String get icon => 'Icona';

  @override
  String get topicUpdatedSuccessfully => 'Argomento aggiornato.';

  @override
  String get cannotUpdateTopicError => 'Errore: Dati originali non caricati.';

  @override
  String get createTopic => 'Crea Argomento';

  @override
  String get topicCreatedSuccessfully => 'Argomento creato.';

  @override
  String get editSource => 'Modifica Fonte';

  @override
  String get sourceUpdatedSuccessfully => 'Fonte aggiornata.';

  @override
  String get loadingSource => 'Caricamento Fonte...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Sede Centrale';

  @override
  String get none => 'Nessuno';

  @override
  String get cannotUpdateSourceError => 'Errore: Dati originali non caricati.';

  @override
  String get sourceTypeNewsAgency => 'Agenzia di Stampa';

  @override
  String get sourceTypeLocalNewsOutlet => 'Testata Locale';

  @override
  String get sourceTypeNationalNewsOutlet => 'Testata Nazionale';

  @override
  String get sourceTypeInternationalNewsOutlet => 'Testata Internazionale';

  @override
  String get sourceTypeSpecializedPublisher => 'Editore Specializzato';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Fonte Governativa';

  @override
  String get sourceTypeAggregator => 'Aggregatore';

  @override
  String get sourceTypeOther => 'Altro';

  @override
  String get editHeadline => 'Modifica Titolo';

  @override
  String get headlineUpdatedSuccessfully => 'Titolo aggiornato.';

  @override
  String get loadingHeadline => 'Caricamento Titolo...';

  @override
  String get image => 'Immagine';

  @override
  String get cannotUpdateHeadlineError =>
      'Errore: Dati originali non caricati.';

  @override
  String get createHeadline => 'Crea Titolo';

  @override
  String get headlineCreatedSuccessfully => 'Titolo creato.';

  @override
  String get loadingData => 'Caricamento dati...';

  @override
  String get loadingFullList => 'Caricamento lista completa...';

  @override
  String get createSource => 'Crea Fonte';

  @override
  String get updateSourceTitle => 'Aggiorna Fonte';

  @override
  String get updateSourceMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get sourceCreatedSuccessfully => 'Fonte creata.';

  @override
  String get updateTopicTitle => 'Aggiorna Argomento';

  @override
  String get status => 'Stato';

  @override
  String get updateTopicMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get lastUpdated => 'Ultimo Aggiornamento';

  @override
  String get contentStatusActive => 'Attivo';

  @override
  String get contentStatusArchived => 'Archiviato';

  @override
  String get contentStatusDraft => 'Bozza';

  @override
  String get totalHeadlines => 'Totale Titoli';

  @override
  String get totalTopics => 'Totale Argomenti';

  @override
  String get totalSources => 'Totale Fonti';

  @override
  String get loadingOverview => 'Caricamento Panoramica...';

  @override
  String get loadingOverviewSubheadline => 'Recupero statistiche...';

  @override
  String get overviewLoadFailure => 'Errore caricamento panoramica.';

  @override
  String get recentHeadlines => 'Titoli Recenti';

  @override
  String get viewAll => 'Vedi Tutto';

  @override
  String get noRecentHeadlines => 'Nessun titolo recente.';

  @override
  String get systemStatus => 'Stato del Sistema';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get createHeadlineAction => 'Crea Titolo';

  @override
  String get manageContentAction => 'Gestisci Contenuti';

  @override
  String get appConfigAction => 'Configurazione App';

  @override
  String get appStatusActive => 'Attivo';

  @override
  String get appStatusDisabled => 'Disattivato';

  @override
  String demoEmailHint(String email) {
    return 'Per demo, usa email: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'Per demo, usa codice: $code';
  }

  @override
  String get appStatusMaintenance => 'Manutenzione';

  @override
  String get appStatusOperational => 'Operativo';

  @override
  String get isUnderMaintenanceLabel => 'In Manutenzione';

  @override
  String get isUnderMaintenanceDescription =>
      'Attiva la modalità manutenzione.';

  @override
  String get isLatestVersionOnlyLabel => 'Forza Ultima Versione';

  @override
  String get isLatestVersionOnlyDescription =>
      'Obbliga gli utenti ad aggiornare.';

  @override
  String get iosUpdateUrlLabel => 'URL Aggiornamento iOS';

  @override
  String get iosUpdateUrlDescription => 'Link per aggiornamenti iOS.';

  @override
  String get androidUpdateUrlLabel => 'URL Aggiornamento Android';

  @override
  String get followedItemsLimitLabel => 'Limite Elementi Seguiti';

  @override
  String get followedItemsLimitDescription =>
      'Massimo elementi seguiti per ruolo.';

  @override
  String get savedFeedFiltersLimitLabel => 'Limite Filtri Salvati';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Massimo filtri salvati per ruolo.';

  @override
  String get adFrequencyLabel => 'Frequenza Annunci';

  @override
  String get adFrequencyDescription => 'Annunci ogni X elementi.';

  @override
  String get savedFeedFilterLimitsTitle => 'Limiti Filtri Salvati';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Imposta i limiti per ogni livello.';

  @override
  String get adPlacementIntervalLabel => 'Intervallo Annunci';

  @override
  String get adPlacementIntervalDescription =>
      'Elementi prima del primo annuncio.';

  @override
  String get articlesBeforeInterstitialAdsLabel => 'Articoli per Interstiziale';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Letture prima dell\'annuncio.';

  @override
  String get daysSuffix => 'Giorni';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Giorni minimi prima del prompt $actionType.';
  }

  @override
  String get retryButtonText => 'Riprova';

  @override
  String get feedActionTypeLinkAccount => 'Collega Account';

  @override
  String get feedActionTypeRateApp => 'Valuta App';

  @override
  String get feedActionTypeFollowTopics => 'Segui Argomenti';

  @override
  String get feedActionTypeFollowSources => 'Segui Fonti';

  @override
  String get feedActionTypeUpgrade => 'Passa a Premium';

  @override
  String get feedActionTypeEnableNotifications => 'Attiva Notifiche';

  @override
  String get countryPickerSearchLabel => 'Cerca';

  @override
  String get countryPickerSearchHint => 'Inizia a scrivere...';

  @override
  String get countryPickerSelectCountryLabel => 'Seleziona un paese';

  @override
  String get archivedHeadlines => 'Titoli Archiviati';

  @override
  String get loadingArchivedHeadlines => 'Caricamento Archiviati';

  @override
  String get noArchivedHeadlinesFound => 'Nessun titolo archiviato.';

  @override
  String get restore => 'Ripristina';

  @override
  String get deleteForever => 'Elimina Definitivamente';

  @override
  String get archivedTopics => 'Argomenti Archiviati';

  @override
  String get loadingArchivedTopics => 'Caricamento Argomenti Archiviati';

  @override
  String get noArchivedTopicsFound => 'Nessun argomento archiviato.';

  @override
  String get archivedSources => 'Fonti Archiviate';

  @override
  String get loadingArchivedSources => 'Caricamento Fonti Archiviate';

  @override
  String get noArchivedSourcesFound => 'Nessuna fonte archiviata.';

  @override
  String get archivedItems => 'Elementi Archiviati';

  @override
  String get addNewItem => 'Aggiungi Nuovo';

  @override
  String get archive => 'Archivia';

  @override
  String headlineDeleted(String title) {
    return 'Eliminato \'\'$title\'\'.';
  }

  @override
  String get undo => 'Annulla';

  @override
  String get enabledLabel => 'Attivo';

  @override
  String get itemsToDisplayLabel => 'Elementi da Mostrare';

  @override
  String get itemsToDisplayDescription =>
      'Numero di elementi in questo decoratore.';

  @override
  String get roleSpecificSettingsTitle => 'Impostazioni per Ruolo';

  @override
  String get daysBetweenViewsLabel => 'Giorni tra Visualizzazioni';

  @override
  String get daysBetweenViewsDescription =>
      'Giorni minimi prima di ripetere il decoratore.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Collega Account';

  @override
  String get feedDecoratorTypeUpgrade => 'Passa a Premium';

  @override
  String get feedDecoratorTypeRateApp => 'Valuta App';

  @override
  String get feedDecoratorTypeEnableNotifications => 'Attiva Notifiche';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Argomenti Suggeriti';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Fonti Suggerite';

  @override
  String get guestUserRole => 'Utente Ospite';

  @override
  String get standardUserRole => 'Utente Standard';

  @override
  String get premiumUserRole => 'Utente Premium';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get clearSelection => 'Cancella Selezione';

  @override
  String get search => 'Cerca';

  @override
  String get noResultsFound => 'Nessun risultato.';

  @override
  String get close => 'Chiudi';

  @override
  String get apply => 'Applica';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visibile a $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Configurazione Piattaforma';

  @override
  String get primaryAdPlatformTitle => 'Piattaforma Primaria';

  @override
  String get primaryAdPlatformDescription => 'Scegli il fornitore principale.';

  @override
  String get adUnitIdentifiersTitle => 'ID Unità Pubblicitarie';

  @override
  String get adUnitIdentifiersDescription =>
      'Configura gli ID per piattaforma.';

  @override
  String get feedAdSettingsTitle => 'Impostazioni Annunci Feed';

  @override
  String get enableFeedAdsLabel => 'Attiva Annunci Feed';

  @override
  String get feedAdTypeSelectionTitle => 'Tipo Annuncio Feed';

  @override
  String get feedAdTypeSelectionDescription => 'Nativo o Banner.';

  @override
  String get userRoleFrequencySettingsTitle => 'Frequenza per Ruolo';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Configura intervalli per ruolo.';

  @override
  String get articleAdSettingsTitle => 'Annunci negli Articoli';

  @override
  String get enableArticleAdsLabel => 'Attiva Annunci Articoli';

  @override
  String get defaultInArticleAdTypeSelectionTitle =>
      'Tipo Annuncio Predefinito';

  @override
  String get defaultInArticleAdTypeSelectionDescription => 'Nativo o Banner.';

  @override
  String get inArticleAdSlotPlacementsTitle => 'Posizionamenti Articolo';

  @override
  String get inArticleAdSlotPlacementsDescription => 'Attiva slot specifici.';

  @override
  String get feedNativeAdIdLabel => 'ID Annuncio Nativo (Feed)';

  @override
  String get feedNativeAdIdDescription => 'ID per annunci nativi nel feed.';

  @override
  String get feedBannerAdIdLabel => 'ID Banner (Feed)';

  @override
  String get feedBannerAdIdDescription => 'ID per banner nel feed.';

  @override
  String get articleInterstitialAdIdLabel => 'ID Interstiziale (Articolo)';

  @override
  String get articleInterstitialAdIdDescription =>
      'ID per interstiziali negli articoli.';

  @override
  String get inArticleNativeAdIdLabel => 'ID Nativo (In-Articolo)';

  @override
  String get inArticleNativeAdIdDescription => 'ID per nativi negli articoli.';

  @override
  String get inArticleBannerAdIdLabel => 'ID Banner (In-Articolo)';

  @override
  String get inArticleBannerAdIdDescription => 'ID per banner negli articoli.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Sopra \'Continua a leggere\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'Sotto \'Continua a leggere\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' copiato.';
  }

  @override
  String get copyId => 'Copia ID';

  @override
  String get enableGlobalAdsLabel => 'Attiva Pubblicità';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'ID Interstiziale (Navigazione)';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'ID mostrato all\'apertura articoli.';

  @override
  String get interstitialAdSettingsTitle => 'Impostazioni Interstiziali';

  @override
  String get enableInterstitialAdsLabel => 'Attiva Interstiziali';

  @override
  String get userRoleInterstitialFrequencyTitle => 'Frequenza per Ruolo';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Transizioni prima dell\'annuncio.';

  @override
  String get transitionsBeforeInterstitialAdsLabel =>
      'Transizioni per Annuncio';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'Numero di transizioni.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Annunci Nativi';

  @override
  String get bannerAdsTab => 'Banner';

  @override
  String get interstitialAdsTab => 'Interstiziali';

  @override
  String get videoAdsTab => 'Video';

  @override
  String get bannerAdType => 'Banner';

  @override
  String get nativeAdType => 'Nativo';

  @override
  String get interstitialAdType => 'Interstiziale';

  @override
  String get videoAdType => 'Video';

  @override
  String get rewardedAdType => 'Con Premio';

  @override
  String get bannerAdShapeSelectionTitle => 'Forma Banner';

  @override
  String get bannerAdShapeSelectionDescription =>
      'Seleziona la forma preferita.';

  @override
  String get bannerAdShapeSquare => 'Quadrato';

  @override
  String get bannerAdShapeRectangle => 'Rettangolo';

  @override
  String get loadingDraftHeadlines => 'Caricamento Bozze';

  @override
  String get noDraftHeadlinesFound => 'Nessuna bozza trovata.';

  @override
  String get publish => 'Pubblica';

  @override
  String get saveAsDraft => 'Salva come Bozza';

  @override
  String get invalidFormTitle => 'Modulo Non Valido';

  @override
  String get invalidFormMessage => 'Completa i campi obbligatori.';

  @override
  String get completeForm => 'Completa';

  @override
  String get discard => 'Scarta';

  @override
  String get drafts => 'Bozze';

  @override
  String get draftsIconTooltip => 'Bozze';

  @override
  String get draftHeadlines => 'Titoli in Bozza';

  @override
  String get draftTopics => 'Argomenti in Bozza';

  @override
  String get draftSources => 'Fonti in Bozza';

  @override
  String get saveHeadlineTitle => 'Salva Titolo';

  @override
  String get saveHeadlineMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get saveTopicTitle => 'Salva Argomento';

  @override
  String get saveTopicMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get saveSourceTitle => 'Salva Fonte';

  @override
  String get saveSourceMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get loadingDraftTopics => 'Caricamento Argomenti...';

  @override
  String get noDraftTopicsFound => 'Nessun argomento in bozza.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Argomento \"$topicTitle\" eliminato.';
  }

  @override
  String get loadingDraftSources => 'Caricamento Fonti...';

  @override
  String get noDraftSourcesFound => 'Nessuna fonte in bozza.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Fonte \"$sourceName\" eliminata.';
  }

  @override
  String get publishTopic => 'Pubblica Argomento';

  @override
  String get publishSource => 'Pubblica Fonte';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Attiva Ads Articoli per $role';
  }

  @override
  String get moreActions => 'Altre Azioni';

  @override
  String get filter => 'Filtra';

  @override
  String get applyFilters => 'Applica Filtri';

  @override
  String get filterHeadlines => 'Filtra Titoli';

  @override
  String get filterTopics => 'Filtra Argomenti';

  @override
  String get filterSources => 'Filtra Fonti';

  @override
  String get searchByHeadlineTitle => 'Cerca per titolo...';

  @override
  String get searchByTopicName => 'Cerca per nome o ID...';

  @override
  String get searchBySourceName => 'Cerca per nome o ID...';

  @override
  String get selectSources => 'Seleziona Fonti';

  @override
  String get selectTopics => 'Seleziona Argomenti';

  @override
  String get countries => 'Paesi';

  @override
  String get selectCountries => 'Seleziona Paesi';

  @override
  String get selectSourceTypes => 'Tipi di Fonte';

  @override
  String get selectLanguages => 'Lingue';

  @override
  String get selectHeadquarters => 'Sedi Centrali';

  @override
  String get resetFiltersButtonText => 'Reimposta Filtri';

  @override
  String get noResultsWithCurrentFilters =>
      'Nessun risultato con i filtri attuali.';

  @override
  String get aboutIconTooltip => 'Informazioni sulla pagina';

  @override
  String get closeButtonText => 'Chiudi';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => 'Gestione Utenti';

  @override
  String get userManagementPageDescription =>
      'Gestisci utenti, ruoli e permessi.';

  @override
  String get loadingUsers => 'Caricamento Utenti';

  @override
  String get noUsersFound => 'Nessun utente trovato.';

  @override
  String get email => 'Email';

  @override
  String get appRole => 'Ruolo App';

  @override
  String get dashboardRole => 'Ruolo Dashboard';

  @override
  String get createdAt => 'Creato il';

  @override
  String get promoteToPublisher => 'Promuovi a Editore';

  @override
  String get demoteToUser => 'Retrocedi a Utente';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Editore';

  @override
  String get filterUsers => 'Filtra Utenti';

  @override
  String get searchByUserEmail => 'Cerca per email o ID...';

  @override
  String get selectAppRoles => 'Ruoli App';

  @override
  String get selectDashboardRoles => 'Ruoli Dashboard';

  @override
  String get authentication => 'Autenticazione';

  @override
  String get subscription => 'Abbonamento';

  @override
  String get authenticationAnonymous => 'Anonimo';

  @override
  String get authenticationAuthenticated => 'Autenticato';

  @override
  String get subscriptionFree => 'Gratis';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle => 'Limiti Filtri Titoli';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Limiti per filtri, fissati e notifiche.';

  @override
  String get totalLimitLabel => 'Limite Totale';

  @override
  String get totalLimitDescription => 'Numero totale di filtri consentiti.';

  @override
  String get pinnedLimitLabel => 'Limite Fissati';

  @override
  String get pinnedLimitDescription => 'Massimo filtri fissati.';

  @override
  String get notificationSubscriptionLimitLabel => 'Limite Notifiche';

  @override
  String get notificationSubscriptionLimitDescription =>
      'Massimo iscrizioni notifiche.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Ultima Ora';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Riepilogo Settimanale';

  @override
  String get isBreakingNewsLabel => 'Segnala come Ultima Ora';

  @override
  String get isBreakingNewsDescription => 'Invia una notifica push immediata.';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'Non invierà push durante la modifica.';

  @override
  String get confirmBreakingNewsTitle => 'Conferma Ultima Ora';

  @override
  String get confirmBreakingNewsMessage => 'Inviare una notifica push a tutti?';

  @override
  String get confirmPublishButton => 'Conferma e Pubblica';

  @override
  String get cannotDraftBreakingNews => 'Impossibile salvare come bozza.';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => 'Ultima Ora';

  @override
  String get breakingNewsFilterAll => 'Tutti';

  @override
  String get breakingNewsFilterBreakingOnly => 'Solo Ultima Ora';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Senza Ultima Ora';

  @override
  String get notificationsTab => 'Notifiche';

  @override
  String get pushNotificationSettingsTitle => 'Impostazioni Notifiche';

  @override
  String get pushNotificationSettingsDescription =>
      'Gestione globale del sistema notifiche.';

  @override
  String get pushNotificationSystemStatusTitle => 'Attiva Notifiche';

  @override
  String get pushNotificationSystemStatusDescription => 'Interruttore globale.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Fornitore Primario';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Firebase o OneSignal.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Tipi di Consegna';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Attiva tipi specifici.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'Generale';

  @override
  String get featuresTab => 'Funzioni';

  @override
  String get limitsTab => 'Limiti';

  @override
  String get maintenanceConfigTitle => 'Modalità Manutenzione';

  @override
  String get maintenanceConfigDescription => 'Attiva la modalità manutenzione.';

  @override
  String get updateConfigTitle => 'Impostazioni Aggiornamento';

  @override
  String get updateConfigDescription =>
      'Configura gli aggiornamenti obbligatori.';

  @override
  String get generalAppConfigTitle => 'Impostazioni Generali';

  @override
  String get generalAppConfigDescription =>
      'Termini di Servizio e Privacy Policy.';

  @override
  String get termsOfServiceUrlLabel => 'URL Termini di Servizio';

  @override
  String get termsOfServiceUrlDescription => 'Link alla pagina dei termini.';

  @override
  String get privacyPolicyUrlLabel => 'URL Privacy Policy';

  @override
  String get privacyPolicyUrlDescription => 'Link alla privacy policy.';

  @override
  String get navigationAdConfigTitle => 'Annunci Navigazione';

  @override
  String get enableNavigationAdsLabel => 'Attiva Annunci Navigazione';

  @override
  String get navigationAdFrequencyTitle => 'Frequenza Navigazione';

  @override
  String get navigationAdFrequencyDescription =>
      'Transizioni prima dell\'annuncio.';

  @override
  String get internalNavigationsBeforeAdLabel => 'Navigazioni Interne';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'Pagine prima dell\'annuncio.';

  @override
  String get externalNavigationsBeforeAdLabel => 'Navigazioni Esterne';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'Uscite prima dell\'annuncio.';

  @override
  String get nativeAdIdLabel => 'ID Annuncio Nativo';

  @override
  String get nativeAdIdDescription => 'ID per annunci nativi.';

  @override
  String get bannerAdIdLabel => 'ID Banner';

  @override
  String get bannerAdIdDescription => 'ID per banner.';

  @override
  String get interstitialAdIdLabel => 'ID Interstiziale';

  @override
  String get interstitialAdIdDescription => 'ID per interstiziali.';

  @override
  String get savedHeadlinesLimitLabel => 'Limite Salvati';

  @override
  String get savedHeadlinesLimitDescription =>
      'Massimo titoli salvati per ruolo.';

  @override
  String get appUpdateManagementTitle => 'Gestione Aggiornamenti';

  @override
  String get feedItemClickBehaviorTitle => 'Comportamento al Clic';

  @override
  String get feedItemClickBehaviorDescription =>
      'Browser interno o di sistema.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'Browser In-App';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'Browser di Sistema';

  @override
  String get userLimitsTitle => 'Limiti Utente';

  @override
  String get userLimitsDescription => 'Definisci i limiti per funzione.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Controllo stato e aggiornamenti.';

  @override
  String get advertisementsDescription => 'Gestione globale pubblicità.';

  @override
  String get notificationsDescription => 'Configurazione notifiche push.';

  @override
  String get feedDescription => 'Controllo comportamento del feed.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Limite per avvisi immediati.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Limite per riepilogo settimanale.';

  @override
  String get appStatusAndUpdatesTitle => 'Stato e Aggiornamenti';

  @override
  String get enableForcedUpdatesLabel => 'Attiva Aggiornamenti Forzati';

  @override
  String get enableForcedUpdatesDescription =>
      'Permette di esigere una versione minima.';

  @override
  String get appUrlsTitle => 'URL Applicazione';

  @override
  String get appUrlsDescription => 'Gestisci i link interni ed esterni.';

  @override
  String get communityAndEngagementTitle => 'Community e Interazione';

  @override
  String get communityAndEngagementDescription =>
      'Configura commenti e segnalazioni.';

  @override
  String get userEngagementTitle => 'Interazione Utente';

  @override
  String get userEngagementDescription => 'Configura reazioni e commenti.';

  @override
  String get contentReportingTitle => 'Segnalazione Contenuti';

  @override
  String get contentReportingDescription => 'Regole per segnalare contenuti.';

  @override
  String get appReviewFunnelTitle => 'Recensioni App';

  @override
  String get appReviewFunnelDescription =>
      'Gestione soddisfazione e recensioni.';

  @override
  String get enableEngagementFeaturesLabel => 'Attiva Interazione';

  @override
  String get enableEngagementFeaturesDescription =>
      'Attiva reazioni e commenti.';

  @override
  String get engagementModeLabel => 'Modalità Interazione';

  @override
  String get engagementModeDescription => 'Solo reazioni o anche commenti.';

  @override
  String get engagementModeReactionsOnly => 'Solo Reazioni';

  @override
  String get engagementModeReactionsAndComments => 'Reazioni e Commenti';

  @override
  String get enableReportingSystemLabel => 'Attiva Sistema Segnalazioni';

  @override
  String get enableReportingSystemDescription =>
      'Attiva opzioni di segnalazione.';

  @override
  String get enableHeadlineReportingLabel => 'Segnalazione Titoli';

  @override
  String get enableSourceReportingLabel => 'Segnalazione Fonti';

  @override
  String get enableCommentReportingLabel => 'Segnalazione Commenti';

  @override
  String get enableAppFeedbackSystemLabel => 'Attiva Feedback Interno';

  @override
  String get enableAppFeedbackSystemDescription =>
      'Chiede periodicamente se l\'app piace.';

  @override
  String get interactionCycleThresholdLabel => 'Soglia Ciclo Interazione';

  @override
  String get interactionCycleThresholdDescription =>
      'Azioni positive per il prompt.';

  @override
  String get initialPromptCooldownLabel => 'Cooldown Iniziale (Giorni)';

  @override
  String get initialPromptCooldownDescription =>
      'Attesa prima del primo prompt.';

  @override
  String get requestStoreReviewLabel => 'Chiedi Recensione Store';

  @override
  String get requestStoreReviewDescription =>
      'Se \'Sì\', chiede recensione ufficiale.';

  @override
  String get requestWrittenFeedbackLabel => 'Chiedi Feedback Scritto';

  @override
  String get requestWrittenFeedbackDescription =>
      'Se \'No\', chiede il motivo.';

  @override
  String get internalPromptLogicTitle => 'Logica Prompt Interno';

  @override
  String get eligiblePositiveInteractionsTitle => 'Interazioni Positive';

  @override
  String get positiveInteractionTypeSaveItem => 'Salva un contenuto';

  @override
  String get positiveInteractionTypeFollowItem => 'Segui un\'entità';

  @override
  String get positiveInteractionTypeShareContent => 'Condividi un contenuto';

  @override
  String get positiveInteractionTypeSaveFilter => 'Crea un filtro salvato';

  @override
  String get followUpActionsTitle => 'Azioni di Seguito';

  @override
  String get enableCommunityFeaturesLabel => 'Attiva Funzioni Community';

  @override
  String get enableCommunityFeaturesDescription =>
      'Attiva interazione e segnalazioni.';

  @override
  String get communityManagementPageDescription =>
      'Gestisci commenti, segnalazioni e recensioni.';

  @override
  String get engagements => 'Interazioni';

  @override
  String get reports => 'Segnalazioni';

  @override
  String get appReviews => 'Recensioni App';

  @override
  String get user => 'Utente';

  @override
  String get engagedContent => 'Contenuto';

  @override
  String get reaction => 'Reazione';

  @override
  String get comment => 'Commento';

  @override
  String get commentStatus => 'Stato Commento';

  @override
  String get hasCommentFilterLabel => 'Contiene Commento';

  @override
  String get hasCommentFilterDescription => 'Solo interazioni con testo.';

  @override
  String get date => 'Data';

  @override
  String get approveComment => 'Approva Commento';

  @override
  String get rejectComment => 'Rifiuta Commento';

  @override
  String get viewEngagedContent => 'Vedi Contenuto';

  @override
  String get copyUserId => 'Copia ID Utente';

  @override
  String get reporter => 'Segnalatore';

  @override
  String get reportedItem => 'Elemento Segnalato';

  @override
  String get reason => 'Motivo';

  @override
  String get reportStatus => 'Stato Segnalazione';

  @override
  String get viewReportedItem => 'Vedi Elemento';

  @override
  String get markAsInReview => 'Segna in Revisione';

  @override
  String get resolveReport => 'Risolvi Segnalazione';

  @override
  String get initialFeedback => 'Feedback Iniziale';

  @override
  String get osPromptRequested => 'Prompt OS?';

  @override
  String get feedbackHistory => 'Cronologia Feedback';

  @override
  String get lastInteraction => 'Ultima Interazione';

  @override
  String get viewFeedbackHistory => 'Vedi Cronologia';

  @override
  String get reactionTypeLike => 'Mi piace';

  @override
  String get reactionTypeInsightful => 'Interessante';

  @override
  String get reactionTypeAmusing => 'Divertente';

  @override
  String get reactionTypeSad => 'Triste';

  @override
  String get reactionTypeAngry => 'Arrabbiato';

  @override
  String get reactionTypeSkeptical => 'Scettico';

  @override
  String get initialAppReviewFeedbackPositive => 'Positivo';

  @override
  String get initialAppReviewFeedbackNegative => 'Negativo';

  @override
  String get filterCommunity => 'Filtra Community';

  @override
  String get searchByEngagementUser => 'Cerca per email...';

  @override
  String get searchByReportReporter => 'Cerca per segnalatore...';

  @override
  String get searchByAppReviewUser => 'Cerca per email...';

  @override
  String get selectCommentStatus => 'Stato Commento';

  @override
  String get selectReportStatus => 'Stato Segnalazione';

  @override
  String get selectInitialFeedback => 'Feedback Iniziale';

  @override
  String get selectReportableEntity => 'Tipo Elemento';

  @override
  String get reportableEntityHeadline => 'Titolo';

  @override
  String get reportableEntitySource => 'Fonte';

  @override
  String get reportableEntityComment => 'Commento';

  @override
  String get noEngagementsFound => 'Nessuna interazione.';

  @override
  String get noReportsFound => 'Nessuna segnalazione.';

  @override
  String get noAppReviewsFound => 'Nessuna recensione.';

  @override
  String get loadingEngagements => 'Caricamento Interazioni';

  @override
  String get loadingReports => 'Caricamento Segnalazioni';

  @override
  String get loadingAppReviews => 'Caricamento Recensioni';

  @override
  String get userIdCopied => 'ID utente copiato.';

  @override
  String get reportStatusUpdated => 'Stato aggiornato.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Cronologia di $email';
  }

  @override
  String get noFeedbackHistory => 'Nessuna cronologia disponibile.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback il: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get noReasonProvided => 'Nessun motivo fornito.';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Disinformazione / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Titolo Clickbait';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Offensivo / Odio';

  @override
  String get reportReasonSpamOrScam => 'Spam / Truffa';

  @override
  String get reportReasonBrokenLink => 'Link Interrotto';

  @override
  String get reportReasonPaywalled => 'Contenuto a Pagamento';

  @override
  String get reportReasonLowQualityJournalism => 'Bassa Qualità';

  @override
  String get reportReasonHighAdDensity => 'Troppa Pubblicità';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Fonte Governativa';

  @override
  String get reportReasonAggregator => 'Aggregatore';

  @override
  String get reportReasonOther => 'Altro';

  @override
  String get reportReasonFrequentPaywalls => 'Paywall Frequenti';

  @override
  String get reportReasonImpersonation => 'Sostituzione di Persona';

  @override
  String get noNegativeFeedbackHistory => 'Nessun feedback negativo.';

  @override
  String get reject => 'Rifiuta';

  @override
  String get commentStatusFlaggedByAi => 'Segnalato da IA';

  @override
  String get cancel => 'Annulla';

  @override
  String get rejectCommentConfirmation =>
      'Eliminare definitivamente questo commento?';

  @override
  String get searchByUserId => 'Cerca per ID Utente...';

  @override
  String get viewReportedHeadline => 'Vedi Titolo';

  @override
  String get viewReportedSource => 'Vedi Fonte';

  @override
  String get viewReportedComment => 'Vedi Commento';

  @override
  String get entityType => 'Tipo Entità';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Dettagli Feedback';

  @override
  String get moderationStatusPendingReview => 'In Revisione';

  @override
  String get moderationStatusResolved => 'Risolto';

  @override
  String get hasComment => 'Ha Commento';

  @override
  String get any => 'Qualsiasi';

  @override
  String get withComment => 'Con Commento';

  @override
  String get withoutComment => 'Senza Commento';

  @override
  String get reportResolved => 'Segnalazione risolta.';

  @override
  String get commentApproved => 'Commento approvato.';

  @override
  String get commentRejected => 'Commento rifiutato.';

  @override
  String get copyHeadlineId => 'Copia ID Titolo';

  @override
  String get copyReportedItemId => 'Copia ID Elemento';

  @override
  String get viewFeedbackDetails => 'Vedi Dettagli';

  @override
  String get reportDetails => 'Dettagli Segnalazione';

  @override
  String get commentDetails => 'Dettagli Commento';

  @override
  String get communityManagement => 'Gestione Community';

  @override
  String get navContent => 'Contenuto';

  @override
  String get navUsers => 'Utenti';

  @override
  String get navCommunity => 'Community';

  @override
  String get confirmPromotionTitle => 'Conferma Promozione';

  @override
  String confirmPromotionMessage(String email) {
    return 'Promuovere $email a Editore?';
  }

  @override
  String get confirmDemotionTitle => 'Conferma Retrocessione';

  @override
  String confirmDemotionMessage(String email) {
    return 'Retrocedere $email a utente standard?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Editore';

  @override
  String get breakingNewsHint => 'Titolo di ultima ora';

  @override
  String get breakingNewsFilterDescription => 'Solo notizie di ultima ora';

  @override
  String publishItemTitle(String itemType) {
    return 'Pubblica $itemType?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'Pubblicare questo $itemType? Sarà visibile.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return 'Archivia $itemType?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'Archiviare questo $itemType? Sarà nascosto.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return 'Ripristina $itemType?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'Ripristinare questo $itemType? Sarà visibile.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return 'Elimina $itemType?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'Sei sicuro di voler eliminare questo $itemType?';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" eliminato.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Scegli il fornitore e configura gli ID.';

  @override
  String get feedAdSettingsDescription =>
      'Controlla visibilità e frequenza nel feed.';

  @override
  String get navigationAdConfigDescription =>
      'Configura gli annunci interstiziali.';

  @override
  String get feedDecoratorLinkAccountDescription =>
      'Invita gli ospiti a registrarsi.';

  @override
  String get feedDecoratorUpgradeDescription => 'Invita a passare a premium.';

  @override
  String get feedDecoratorRateAppDescription => 'Invita a valutare l\'app.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Invita ad attivare le notifiche.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Mostra argomenti suggeriti.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Mostra fonti suggerite.';

  @override
  String get enableGlobalAdsDescription =>
      'Attiva o disattiva tutta la pubblicità.';

  @override
  String get enableFeedAdsDescription => 'Controlla gli annunci nei feed.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'Attivo per gli utenti con ruolo \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription =>
      'Attiva questo decoratore globalmente.';

  @override
  String get enableNavigationAdsDescription =>
      'Annunci durante la navigazione interna.';

  @override
  String get enableHeadlineReportingDescription =>
      'Permette di segnalare i titoli.';

  @override
  String get enableSourceReportingDescription =>
      'Permette di segnalare le fonti.';

  @override
  String get enableCommentReportingDescription =>
      'Permette di segnalare i commenti.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Avvisi per notizie dell\'ultima ora.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Riepilogo quotidiano.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Riepilogo settimanale.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Conta quando un titolo viene salvato.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Conta quando si segue un\'entità.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Conta quando si condivide.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Conta quando si crea un filtro.';

  @override
  String get internalPromptLogicDescription =>
      'Condizioni che attivano il prompt.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Azioni contate come positive.';

  @override
  String get followUpActionsDescription => 'Azioni dopo la risposta al prompt.';

  @override
  String get analyticsTab => 'Analitica';

  @override
  String get analyticsDescription => 'Configura il tracciamento degli eventi.';

  @override
  String get analyticsSystemStatusTitle => 'Attiva Sistema Analitica';

  @override
  String get analyticsSystemStatusDescription =>
      'Interruttore principale tracciamento.';

  @override
  String get analyticsProviderTitle => 'Fornitore Attivo';

  @override
  String get analyticsProviderDescription =>
      'Seleziona il servizio di analitica.';

  @override
  String get analyticsEventsTitle => 'Configurazione Eventi';

  @override
  String get analyticsEventsDescription =>
      'Regola il logging di eventi specifici.';

  @override
  String samplingRateLabel(int rate) {
    return 'Tasso di campionamento: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'Registrazione Utente';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'Traccia le nuove registrazioni.';

  @override
  String get analyticsEventUserLoginLabel => 'Accesso Utente';

  @override
  String get analyticsEventUserLoginDescription => 'Traccia gli accessi.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Account Collegato';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'Traccia i collegamenti account.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'Cambio Ruolo';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Traccia aggiornamenti di livello.';

  @override
  String get analyticsEventContentViewedLabel => 'Contenuto Visto';

  @override
  String get analyticsEventContentViewedDescription => 'Traccia le letture.';

  @override
  String get analyticsEventContentSharedLabel => 'Contenuto Condiviso';

  @override
  String get analyticsEventContentSharedDescription =>
      'Traccia le condivisioni.';

  @override
  String get analyticsEventContentSavedLabel => 'Contenuto Salvato';

  @override
  String get analyticsEventContentSavedDescription => 'Traccia i segnalibri.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Contenuto Rimosso';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Traccia rimozione segnalibri.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Tempo di Lettura';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'Traccia durata lettura.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Reazione Aggiunta';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Traccia nuove reazioni.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Reazione Rimossa';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Traccia rimozione reazioni.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Commento Inviato';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Traccia nuovi commenti.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Commento Eliminato';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Traccia rimozione commenti.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Segnalazione Inviata';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Traccia le segnalazioni.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'Filtro Creato';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Traccia creazione filtri.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'Filtro Aggiornato';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Traccia modifiche filtri.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Filtro Usato';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Traccia applicazione filtri.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Ricerca Effettuata';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'Traccia le query di ricerca.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel =>
      'Risposta al Prompt';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Traccia risposte a \'Ti piace l\'app?\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Recensione Store Richiesta';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Traccia richieste recensione ufficiale.';

  @override
  String get analyticsEventLimitExceededLabel => 'Limite Superato';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Traccia quando si tocca un limite.';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => 'Clic CTA Limite';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Traccia clic su \'Passa a Premium\'.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Impressione Paywall';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Traccia visualizzazioni paywall.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Abbonamento Iniziato';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Traccia nuovi acquisti.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Abbonamento Rinnovato';

  @override
  String get analyticsEventSubscriptionRenewedDescription => 'Traccia rinnovi.';

  @override
  String get analyticsEventSubscriptionCancelledLabel =>
      'Abbonamento Annullato';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Traccia cancellazioni.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Abbonamento Terminato';

  @override
  String get analyticsEventSubscriptionEndedDescription => 'Traccia scadenze.';

  @override
  String get analyticsEventAdImpressionLabel => 'Impressione Annuncio';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Traccia visualizzazione ads.';

  @override
  String get analyticsEventAdClickedLabel => 'Clic su Annuncio';

  @override
  String get analyticsEventAdClickedDescription => 'Traccia clic su ads.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Errore Caricamento Ad';

  @override
  String get analyticsEventAdLoadFailedDescription => 'Traccia fallimenti ads.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Premio Guadagnato';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Traccia ads con premio completati.';

  @override
  String get analyticsEventThemeChangedLabel => 'Cambio Tema';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Traccia modifiche visive.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Cambio Lingua';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Traccia modifiche lingua.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Cambio Densità Feed';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Traccia regolazioni feed.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel =>
      'Cambio Preferenza Browser';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Traccia scelta browser.';

  @override
  String get analyticsEventAppTourStartedLabel => 'Tour Iniziato';

  @override
  String get analyticsEventAppTourStartedDescription => 'Traccia inizio tour.';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'Passaggio Tour Visto';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'Traccia visualizzazioni pagine tour.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'Tour Completato';

  @override
  String get analyticsEventAppTourCompletedDescription => 'Traccia fine tour.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'Tour Saltato';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'Traccia se il tour viene saltato.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'Personalizzazione Iniziata';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'Traccia inizio onboarding.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'Passaggio Onboarding Visto';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'Traccia passi onboarding.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'Personalizzazione Completata';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'Traccia fine onboarding.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'Personalizzazione Saltata';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'Traccia se onboarding saltato.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7G';

  @override
  String get timeFrameMonth => '30G';

  @override
  String get timeFrameYear => '1A';

  @override
  String get noDataAvailable => 'Nessun dato disponibile';

  @override
  String get vsPreviousPeriod => 'vs periodo precedente';

  @override
  String get vsPreviousDay => 'vs ultime 24h';

  @override
  String get vsPreviousWeek => 'vs ultimi 7 giorni';

  @override
  String get vsPreviousMonth => 'vs ultimi 30 giorni';

  @override
  String get vsPreviousYear => 'vs anno precedente';

  @override
  String get kpiUsersTotalRegistered => 'Utenti Registrati';

  @override
  String get kpiUsersNewRegistrations => 'Nuove Registrazioni';

  @override
  String get kpiUsersActiveUsers => 'Utenti Attivi';

  @override
  String get kpiContentHeadlinesTotalPublished => 'Titoli Pubblicati';

  @override
  String get kpiContentHeadlinesTotalViews => 'Visualizzazioni Titoli';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Like sui Titoli';

  @override
  String get kpiContentSourcesTotalSources => 'Totale Fonti';

  @override
  String get kpiContentSourcesNewSources => 'Nuove Fonti';

  @override
  String get kpiContentSourcesTotalFollowers => 'Seguaci Fonti';

  @override
  String get kpiContentTopicsTotalTopics => 'Totale Argomenti';

  @override
  String get kpiContentTopicsNewTopics => 'Nuovi Argomenti';

  @override
  String get kpiContentTopicsTotalFollowers => 'Seguaci Argomenti';

  @override
  String get kpiEngagementsTotalReactions => 'Totale Reazioni';

  @override
  String get kpiEngagementsTotalComments => 'Totale Commenti';

  @override
  String get kpiEngagementsAverageEngagementRate => 'Tasso Interazione Medio';

  @override
  String get kpiEngagementsReportsPending => 'Segnalazioni Pendenti';

  @override
  String get kpiEngagementsReportsResolved => 'Segnalazioni Risolte';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Tempo Medio Risoluzione';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Totale Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Feedback Positivo';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Richieste Recensione';

  @override
  String get chartUsersRegistrationsOverTime => 'Registrazioni nel Tempo';

  @override
  String get chartUsersActiveUsersOverTime => 'Trend Utenti Attivi';

  @override
  String get chartUsersRoleDistribution => 'Distribuzione Ruoli';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Trend Visualizzazioni';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Trend Like';

  @override
  String get chartContentHeadlinesViewsByTopic =>
      'Visualizzazioni per Argomento';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => 'Attività Fonti';

  @override
  String get chartContentSourcesFollowersOverTime => 'Crescita Seguaci Fonti';

  @override
  String get chartContentSourcesEngagementByType =>
      'Interazione per Tipo Fonte';

  @override
  String get chartContentTopicsFollowersOverTime =>
      'Crescita Seguaci Argomenti';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime =>
      'Attività Argomenti';

  @override
  String get chartContentTopicsEngagementByTopic => 'Interazione per Argomento';

  @override
  String get chartEngagementsReactionsOverTime => 'Trend Reazioni';

  @override
  String get chartEngagementsCommentsOverTime => 'Trend Commenti';

  @override
  String get chartEngagementsReactionsByType => 'Distribuzione Reazioni';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'Segnalazioni Inviate';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'Trend Risoluzione';

  @override
  String get chartEngagementsReportsByReason => 'Segnalazioni per Motivo';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'Trend Feedback';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Analisi Sentiment';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Trend Richieste Store';

  @override
  String get chartContentSourcesStatusDistribution =>
      'Distribuzione Stato Fonti';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'Distribuzione Ultime Notizie';

  @override
  String get chartOverviewAppTourFunnel => 'Funnel Tour App';

  @override
  String get chartOverviewInitialPersonalizationFunnel => 'Funnel Onboarding';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'Titoli Più Visti';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'Titoli Più Apprezzati';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'Fonti Più Seguite';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Argomenti Più Seguiti';

  @override
  String get subscriptionTab => 'Abbonamenti';

  @override
  String get subscriptionDescription => 'Configura i piani di abbonamento.';

  @override
  String get enableSubscriptionLabel => 'Attiva Funzione Abbonamenti';

  @override
  String get enableSubscriptionDescription =>
      'Permette agli utenti di migliorare il livello.';

  @override
  String get monthlyPlanTitle => 'Piano Mensile';

  @override
  String get annualPlanTitle => 'Piano Annuale';

  @override
  String get planEnabledLabel => 'Attiva Piano';

  @override
  String get planRecommendedLabel => 'Piano Consigliato';

  @override
  String get planRecommendedDescription =>
      'Evidenzia questo piano come migliore.';

  @override
  String get appleProductIdLabel => 'ID Prodotto Apple App Store';

  @override
  String get googleProductIdLabel => 'ID Prodotto Google Play Store';

  @override
  String get subscriptionPlanEnablementError =>
      'Inserisci almeno un ID prodotto.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Piano disattivato (ID mancanti).';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Abbonamenti disattivati.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Notifiche disattivate.';

  @override
  String get analyticsFeatureDisabledNotification => 'Analitica disattivata.';

  @override
  String get reportingFeatureDisabledNotification =>
      'Segnalazioni disattivate.';

  @override
  String get appReviewFeatureDisabledNotification => 'Recensioni disattivate.';

  @override
  String get subscriptionsName => 'Abbonamenti';

  @override
  String get subscriptionProvider => 'Fornitore Store';

  @override
  String get accessTier => 'Livello Accesso';

  @override
  String get expiryDate => 'Data Scadenza';

  @override
  String get willAutoRenew => 'Rinnovo Automatico';

  @override
  String get allAccessTiers => 'Tutti i Livelli';

  @override
  String get subscriptionActionCopyUserId => 'Copia ID Utente';

  @override
  String get subscriptionActionCopySubscriptionId => 'Copia ID Abbonamento';

  @override
  String get filterSubscriptions => 'Filtra Abbonamenti';

  @override
  String get selectStatus => 'Stato';

  @override
  String get selectProvider => 'Fornitore';

  @override
  String get selectTier => 'Livello';

  @override
  String get noSubscriptionsFound => 'Nessun abbonamento trovato.';

  @override
  String get loadingSubscriptions => 'Caricamento Abbonamenti';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Cerca per ID Utente o Abbonamento...';

  @override
  String get subscriptionsPageDescription =>
      'Monitoraggio abbonamenti (sola lettura).';

  @override
  String get subscriptionStatusActive => 'Attivo';

  @override
  String get subscriptionStatusGracePeriod => 'Periodo di Grazia';

  @override
  String get subscriptionStatusBillingIssue => 'Problema Fatturazione';

  @override
  String get subscriptionStatusCanceled => 'Annullato';

  @override
  String get subscriptionStatusExpired => 'Scaduto';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'Abbonamenti Attivi nel Tempo';

  @override
  String get chartSubscriptionsStatusDistribution => 'Distribuzione Stati';

  @override
  String get chartSubscriptionsByStoreProvider => 'Abbonamenti per Store';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Totale Annunci Visti';

  @override
  String get kpiRewardsActiveUsersCount => 'Utenti con Premio Attivo';

  @override
  String get rewardsTab => 'Premi';

  @override
  String get rewardsDescription => 'Configura i premi per l\'interazione.';

  @override
  String get enableRewardsLabel => 'Attiva Sistema Premi';

  @override
  String get enableRewardsDescription =>
      'Permette di guadagnare premi vedendo ads.';

  @override
  String get rewardTypeAdFree => 'Esperienza Senza Pubblicità';

  @override
  String get rewardDurationDaysLabel => 'Durata (Giorni)';

  @override
  String get rewardEnabledLabel => 'Attivo';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Trend Annunci Visti';

  @override
  String get chartRewardsActiveByType => 'Premi Attivi per Tipo';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Invita a vedere un ad per sbloccare funzioni.';

  @override
  String get rewardDurationDaysDescription => 'Giorni di validità del premio.';

  @override
  String get rewardsManagement => 'Gestione Premi';

  @override
  String get rewardsManagementPageDescription =>
      'Gestisci i premi degli utenti.';

  @override
  String get loadingRewards => 'Caricamento Premi';

  @override
  String get noRewardsFound => 'Nessun premio trovato.';

  @override
  String get userId => 'ID Utente';

  @override
  String get activeRewards => 'Premi Attivi';

  @override
  String get expiry => 'Scadenza';

  @override
  String get filterRewards => 'Filtra Premi';

  @override
  String get rewardType => 'Tipo Premio';

  @override
  String get selectRewardTypes => 'Tipi di Premio';

  @override
  String get loadingAnalytics => 'Caricamento Analitica';

  @override
  String get noAnalyticsDataHeadline => 'Nessun Dato Analitica';

  @override
  String get noAnalyticsDataSubheadline =>
      'Nessun dato da mostrare al momento.';

  @override
  String get androidAdUnitsTitle => 'Unità Android';

  @override
  String get iosAdUnitsTitle => 'Unità iOS';

  @override
  String get rewardedAdIdLabel => 'ID Annuncio con Premio';

  @override
  String get rewardedAdIdDescription => 'ID per annunci che offrono premi.';

  @override
  String get kpiRewardsGrantedTotal => 'Totale Premi Assegnati';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'Hub Premi Visto';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'Traccia visite all\'hub premi.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'Offerta Cliccata';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'Traccia clic su offerte.';

  @override
  String get analyticsEventRewardGrantedLabel => 'Premio Assegnato';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'Traccia premi consegnati.';

  @override
  String get chartRewardsGrantedOverTime => 'Trend Premi Assegnati';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'Personalizzazione Iniziale';

  @override
  String get initialPersonalizationDescription =>
      'Configura il flusso di benvenuto.';

  @override
  String get enableInitialPersonalizationLabel => 'Attiva Personalizzazione';

  @override
  String get enableInitialPersonalizationDescription => 'Guida i nuovi utenti.';

  @override
  String get enableCountrySelectionLabel => 'Selezione Paese';

  @override
  String get enableCountrySelectionDescription =>
      'Permette di scegliere il paese all\'inizio.';

  @override
  String get enableTopicSelectionLabel => 'Selezione Argomenti';

  @override
  String get enableTopicSelectionDescription =>
      'Permette di scegliere argomenti all\'inizio.';

  @override
  String get enableSourceSelectionLabel => 'Selezione Fonti';

  @override
  String get enableSourceSelectionDescription =>
      'Permette di scegliere fonti all\'inizio.';

  @override
  String get minSelectionsRequiredLabel => 'Selezioni Minime';

  @override
  String get minSelectionsRequiredDescription =>
      'Elementi necessari per procedere.';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingDescription => 'Gestisci la prima esperienza utente.';

  @override
  String get enableOnboardingLabel => 'Attiva Onboarding';

  @override
  String get enableOnboardingDescription =>
      'Interruttore principale benvenuto.';

  @override
  String get appTourTitle => 'Tour dell\'App';

  @override
  String get appTourDescription => 'Configura il tour pre-autenticazione.';

  @override
  String get enableAppTourLabel => 'Attiva Tour';

  @override
  String get enableAppTourDescription => 'Mostra le funzioni prima del login.';

  @override
  String get skippableAppTourLabel => 'Tour Saltabile';

  @override
  String get skippableAppTourDescription => 'Permette di saltare il tour.';

  @override
  String get skippableInitialPersonalizationLabel =>
      'Personalizzazione Saltabile';

  @override
  String get skippableInitialPersonalizationDescription =>
      'Permette di saltare onboarding.';

  @override
  String get filePickingErrorMessage => 'Errore durante la selezione del file.';

  @override
  String get removeImage => 'Rimuovi immagine';

  @override
  String get clickToUploadImage => 'Clicca per caricare';

  @override
  String get processingImage => 'Elaborazione Immagine...';

  @override
  String get processingImageDescription => 'Ottimizzazione in corso...';

  @override
  String get chartMediaUploadsOverTime => 'Caricamenti nel Tempo';

  @override
  String get chartMediaUploadsByPurpose => 'Caricamenti per Scopo';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'Successo vs Fallimento';

  @override
  String get kpiMediaTotalUploads => 'Totale Caricamenti';

  @override
  String get kpiMediaFailedUploads => 'Caricamenti Falliti';

  @override
  String get kpiMediaAverageUploadTime => 'Tempo Medio (s)';

  @override
  String get updateHeadlineTitle => 'Aggiorna Titolo';

  @override
  String get updateHeadlineMessage => 'Vuoi pubblicare o salvare come bozza?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'Caricamento Iniziato';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'Traccia inizio upload.';

  @override
  String get analyticsEventMediaUploadCompletedLabel =>
      'Caricamento Completato';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'Traccia successo upload.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'Caricamento Fallito';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'Traccia fallimenti upload.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get aboutOverviewPageTitle => 'Informazioni sulla Panoramica';

  @override
  String get aboutOverviewPageDescription =>
      'Metriche chiave aggiornate periodicamente.';

  @override
  String get audience => 'Pubblico';

  @override
  String get content => 'Contenuto';

  @override
  String get community => 'Community';

  @override
  String get monetization => 'Monetizzazione';

  @override
  String get configuration => 'Configurazione';

  @override
  String get loadingConfiguration => 'Caricamento Configurazione...';

  @override
  String get noConfigurationDataHeadline => 'Nessun Dato';

  @override
  String get noConfigurationDataSubheadline =>
      'Impossibile caricare la configurazione.';

  @override
  String get readOnlyConfigurationView => 'Vista Sola Lettura';

  @override
  String get readOnlyConfigurationViewDescription =>
      'Istantanea in tempo reale.';

  @override
  String get providers => 'Fornitori';

  @override
  String get summary => 'Riepilogo';

  @override
  String get about => 'Informazioni';

  @override
  String get localizationConfigDescription =>
      'Lingue supportate e predefinita.';

  @override
  String get enabledLanguagesLabel => 'Lingue Attivate';

  @override
  String get cannotDisableDefaultLanguage =>
      'Impossibile disattivare la predefinita.';

  @override
  String get atLeastOneLanguageRequired =>
      'Almeno una lingua deve essere attiva.';

  @override
  String get defaultLanguageLabel => 'Lingua Predefinita';

  @override
  String get defaultLanguageDescription => 'Lingua di fallback.';

  @override
  String get localizationTitle => 'Localizzazione';

  @override
  String get localizationDescription =>
      'Controlla le lingue attive per app e dashboard.';

  @override
  String defaultLanguageRequired(String language) {
    return 'La lingua predefinita ($language) è richiesta.';
  }

  @override
  String get languageNameEn => 'Inglese';

  @override
  String get languageNameEs => 'Spagnolo';

  @override
  String get languageNameFr => 'Francese';

  @override
  String get languageNameAr => 'Arabo';

  @override
  String get languageNamePt => 'Portoghese';

  @override
  String get languageNameDe => 'Tedesco';

  @override
  String get languageNameIt => 'Italiano';

  @override
  String get languageNameZh => 'Cinese';

  @override
  String get languageNameHi => 'Hindi';

  @override
  String get languageNameJa => 'Giapponese';
}
