// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Accès au Tableau de Bord';

  @override
  String get authenticationPageSubheadline =>
      'Connexion sécurisée pour les administrateurs.';

  @override
  String get authenticationEmailSignInButton => 'Se connecter par Email';

  @override
  String get emailSignInPageTitle => 'Connexion Sécurisée';

  @override
  String get requestCodePageHeadline => 'Connexion par Email';

  @override
  String get requestCodePageSubheadline =>
      'Entrez votre email pour recevoir un code.';

  @override
  String get requestCodeEmailLabel => 'Email';

  @override
  String get requestCodeEmailHint => 'votre.email@exemple.com';

  @override
  String get accountLinkingEmailValidationError =>
      'Veuillez entrer un email valide.';

  @override
  String get requestCodeSendCodeButton => 'Envoyer le Code';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Vérifier le Code';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'Vérifiez votre boîte de réception et entrez le code.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'En mode démo, utilisez : $code';
  }

  @override
  String get emailCodeVerificationHint => 'Code à 6 chiffres';

  @override
  String get emailCodeValidationEmptyError => 'Le code ne peut pas être vide.';

  @override
  String get emailCodeValidationLengthError =>
      'Le code doit comporter 6 chiffres.';

  @override
  String get emailCodeVerificationButtonLabel => 'Vérifier le Code';

  @override
  String get overview => 'Aperçu';

  @override
  String get contentManagement => 'Gestion du Contenu';

  @override
  String get contentManagementPageDescription =>
      'Gérez les titres, les sujets et les sources.';

  @override
  String get headlines => 'Titres';

  @override
  String get headline => 'Titre';

  @override
  String get topics => 'Sujets';

  @override
  String get topic => 'Sujet';

  @override
  String get sources => 'Sources';

  @override
  String get source => 'Source';

  @override
  String get appConfiguration => 'Config. à Distance';

  @override
  String get appConfigurationPageDescription =>
      'Paramètres globaux de l\'application mobile.';

  @override
  String get settings => 'Paramètres';

  @override
  String get appConfigurationPageTitle => 'Configuration à Distance';

  @override
  String get feedTab => 'Flux';

  @override
  String get advertisementsTab => 'Publicités';

  @override
  String get systemTab => 'Système';

  @override
  String get userContentLimitsTitle => 'Limites de Contenu';

  @override
  String get userContentLimitsDescription =>
      'Limites de suivi et d\'enregistrement par niveau.';

  @override
  String get feedActionsTitle => 'Actions du Flux';

  @override
  String get feedActionsDescription =>
      'Fréquence des widgets d\'action dans le flux.';

  @override
  String get feedDecoratorsTitle => 'Décorateurs de Flux';

  @override
  String get feedDecoratorsDescription =>
      'Configuration de la présentation visuelle par rôle.';

  @override
  String get adSettingsTitle => 'Paramètres Publicitaires';

  @override
  String get adSettingsDescription =>
      'Gérez la fréquence et l\'emplacement des publicités.';

  @override
  String get maintenanceModeTitle => 'Mode Maintenance';

  @override
  String get maintenanceModeDescription =>
      'Activer l\'écran de maintenance global.';

  @override
  String get forceUpdateTitle => 'Mise à Jour Forcée';

  @override
  String get forceUpdateDescription =>
      'Configurez les mises à jour obligatoires.';

  @override
  String get forceUpdateTab => 'Mise à Jour';

  @override
  String get appConfigSaveSuccessMessage =>
      'Configuration enregistrée avec succès.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Erreur : $errorMessage';
  }

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get loadingConfigurationHeadline => 'Chargement de la Configuration';

  @override
  String get loadingConfigurationSubheadline => 'Veuillez patienter...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Échec du chargement de la configuration.';

  @override
  String get loadAppSettingsSubheadline =>
      'Charger les paramètres depuis le backend.';

  @override
  String get discardChangesButton => 'Abandonner les Changements';

  @override
  String get saveChangesButton => 'Enregistrer les Changements';

  @override
  String get confirmConfigUpdateDialogTitle => 'Confirmer la Mise à Jour';

  @override
  String get confirmConfigUpdateDialogContent =>
      'Appliquer les changements à l\'application ?';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get confirmSaveButton => 'Confirmer l\'Enregistrement';

  @override
  String get guestUserTab => 'Invité';

  @override
  String get authenticatedUserTab => 'Authentifié';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Limite de Suivi (Invité)';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Nombre max. de sujets ou sources suivis.';

  @override
  String get guestSavedHeadlinesLimitLabel =>
      'Limite d\'Enregistrement (Invité)';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Nombre max. de titres enregistrés.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'Limite de Suivi (Standard)';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Limite pour les utilisateurs standard.';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Limite d\'Enregistrement (Standard)';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Limite pour les utilisateurs standard.';

  @override
  String get premiumFollowedItemsLimitLabel => 'Limite de Suivi (Premium)';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Limite pour les utilisateurs premium.';

  @override
  String get premiumSavedHeadlinesLimitLabel =>
      'Limite d\'Enregistrement (Premium)';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Limite pour les utilisateurs premium.';

  @override
  String get standardUserAdTab => 'Utilisateur Standard';

  @override
  String get guestAdFrequencyLabel => 'Fréquence Pub (Invité)';

  @override
  String get guestAdFrequencyDescription =>
      'Publicités tous les X éléments du flux.';

  @override
  String get guestAdPlacementIntervalLabel => 'Intervalle Initial (Invité)';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Éléments avant la première publicité.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Articles avant Interstitiel';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Lectures avant publicité.';

  @override
  String get standardUserAdFrequencyLabel => 'Fréquence (Standard)';

  @override
  String get standardUserAdFrequencyDescription =>
      'Fréquence pour les utilisateurs standard.';

  @override
  String get standardUserAdPlacementIntervalLabel => 'Intervalle (Standard)';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Intervalle pour standard.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Articles (Standard)';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Lectures pour standard.';

  @override
  String get premiumAdFrequencyLabel => 'Fréquence (Premium)';

  @override
  String get premiumAdFrequencyDescription =>
      'Fréquence pour premium (0 = pas de pub).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Intervalle (Premium)';

  @override
  String get premiumAdPlacementIntervalDescription =>
      'Intervalle pour premium.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Articles (Premium)';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Lectures pour premium.';

  @override
  String get appOperationalStatusWarning =>
      'ATTENTION : Affecte tous les utilisateurs.';

  @override
  String get appOperationalStatusLabel => 'État Opérationnel';

  @override
  String get appOperationalStatusDescription =>
      'État actuel (actif, maintenance).';

  @override
  String get maintenanceMessageLabel => 'Message de Maintenance';

  @override
  String get maintenanceMessageDescription => 'Message affiché en maintenance.';

  @override
  String get disabledMessageLabel => 'Message de Désactivation';

  @override
  String get disabledMessageDescription => 'Message si l\'app est désactivée.';

  @override
  String get forceUpdateConfigurationTitle => 'Configuration de Mise à Jour';

  @override
  String get minAllowedAppVersionLabel => 'Version Minimale Autorisée';

  @override
  String get minAllowedAppVersionDescription =>
      'Version la plus basse autorisée (ex. 1.2.0).';

  @override
  String get latestAppVersionLabel => 'Dernière Version';

  @override
  String get latestAppVersionDescription =>
      'Version la plus récente (ex. 1.5.0).';

  @override
  String get updateRequiredMessageLabel => 'Message de Mise à Jour Obligatoire';

  @override
  String get updateRequiredMessageDescription =>
      'Message pour forcer la mise à jour.';

  @override
  String get updateOptionalMessageLabel => 'Message de Mise à Jour Facultative';

  @override
  String get updateOptionalMessageDescription =>
      'Message pour mise à jour facultative.';

  @override
  String get iosStoreUrlLabel => 'URL App Store (iOS)';

  @override
  String get iosStoreUrlDescription => 'Lien vers la boutique Apple.';

  @override
  String get androidStoreUrlLabel => 'URL Play Store (Android)';

  @override
  String get androidUpdateUrlDescription => 'Lien vers la boutique Google.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'Jours entre Invites (Invité)';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Jours minimum entre les invites.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Jours entre Invites (Standard)';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Jours pour standard.';

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get settingsSavedSuccessfully => 'Paramètres enregistrés !';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Erreur d\'enregistrement : $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Chargement des Paramètres';

  @override
  String get loadingSettingsSubheadline => 'Veuillez patienter...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Échec du chargement : $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Thème de Base';

  @override
  String get baseThemeDescription => 'Apparence claire ou sombre.';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Par Défaut du Système';

  @override
  String get accentThemeLabel => 'Couleur d\'Accentuation';

  @override
  String get accentThemeDescription =>
      'Couleur principale des éléments interactifs.';

  @override
  String get defaultBlueTheme => 'Bleu par Défaut';

  @override
  String get newsRedTheme => 'Rouge Actualités';

  @override
  String get graphiteGrayTheme => 'Gris Graphite';

  @override
  String get fontFamilyLabel => 'Police';

  @override
  String get fontFamilyDescription => 'Typographie de l\'application.';

  @override
  String get systemDefaultFont => 'Par Défaut';

  @override
  String get textScaleFactorLabel => 'Taille du Texte';

  @override
  String get textScaleFactorDescription => 'Ajuste la taille de la police.';

  @override
  String get smallText => 'Petit';

  @override
  String get mediumText => 'Moyen';

  @override
  String get largeText => 'Grand';

  @override
  String get extraLargeText => 'Très Grand';

  @override
  String get fontWeightLabel => 'Épaisseur de Police';

  @override
  String get fontWeightDescription => 'Épaisseur du texte.';

  @override
  String get lightFontWeight => 'Léger';

  @override
  String get regularFontWeight => 'Régulier';

  @override
  String get boldFontWeight => 'Gras';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageDescription => 'Sélectionnez la langue du panel.';

  @override
  String get edit => 'Modifier';

  @override
  String get englishLanguage => 'Anglais';

  @override
  String get arabicLanguage => 'Arabe';

  @override
  String get appearanceSettingsLabel => 'Apparence';

  @override
  String get languageSettingsLabel => 'Langue';

  @override
  String get themeSettingsLabel => 'Réglages du Thème';

  @override
  String get fontSettingsLabel => 'Réglages de Police';

  @override
  String get settingsPageDescription =>
      'Configurez vos préférences visuelles et linguistiques.';

  @override
  String get appearanceSettingsDescription =>
      'Ajustez le thème, les couleurs et la typographie.';

  @override
  String get loadingHeadlines => 'Chargement des Titres';

  @override
  String get pleaseWait => 'Patientez...';

  @override
  String get noHeadlinesFound => 'Aucun titre trouvé.';

  @override
  String get headlineTitle => 'Titre';

  @override
  String get excerpt => 'Extrait';

  @override
  String get countryName => 'Pays';

  @override
  String get publishedAt => 'Publié le';

  @override
  String get actions => 'Actions';

  @override
  String get unknown => 'Inconnu';

  @override
  String get loadingTopics => 'Chargement des Sujets';

  @override
  String get noTopicsFound => 'Aucun sujet trouvé.';

  @override
  String get topicName => 'Sujet';

  @override
  String get description => 'Description';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'Chargement des Sources';

  @override
  String get noSourcesFound => 'Aucune source trouvée.';

  @override
  String get sourceName => 'Source';

  @override
  String get sourceType => 'Type';

  @override
  String get language => 'Langue';

  @override
  String get editTopic => 'Modifier le Sujet';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get loadingTopic => 'Chargement du Sujet';

  @override
  String get icon => 'Icône';

  @override
  String get topicUpdatedSuccessfully => 'Sujet mis à jour.';

  @override
  String get cannotUpdateTopicError =>
      'Erreur : Données originales non chargées.';

  @override
  String get createTopic => 'Créer un Sujet';

  @override
  String get topicCreatedSuccessfully => 'Sujet créé.';

  @override
  String get editSource => 'Modifier la Source';

  @override
  String get sourceUpdatedSuccessfully => 'Source mise à jour.';

  @override
  String get loadingSource => 'Chargement de la Source...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Siège Social';

  @override
  String get none => 'Aucun';

  @override
  String get cannotUpdateSourceError =>
      'Erreur : Données originales non chargées.';

  @override
  String get sourceTypeNewsAgency => 'Agence de Presse';

  @override
  String get sourceTypeLocalNewsOutlet => 'Média Local';

  @override
  String get sourceTypeNationalNewsOutlet => 'Média National';

  @override
  String get sourceTypeInternationalNewsOutlet => 'Média International';

  @override
  String get sourceTypeSpecializedPublisher => 'Éditeur Spécialisé';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Source Gouvernementale';

  @override
  String get sourceTypeAggregator => 'Agrégateur';

  @override
  String get sourceTypeOther => 'Autre';

  @override
  String get editHeadline => 'Modifier le Titre';

  @override
  String get headlineUpdatedSuccessfully => 'Titre mis à jour.';

  @override
  String get loadingHeadline => 'Chargement du Titre...';

  @override
  String get image => 'Image';

  @override
  String get cannotUpdateHeadlineError =>
      'Erreur : Données originales non chargées.';

  @override
  String get createHeadline => 'Créer un Titre';

  @override
  String get headlineCreatedSuccessfully => 'Titre créé.';

  @override
  String get loadingData => 'Chargement des données...';

  @override
  String get loadingFullList => 'Chargement de la liste...';

  @override
  String get createSource => 'Créer une Source';

  @override
  String get updateSourceTitle => 'Mettre à Jour la Source';

  @override
  String get updateSourceMessage =>
      'Publier les changements ou enregistrer en brouillon ?';

  @override
  String get sourceCreatedSuccessfully => 'Source créée.';

  @override
  String get updateTopicTitle => 'Mettre à Jour le Sujet';

  @override
  String get status => 'Statut';

  @override
  String get updateTopicMessage =>
      'Publier les changements ou enregistrer en brouillon ?';

  @override
  String get lastUpdated => 'Dernière Mise à Jour';

  @override
  String get contentStatusActive => 'Actif';

  @override
  String get contentStatusArchived => 'Archivé';

  @override
  String get contentStatusDraft => 'Brouillon';

  @override
  String get totalHeadlines => 'Total Titres';

  @override
  String get totalTopics => 'Total Sujets';

  @override
  String get totalSources => 'Total Sources';

  @override
  String get loadingOverview => 'Chargement de l\'Aperçu...';

  @override
  String get loadingOverviewSubheadline => 'Récupération des statistiques...';

  @override
  String get overviewLoadFailure => 'Échec du chargement de l\'aperçu.';

  @override
  String get recentHeadlines => 'Titres Récents';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get noRecentHeadlines => 'Aucun titre récent.';

  @override
  String get systemStatus => 'État du Système';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get createHeadlineAction => 'Créer un Titre';

  @override
  String get manageContentAction => 'Gérer le Contenu';

  @override
  String get appConfigAction => 'Config. App';

  @override
  String get appStatusActive => 'Actif';

  @override
  String get appStatusDisabled => 'Désactivé';

  @override
  String demoEmailHint(String email) {
    return 'Pour démo, utilisez : $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'Pour démo, utilisez : $code';
  }

  @override
  String get appStatusMaintenance => 'Maintenance';

  @override
  String get appStatusOperational => 'Opérationnel';

  @override
  String get isUnderMaintenanceLabel => 'En Maintenance';

  @override
  String get isUnderMaintenanceDescription => 'Active le mode maintenance.';

  @override
  String get isLatestVersionOnlyLabel => 'Forcer Dernière Version';

  @override
  String get isLatestVersionOnlyDescription =>
      'Oblige la mise à jour pour utiliser l\'app.';

  @override
  String get iosUpdateUrlLabel => 'URL Mise à Jour iOS';

  @override
  String get iosUpdateUrlDescription => 'Lien de mise à jour pour iOS.';

  @override
  String get androidUpdateUrlLabel => 'URL Mise à Jour Android';

  @override
  String get followedItemsLimitLabel => 'Limite de Suivi';

  @override
  String get followedItemsLimitDescription =>
      'Nombre max. d\'éléments suivis par rôle.';

  @override
  String get savedFeedFiltersLimitLabel => 'Limite de Filtres Enregistrés';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Nombre max. de filtres enregistrés.';

  @override
  String get adFrequencyLabel => 'Fréquence Publicitaire';

  @override
  String get adFrequencyDescription => 'Publicités tous les X éléments.';

  @override
  String get savedFeedFilterLimitsTitle => 'Limites de Filtres';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Configurez les limites de filtres par niveau.';

  @override
  String get adPlacementIntervalLabel => 'Intervalle Publicitaire';

  @override
  String get adPlacementIntervalDescription =>
      'Éléments avant la première publicité.';

  @override
  String get articlesBeforeInterstitialAdsLabel =>
      'Articles avant Interstitiel';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Lectures avant publicité.';

  @override
  String get daysSuffix => 'Jours';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Jours minimum avant l\'invite de $actionType.';
  }

  @override
  String get retryButtonText => 'Réessayer';

  @override
  String get feedActionTypeLinkAccount => 'Lier le Compte';

  @override
  String get feedActionTypeRateApp => 'Noter l\'App';

  @override
  String get feedActionTypeFollowTopics => 'Suivre des Sujets';

  @override
  String get feedActionTypeFollowSources => 'Suivre des Sources';

  @override
  String get feedActionTypeUpgrade => 'Améliorer le Plan';

  @override
  String get feedActionTypeEnableNotifications => 'Activer Notifications';

  @override
  String get countryPickerSearchLabel => 'Rechercher';

  @override
  String get countryPickerSearchHint => 'Tapez pour rechercher...';

  @override
  String get countryPickerSelectCountryLabel => 'Sélectionnez un pays';

  @override
  String get archivedHeadlines => 'Titres Archivés';

  @override
  String get loadingArchivedHeadlines => 'Chargement des Archivés';

  @override
  String get noArchivedHeadlinesFound => 'Aucun titre archivé.';

  @override
  String get restore => 'Restaurer';

  @override
  String get deleteForever => 'Supprimer Définitivement';

  @override
  String get archivedTopics => 'Sujets Archivés';

  @override
  String get loadingArchivedTopics => 'Chargement des Sujets Archivés';

  @override
  String get noArchivedTopicsFound => 'Aucun sujet archivé.';

  @override
  String get archivedSources => 'Sources Archivées';

  @override
  String get loadingArchivedSources => 'Chargement des Sources Archivées';

  @override
  String get noArchivedSourcesFound => 'Aucune source archivée.';

  @override
  String get archivedItems => 'Éléments Archivés';

  @override
  String get addNewItem => 'Ajouter Nouveau';

  @override
  String get archive => 'Archiver';

  @override
  String headlineDeleted(String title) {
    return 'Supprimé \'\'$title\'\'.';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get enabledLabel => 'Activé';

  @override
  String get itemsToDisplayLabel => 'Éléments à Afficher';

  @override
  String get itemsToDisplayDescription =>
      'Nombre d\'éléments dans ce décorateur.';

  @override
  String get roleSpecificSettingsTitle => 'Paramètres par Rôle';

  @override
  String get daysBetweenViewsLabel => 'Jours entre Affichages';

  @override
  String get daysBetweenViewsDescription =>
      'Jours minimum avant de répéter le décorateur.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Lier le Compte';

  @override
  String get feedDecoratorTypeUpgrade => 'Passer au Premium';

  @override
  String get feedDecoratorTypeRateApp => 'Noter l\'App';

  @override
  String get feedDecoratorTypeEnableNotifications => 'Activer Notifications';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Sujets Suggérés';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Sources Suggérées';

  @override
  String get guestUserRole => 'Invité';

  @override
  String get standardUserRole => 'Utilisateur Standard';

  @override
  String get premiumUserRole => 'Utilisateur Premium';

  @override
  String get dashboardTitle => 'Tableau de Bord';

  @override
  String get clearSelection => 'Effacer la Sélection';

  @override
  String get search => 'Rechercher';

  @override
  String get noResultsFound => 'Aucun résultat.';

  @override
  String get close => 'Fermer';

  @override
  String get apply => 'Appliquer';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visible pour $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Plateforme Publicitaire';

  @override
  String get primaryAdPlatformTitle => 'Plateforme Principale';

  @override
  String get primaryAdPlatformDescription =>
      'Fournisseur principal de publicités.';

  @override
  String get adUnitIdentifiersTitle => 'IDs d\'Unités Publicitaires';

  @override
  String get adUnitIdentifiersDescription =>
      'Configurez les IDs par plateforme.';

  @override
  String get feedAdSettingsTitle => 'Publicités dans le Flux';

  @override
  String get enableFeedAdsLabel => 'Activer Pubs dans le Flux';

  @override
  String get feedAdTypeSelectionTitle => 'Type de Pub dans le Flux';

  @override
  String get feedAdTypeSelectionDescription => 'Natif ou Bannière.';

  @override
  String get userRoleFrequencySettingsTitle => 'Fréquence par Rôle';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Configurez les intervalles par rôle.';

  @override
  String get articleAdSettingsTitle => 'Publicités dans les Articles';

  @override
  String get enableArticleAdsLabel => 'Activer Pubs dans les Articles';

  @override
  String get defaultInArticleAdTypeSelectionTitle => 'Type de Pub par Défaut';

  @override
  String get defaultInArticleAdTypeSelectionDescription => 'Natif ou Bannière.';

  @override
  String get inArticleAdSlotPlacementsTitle => 'Emplacements dans l\'Article';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'Activez des emplacements spécifiques.';

  @override
  String get feedNativeAdIdLabel => 'ID Pub Native (Flux)';

  @override
  String get feedNativeAdIdDescription => 'ID pour les publicités natives.';

  @override
  String get feedBannerAdIdLabel => 'ID Bannière (Flux)';

  @override
  String get feedBannerAdIdDescription => 'ID pour les bannières.';

  @override
  String get articleInterstitialAdIdLabel => 'ID Interstitiel (Article)';

  @override
  String get articleInterstitialAdIdDescription => 'ID pour les interstitiels.';

  @override
  String get inArticleNativeAdIdLabel => 'ID Natif (Dans l\'Article)';

  @override
  String get inArticleNativeAdIdDescription => 'ID pour les natifs internes.';

  @override
  String get inArticleBannerAdIdLabel => 'ID Bannière (Dans l\'Article)';

  @override
  String get inArticleBannerAdIdDescription =>
      'ID pour les bannières internes.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Au-dessus de \'Lire la suite\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'En dessous de \'Lire la suite\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' copié.';
  }

  @override
  String get copyId => 'Copier l\'ID';

  @override
  String get enableGlobalAdsLabel => 'Activer la Publicité';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'ID Interstitiel (Navigation)';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'ID lors de l\'ouverture d\'articles.';

  @override
  String get interstitialAdSettingsTitle => 'Réglages des Interstitiels';

  @override
  String get enableInterstitialAdsLabel => 'Activer les Interstitiels';

  @override
  String get userRoleInterstitialFrequencyTitle => 'Fréquence par Rôle';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Transitions avant publicité.';

  @override
  String get transitionsBeforeInterstitialAdsLabel => 'Transitions pour Pub';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'Nombre de transitions.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Natives';

  @override
  String get bannerAdsTab => 'Bannières';

  @override
  String get interstitialAdsTab => 'Interstitiels';

  @override
  String get videoAdsTab => 'Vidéo';

  @override
  String get bannerAdType => 'Bannière';

  @override
  String get nativeAdType => 'Natif';

  @override
  String get interstitialAdType => 'Interstitiel';

  @override
  String get videoAdType => 'Vidéo';

  @override
  String get rewardedAdType => 'Récompensée';

  @override
  String get bannerAdShapeSelectionTitle => 'Forme de la Bannière';

  @override
  String get bannerAdShapeSelectionDescription => 'Carrée ou Rectangulaire.';

  @override
  String get bannerAdShapeSquare => 'Carré';

  @override
  String get bannerAdShapeRectangle => 'Rectangle';

  @override
  String get loadingDraftHeadlines => 'Chargement des Brouillons';

  @override
  String get noDraftHeadlinesFound => 'Aucun brouillon.';

  @override
  String get publish => 'Publier';

  @override
  String get saveAsDraft => 'Enregistrer Brouillon';

  @override
  String get invalidFormTitle => 'Formulaire Invalide';

  @override
  String get invalidFormMessage => 'Veuillez remplir les champs obligatoires.';

  @override
  String get completeForm => 'Compléter';

  @override
  String get discard => 'Abandonner';

  @override
  String get drafts => 'Brouillons';

  @override
  String get draftsIconTooltip => 'Brouillons';

  @override
  String get draftHeadlines => 'Titres en Brouillon';

  @override
  String get draftTopics => 'Sujets en Brouillon';

  @override
  String get draftSources => 'Sources en Brouillon';

  @override
  String get saveHeadlineTitle => 'Enregistrer le Titre';

  @override
  String get saveHeadlineMessage => 'Publier ou enregistrer en brouillon ?';

  @override
  String get saveTopicTitle => 'Enregistrer le Sujet';

  @override
  String get saveTopicMessage => 'Publier ou enregistrer en brouillon ?';

  @override
  String get saveSourceTitle => 'Enregistrer la Source';

  @override
  String get saveSourceMessage => 'Publier ou enregistrer en brouillon ?';

  @override
  String get loadingDraftTopics => 'Chargement des Sujets...';

  @override
  String get noDraftTopicsFound => 'Aucun sujet en brouillon.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Sujet \"$topicTitle\" supprimé.';
  }

  @override
  String get loadingDraftSources => 'Chargement des Sources...';

  @override
  String get noDraftSourcesFound => 'Aucune source en brouillon.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Source \"$sourceName\" supprimée.';
  }

  @override
  String get publishTopic => 'Publier le Sujet';

  @override
  String get publishSource => 'Publier la Source';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Activer Pubs Articles pour $role';
  }

  @override
  String get moreActions => 'Plus d\'Actions';

  @override
  String get filter => 'Filtrer';

  @override
  String get applyFilters => 'Appliquer Filtres';

  @override
  String get filterHeadlines => 'Filtrer les Titres';

  @override
  String get filterTopics => 'Filtrer les Sujets';

  @override
  String get filterSources => 'Filtrer les Sources';

  @override
  String get searchByHeadlineTitle => 'Rechercher par titre...';

  @override
  String get searchByTopicName => 'Rechercher par nom ou ID...';

  @override
  String get searchBySourceName => 'Rechercher par nom ou ID...';

  @override
  String get selectSources => 'Sélectionner Sources';

  @override
  String get selectTopics => 'Sélectionner Sujets';

  @override
  String get countries => 'Pays';

  @override
  String get selectCountries => 'Sélectionner Pays';

  @override
  String get selectSourceTypes => 'Types de Source';

  @override
  String get selectLanguages => 'Langues';

  @override
  String get selectHeadquarters => 'Sièges Sociaux';

  @override
  String get resetFiltersButtonText => 'Réinitialiser Filtres';

  @override
  String get noResultsWithCurrentFilters => 'Aucun résultat avec ces filtres.';

  @override
  String get aboutIconTooltip => 'À propos de cette page';

  @override
  String get closeButtonText => 'Fermer';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => 'Gestion des Utilisateurs';

  @override
  String get userManagementPageDescription =>
      'Gérez les utilisateurs, rôles et permissions.';

  @override
  String get loadingUsers => 'Chargement des Utilisateurs';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé.';

  @override
  String get email => 'Email';

  @override
  String get appRole => 'Rôle App';

  @override
  String get dashboardRole => 'Rôle Panel';

  @override
  String get createdAt => 'Créé le';

  @override
  String get promoteToPublisher => 'Promouvoir Éditeur';

  @override
  String get demoteToUser => 'Rétrograder Utilisateur';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Éditeur';

  @override
  String get filterUsers => 'Filtrer Utilisateurs';

  @override
  String get searchByUserEmail => 'Rechercher par email ou ID...';

  @override
  String get selectAppRoles => 'Rôles App';

  @override
  String get selectDashboardRoles => 'Rôles Panel';

  @override
  String get authentication => 'Authentification';

  @override
  String get subscription => 'Abonnement';

  @override
  String get authenticationAnonymous => 'Anonyme';

  @override
  String get authenticationAuthenticated => 'Authentifié';

  @override
  String get subscriptionFree => 'Gratuit';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle => 'Limites de Filtres de Titres';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Limites de filtres, épinglés et notifications.';

  @override
  String get totalLimitLabel => 'Limite Totale';

  @override
  String get totalLimitDescription => 'Total de filtres autorisés.';

  @override
  String get pinnedLimitLabel => 'Limite d\'Épinglés';

  @override
  String get pinnedLimitDescription => 'Nombre max. de filtres épinglés.';

  @override
  String get notificationSubscriptionLimitLabel => 'Limite de Notifications';

  @override
  String get notificationSubscriptionLimitDescription =>
      'Nombre max. d\'abonnements.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Dernière Minute';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Résumé Hebdo';

  @override
  String get isBreakingNewsLabel => 'Marquer comme Dernière Minute';

  @override
  String get isBreakingNewsDescription =>
      'Envoie une notification push immédiate.';

  @override
  String get isBreakingNewsDescriptionEdit =>
      'N\'enverra pas de push lors de l\'édition.';

  @override
  String get confirmBreakingNewsTitle => 'Confirmer Dernière Minute';

  @override
  String get confirmBreakingNewsMessage =>
      'Envoyer une notification push à tous ?';

  @override
  String get confirmPublishButton => 'Confirmer et Publier';

  @override
  String get cannotDraftBreakingNews =>
      'Impossible d\'enregistrer en brouillon.';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => 'Dernière Minute';

  @override
  String get breakingNewsFilterAll => 'Tous';

  @override
  String get breakingNewsFilterBreakingOnly => 'Dernière Minute Uniquement';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Sans Dernière Minute';

  @override
  String get notificationsTab => 'Notifications';

  @override
  String get pushNotificationSettingsTitle => 'Réglages Notifications';

  @override
  String get pushNotificationSettingsDescription =>
      'Gestion globale des notifications.';

  @override
  String get pushNotificationSystemStatusTitle => 'Activer Notifications';

  @override
  String get pushNotificationSystemStatusDescription => 'Interrupteur global.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Fournisseur Principal';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Firebase ou OneSignal.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Types d\'Envoi';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Activez des types spécifiques.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'Général';

  @override
  String get featuresTab => 'Fonctions';

  @override
  String get limitsTab => 'Limites';

  @override
  String get maintenanceConfigTitle => 'Mode Maintenance';

  @override
  String get maintenanceConfigDescription => 'Active le mode maintenance.';

  @override
  String get updateConfigTitle => 'Réglages Mise à Jour';

  @override
  String get updateConfigDescription =>
      'Configurez les mises à jour obligatoires.';

  @override
  String get generalAppConfigTitle => 'Réglages Généraux';

  @override
  String get generalAppConfigDescription =>
      'Conditions et Politique de Confidentialité.';

  @override
  String get termsOfServiceUrlLabel => 'URL Conditions d\'Utilisation';

  @override
  String get termsOfServiceUrlDescription => 'Lien vers les conditions.';

  @override
  String get privacyPolicyUrlLabel => 'URL Politique de Confidentialité';

  @override
  String get privacyPolicyUrlDescription => 'Lien vers la politique.';

  @override
  String get navigationAdConfigTitle => 'Pubs de Navigation';

  @override
  String get enableNavigationAdsLabel => 'Activer Pubs de Navigation';

  @override
  String get navigationAdFrequencyTitle => 'Fréquence de Navigation';

  @override
  String get navigationAdFrequencyDescription => 'Transitions avant publicité.';

  @override
  String get internalNavigationsBeforeAdLabel => 'Navigations Internes';

  @override
  String get internalNavigationsBeforeAdDescription => 'Pages avant publicité.';

  @override
  String get externalNavigationsBeforeAdLabel => 'Navigations Externes';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'Sorties avant publicité.';

  @override
  String get nativeAdIdLabel => 'ID Pub Native';

  @override
  String get nativeAdIdDescription => 'ID pour les publicités natives.';

  @override
  String get bannerAdIdLabel => 'ID Bannière';

  @override
  String get bannerAdIdDescription => 'ID pour les bannières.';

  @override
  String get interstitialAdIdLabel => 'ID Interstitiel';

  @override
  String get interstitialAdIdDescription => 'ID pour les interstitiels.';

  @override
  String get savedHeadlinesLimitLabel => 'Limite d\'Enregistrement';

  @override
  String get savedHeadlinesLimitDescription =>
      'Nombre max. de titres enregistrés.';

  @override
  String get appUpdateManagementTitle => 'Gestion des Mises à Jour';

  @override
  String get feedItemClickBehaviorTitle => 'Comportement au Clic';

  @override
  String get feedItemClickBehaviorDescription =>
      'Navigateur interne ou système.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'Navigateur In-App';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'Navigateur Système';

  @override
  String get userLimitsTitle => 'Limites Utilisateur';

  @override
  String get userLimitsDescription => 'Définissez les limites par fonction.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Contrôle de l\'état et des mises à jour.';

  @override
  String get advertisementsDescription => 'Gestion globale de la publicité.';

  @override
  String get notificationsDescription =>
      'Configuration des notifications push.';

  @override
  String get feedDescription => 'Contrôle du comportement du flux.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Limite pour les alertes immédiates.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Limite pour le résumé hebdo.';

  @override
  String get appStatusAndUpdatesTitle => 'État et Mises à Jour';

  @override
  String get enableForcedUpdatesLabel => 'Activer Mises à Jour Forcées';

  @override
  String get enableForcedUpdatesDescription =>
      'Permet d\'exiger une version minimale.';

  @override
  String get appUrlsTitle => 'URLs de l\'Application';

  @override
  String get appUrlsDescription => 'Gérez les liens internes et externes.';

  @override
  String get communityAndEngagementTitle => 'Communauté et Engagement';

  @override
  String get communityAndEngagementDescription =>
      'Configurez les commentaires et rapports.';

  @override
  String get userEngagementTitle => 'Engagement Utilisateur';

  @override
  String get userEngagementDescription =>
      'Configurez les réactions et commentaires.';

  @override
  String get contentReportingTitle => 'Signalement de Contenu';

  @override
  String get contentReportingDescription => 'Règles pour signaler du contenu.';

  @override
  String get appReviewFunnelTitle => 'Avis sur l\'App';

  @override
  String get appReviewFunnelDescription =>
      'Gestion de la satisfaction et des avis.';

  @override
  String get enableEngagementFeaturesLabel => 'Activer l\'Engagement';

  @override
  String get enableEngagementFeaturesDescription =>
      'Active les réactions et commentaires.';

  @override
  String get engagementModeLabel => 'Mode d\'Engagement';

  @override
  String get engagementModeDescription =>
      'Réactions uniquement ou aussi commentaires.';

  @override
  String get engagementModeReactionsOnly => 'Réactions Uniquement';

  @override
  String get engagementModeReactionsAndComments => 'Réactions et Commentaires';

  @override
  String get enableReportingSystemLabel => 'Activer le Système de Signalement';

  @override
  String get enableReportingSystemDescription =>
      'Active les options de signalement.';

  @override
  String get enableHeadlineReportingLabel => 'Signalement de Titres';

  @override
  String get enableSourceReportingLabel => 'Signalement de Sources';

  @override
  String get enableCommentReportingLabel => 'Signalement de Commentaires';

  @override
  String get enableAppFeedbackSystemLabel => 'Activer Feedback Interne';

  @override
  String get enableAppFeedbackSystemDescription =>
      'Demande si l\'utilisateur aime l\'app.';

  @override
  String get interactionCycleThresholdLabel => 'Seuil d\'Interaction';

  @override
  String get interactionCycleThresholdDescription =>
      'Actions positives pour l\'invite.';

  @override
  String get initialPromptCooldownLabel => 'Délai Initial (Jours)';

  @override
  String get initialPromptCooldownDescription =>
      'Attente avant la première invite.';

  @override
  String get requestStoreReviewLabel => 'Demander Avis en Boutique';

  @override
  String get requestStoreReviewDescription =>
      'Si \'Oui\', demander un avis officiel.';

  @override
  String get requestWrittenFeedbackLabel => 'Demander Feedback Écrit';

  @override
  String get requestWrittenFeedbackDescription =>
      'Si \'Non\', demander le motif.';

  @override
  String get internalPromptLogicTitle => 'Logique d\'Invite';

  @override
  String get eligiblePositiveInteractionsTitle => 'Interactions Positives';

  @override
  String get positiveInteractionTypeSaveItem => 'Enregistrer du contenu';

  @override
  String get positiveInteractionTypeFollowItem => 'Suivre une entité';

  @override
  String get positiveInteractionTypeShareContent => 'Share a content item';

  @override
  String get positiveInteractionTypeSaveFilter => 'Créer un filtre enregistré';

  @override
  String get followUpActionsTitle => 'Actions de Suivi';

  @override
  String get enableCommunityFeaturesLabel => 'Activer Fonctions Communauté';

  @override
  String get enableCommunityFeaturesDescription =>
      'Active l\'engagement et les rapports.';

  @override
  String get communityManagementPageDescription =>
      'Gérez les commentaires, rapports et avis.';

  @override
  String get engagements => 'Engagements';

  @override
  String get reports => 'Rapports';

  @override
  String get appReviews => 'Avis App';

  @override
  String get user => 'Utilisateur';

  @override
  String get engagedContent => 'Contenu';

  @override
  String get reaction => 'Réaction';

  @override
  String get comment => 'Commentaire';

  @override
  String get commentStatus => 'État du Commentaire';

  @override
  String get hasCommentFilterLabel => 'Contient Commentaire';

  @override
  String get hasCommentFilterDescription => 'Uniquement avec texte.';

  @override
  String get date => 'Date';

  @override
  String get approveComment => 'Approuver Commentaire';

  @override
  String get rejectComment => 'Rejeter Commentaire';

  @override
  String get viewEngagedContent => 'Voir Contenu';

  @override
  String get copyUserId => 'Copier ID Utilisateur';

  @override
  String get reporter => 'Informateur';

  @override
  String get reportedItem => 'Élément Signalé';

  @override
  String get reason => 'Motif';

  @override
  String get reportStatus => 'État du Rapport';

  @override
  String get viewReportedItem => 'Voir Élément';

  @override
  String get markAsInReview => 'Marquer en Révision';

  @override
  String get resolveReport => 'Résoudre Rapport';

  @override
  String get initialFeedback => 'Feedback Initial';

  @override
  String get osPromptRequested => 'Invite OS ?';

  @override
  String get feedbackHistory => 'Historique';

  @override
  String get lastInteraction => 'Dernière Interaction';

  @override
  String get viewFeedbackHistory => 'Voir Historique';

  @override
  String get reactionTypeLike => 'J\'aime';

  @override
  String get reactionTypeInsightful => 'Pertinent';

  @override
  String get reactionTypeAmusing => 'Amusant';

  @override
  String get reactionTypeSad => 'Triste';

  @override
  String get reactionTypeAngry => 'En colère';

  @override
  String get reactionTypeSkeptical => 'Sceptique';

  @override
  String get initialAppReviewFeedbackPositive => 'Positif';

  @override
  String get initialAppReviewFeedbackNegative => 'Négatif';

  @override
  String get filterCommunity => 'Filtrer Communauté';

  @override
  String get searchByEngagementUser => 'Rechercher par email...';

  @override
  String get searchByReportReporter => 'Rechercher par informateur...';

  @override
  String get searchByAppReviewUser => 'Rechercher par email...';

  @override
  String get selectCommentStatus => 'État du Commentaire';

  @override
  String get selectReportStatus => 'État du Rapport';

  @override
  String get selectInitialFeedback => 'Feedback Initial';

  @override
  String get selectReportableEntity => 'Type d\'Élément';

  @override
  String get reportableEntityHeadline => 'Titre';

  @override
  String get reportableEntitySource => 'Source';

  @override
  String get reportableEntityComment => 'Commentaire';

  @override
  String get noEngagementsFound => 'Aucun engagement.';

  @override
  String get noReportsFound => 'Aucun rapport.';

  @override
  String get noAppReviewsFound => 'Aucun avis.';

  @override
  String get loadingEngagements => 'Chargement Engagements';

  @override
  String get loadingReports => 'Chargement Rapports';

  @override
  String get loadingAppReviews => 'Chargement Avis';

  @override
  String get userIdCopied => 'ID utilisateur copié.';

  @override
  String get reportStatusUpdated => 'État mis à jour.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Historique de $email';
  }

  @override
  String get noFeedbackHistory => 'Aucun historique disponible.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback le : $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Motif : $reason';
  }

  @override
  String get noReasonProvided => 'Aucun motif fourni.';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Désinformation / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Titre Clickbait';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Offensant / Haine';

  @override
  String get reportReasonSpamOrScam => 'Spam / Arnaque';

  @override
  String get reportReasonBrokenLink => 'Lien Mort';

  @override
  String get reportReasonPaywalled => 'Paywall';

  @override
  String get reportReasonLowQualityJournalism => 'Basse Qualité';

  @override
  String get reportReasonHighAdDensity => 'Excès de Pub';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Source Gouvernementale';

  @override
  String get reportReasonAggregator => 'Agrégateur';

  @override
  String get reportReasonOther => 'Autre';

  @override
  String get reportReasonFrequentPaywalls => 'Paywalls Fréquents';

  @override
  String get reportReasonImpersonation => 'Usurpation';

  @override
  String get noNegativeFeedbackHistory => 'Aucun feedback négatif.';

  @override
  String get reject => 'Rejeter';

  @override
  String get commentStatusFlaggedByAi => 'Marqué par IA';

  @override
  String get cancel => 'Annuler';

  @override
  String get rejectCommentConfirmation =>
      'Supprimer définitivement ce commentaire ?';

  @override
  String get searchByUserId => 'Rechercher par ID...';

  @override
  String get viewReportedHeadline => 'Voir Titre';

  @override
  String get viewReportedSource => 'Voir Source';

  @override
  String get viewReportedComment => 'Voir Commentaire';

  @override
  String get entityType => 'Type d\'Entité';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Détails du Feedback';

  @override
  String get moderationStatusPendingReview => 'En Attente';

  @override
  String get moderationStatusResolved => 'Résolu';

  @override
  String get hasComment => 'A un Commentaire';

  @override
  String get any => 'Tous';

  @override
  String get withComment => 'Avec Commentaire';

  @override
  String get withoutComment => 'Sans Commentaire';

  @override
  String get reportResolved => 'Rapport résolu.';

  @override
  String get commentApproved => 'Commentaire approuvé.';

  @override
  String get commentRejected => 'Commentaire rejeté.';

  @override
  String get copyHeadlineId => 'Copiar ID de Titre';

  @override
  String get copyReportedItemId => 'Copier ID Élément';

  @override
  String get viewFeedbackDetails => 'Voir Détails';

  @override
  String get reportDetails => 'Détails du Rapport';

  @override
  String get commentDetails => 'Détails du Commentaire';

  @override
  String get communityManagement => 'Gestion Communauté';

  @override
  String get navContent => 'Contenu';

  @override
  String get navUsers => 'Utilisateurs';

  @override
  String get navCommunity => 'Communauté';

  @override
  String get confirmPromotionTitle => 'Confirmer Promotion';

  @override
  String confirmPromotionMessage(String email) {
    return 'Promouvoir $email en tant qu\'Éditeur ?';
  }

  @override
  String get confirmDemotionTitle => 'Confirmer Rétrogradation';

  @override
  String confirmDemotionMessage(String email) {
    return 'Rétrograder $email en utilisateur standard ?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Éditeur';

  @override
  String get breakingNewsHint => 'Titre de dernière minute';

  @override
  String get breakingNewsFilterDescription =>
      'Uniquement actualités de dernière minute';

  @override
  String publishItemTitle(String itemType) {
    return 'Publier $itemType ?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'Publier ce $itemType ? Il sera visible.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return 'Archiver $itemType ?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'Archiver ce $itemType ? Il sera masqué.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return 'Restaurer $itemType ?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'Restaurer ce $itemType ? Il sera visible.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return 'Supprimer $itemType ?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'Voulez-vous vraiment supprimer ce $itemType ?';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" supprimé.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Fournisseur et IDs de publicités.';

  @override
  String get feedAdSettingsDescription =>
      'Visibilité et fréquence dans le flux.';

  @override
  String get navigationAdConfigDescription =>
      'Publicités lors de la navigation.';

  @override
  String get feedDecoratorLinkAccountDescription => 'Invite à créer un compte.';

  @override
  String get feedDecoratorUpgradeDescription => 'Invite à passer au premium.';

  @override
  String get feedDecoratorRateAppDescription =>
      'Invite à noter l\'application.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Invite aux notifications.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Affiche des sujets suggérés.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Affiche des sources suggérées.';

  @override
  String get enableGlobalAdsDescription =>
      'Active ou désactive toute publicité.';

  @override
  String get enableFeedAdsDescription =>
      'Contrôle les publicités dans le flux.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'Actif pour les utilisateurs avec le rôle \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription => 'Active ce décorateur globalement.';

  @override
  String get enableNavigationAdsDescription =>
      'Publicités lors de la navigation interne.';

  @override
  String get enableHeadlineReportingDescription =>
      'Permet de signaler les titres.';

  @override
  String get enableSourceReportingDescription =>
      'Permet de signaler les sources.';

  @override
  String get enableCommentReportingDescription =>
      'Permite de signaler les commentaires.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Alertes de dernière minute.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Résumé quotidien.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Résumé hebdomadaire.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Lorsqu\'un titre est enregistré.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Lorsqu\'un sujet ou source est suivi.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Lorsqu\'un contenu est partagé.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Lorsqu\'un filtre est créé.';

  @override
  String get internalPromptLogicDescription =>
      'Conditions pour l\'invite de satisfaction.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Actions comptées comme positives.';

  @override
  String get followUpActionsDescription => 'Actions après réponse à l\'invite.';

  @override
  String get analyticsTab => 'Analytiques';

  @override
  String get analyticsDescription => 'Configurez le suivi des événements.';

  @override
  String get analyticsSystemStatusTitle => 'Activer Analytiques';

  @override
  String get analyticsSystemStatusDescription =>
      'Interrupteur maître du suivi.';

  @override
  String get analyticsProviderTitle => 'Fournisseur Actif';

  @override
  String get analyticsProviderDescription =>
      'Service d\'analytiques principal.';

  @override
  String get analyticsEventsTitle => 'Configuration Événements';

  @override
  String get analyticsEventsDescription =>
      'Ajustez le suivi d\'événements spécifiques.';

  @override
  String samplingRateLabel(int rate) {
    return 'Taux d\'échantillonnage : $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'Inscription Utilisateur';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'Suit les nouvelles inscriptions.';

  @override
  String get analyticsEventUserLoginLabel => 'Connexion Utilisateur';

  @override
  String get analyticsEventUserLoginDescription => 'Suit les accès.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Compte Lié';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'Suit les liaisons de compte.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'Changement de Rôle';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Suit les changements de niveau.';

  @override
  String get analyticsEventContentViewedLabel => 'Contenu Vu';

  @override
  String get analyticsEventContentViewedDescription => 'Suit les lectures.';

  @override
  String get analyticsEventContentSharedLabel => 'Contenu Partagé';

  @override
  String get analyticsEventContentSharedDescription => 'Suit les partages.';

  @override
  String get analyticsEventContentSavedLabel => 'Contenu Enregistré';

  @override
  String get analyticsEventContentSavedDescription => 'Suit les favoris.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Contenu Désenregistré';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Suit les suppressions de favoris.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Temps de Lecture';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'Suit la durée de lecture.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Réaction Ajoutée';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Suit les nouvelles réactions.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Réaction Supprimée';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Suit les suppressions de réactions.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Commentaire Publié';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Suit les nouveaux commentaires.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Commentaire Supprimé';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Suit les suppressions de commentaires.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Rapport Envoyé';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Suit les signalements.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'Filtre Créé';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Suit la création de filtres.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'Filtre Mis à Jour';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Suit les modifications de filtres.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Filtre Utilisé';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Suit l\'application de filtres.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Recherche Effectuée';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'Suit les requêtes de recherche.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel =>
      'Réponse à l\'Invite';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Suit la réponse à \'Aimez-vous l\'app ?\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Avis Boutique Demandé';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Suit les demandes d\'avis officiel.';

  @override
  String get analyticsEventLimitExceededLabel => 'Limite Dépassée';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Suit quand une limite est atteinte.';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => 'Clic CTA Limite';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Suit les clics sur \'Améliorer\'.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Paywall Affiché';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Suit les impressions du paywall.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Abonnement Lancé';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Suit les nouveaux achats.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Abonnement Renouvelé';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'Suit les renouvellements.';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'Abonnement Annulé';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Suit les annulations.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Abonnement Terminé';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'Suit les expirations.';

  @override
  String get analyticsEventAdImpressionLabel => 'Impression Pub';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Suit l\'affichage des pubs.';

  @override
  String get analyticsEventAdClickedLabel => 'Clic sur Pub';

  @override
  String get analyticsEventAdClickedDescription =>
      'Suit les clics sur les pubs.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Échec Chargement Pub';

  @override
  String get analyticsEventAdLoadFailedDescription =>
      'Suit les erreurs de pubs.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Récompense Gagnée';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Suit les pubs récompensées finies.';

  @override
  String get analyticsEventThemeChangedLabel => 'Changement de Thème';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Suit les changements visuels.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Changement de Langue';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Suit les changements de langue.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Changement Densité';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Suit les réglages du flux.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'Changement Navigateur';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Suit la préférence de liens.';

  @override
  String get analyticsEventAppTourStartedLabel => 'Tour Lancé';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'Suit le début du tour.';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'Étape du Tour Vue';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'Suit les vues du tour.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'Tour Terminé';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'Suit la fin du tour.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'Tour Ignoré';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'Suit si le tour est sauté.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'Personnalisation Lancée';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'Suit le début de l\'onboarding.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'Étape Onboarding Vue';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'Suit les étapes d\'onboarding.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'Personnalisation Finie';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'Suit la fin de l\'onboarding.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'Personnalisation Ignorée';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'Suit si l\'onboarding est sauté.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7J';

  @override
  String get timeFrameMonth => '30J';

  @override
  String get timeFrameYear => '1A';

  @override
  String get noDataAvailable => 'Aucune donnée';

  @override
  String get vsPreviousPeriod => 'vs période précédente';

  @override
  String get vsPreviousDay => 'vs dernières 24h';

  @override
  String get vsPreviousWeek => 'vs derniers 7 jours';

  @override
  String get vsPreviousMonth => 'vs derniers 30 jours';

  @override
  String get vsPreviousYear => 'vs année précédente';

  @override
  String get kpiUsersTotalRegistered => 'Utilisateurs Inscrits';

  @override
  String get kpiUsersNewRegistrations => 'Nouvelles Inscriptions';

  @override
  String get kpiUsersActiveUsers => 'Utilisateurs Actifs';

  @override
  String get kpiContentHeadlinesTotalPublished => 'Titres Publiés';

  @override
  String get kpiContentHeadlinesTotalViews => 'Vues des Titres';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Likes sur Titres';

  @override
  String get kpiContentSourcesTotalSources => 'Total Sources';

  @override
  String get kpiContentSourcesNewSources => 'Nouvelles Sources';

  @override
  String get kpiContentSourcesTotalFollowers => 'Abonnés aux Sources';

  @override
  String get kpiContentTopicsTotalTopics => 'Total Sujets';

  @override
  String get kpiContentTopicsNewTopics => 'Nouveaux Sujets';

  @override
  String get kpiContentTopicsTotalFollowers => 'Abonnés aux Sujets';

  @override
  String get kpiEngagementsTotalReactions => 'Total Réactions';

  @override
  String get kpiEngagementsTotalComments => 'Total Commentaires';

  @override
  String get kpiEngagementsAverageEngagementRate => 'Taux d\'Engagement Moyen';

  @override
  String get kpiEngagementsReportsPending => 'Rapports en Attente';

  @override
  String get kpiEngagementsReportsResolved => 'Rapports Résolus';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Temps Moyen de Résolution';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Total Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Feedback Positif';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Demandes d\'Avis';

  @override
  String get chartUsersRegistrationsOverTime => 'Inscriptions dans le Temps';

  @override
  String get chartUsersActiveUsersOverTime => 'Tendance Actifs';

  @override
  String get chartUsersRoleDistribution => 'Distribution par Rôle';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Tendance des Vues';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Tendance des Likes';

  @override
  String get chartContentHeadlinesViewsByTopic => 'Vues par Sujet';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime =>
      'Activité des Sources';

  @override
  String get chartContentSourcesFollowersOverTime => 'Croissance des Sources';

  @override
  String get chartContentSourcesEngagementByType => 'Engagement par Type';

  @override
  String get chartContentTopicsFollowersOverTime => 'Croissance des Sujets';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime =>
      'Activité des Sujets';

  @override
  String get chartContentTopicsEngagementByTopic => 'Engagement par Sujet';

  @override
  String get chartEngagementsReactionsOverTime => 'Tendance des Réactions';

  @override
  String get chartEngagementsCommentsOverTime => 'Tendance des Commentaires';

  @override
  String get chartEngagementsReactionsByType => 'Distribution des Réactions';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'Rapports Envoyés';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'Tendance de Résolution';

  @override
  String get chartEngagementsReportsByReason => 'Rapports par Motif';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime =>
      'Tendance du Feedback';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Analyse de Sentiment';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Tendance des Demandes';

  @override
  String get chartContentSourcesStatusDistribution => 'Distribution des États';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution => 'Dernière Minute';

  @override
  String get chartOverviewAppTourFunnel => 'Entonnoir du Tour';

  @override
  String get chartOverviewInitialPersonalizationFunnel =>
      'Entonnoir Onboarding';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'Titres les Plus Vus';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'Titres les Plus Aimés';

  @override
  String get rankedListOverviewSourcesMostFollowed =>
      'Sources les Plus Suivies';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Sujets les Plus Suivis';

  @override
  String get subscriptionTab => 'Abonnements';

  @override
  String get subscriptionDescription => 'Configurez les plans d\'abonnement.';

  @override
  String get enableSubscriptionLabel => 'Activer Abonnements';

  @override
  String get enableSubscriptionDescription =>
      'Permet aux utilisateurs d\'améliorer leur niveau.';

  @override
  String get monthlyPlanTitle => 'Plan Mensuel';

  @override
  String get annualPlanTitle => 'Plan Annuel';

  @override
  String get planEnabledLabel => 'Plan Activé';

  @override
  String get planRecommendedLabel => 'Plan Recommandé';

  @override
  String get planRecommendedDescription => 'Met en avant ce plan.';

  @override
  String get appleProductIdLabel => 'ID Produit Apple App Store';

  @override
  String get googleProductIdLabel => 'ID Produit Google Play Store';

  @override
  String get subscriptionPlanEnablementError =>
      'Entrez au moins un ID de produit.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Plan désactivé (ID manquant).';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Abonnements désactivés.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Notifications désactivées.';

  @override
  String get analyticsFeatureDisabledNotification => 'Analytiques désactivées.';

  @override
  String get reportingFeatureDisabledNotification => 'Signalements désactivés.';

  @override
  String get appReviewFeatureDisabledNotification => 'Avis désactivés.';

  @override
  String get subscriptionsName => 'Abonnements';

  @override
  String get subscriptionProvider => 'Fournisseur';

  @override
  String get accessTier => 'Niveau d\'Accès';

  @override
  String get expiryDate => 'Date d\'Expiration';

  @override
  String get willAutoRenew => 'Auto-renouvellement';

  @override
  String get allAccessTiers => 'Tous les Niveaux';

  @override
  String get subscriptionActionCopyUserId => 'Copier ID Utilisateur';

  @override
  String get subscriptionActionCopySubscriptionId => 'Copier ID Abonnement';

  @override
  String get filterSubscriptions => 'Filtrer Abonnements';

  @override
  String get selectStatus => 'État';

  @override
  String get selectProvider => 'Fournisseur';

  @override
  String get selectTier => 'Niveau';

  @override
  String get noSubscriptionsFound => 'Aucun abonnement.';

  @override
  String get loadingSubscriptions => 'Chargement Abonnements';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Rechercher par ID Utilisateur ou Abonnement...';

  @override
  String get subscriptionsPageDescription =>
      'Suivi des abonnements (lecture seule).';

  @override
  String get subscriptionStatusActive => 'Actif';

  @override
  String get subscriptionStatusGracePeriod => 'Délai de Grâce';

  @override
  String get subscriptionStatusBillingIssue => 'Problème de Facturation';

  @override
  String get subscriptionStatusCanceled => 'Annulé';

  @override
  String get subscriptionStatusExpired => 'Expiré';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'Abonnements Actifs';

  @override
  String get chartSubscriptionsStatusDistribution => 'Distribution des États';

  @override
  String get chartSubscriptionsByStoreProvider => 'Abonnements par Boutique';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Total Pubs Vues';

  @override
  String get kpiRewardsActiveUsersCount => 'Utilisateurs avec Récompense';

  @override
  String get rewardsTab => 'Récompenses';

  @override
  String get rewardsDescription =>
      'Configurez les récompenses par interaction.';

  @override
  String get enableRewardsLabel => 'Activer Récompenses';

  @override
  String get enableRewardsDescription =>
      'Permet de gagner des prix via les pubs.';

  @override
  String get rewardTypeAdFree => 'Expérience Sans Pub';

  @override
  String get rewardDurationDaysLabel => 'Durée (Jours)';

  @override
  String get rewardEnabledLabel => 'Activé';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Tendance des Pubs Vues';

  @override
  String get chartRewardsActiveByType => 'Récompenses Actives par Type';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Invite à débloquer des fonctions.';

  @override
  String get rewardDurationDaysDescription =>
      'Jours de validité de la récompense.';

  @override
  String get rewardsManagement => 'Gestion des Récompenses';

  @override
  String get rewardsManagementPageDescription =>
      'Gérez les prix des utilisateurs.';

  @override
  String get loadingRewards => 'Chargement des Récompenses';

  @override
  String get noRewardsFound => 'Aucune récompense.';

  @override
  String get userId => 'ID Utilisateur';

  @override
  String get activeRewards => 'Récompenses Actives';

  @override
  String get expiry => 'Expiration';

  @override
  String get filterRewards => 'Filtrer Récompenses';

  @override
  String get rewardType => 'Type de Récompense';

  @override
  String get selectRewardTypes => 'Types de Récompense';

  @override
  String get loadingAnalytics => 'Chargement Analytiques';

  @override
  String get noAnalyticsDataHeadline => 'Aucune Donnée Analytique';

  @override
  String get noAnalyticsDataSubheadline =>
      'Aucune donnée à afficher pour le moment.';

  @override
  String get androidAdUnitsTitle => 'Unités Android';

  @override
  String get iosAdUnitsTitle => 'Unités iOS';

  @override
  String get rewardedAdIdLabel => 'ID Pub Récompensée';

  @override
  String get rewardedAdIdDescription => 'ID pour les pubs avec prix.';

  @override
  String get kpiRewardsGrantedTotal => 'Total Prix Accordés';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'Hub de Récompenses Vu';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'Suit les visites du hub.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'Offre Cliquée';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'Suit les clics sur les offres.';

  @override
  String get analyticsEventRewardGrantedLabel => 'Récompense Accordée';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'Suit les prix délivrés.';

  @override
  String get chartRewardsGrantedOverTime => 'Tendance des Prix';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'Personnalisation Initiale';

  @override
  String get initialPersonalizationDescription =>
      'Configurez le flux de bienvenue.';

  @override
  String get enableInitialPersonalizationLabel => 'Activer Personnalisation';

  @override
  String get enableInitialPersonalizationDescription =>
      'Guide les nouveaux utilisateurs.';

  @override
  String get enableCountrySelectionLabel => 'Sélection du Pays';

  @override
  String get enableCountrySelectionDescription =>
      'Permet de choisir le pays au début.';

  @override
  String get enableTopicSelectionLabel => 'Sélection des Sujets';

  @override
  String get enableTopicSelectionDescription =>
      'Permet de choisir les sujets au début.';

  @override
  String get enableSourceSelectionLabel => 'Sélection des Sources';

  @override
  String get enableSourceSelectionDescription =>
      'Permet de choisir les sources au début.';

  @override
  String get minSelectionsRequiredLabel => 'Sélections Minimum';

  @override
  String get minSelectionsRequiredDescription =>
      'Éléments requis pour continuer.';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingDescription => 'Gérez la première expérience.';

  @override
  String get enableOnboardingLabel => 'Activer Onboarding';

  @override
  String get enableOnboardingDescription => 'Interrupteur maître de bienvenue.';

  @override
  String get appTourTitle => 'Tour de l\'App';

  @override
  String get appTourDescription => 'Configurez le tour avant connexion.';

  @override
  String get enableAppTourLabel => 'Activer le Tour';

  @override
  String get enableAppTourDescription =>
      'Affiche les fonctions avant d\'entrer.';

  @override
  String get skippableAppTourLabel => 'Tour Ignorable';

  @override
  String get skippableAppTourDescription => 'Permet de sauter le tour.';

  @override
  String get skippableInitialPersonalizationLabel =>
      'Personnalisation Ignorable';

  @override
  String get skippableInitialPersonalizationDescription =>
      'Permet de sauter l\'onboarding.';

  @override
  String get filePickingErrorMessage =>
      'Erreur lors de la sélection du fichier.';

  @override
  String get removeImage => 'Retirer l\'image';

  @override
  String get clickToUploadImage => 'Cliquer pour uploader';

  @override
  String get processingImage => 'Traitement de l\'Image...';

  @override
  String get processingImageDescription => 'Optimisation en cours...';

  @override
  String get chartMediaUploadsOverTime => 'Uploads dans le Temps';

  @override
  String get chartMediaUploadsByPurpose => 'Uploads par Usage';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'Succès vs Échec';

  @override
  String get kpiMediaTotalUploads => 'Total Uploads';

  @override
  String get kpiMediaFailedUploads => 'Uploads Échoués';

  @override
  String get kpiMediaAverageUploadTime => 'Temps Moyen (s)';

  @override
  String get updateHeadlineTitle => 'Mettre à Jour le Titre';

  @override
  String get updateHeadlineMessage =>
      'Publier les changements ou enregistrer en brouillon ?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'Upload Lancé';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'Suit le début de l\'upload.';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'Upload Terminé';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'Suit le succès de l\'upload.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'Upload Échoué';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'Suit les échecs d\'upload.';

  @override
  String get dashboard => 'Panel';

  @override
  String get aboutOverviewPageTitle => 'À propos de l\'Aperçu';

  @override
  String get aboutOverviewPageDescription =>
      'Métriques clés mises à jour périodiquement.';

  @override
  String get audience => 'Audience';

  @override
  String get content => 'Contenu';

  @override
  String get community => 'Communauté';

  @override
  String get monetization => 'Monétisation';

  @override
  String get configuration => 'Configuration';

  @override
  String get loadingConfiguration => 'Chargement Configuration...';

  @override
  String get noConfigurationDataHeadline => 'Aucune Donnée';

  @override
  String get noConfigurationDataSubheadline =>
      'Échec du chargement de la config.';

  @override
  String get readOnlyConfigurationView => 'Vue en Lecture Seule';

  @override
  String get readOnlyConfigurationViewDescription =>
      'Instantané en temps réel.';

  @override
  String get providers => 'Fournisseurs';

  @override
  String get summary => 'Résumé';

  @override
  String get about => 'À propos';

  @override
  String get localizationConfigDescription =>
      'Langues supportées et par défaut.';

  @override
  String get enabledLanguagesLabel => 'Langues Activées';

  @override
  String get cannotDisableDefaultLanguage =>
      'Impossible de désactiver la langue par défaut.';

  @override
  String get atLeastOneLanguageRequired => 'Au moins une langue est requise.';

  @override
  String get defaultLanguageLabel => 'Langue par Défaut';

  @override
  String get defaultLanguageDescription => 'Langue de secours.';

  @override
  String get localizationTitle => 'Localisation';

  @override
  String get localizationDescription => 'Contrôle les langues actives.';

  @override
  String defaultLanguageRequired(String language) {
    return 'La langue par défaut ($language) est requise.';
  }

  @override
  String get languageNameEn => 'Anglais';

  @override
  String get languageNameEs => 'Espagnol';

  @override
  String get languageNameFr => 'Français';

  @override
  String get languageNameAr => 'Arabe';

  @override
  String get languageNamePt => 'Portugais';

  @override
  String get languageNameDe => 'Allemand';

  @override
  String get languageNameIt => 'Italien';

  @override
  String get languageNameZh => 'Chinois';

  @override
  String get languageNameHi => 'Hindi';

  @override
  String get languageNameJa => 'Japonais';
}
