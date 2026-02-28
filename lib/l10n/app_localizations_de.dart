// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Dashboard-Zugriff';

  @override
  String get authenticationPageSubheadline =>
      'Sichere Anmeldung für Admins & Herausgeber.';

  @override
  String get authenticationEmailSignInButton => 'Mit E-Mail anmelden';

  @override
  String get emailSignInPageTitle => 'Sichere E-Mail-Anmeldung';

  @override
  String get requestCodePageHeadline => 'Sichere E-Mail-Anmeldung';

  @override
  String get requestCodePageSubheadline =>
      'E-Mail eingeben, um einen Code zu erhalten.';

  @override
  String get requestCodeEmailLabel => 'E-Mail';

  @override
  String get requestCodeEmailHint => 'ihre.email@beispiel.de';

  @override
  String get accountLinkingEmailValidationError => 'Ungültige E-Mail-Adresse.';

  @override
  String get requestCodeSendCodeButton => 'Code senden';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Erneut senden in ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Code verifizieren';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'Code an $email gesendet';
  }

  @override
  String get emailCodeSentInstructions => 'Bitte prüfen Sie Ihren Posteingang.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'Im Demo-Modus nutzen Sie: $code';
  }

  @override
  String get emailCodeVerificationHint => '6-stelliger Code';

  @override
  String get emailCodeValidationEmptyError => 'Code darf nicht leer sein.';

  @override
  String get emailCodeValidationLengthError => 'Code muss 6 Stellen haben.';

  @override
  String get emailCodeVerificationButtonLabel => 'Code verifizieren';

  @override
  String get overview => 'Übersicht';

  @override
  String get contentManagement => 'Inhaltsverwaltung';

  @override
  String get contentManagementPageDescription =>
      'Schlagzeilen, Themen und Quellen verwalten.';

  @override
  String get headlines => 'Schlagzeilen';

  @override
  String get headline => 'Schlagzeile';

  @override
  String get topics => 'Themen';

  @override
  String get topic => 'Thema';

  @override
  String get sources => 'Quellen';

  @override
  String get source => 'Quelle';

  @override
  String get appConfiguration => 'Remote-Konfig';

  @override
  String get appConfigurationPageDescription =>
      'Globale Einstellungen der mobilen App.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get appConfigurationPageTitle => 'Remote-Konfiguration';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Werbung';

  @override
  String get systemTab => 'System';

  @override
  String get userContentLimitsTitle => 'Inhaltslimits';

  @override
  String get userContentLimitsDescription =>
      'Limits für gefolgte Elemente und Lesezeichen.';

  @override
  String get feedActionsTitle => 'Feed-Aktionen';

  @override
  String get feedActionsDescription =>
      'Häufigkeit von Aktions-Widgets im Feed.';

  @override
  String get feedDecoratorsTitle => 'Feed-Dekoratoren';

  @override
  String get feedDecoratorsDescription =>
      'Visuelle Präsentation im Feed nach Rolle.';

  @override
  String get adSettingsTitle => 'Werbeeinstellungen';

  @override
  String get adSettingsDescription =>
      'Anzeigenhäufigkeit und Platzierung verwalten.';

  @override
  String get maintenanceModeTitle => 'Wartungsmodus';

  @override
  String get maintenanceModeDescription =>
      'Wartungsbildschirm für alle Nutzer aktivieren.';

  @override
  String get forceUpdateTitle => 'Update erzwingen';

  @override
  String get forceUpdateDescription =>
      'Obligatorische App-Updates konfigurieren.';

  @override
  String get forceUpdateTab => 'Update';

  @override
  String get appConfigSaveSuccessMessage =>
      'Konfiguration erfolgreich gespeichert.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Fehler: $errorMessage';
  }

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get loadingConfigurationHeadline => 'Konfiguration wird geladen';

  @override
  String get loadingConfigurationSubheadline => 'Bitte warten...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Laden der Konfiguration fehlgeschlagen.';

  @override
  String get loadAppSettingsSubheadline => 'Einstellungen vom Backend laden.';

  @override
  String get discardChangesButton => 'Änderungen verwerfen';

  @override
  String get saveChangesButton => 'Änderungen speichern';

  @override
  String get confirmConfigUpdateDialogTitle => 'Update bestätigen';

  @override
  String get confirmConfigUpdateDialogContent => 'Änderungen live schalten?';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get confirmSaveButton => 'Speichern bestätigen';

  @override
  String get guestUserTab => 'Gast';

  @override
  String get authenticatedUserTab => 'Authentifiziert';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Limit gefolgte Elemente (Gast)';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Max. Anzahl gefolgter Themen/Quellen.';

  @override
  String get guestSavedHeadlinesLimitLabel => 'Limit Lesezeichen (Gast)';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Max. Anzahl gespeicherter Schlagzeilen.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'Limit gefolgte Elemente (Standard)';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Limit für Standard-Nutzer.';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Limit Lesezeichen (Standard)';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Limit für Standard-Nutzer.';

  @override
  String get premiumFollowedItemsLimitLabel =>
      'Limit gefolgte Elemente (Premium)';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Limit für Premium-Nutzer.';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Limit Lesezeichen (Premium)';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Limit für Premium-Nutzer.';

  @override
  String get standardUserAdTab => 'Standard-Nutzer';

  @override
  String get guestAdFrequencyLabel => 'Anzeigenhäufigkeit (Gast)';

  @override
  String get guestAdFrequencyDescription => 'Anzeige alle X Feed-Elemente.';

  @override
  String get guestAdPlacementIntervalLabel => 'Platzierungsintervall (Gast)';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Elemente vor der ersten Anzeige.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Artikel vor Interstitial';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Gelesene Artikel vor Anzeige.';

  @override
  String get standardUserAdFrequencyLabel => 'Häufigkeit (Standard)';

  @override
  String get standardUserAdFrequencyDescription =>
      'Häufigkeit für Standard-Nutzer.';

  @override
  String get standardUserAdPlacementIntervalLabel => 'Intervall (Standard)';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Intervall für Standard.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Artikel (Standard)';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Lesungen für Standard.';

  @override
  String get premiumAdFrequencyLabel => 'Häufigkeit (Premium)';

  @override
  String get premiumAdFrequencyDescription =>
      'Häufigkeit für Premium (0 = keine Ads).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Intervall (Premium)';

  @override
  String get premiumAdPlacementIntervalDescription => 'Intervall für Premium.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Artikel (Premium)';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Lesungen für Premium.';

  @override
  String get appOperationalStatusWarning => 'WARNUNG: Betrifft alle Nutzer.';

  @override
  String get appOperationalStatusLabel => 'Betriebsstatus';

  @override
  String get appOperationalStatusDescription =>
      'Aktueller Status (Aktiv, Wartung).';

  @override
  String get maintenanceMessageLabel => 'Wartungsmeldung';

  @override
  String get maintenanceMessageDescription => 'Text während des Wartungsmodus.';

  @override
  String get disabledMessageLabel => 'Deaktivierungsmeldung';

  @override
  String get disabledMessageDescription => 'Text bei deaktivierter App.';

  @override
  String get forceUpdateConfigurationTitle => 'Update-Konfiguration';

  @override
  String get minAllowedAppVersionLabel => 'Minimale App-Version';

  @override
  String get minAllowedAppVersionDescription =>
      'Niedrigste erlaubte Version (z.B. 1.2.0).';

  @override
  String get latestAppVersionLabel => 'Neueste App-Version';

  @override
  String get latestAppVersionDescription => 'Aktuellste verfügbare Version.';

  @override
  String get updateRequiredMessageLabel => 'Meldung: Update erforderlich';

  @override
  String get updateRequiredMessageDescription => 'Text für erzwungenes Update.';

  @override
  String get updateOptionalMessageLabel => 'Meldung: Update optional';

  @override
  String get updateOptionalMessageDescription => 'Text für optionales Update.';

  @override
  String get iosStoreUrlLabel => 'iOS Store URL';

  @override
  String get iosStoreUrlDescription => 'Link zum Apple App Store.';

  @override
  String get androidStoreUrlLabel => 'Android Store URL';

  @override
  String get androidUpdateUrlDescription => 'Link zum Google Play Store.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'Tage zwischen Prompts (Gast)';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Mindesttage zwischen In-App-Prompts.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Tage zwischen Prompts (Standard)';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Tage für Standard.';

  @override
  String get signOut => 'Abmelden';

  @override
  String get settingsSavedSuccessfully => 'Einstellungen gespeichert!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Fehler beim Speichern: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Einstellungen laden';

  @override
  String get loadingSettingsSubheadline => 'Bitte warten...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Laden fehlgeschlagen: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Basis-Design';

  @override
  String get baseThemeDescription => 'Helles oder dunkles Erscheinungsbild.';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get systemTheme => 'Systemstandard';

  @override
  String get accentThemeLabel => 'Akzentfarbe';

  @override
  String get accentThemeDescription => 'Primärfarbe für interaktive Elemente.';

  @override
  String get defaultBlueTheme => 'Standard Blau';

  @override
  String get newsRedTheme => 'Nachrichten Rot';

  @override
  String get graphiteGrayTheme => 'Graphit Grau';

  @override
  String get fontFamilyLabel => 'Schriftart';

  @override
  String get fontFamilyDescription => 'Schriftart der Anwendung.';

  @override
  String get systemDefaultFont => 'Systemstandard';

  @override
  String get textScaleFactorLabel => 'Textgröße';

  @override
  String get textScaleFactorDescription => 'Schriftgröße in der App anpassen.';

  @override
  String get smallText => 'Klein';

  @override
  String get mediumText => 'Mittel';

  @override
  String get largeText => 'Groß';

  @override
  String get extraLargeText => 'Sehr groß';

  @override
  String get fontWeightLabel => 'Schriftstärke';

  @override
  String get fontWeightDescription => 'Dicke des Textes wählen.';

  @override
  String get lightFontWeight => 'Leicht';

  @override
  String get regularFontWeight => 'Normal';

  @override
  String get boldFontWeight => 'Fett';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get languageDescription => 'Sprache des Dashboards wählen.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get englishLanguage => 'Englisch';

  @override
  String get arabicLanguage => 'Arabisch';

  @override
  String get appearanceSettingsLabel => 'Erscheinungsbild';

  @override
  String get languageSettingsLabel => 'Sprache';

  @override
  String get themeSettingsLabel => 'Design-Einstellungen';

  @override
  String get fontSettingsLabel => 'Schrift-Einstellungen';

  @override
  String get settingsPageDescription =>
      'Persönliche Präferenzen konfigurieren.';

  @override
  String get appearanceSettingsDescription =>
      'Design, Farben und Typografie anpassen.';

  @override
  String get loadingHeadlines => 'Schlagzeilen laden';

  @override
  String get pleaseWait => 'Bitte warten...';

  @override
  String get noHeadlinesFound => 'Keine Schlagzeilen gefunden.';

  @override
  String get headlineTitle => 'Titel';

  @override
  String get excerpt => 'Auszug';

  @override
  String get countryName => 'Land';

  @override
  String get publishedAt => 'Veröffentlicht am';

  @override
  String get actions => 'Aktionen';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get loadingTopics => 'Themen laden';

  @override
  String get noTopicsFound => 'Keine Themen gefunden.';

  @override
  String get topicName => 'Thema';

  @override
  String get description => 'Beschreibung';

  @override
  String get notAvailable => 'N/V';

  @override
  String get loadingSources => 'Quellen laden';

  @override
  String get noSourcesFound => 'Keine Quellen gefunden.';

  @override
  String get sourceName => 'Quelle';

  @override
  String get sourceType => 'Typ';

  @override
  String get language => 'Sprache';

  @override
  String get editTopic => 'Thema bearbeiten';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get loadingTopic => 'Thema wird geladen';

  @override
  String get icon => 'Icon';

  @override
  String get topicUpdatedSuccessfully => 'Thema erfolgreich aktualisiert.';

  @override
  String get cannotUpdateTopicError => 'Fehler: Originaldaten nicht geladen.';

  @override
  String get createTopic => 'Thema erstellen';

  @override
  String get topicCreatedSuccessfully => 'Thema erstellt.';

  @override
  String get editSource => 'Quelle bearbeiten';

  @override
  String get sourceUpdatedSuccessfully => 'Quelle aktualisiert.';

  @override
  String get loadingSource => 'Quelle wird geladen...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Hauptsitz';

  @override
  String get none => 'Keine';

  @override
  String get cannotUpdateSourceError => 'Fehler: Originaldaten nicht geladen.';

  @override
  String get sourceTypeNewsAgency => 'Nachrichtenagentur';

  @override
  String get sourceTypeLocalNewsOutlet => 'Lokales Medium';

  @override
  String get sourceTypeNationalNewsOutlet => 'Nationales Medium';

  @override
  String get sourceTypeInternationalNewsOutlet => 'Internationales Medium';

  @override
  String get sourceTypeSpecializedPublisher => 'Fachverlag';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Regierungsquelle';

  @override
  String get sourceTypeAggregator => 'Aggregator';

  @override
  String get sourceTypeOther => 'Andere';

  @override
  String get editHeadline => 'Schlagzeile bearbeiten';

  @override
  String get headlineUpdatedSuccessfully => 'Schlagzeile aktualisiert.';

  @override
  String get loadingHeadline => 'Schlagzeile wird geladen...';

  @override
  String get image => 'Bild';

  @override
  String get cannotUpdateHeadlineError =>
      'Fehler: Originaldaten nicht geladen.';

  @override
  String get createHeadline => 'Schlagzeile erstellen';

  @override
  String get headlineCreatedSuccessfully => 'Schlagzeile erstellt.';

  @override
  String get loadingData => 'Daten werden geladen...';

  @override
  String get loadingFullList => 'Vollständige Liste laden...';

  @override
  String get createSource => 'Quelle erstellen';

  @override
  String get updateSourceTitle => 'Quelle aktualisieren';

  @override
  String get updateSourceMessage =>
      'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get sourceCreatedSuccessfully => 'Quelle erstellt.';

  @override
  String get updateTopicTitle => 'Thema aktualisieren';

  @override
  String get status => 'Status';

  @override
  String get updateTopicMessage =>
      'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert';

  @override
  String get contentStatusActive => 'Aktiv';

  @override
  String get contentStatusArchived => 'Archiviert';

  @override
  String get contentStatusDraft => 'Entwurf';

  @override
  String get totalHeadlines => 'Gesamt Schlagzeilen';

  @override
  String get totalTopics => 'Gesamt Themen';

  @override
  String get totalSources => 'Gesamt Quellen';

  @override
  String get loadingOverview => 'Übersicht wird geladen...';

  @override
  String get loadingOverviewSubheadline => 'Statistiken werden abgerufen...';

  @override
  String get overviewLoadFailure => 'Laden der Übersicht fehlgeschlagen.';

  @override
  String get recentHeadlines => 'Aktuelle Schlagzeilen';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get noRecentHeadlines => 'Keine aktuellen Schlagzeilen.';

  @override
  String get systemStatus => 'Systemstatus';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get createHeadlineAction => 'Schlagzeile erstellen';

  @override
  String get manageContentAction => 'Inhalt verwalten';

  @override
  String get appConfigAction => 'App-Konfiguration';

  @override
  String get appStatusActive => 'Aktiv';

  @override
  String get appStatusDisabled => 'Deaktiviert';

  @override
  String demoEmailHint(String email) {
    return 'Demo-E-Mail: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'Demo-Code: $code';
  }

  @override
  String get appStatusMaintenance => 'Wartung';

  @override
  String get appStatusOperational => 'Betriebsbereit';

  @override
  String get isUnderMaintenanceLabel => 'In Wartung';

  @override
  String get isUnderMaintenanceDescription =>
      'App in den Wartungsmodus versetzen.';

  @override
  String get isLatestVersionOnlyLabel => 'Nur neueste Version';

  @override
  String get isLatestVersionOnlyDescription =>
      'Nutzer müssen für Zugriff updaten.';

  @override
  String get iosUpdateUrlLabel => 'iOS Update URL';

  @override
  String get iosUpdateUrlDescription => 'URL für iOS-Updates.';

  @override
  String get androidUpdateUrlLabel => 'Android Update URL';

  @override
  String get followedItemsLimitLabel => 'Limit gefolgte Elemente';

  @override
  String get followedItemsLimitDescription =>
      'Max. Anzahl gefolgter Elemente pro Rolle.';

  @override
  String get savedFeedFiltersLimitLabel => 'Limit gespeicherte Filter';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Max. Anzahl gespeicherter Feed-Filter.';

  @override
  String get adFrequencyLabel => 'Anzeigenhäufigkeit';

  @override
  String get adFrequencyDescription => 'Anzeige alle X Elemente.';

  @override
  String get savedFeedFilterLimitsTitle => 'Filter-Limits';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Limits für gespeicherte Filter pro Stufe.';

  @override
  String get adPlacementIntervalLabel => 'Platzierungsintervall';

  @override
  String get adPlacementIntervalDescription =>
      'Elemente vor der ersten Anzeige.';

  @override
  String get articlesBeforeInterstitialAdsLabel => 'Artikel vor Interstitial';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Lesungen vor Anzeige.';

  @override
  String get daysSuffix => 'Tage';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Mindesttage vor dem $actionType Prompt.';
  }

  @override
  String get retryButtonText => 'Wiederholen';

  @override
  String get feedActionTypeLinkAccount => 'Konto verknüpfen';

  @override
  String get feedActionTypeRateApp => 'App bewerten';

  @override
  String get feedActionTypeFollowTopics => 'Themen folgen';

  @override
  String get feedActionTypeFollowSources => 'Quellen folgen';

  @override
  String get feedActionTypeUpgrade => 'Upgrade';

  @override
  String get feedActionTypeEnableNotifications =>
      'Benachrichtigungen aktivieren';

  @override
  String get countryPickerSearchLabel => 'Suche';

  @override
  String get countryPickerSearchHint => 'Suchen...';

  @override
  String get countryPickerSelectCountryLabel => 'Land wählen';

  @override
  String get archivedHeadlines => 'Archivierte Schlagzeilen';

  @override
  String get loadingArchivedHeadlines => 'Archiv wird geladen';

  @override
  String get noArchivedHeadlinesFound => 'Keine archivierten Schlagzeilen.';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get deleteForever => 'Endgültig löschen';

  @override
  String get archivedTopics => 'Archivierte Themen';

  @override
  String get loadingArchivedTopics => 'Archivierte Themen laden';

  @override
  String get noArchivedTopicsFound => 'Keine archivierten Themen.';

  @override
  String get archivedSources => 'Archivierte Quellen';

  @override
  String get loadingArchivedSources => 'Archivierte Quellen laden';

  @override
  String get noArchivedSourcesFound => 'Keine archivierten Quellen.';

  @override
  String get archivedItems => 'Archivierte Elemente';

  @override
  String get addNewItem => 'Neu hinzufügen';

  @override
  String get archive => 'Archivieren';

  @override
  String headlineDeleted(String title) {
    return '\'\'$title\'\' gelöscht.';
  }

  @override
  String get undo => 'Rückgängig';

  @override
  String get enabledLabel => 'Aktiviert';

  @override
  String get itemsToDisplayLabel => 'Anzuzeigende Elemente';

  @override
  String get itemsToDisplayDescription =>
      'Anzahl der Elemente in diesem Dekorator.';

  @override
  String get roleSpecificSettingsTitle => 'Rollenspezifische Einstellungen';

  @override
  String get daysBetweenViewsLabel => 'Tage zwischen Ansichten';

  @override
  String get daysBetweenViewsDescription => 'Mindesttage vor erneuter Anzeige.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Konto verknüpfen';

  @override
  String get feedDecoratorTypeUpgrade => 'Premium-Upgrade';

  @override
  String get feedDecoratorTypeRateApp => 'App bewerten';

  @override
  String get feedDecoratorTypeEnableNotifications =>
      'Benachrichtigungen aktivieren';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Vorgeschlagene Themen';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Vorgeschlagene Quellen';

  @override
  String get guestUserRole => 'Gast';

  @override
  String get standardUserRole => 'Standard-Nutzer';

  @override
  String get premiumUserRole => 'Premium-Nutzer';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get clearSelection => 'Auswahl aufheben';

  @override
  String get search => 'Suchen';

  @override
  String get noResultsFound => 'Keine Ergebnisse.';

  @override
  String get close => 'Schließen';

  @override
  String get apply => 'Anwenden';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Sichtbar für $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Werbeplattform-Konfig';

  @override
  String get primaryAdPlatformTitle => 'Primäre Plattform';

  @override
  String get primaryAdPlatformDescription => 'Haupt-Werbeanbieter wählen.';

  @override
  String get adUnitIdentifiersTitle => 'Anzeigen-IDs';

  @override
  String get adUnitIdentifiersDescription => 'IDs pro Plattform konfigurieren.';

  @override
  String get feedAdSettingsTitle => 'Feed-Anzeigen';

  @override
  String get enableFeedAdsLabel => 'Feed-Anzeigen aktivieren';

  @override
  String get feedAdTypeSelectionTitle => 'Feed-Anzeigentyp';

  @override
  String get feedAdTypeSelectionDescription => 'Native oder Banner.';

  @override
  String get userRoleFrequencySettingsTitle => 'Häufigkeit pro Rolle';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Intervalle pro Rolle festlegen.';

  @override
  String get articleAdSettingsTitle => 'Artikel-Anzeigen';

  @override
  String get enableArticleAdsLabel => 'Artikel-Anzeigen aktivieren';

  @override
  String get defaultInArticleAdTypeSelectionTitle => 'Standard-Anzeigentyp';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      'Native oder Banner.';

  @override
  String get inArticleAdSlotPlacementsTitle => 'Platzierungen im Artikel';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'Spezifische Slots aktivieren.';

  @override
  String get feedNativeAdIdLabel => 'Feed Native Ad ID';

  @override
  String get feedNativeAdIdDescription => 'ID für native Anzeigen im Feed.';

  @override
  String get feedBannerAdIdLabel => 'Feed Banner Ad ID';

  @override
  String get feedBannerAdIdDescription => 'ID für Banner im Feed.';

  @override
  String get articleInterstitialAdIdLabel => 'Artikel Interstitial ID';

  @override
  String get articleInterstitialAdIdDescription =>
      'ID für Interstitials in Artikeln.';

  @override
  String get inArticleNativeAdIdLabel => 'In-Artikel Native ID';

  @override
  String get inArticleNativeAdIdDescription => 'ID für native Ads im Artikel.';

  @override
  String get inArticleBannerAdIdLabel => 'In-Artikel Banner ID';

  @override
  String get inArticleBannerAdIdDescription => 'ID für Banner im Artikel.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Über \'Weiterlesen\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'Unter \'Weiterlesen\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' kopiert.';
  }

  @override
  String get copyId => 'ID kopieren';

  @override
  String get enableGlobalAdsLabel => 'Werbung aktivieren';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'Navigations-Interstitial ID';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'ID beim Öffnen von Artikeln.';

  @override
  String get interstitialAdSettingsTitle => 'Interstitial-Einstellungen';

  @override
  String get enableInterstitialAdsLabel => 'Interstitials aktivieren';

  @override
  String get userRoleInterstitialFrequencyTitle => 'Häufigkeit pro Rolle';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Übergänge vor Anzeige.';

  @override
  String get transitionsBeforeInterstitialAdsLabel => 'Übergänge vor Anzeige';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'Anzahl der Übergänge.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Native Ads';

  @override
  String get bannerAdsTab => 'Banner Ads';

  @override
  String get interstitialAdsTab => 'Interstitial Ads';

  @override
  String get videoAdsTab => 'Video Ads';

  @override
  String get bannerAdType => 'Banner';

  @override
  String get nativeAdType => 'Native';

  @override
  String get interstitialAdType => 'Interstitial';

  @override
  String get videoAdType => 'Video';

  @override
  String get rewardedAdType => 'Belohnt';

  @override
  String get bannerAdShapeSelectionTitle => 'Banner-Form';

  @override
  String get bannerAdShapeSelectionDescription =>
      'Quadratisch oder Rechteckig.';

  @override
  String get bannerAdShapeSquare => 'Quadrat';

  @override
  String get bannerAdShapeRectangle => 'Rechteck';

  @override
  String get loadingDraftHeadlines => 'Entwürfe laden';

  @override
  String get noDraftHeadlinesFound => 'Keine Entwürfe gefunden.';

  @override
  String get publish => 'Veröffentlichen';

  @override
  String get saveAsDraft => 'Als Entwurf speichern';

  @override
  String get invalidFormTitle => 'Ungültiges Formular';

  @override
  String get invalidFormMessage => 'Bitte alle Pflichtfelder ausfüllen.';

  @override
  String get completeForm => 'Ausfüllen';

  @override
  String get discard => 'Verwerfen';

  @override
  String get drafts => 'Entwürfe';

  @override
  String get draftsIconTooltip => 'Entwürfe';

  @override
  String get draftHeadlines => 'Schlagzeilen-Entwürfe';

  @override
  String get draftTopics => 'Themen-Entwürfe';

  @override
  String get draftSources => 'Quellen-Entwürfe';

  @override
  String get saveHeadlineTitle => 'Schlagzeile speichern';

  @override
  String get saveHeadlineMessage =>
      'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get saveTopicTitle => 'Thema speichern';

  @override
  String get saveTopicMessage => 'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get saveSourceTitle => 'Quelle speichern';

  @override
  String get saveSourceMessage => 'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get loadingDraftTopics => 'Themen-Entwürfe laden...';

  @override
  String get noDraftTopicsFound => 'Keine Themen-Entwürfe.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Thema \"$topicTitle\" gelöscht.';
  }

  @override
  String get loadingDraftSources => 'Quellen-Entwürfe laden...';

  @override
  String get noDraftSourcesFound => 'Keine Quellen-Entwürfe.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Quelle \"$sourceName\" gelöscht.';
  }

  @override
  String get publishTopic => 'Thema veröffentlichen';

  @override
  String get publishSource => 'Quelle veröffentlichen';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Artikel-Ads für $role aktivieren';
  }

  @override
  String get moreActions => 'Weitere Aktionen';

  @override
  String get filter => 'Filter';

  @override
  String get applyFilters => 'Filter anwenden';

  @override
  String get filterHeadlines => 'Schlagzeilen filtern';

  @override
  String get filterTopics => 'Themen filtern';

  @override
  String get filterSources => 'Quellen filtern';

  @override
  String get searchByHeadlineTitle => 'Nach Titel suchen...';

  @override
  String get searchByTopicName => 'Nach Name oder ID suchen...';

  @override
  String get searchBySourceName => 'Nach Name oder ID suchen...';

  @override
  String get selectSources => 'Quellen wählen';

  @override
  String get selectTopics => 'Themen wählen';

  @override
  String get countries => 'Länder';

  @override
  String get selectCountries => 'Länder wählen';

  @override
  String get selectSourceTypes => 'Quellentypen wählen';

  @override
  String get selectLanguages => 'Sprachen wählen';

  @override
  String get selectHeadquarters => 'Hauptsitze wählen';

  @override
  String get resetFiltersButtonText => 'Filter zurücksetzen';

  @override
  String get noResultsWithCurrentFilters =>
      'Keine Ergebnisse mit diesen Filtern.';

  @override
  String get aboutIconTooltip => 'Über diese Seite';

  @override
  String get closeButtonText => 'Schließen';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => 'Nutzerverwaltung';

  @override
  String get userManagementPageDescription =>
      'Nutzer, Rollen und Berechtigungen verwalten.';

  @override
  String get loadingUsers => 'Nutzer laden';

  @override
  String get noUsersFound => 'Keine Nutzer gefunden.';

  @override
  String get email => 'E-Mail';

  @override
  String get appRole => 'App-Rolle';

  @override
  String get dashboardRole => 'Dashboard-Rolle';

  @override
  String get createdAt => 'Erstellt am';

  @override
  String get promoteToPublisher => 'Zum Herausgeber befördern';

  @override
  String get demoteToUser => 'Zum Nutzer herabstufen';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Herausgeber';

  @override
  String get filterUsers => 'Nutzer filtern';

  @override
  String get searchByUserEmail => 'Nach E-Mail oder ID suchen...';

  @override
  String get selectAppRoles => 'App-Rollen wählen';

  @override
  String get selectDashboardRoles => 'Dashboard-Rollen wählen';

  @override
  String get authentication => 'Authentifizierung';

  @override
  String get subscription => 'Abonnement';

  @override
  String get authenticationAnonymous => 'Anonym';

  @override
  String get authenticationAuthenticated => 'Authentifiziert';

  @override
  String get subscriptionFree => 'Kostenlos';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle => 'Filter-Limits';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Limits für Filter, Fixierungen und Abos.';

  @override
  String get totalLimitLabel => 'Gesamtlimit';

  @override
  String get totalLimitDescription => 'Max. Anzahl erlaubter Filter.';

  @override
  String get pinnedLimitLabel => 'Limit Fixierungen';

  @override
  String get pinnedLimitDescription => 'Max. Anzahl fixierter Filter.';

  @override
  String get notificationSubscriptionLimitLabel => 'Limit Benachrichtigungen';

  @override
  String get notificationSubscriptionLimitDescription =>
      'Max. Anzahl Benachrichtigungs-Abos.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Eilmeldungen';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Wochenrückblick';

  @override
  String get isBreakingNewsLabel => 'Als Eilmeldung markieren';

  @override
  String get isBreakingNewsDescription =>
      'Sendet sofortige Push-Benachrichtigung.';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'Sendet beim Bearbeiten KEINE Push.';

  @override
  String get confirmBreakingNewsTitle => 'Eilmeldung bestätigen';

  @override
  String get confirmBreakingNewsMessage => 'Push an alle Abonnenten senden?';

  @override
  String get confirmPublishButton => 'Bestätigen & Veröffentlichen';

  @override
  String get cannotDraftBreakingNews =>
      'Eilmeldungen können kein Entwurf sein.';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => 'Eilmeldungen';

  @override
  String get breakingNewsFilterAll => 'Alle';

  @override
  String get breakingNewsFilterBreakingOnly => 'Nur Eilmeldungen';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Keine Eilmeldungen';

  @override
  String get notificationsTab => 'Benachrichtigungen';

  @override
  String get pushNotificationSettingsTitle => 'Push-Einstellungen';

  @override
  String get pushNotificationSettingsDescription =>
      'Globale Verwaltung des Push-Systems.';

  @override
  String get pushNotificationSystemStatusTitle => 'Push aktivieren';

  @override
  String get pushNotificationSystemStatusDescription => 'Globaler Schalter.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Primärer Anbieter';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Firebase oder OneSignal.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Zustellungsarten';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Spezifische Typen aktivieren.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'Allgemein';

  @override
  String get featuresTab => 'Funktionen';

  @override
  String get limitsTab => 'Limits';

  @override
  String get maintenanceConfigTitle => 'Wartungsmodus';

  @override
  String get maintenanceConfigDescription => 'App in Wartungsmodus versetzen.';

  @override
  String get updateConfigTitle => 'Update-Einstellungen';

  @override
  String get updateConfigDescription => 'Erzwungene Updates konfigurieren.';

  @override
  String get generalAppConfigTitle => 'Allgemeine App-Einstellungen';

  @override
  String get generalAppConfigDescription =>
      'AGB und Datenschutz-URLs verwalten.';

  @override
  String get termsOfServiceUrlLabel => 'AGB URL';

  @override
  String get termsOfServiceUrlDescription => 'Link zur AGB-Seite.';

  @override
  String get privacyPolicyUrlLabel => 'Datenschutz URL';

  @override
  String get privacyPolicyUrlDescription => 'Link zur Datenschutzseite.';

  @override
  String get navigationAdConfigTitle => 'Navigations-Anzeigen';

  @override
  String get enableNavigationAdsLabel => 'Navigations-Ads aktivieren';

  @override
  String get navigationAdFrequencyTitle => 'Navigations-Häufigkeit';

  @override
  String get navigationAdFrequencyDescription => 'Übergänge vor Anzeige.';

  @override
  String get internalNavigationsBeforeAdLabel => 'Interne Navigationen';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'Seitenaufrufe vor Anzeige.';

  @override
  String get externalNavigationsBeforeAdLabel => 'Externe Navigationen';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'Externe Klicks vor Anzeige.';

  @override
  String get nativeAdIdLabel => 'Native Ad ID';

  @override
  String get nativeAdIdDescription => 'ID für native Anzeigen.';

  @override
  String get bannerAdIdLabel => 'Banner Ad ID';

  @override
  String get bannerAdIdDescription => 'ID für Banner-Anzeigen.';

  @override
  String get interstitialAdIdLabel => 'Interstitial Ad ID';

  @override
  String get interstitialAdIdDescription => 'ID für Interstitial-Anzeigen.';

  @override
  String get savedHeadlinesLimitLabel => 'Limit Lesezeichen';

  @override
  String get savedHeadlinesLimitDescription =>
      'Max. Anzahl gespeicherter Schlagzeilen.';

  @override
  String get appUpdateManagementTitle => 'App-Update-Verwaltung';

  @override
  String get feedItemClickBehaviorTitle => 'Klick-Verhalten';

  @override
  String get feedItemClickBehaviorDescription =>
      'Standard-Browser für Schlagzeilen.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'In-App Browser';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'System-Browser';

  @override
  String get userLimitsTitle => 'Nutzer-Limits';

  @override
  String get userLimitsDescription => 'Limits für Funktionen definieren.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Betriebsstatus und Updates steuern.';

  @override
  String get advertisementsDescription => 'Globale Werbeverwaltung.';

  @override
  String get notificationsDescription => 'Push-System konfigurieren.';

  @override
  String get feedDescription => 'Verhalten und Aussehen des Feeds.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Limit für Eilmeldungs-Abos.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Limit für Wochenrückblicke.';

  @override
  String get appStatusAndUpdatesTitle => 'Status & Updates';

  @override
  String get enableForcedUpdatesLabel => 'Erzwungene Updates aktivieren';

  @override
  String get enableForcedUpdatesDescription =>
      'Mindestversion für App festlegen.';

  @override
  String get appUrlsTitle => 'App-URLs';

  @override
  String get appUrlsDescription => 'Interne und externe Links verwalten.';

  @override
  String get communityAndEngagementTitle => 'Community & Interaktion';

  @override
  String get communityAndEngagementDescription =>
      'Kommentare und Meldungen konfigurieren.';

  @override
  String get userEngagementTitle => 'Nutzer-Interaktion';

  @override
  String get userEngagementDescription =>
      'Reaktionen und Kommentare einstellen.';

  @override
  String get contentReportingTitle => 'Inhaltsmeldung';

  @override
  String get contentReportingDescription => 'Regeln für Meldungen festlegen.';

  @override
  String get appReviewFunnelTitle => 'App-Bewertungen';

  @override
  String get appReviewFunnelDescription => 'Zufriedenheitsabfragen verwalten.';

  @override
  String get enableEngagementFeaturesLabel => 'Interaktion aktivieren';

  @override
  String get enableEngagementFeaturesDescription =>
      'Reaktionen und Kommentare ein/aus.';

  @override
  String get engagementModeLabel => 'Interaktionsmodus';

  @override
  String get engagementModeDescription =>
      'Nur Reaktionen oder auch Kommentare.';

  @override
  String get engagementModeReactionsOnly => 'Nur Reaktionen';

  @override
  String get engagementModeReactionsAndComments => 'Reaktionen & Kommentare';

  @override
  String get enableReportingSystemLabel => 'Meldesystem aktivieren';

  @override
  String get enableReportingSystemDescription =>
      'Meldeoptionen global steuern.';

  @override
  String get enableHeadlineReportingLabel => 'Schlagzeilen melden';

  @override
  String get enableSourceReportingLabel => 'Quellen melden';

  @override
  String get enableCommentReportingLabel => 'Kommentare melden';

  @override
  String get enableAppFeedbackSystemLabel => 'Internes Feedback aktivieren';

  @override
  String get enableAppFeedbackSystemDescription =>
      'Nutzer nach Zufriedenheit fragen.';

  @override
  String get interactionCycleThresholdLabel => 'Interaktions-Schwellenwert';

  @override
  String get interactionCycleThresholdDescription =>
      'Positive Aktionen für Prompt.';

  @override
  String get initialPromptCooldownLabel => 'Erster Prompt Cooldown (Tage)';

  @override
  String get initialPromptCooldownDescription =>
      'Wartezeit bis zur ersten Abfrage.';

  @override
  String get requestStoreReviewLabel => 'Store-Bewertung anfordern';

  @override
  String get requestStoreReviewDescription =>
      'Bei \'Ja\' offiziellen Dialog zeigen.';

  @override
  String get requestWrittenFeedbackLabel => 'Schriftliches Feedback anfordern';

  @override
  String get requestWrittenFeedbackDescription =>
      'Bei \'Nein\' nach Grund fragen.';

  @override
  String get internalPromptLogicTitle => 'Interne Prompt-Logik';

  @override
  String get eligiblePositiveInteractionsTitle => 'Positive Interaktionen';

  @override
  String get positiveInteractionTypeSaveItem => 'Inhalt speichern';

  @override
  String get positiveInteractionTypeFollowItem => 'Entität folgen';

  @override
  String get positiveInteractionTypeShareContent => 'Inhalt teilen';

  @override
  String get positiveInteractionTypeSaveFilter => 'Filter speichern';

  @override
  String get followUpActionsTitle => 'Folgeaktionen';

  @override
  String get enableCommunityFeaturesLabel => 'Community-Funktionen aktivieren';

  @override
  String get enableCommunityFeaturesDescription =>
      'Interaktion und Meldungen steuern.';

  @override
  String get communityManagementPageDescription =>
      'Kommentare, Meldungen und Reviews verwalten.';

  @override
  String get engagements => 'Interaktionen';

  @override
  String get reports => 'Meldungen';

  @override
  String get appReviews => 'App-Reviews';

  @override
  String get user => 'Nutzer';

  @override
  String get engagedContent => 'Inhalt';

  @override
  String get reaction => 'Reaktion';

  @override
  String get comment => 'Kommentar';

  @override
  String get commentStatus => 'Kommentar-Status';

  @override
  String get hasCommentFilterLabel => 'Enthält Kommentar';

  @override
  String get hasCommentFilterDescription => 'Nur Interaktionen mit Text.';

  @override
  String get date => 'Datum';

  @override
  String get approveComment => 'Kommentar genehmigen';

  @override
  String get rejectComment => 'Kommentar ablehnen';

  @override
  String get viewEngagedContent => 'Inhalt ansehen';

  @override
  String get copyUserId => 'Nutzer-ID kopieren';

  @override
  String get reporter => 'Melder';

  @override
  String get reportedItem => 'Gemeldetes Element';

  @override
  String get reason => 'Grund';

  @override
  String get reportStatus => 'Meldestatus';

  @override
  String get viewReportedItem => 'Element ansehen';

  @override
  String get markAsInReview => 'In Prüfung markieren';

  @override
  String get resolveReport => 'Meldung lösen';

  @override
  String get initialFeedback => 'Erstes Feedback';

  @override
  String get osPromptRequested => 'OS Prompt?';

  @override
  String get feedbackHistory => 'Feedback-Verlauf';

  @override
  String get lastInteraction => 'Letzte Interaktion';

  @override
  String get viewFeedbackHistory => 'Verlauf ansehen';

  @override
  String get reactionTypeLike => 'Gefällt mir';

  @override
  String get reactionTypeInsightful => 'Aufschlussreich';

  @override
  String get reactionTypeAmusing => 'Amüsant';

  @override
  String get reactionTypeSad => 'Traurig';

  @override
  String get reactionTypeAngry => 'Wütend';

  @override
  String get reactionTypeSkeptical => 'Skeptisch';

  @override
  String get initialAppReviewFeedbackPositive => 'Positiv';

  @override
  String get initialAppReviewFeedbackNegative => 'Negativ';

  @override
  String get filterCommunity => 'Community-Inhalt filtern';

  @override
  String get searchByEngagementUser => 'Nach Nutzer-E-Mail suchen...';

  @override
  String get searchByReportReporter => 'Nach Melder-E-Mail suchen...';

  @override
  String get searchByAppReviewUser => 'Nach Nutzer-E-Mail suchen...';

  @override
  String get selectCommentStatus => 'Kommentar-Status wählen';

  @override
  String get selectReportStatus => 'Meldestatus wählen';

  @override
  String get selectInitialFeedback => 'Erstes Feedback wählen';

  @override
  String get selectReportableEntity => 'Elementtyp wählen';

  @override
  String get reportableEntityHeadline => 'Schlagzeile';

  @override
  String get reportableEntitySource => 'Quelle';

  @override
  String get reportableEntityComment => 'Kommentar';

  @override
  String get noEngagementsFound => 'Keine Interaktionen.';

  @override
  String get noReportsFound => 'Keine Meldungen.';

  @override
  String get noAppReviewsFound => 'Keine Reviews.';

  @override
  String get loadingEngagements => 'Interaktionen laden';

  @override
  String get loadingReports => 'Meldungen laden';

  @override
  String get loadingAppReviews => 'Reviews laden';

  @override
  String get userIdCopied => 'Nutzer-ID kopiert.';

  @override
  String get reportStatusUpdated => 'Meldestatus aktualisiert.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Feedback-Verlauf für $email';
  }

  @override
  String get noFeedbackHistory => 'Kein Verlauf verfügbar.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback am: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Grund: $reason';
  }

  @override
  String get noReasonProvided => 'Kein Grund angegeben.';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Falschinformation / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Clickbait-Titel';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Beleidigend / Hassrede';

  @override
  String get reportReasonSpamOrScam => 'Spam / Betrug';

  @override
  String get reportReasonBrokenLink => 'Defekter Link';

  @override
  String get reportReasonPaywalled => 'Bezahlschranke';

  @override
  String get reportReasonLowQualityJournalism => 'Minderwertiger Journalismus';

  @override
  String get reportReasonHighAdDensity => 'Zu viel Werbung';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Regierungsquelle';

  @override
  String get reportReasonAggregator => 'Aggregator';

  @override
  String get reportReasonOther => 'Anderes';

  @override
  String get reportReasonFrequentPaywalls => 'Häufige Bezahlschranken';

  @override
  String get reportReasonImpersonation => 'Identitätsdiebstahl';

  @override
  String get noNegativeFeedbackHistory => 'Kein negatives Feedback gefunden.';

  @override
  String get reject => 'Ablehnen';

  @override
  String get commentStatusFlaggedByAi => 'Von KI markiert';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get rejectCommentConfirmation => 'Kommentar endgültig löschen?';

  @override
  String get searchByUserId => 'Nach Nutzer-ID suchen...';

  @override
  String get viewReportedHeadline => 'Schlagzeile ansehen';

  @override
  String get viewReportedSource => 'Quelle ansehen';

  @override
  String get viewReportedComment => 'Kommentar ansehen';

  @override
  String get entityType => 'Entitätstyp';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Feedback-Details';

  @override
  String get moderationStatusPendingReview => 'Prüfung ausstehend';

  @override
  String get moderationStatusResolved => 'Gelöst';

  @override
  String get hasComment => 'Hat Kommentar';

  @override
  String get any => 'Alle';

  @override
  String get withComment => 'Mit Kommentar';

  @override
  String get withoutComment => 'Ohne Kommentar';

  @override
  String get reportResolved => 'Meldung gelöst.';

  @override
  String get commentApproved => 'Kommentar genehmigt.';

  @override
  String get commentRejected => 'Kommentar abgelehnt.';

  @override
  String get copyHeadlineId => 'Schlagzeilen-ID kopieren';

  @override
  String get copyReportedItemId => 'Element-ID kopieren';

  @override
  String get viewFeedbackDetails => 'Details ansehen';

  @override
  String get reportDetails => 'Meldungs-Details';

  @override
  String get commentDetails => 'Kommentar-Details';

  @override
  String get communityManagement => 'Community-Verwaltung';

  @override
  String get navContent => 'Inhalt';

  @override
  String get navUsers => 'Nutzer';

  @override
  String get navCommunity => 'Community';

  @override
  String get confirmPromotionTitle => 'Beförderung bestätigen';

  @override
  String confirmPromotionMessage(String email) {
    return '$email zum Herausgeber befördern?';
  }

  @override
  String get confirmDemotionTitle => 'Herabstufung bestätigen';

  @override
  String confirmDemotionMessage(String email) {
    return '$email zum Standard-Nutzer herabstufen?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Herausgeber';

  @override
  String get breakingNewsHint => 'Dies ist eine Eilmeldung';

  @override
  String get breakingNewsFilterDescription => 'Nur Eilmeldungen anzeigen';

  @override
  String publishItemTitle(String itemType) {
    return '$itemType veröffentlichen?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'Diesen $itemType veröffentlichen? Er wird öffentlich sichtbar.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return '$itemType archivieren?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'Diesen $itemType archivieren? Er wird ausgeblendet.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return '$itemType wiederherstellen?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'Diesen $itemType wiederherstellen? Er wird wieder aktiv.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return '$itemType löschen?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'Diesen $itemType wirklich löschen?';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" gelöscht.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Primären Anbieter und IDs wählen.';

  @override
  String get feedAdSettingsDescription =>
      'Sichtbarkeit und Häufigkeit im Feed.';

  @override
  String get navigationAdConfigDescription =>
      'Interstitial-Ads bei Navigation.';

  @override
  String get feedDecoratorLinkAccountDescription =>
      'Gäste zur Registrierung auffordern.';

  @override
  String get feedDecoratorUpgradeDescription =>
      'Standard-Nutzer zum Upgrade auffordern.';

  @override
  String get feedDecoratorRateAppDescription =>
      'Nutzer zur Bewertung auffordern.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Push-Aktivierung vorschlagen.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Themenvorschläge anzeigen.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Quellenvorschläge anzeigen.';

  @override
  String get enableGlobalAdsDescription => 'Alle Anzeigen global ein/aus.';

  @override
  String get enableFeedAdsDescription => 'Anzeigen im Feed steuern.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'Aktiv für Nutzer mit der Rolle \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription =>
      'Diesen Dekorator global aktivieren.';

  @override
  String get enableNavigationAdsDescription =>
      'Ads bei internen Seitenwechseln.';

  @override
  String get enableHeadlineReportingDescription =>
      'Nutzer können Schlagzeilen melden.';

  @override
  String get enableSourceReportingDescription =>
      'Nutzer können Quellen melden.';

  @override
  String get enableCommentReportingDescription =>
      'Nutzer können Kommentare melden.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Abos für Eilmeldungen.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Tägliche Zusammenfassung.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Wöchentlicher Rückblick.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Zählt beim Speichern einer Schlagzeile.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Zählt beim Folgen einer Entität.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Zählt beim Teilen von Inhalten.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Zählt beim Speichern eines Filters.';

  @override
  String get internalPromptLogicDescription =>
      'Bedingungen für den Zufriedenheits-Prompt.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Aktionen, die als positiv zählen.';

  @override
  String get followUpActionsDescription =>
      'Aktionen nach Antwort auf den Prompt.';

  @override
  String get analyticsTab => 'Analytik';

  @override
  String get analyticsDescription =>
      'Anbieter, Events und Sampling konfigurieren.';

  @override
  String get analyticsSystemStatusTitle => 'Analytik-System aktivieren';

  @override
  String get analyticsSystemStatusDescription => 'Hauptschalter für Tracking.';

  @override
  String get analyticsProviderTitle => 'Aktiver Anbieter';

  @override
  String get analyticsProviderDescription => 'Primären Analytik-Dienst wählen.';

  @override
  String get analyticsEventsTitle => 'Event-Konfiguration';

  @override
  String get analyticsEventsDescription =>
      'Logging für spezifische Events anpassen.';

  @override
  String samplingRateLabel(int rate) {
    return 'Sampling-Rate: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'Nutzer-Registrierung';

  @override
  String get analyticsEventUserRegisteredDescription => 'Trackt neue Konten.';

  @override
  String get analyticsEventUserLoginLabel => 'Nutzer-Login';

  @override
  String get analyticsEventUserLoginDescription => 'Trackt Anmeldungen.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Konto-Verknüpfung';

  @override
  String get analyticsEventAccountLinkedDescription => 'Trackt Verknüpfungen.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'Rollenwechsel';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Trackt Upgrades/Änderungen.';

  @override
  String get analyticsEventContentViewedLabel => 'Inhalt angesehen';

  @override
  String get analyticsEventContentViewedDescription => 'Trackt Lesevorgänge.';

  @override
  String get analyticsEventContentSharedLabel => 'Inhalt geteilt';

  @override
  String get analyticsEventContentSharedDescription => 'Trackt Teilvorgänge.';

  @override
  String get analyticsEventContentSavedLabel => 'Inhalt gespeichert';

  @override
  String get analyticsEventContentSavedDescription => 'Trackt Lesezeichen.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Lesezeichen entfernt';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Trackt Entfernen von Lesezeichen.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Lesezeit';

  @override
  String get analyticsEventContentReadingTimeDescription => 'Trackt Lesedauer.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Reaktion hinzugefügt';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Trackt neue Reaktionen.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Reaktion entfernt';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Trackt Löschen von Reaktionen.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Kommentar gepostet';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Trackt neue Kommentare.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Kommentar gelöscht';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Trackt Löschen von Kommentaren.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Meldung gesendet';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Trackt Nutzer-Meldungen.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'Filter erstellt';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Trackt neue Filter.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'Filter aktualisiert';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Trackt Filter-Änderungen.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Filter genutzt';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Trackt Filter-Anwendung.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Suche ausgeführt';

  @override
  String get analyticsEventSearchPerformedDescription => 'Trackt Suchanfragen.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel => 'Prompt-Antwort';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Trackt Antworten auf \'Gefällt dir die App?\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Store-Review angefordert';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Trackt offizielle Review-Anfragen.';

  @override
  String get analyticsEventLimitExceededLabel => 'Limit überschritten';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Trackt Erreichen von Limits.';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => 'Limit CTA Klick';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Trackt Klicks auf \'Upgrade\'.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Paywall angezeigt';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Trackt Paywall-Impressions.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Abo gestartet';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Trackt neue Käufe.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Abo verlängert';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'Trackt Verlängerungen.';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'Abo gekündigt';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Trackt Kündigungen.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Abo beendet';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'Trackt Ablauf von Abos.';

  @override
  String get analyticsEventAdImpressionLabel => 'Anzeigen-Impression';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Trackt Sichtbarkeit von Ads.';

  @override
  String get analyticsEventAdClickedLabel => 'Anzeigen-Klick';

  @override
  String get analyticsEventAdClickedDescription => 'Trackt Klicks auf Ads.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Anzeigen-Ladefehler';

  @override
  String get analyticsEventAdLoadFailedDescription =>
      'Trackt Fehler beim Laden.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Belohnung erhalten';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Trackt abgeschlossene Belohnungs-Ads.';

  @override
  String get analyticsEventThemeChangedLabel => 'Design geändert';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Trackt visuelle Änderungen.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Sprache geändert';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Trackt Sprachänderungen.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Dichte geändert';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Trackt Feed-Anpassungen.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'Browser-Wahl geändert';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Trackt Link-Präferenzen.';

  @override
  String get analyticsEventAppTourStartedLabel => 'Tour gestartet';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'Trackt Start der App-Tour.';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'Tour-Schritt angesehen';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'Trackt Seitenaufrufe in der Tour.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'Tour abgeschlossen';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'Trackt Ende der Tour.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'Tour übersprungen';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'Trackt Überspringen der Tour.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'Personalisierung gestartet';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'Trackt Start des Onboardings.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'Onboarding-Schritt angesehen';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'Trackt Onboarding-Seiten.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'Personalisierung abgeschlossen';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'Trackt Ende des Onboardings.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'Personalisierung übersprungen';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'Trackt Überspringen des Onboardings.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7T';

  @override
  String get timeFrameMonth => '30T';

  @override
  String get timeFrameYear => '1J';

  @override
  String get noDataAvailable => 'Keine Daten';

  @override
  String get vsPreviousPeriod => 'vs Vorperiode';

  @override
  String get vsPreviousDay => 'vs letzte 24h';

  @override
  String get vsPreviousWeek => 'vs letzte 7 Tage';

  @override
  String get vsPreviousMonth => 'vs letzte 30 Tage';

  @override
  String get vsPreviousYear => 'vs Vorjahr';

  @override
  String get kpiUsersTotalRegistered => 'Registrierte Nutzer';

  @override
  String get kpiUsersNewRegistrations => 'Neu-Registrierungen';

  @override
  String get kpiUsersActiveUsers => 'Aktive Nutzer';

  @override
  String get kpiContentHeadlinesTotalPublished =>
      'Veröffentlichte Schlagzeilen';

  @override
  String get kpiContentHeadlinesTotalViews => 'Gesamtansichten';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Gesamt-Likes';

  @override
  String get kpiContentSourcesTotalSources => 'Gesamt Quellen';

  @override
  String get kpiContentSourcesNewSources => 'Neue Quellen';

  @override
  String get kpiContentSourcesTotalFollowers => 'Quellen-Follower';

  @override
  String get kpiContentTopicsTotalTopics => 'Gesamt Themen';

  @override
  String get kpiContentTopicsNewTopics => 'Neue Themen';

  @override
  String get kpiContentTopicsTotalFollowers => 'Themen-Follower';

  @override
  String get kpiEngagementsTotalReactions => 'Gesamt Reaktionen';

  @override
  String get kpiEngagementsTotalComments => 'Gesamt Kommentare';

  @override
  String get kpiEngagementsAverageEngagementRate =>
      'Durchschn. Interaktionsrate';

  @override
  String get kpiEngagementsReportsPending => 'Offene Meldungen';

  @override
  String get kpiEngagementsReportsResolved => 'Gelöste Meldungen';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Durchschn. Lösezeit';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Gesamt Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Positives Feedback';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Store-Anfragen';

  @override
  String get chartUsersRegistrationsOverTime =>
      'Registrierungen im Zeitverlauf';

  @override
  String get chartUsersActiveUsersOverTime => 'Trend aktive Nutzer';

  @override
  String get chartUsersRoleDistribution => 'Rollenverteilung';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Trend Ansichten';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Trend Likes';

  @override
  String get chartContentHeadlinesViewsByTopic => 'Ansichten nach Thema';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime =>
      'Quellen-Aktivität';

  @override
  String get chartContentSourcesFollowersOverTime => 'Quellen-Wachstum';

  @override
  String get chartContentSourcesEngagementByType =>
      'Interaktion nach Quellentyp';

  @override
  String get chartContentTopicsFollowersOverTime => 'Themen-Wachstum';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => 'Themen-Aktivität';

  @override
  String get chartContentTopicsEngagementByTopic => 'Interaktion nach Thema';

  @override
  String get chartEngagementsReactionsOverTime => 'Trend Reaktionen';

  @override
  String get chartEngagementsCommentsOverTime => 'Trend Kommentare';

  @override
  String get chartEngagementsReactionsByType => 'Reaktionsverteilung';

  @override
  String get chartEngagementsReportsSubmittedOverTime =>
      'Eingegangene Meldungen';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime => 'Trend Lösezeit';

  @override
  String get chartEngagementsReportsByReason => 'Meldungen nach Grund';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'Feedback-Trend';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Sentiment-Analyse';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Trend Store-Anfragen';

  @override
  String get chartContentSourcesStatusDistribution =>
      'Statusverteilung Quellen';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'Eilmeldungs-Verteilung';

  @override
  String get chartOverviewAppTourFunnel => 'App-Tour Funnel';

  @override
  String get chartOverviewInitialPersonalizationFunnel => 'Onboarding-Funnel';

  @override
  String get rankedListOverviewHeadlinesMostViewed =>
      'Meistgesehene Schlagzeilen';

  @override
  String get rankedListOverviewHeadlinesMostLiked =>
      'Meistgeliebte Schlagzeilen';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'Meistgefolgte Quellen';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Meistgefolgte Themen';

  @override
  String get subscriptionTab => 'Abos';

  @override
  String get subscriptionDescription =>
      'Abo-Pläne (monatlich, jährlich) konfigurieren.';

  @override
  String get enableSubscriptionLabel => 'Abo-Funktion aktivieren';

  @override
  String get enableSubscriptionDescription =>
      'Hauptschalter für das Abo-System.';

  @override
  String get monthlyPlanTitle => 'Monatsplan';

  @override
  String get annualPlanTitle => 'Jahresplan';

  @override
  String get planEnabledLabel => 'Plan aktivieren';

  @override
  String get planRecommendedLabel => 'Empfohlener Plan';

  @override
  String get planRecommendedDescription =>
      'Markiert diesen Plan als beste Wahl.';

  @override
  String get appleProductIdLabel => 'Apple App Store Produkt-ID';

  @override
  String get googleProductIdLabel => 'Google Play Store Produkt-ID';

  @override
  String get subscriptionPlanEnablementError =>
      'Mindestens eine Produkt-ID erforderlich.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Plan deaktiviert (IDs fehlen).';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Abo-Funktion deaktiviert.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Push-System deaktiviert.';

  @override
  String get analyticsFeatureDisabledNotification =>
      'Analytik-System deaktiviert.';

  @override
  String get reportingFeatureDisabledNotification => 'Meldesystem deaktiviert.';

  @override
  String get appReviewFeatureDisabledNotification =>
      'Review-System deaktiviert.';

  @override
  String get subscriptionsName => 'Abonnements';

  @override
  String get subscriptionProvider => 'Store-Anbieter';

  @override
  String get accessTier => 'Zugangsstufe';

  @override
  String get expiryDate => 'Ablaufdatum';

  @override
  String get willAutoRenew => 'Auto-Verlängerung';

  @override
  String get allAccessTiers => 'Alle Stufen';

  @override
  String get subscriptionActionCopyUserId => 'Nutzer-ID kopieren';

  @override
  String get subscriptionActionCopySubscriptionId => 'Abo-ID kopieren';

  @override
  String get filterSubscriptions => 'Abos filtern';

  @override
  String get selectStatus => 'Status wählen';

  @override
  String get selectProvider => 'Anbieter wählen';

  @override
  String get selectTier => 'Stufe wählen';

  @override
  String get noSubscriptionsFound => 'Keine Abos gefunden.';

  @override
  String get loadingSubscriptions => 'Abos laden';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Nach Nutzer- oder Abo-ID suchen...';

  @override
  String get subscriptionsPageDescription =>
      'Nur-Lese-Ansicht der Nutzer-Abos.';

  @override
  String get subscriptionStatusActive => 'Aktiv';

  @override
  String get subscriptionStatusGracePeriod => 'Kulanzzeitraum';

  @override
  String get subscriptionStatusBillingIssue => 'Zahlungsproblem';

  @override
  String get subscriptionStatusCanceled => 'Gekündigt';

  @override
  String get subscriptionStatusExpired => 'Abgelaufen';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'Aktive Abos im Zeitverlauf';

  @override
  String get chartSubscriptionsStatusDistribution => 'Abo-Statusverteilung';

  @override
  String get chartSubscriptionsByStoreProvider => 'Abos nach Store';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Gesamt Ads gesehen';

  @override
  String get kpiRewardsActiveUsersCount => 'Aktive Belohnungs-Nutzer';

  @override
  String get rewardsTab => 'Belohnungen';

  @override
  String get rewardsDescription => 'Zeitbasierte Belohnungen konfigurieren.';

  @override
  String get enableRewardsLabel => 'Belohnungssystem aktivieren';

  @override
  String get enableRewardsDescription =>
      'Nutzer können Belohnungen durch Ads verdienen.';

  @override
  String get rewardTypeAdFree => 'Werbefreies Erlebnis';

  @override
  String get rewardDurationDaysLabel => 'Dauer (Tage)';

  @override
  String get rewardEnabledLabel => 'Aktiviert';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Trend gesehene Ads';

  @override
  String get chartRewardsActiveByType => 'Aktive Belohnungen nach Typ';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Aufforderung zum Ad-Schauen für Premium-Features.';

  @override
  String get rewardDurationDaysDescription =>
      'Anzahl der Tage, die die Belohnung gilt.';

  @override
  String get rewardsManagement => 'Belohnungsverwaltung';

  @override
  String get rewardsManagementPageDescription =>
      'Nutzer-Belohnungen verwalten.';

  @override
  String get loadingRewards => 'Belohnungen laden';

  @override
  String get noRewardsFound => 'Keine Belohnungen gefunden.';

  @override
  String get userId => 'Nutzer-ID';

  @override
  String get activeRewards => 'Aktive Belohnungen';

  @override
  String get expiry => 'Ablauf';

  @override
  String get filterRewards => 'Belohnungen filtern';

  @override
  String get rewardType => 'Belohnungstyp';

  @override
  String get selectRewardTypes => 'Belohnungstypen wählen';

  @override
  String get loadingAnalytics => 'Analytik laden';

  @override
  String get noAnalyticsDataHeadline => 'Keine Analytik-Daten';

  @override
  String get noAnalyticsDataSubheadline =>
      'Noch keine Daten zum Anzeigen verfügbar.';

  @override
  String get androidAdUnitsTitle => 'Android Anzeigen-Einheiten';

  @override
  String get iosAdUnitsTitle => 'iOS Anzeigen-Einheiten';

  @override
  String get rewardedAdIdLabel => 'Rewarded Ad ID';

  @override
  String get rewardedAdIdDescription => 'ID für Belohnungs-Anzeigen.';

  @override
  String get kpiRewardsGrantedTotal => 'Gesamt Belohnungen gewährt';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'Belohnungs-Hub angesehen';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'Trackt Besuche im Hub.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'Angebot angeklickt';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'Trackt Klicks auf Angebote.';

  @override
  String get analyticsEventRewardGrantedLabel => 'Belohnung gewährt';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'Trackt erfolgreiche Gewährung.';

  @override
  String get chartRewardsGrantedOverTime => 'Trend gewährt Belohnungen';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'Erste Personalisierung';

  @override
  String get initialPersonalizationDescription =>
      'Onboarding-Flow für neue Nutzer konfigurieren.';

  @override
  String get enableInitialPersonalizationLabel => 'Personalisierung aktivieren';

  @override
  String get enableInitialPersonalizationDescription =>
      'Führt neue Nutzer durch die Auswahl.';

  @override
  String get enableCountrySelectionLabel => 'Länderauswahl aktivieren';

  @override
  String get enableCountrySelectionDescription =>
      'Nutzer können Land im Onboarding wählen.';

  @override
  String get enableTopicSelectionLabel => 'Themenauswahl aktivieren';

  @override
  String get enableTopicSelectionDescription =>
      'Nutzer können Themen im Onboarding wählen.';

  @override
  String get enableSourceSelectionLabel => 'Quellenauswahl aktivieren';

  @override
  String get enableSourceSelectionDescription =>
      'Nutzer können Quellen im Onboarding wählen.';

  @override
  String get minSelectionsRequiredLabel => 'Mindestauswahl erforderlich';

  @override
  String get minSelectionsRequiredDescription =>
      'Anzahl der Elemente zum Fortfahren.';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingDescription =>
      'App-Tour und Personalisierung verwalten.';

  @override
  String get enableOnboardingLabel => 'Onboarding aktivieren';

  @override
  String get enableOnboardingDescription =>
      'Hauptschalter für den gesamten Flow.';

  @override
  String get appTourTitle => 'App-Tour';

  @override
  String get appTourDescription => 'Tour vor der Anmeldung konfigurieren.';

  @override
  String get enableAppTourLabel => 'App-Tour aktivieren';

  @override
  String get enableAppTourDescription =>
      'Kurze Einführung vor dem Login zeigen.';

  @override
  String get skippableAppTourLabel => 'Tour überspringbar';

  @override
  String get skippableAppTourDescription =>
      'Nutzer können die Tour überspringen.';

  @override
  String get skippableInitialPersonalizationLabel =>
      'Personalisierung überspringbar';

  @override
  String get skippableInitialPersonalizationDescription =>
      'Nutzer können Onboarding überspringen.';

  @override
  String get filePickingErrorMessage => 'Fehler beim Auswählen der Datei.';

  @override
  String get removeImage => 'Bild entfernen';

  @override
  String get clickToUploadImage => 'Klicken zum Hochladen';

  @override
  String get processingImage => 'Bild wird verarbeitet...';

  @override
  String get processingImageDescription => 'Bild wird optimiert.';

  @override
  String get chartMediaUploadsOverTime => 'Uploads im Zeitverlauf';

  @override
  String get chartMediaUploadsByPurpose => 'Uploads nach Zweck';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'Erfolg vs. Fehler';

  @override
  String get kpiMediaTotalUploads => 'Gesamt Uploads';

  @override
  String get kpiMediaFailedUploads => 'Fehlgeschlagene Uploads';

  @override
  String get kpiMediaAverageUploadTime => 'Durchschn. Upload-Zeit (s)';

  @override
  String get updateHeadlineTitle => 'Schlagzeile aktualisieren';

  @override
  String get updateHeadlineMessage =>
      'Veröffentlichen oder als Entwurf speichern?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'Upload gestartet';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'Trackt Start des Uploads.';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'Upload abgeschlossen';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'Trackt erfolgreichen Upload.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'Upload fehlgeschlagen';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'Trackt Upload-Fehler.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get aboutOverviewPageTitle => 'Über die Übersicht';

  @override
  String get aboutOverviewPageDescription =>
      'Wichtige Metriken, periodisch aktualisiert.';

  @override
  String get audience => 'Publikum';

  @override
  String get content => 'Inhalt';

  @override
  String get community => 'Community';

  @override
  String get monetization => 'Monetarisierung';

  @override
  String get configuration => 'Konfiguration';

  @override
  String get loadingConfiguration => 'Konfiguration laden...';

  @override
  String get noConfigurationDataHeadline => 'Keine Konfig-Daten';

  @override
  String get noConfigurationDataSubheadline =>
      'Remote-Konfig konnte nicht geladen werden.';

  @override
  String get readOnlyConfigurationView => 'Nur-Lese-Konfiguration';

  @override
  String get readOnlyConfigurationViewDescription =>
      'Echtzeit-Snapshot der Einstellungen.';

  @override
  String get providers => 'Anbieter';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get about => 'Über';

  @override
  String get localizationConfigDescription =>
      'Unterstützte Sprachen und Fallback.';

  @override
  String get enabledLanguagesLabel => 'Aktivierte Sprachen';

  @override
  String get cannotDisableDefaultLanguage =>
      'Standardsprache kann nicht deaktiviert werden.';

  @override
  String get atLeastOneLanguageRequired =>
      'Mindestens eine Sprache muss aktiv sein.';

  @override
  String get defaultLanguageLabel => 'Standardsprache';

  @override
  String get defaultLanguageDescription =>
      'Fallback-Sprache bei fehlender Übersetzung.';

  @override
  String get localizationTitle => 'Lokalisierung';

  @override
  String get localizationDescription =>
      'Aktive Sprachen für App und Dashboard steuern.';

  @override
  String defaultLanguageRequired(String language) {
    return 'Standardsprache ($language) ist erforderlich.';
  }

  @override
  String get languageNameEn => 'Englisch';

  @override
  String get languageNameEs => 'Spanisch';

  @override
  String get languageNameFr => 'Französisch';

  @override
  String get languageNameAr => 'Arabisch';

  @override
  String get languageNamePt => 'Portugiesisch';

  @override
  String get languageNameDe => 'Deutsch';

  @override
  String get languageNameIt => 'Italienisch';

  @override
  String get languageNameZh => 'Chinesisch';

  @override
  String get languageNameHi => 'Hindi';

  @override
  String get languageNameJa => 'Japanisch';
}
