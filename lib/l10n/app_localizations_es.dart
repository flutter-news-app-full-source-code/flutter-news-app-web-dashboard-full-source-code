// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Acceso al Panel';

  @override
  String get authenticationPageSubheadline =>
      'Inicio de sesión seguro para administradores.';

  @override
  String get authenticationEmailSignInButton => 'Iniciar sesión con Email';

  @override
  String get emailSignInPageTitle => 'Inicio de Sesión Seguro';

  @override
  String get requestCodePageHeadline => 'Inicio de Sesión por Email';

  @override
  String get requestCodePageSubheadline =>
      'Introduce tu email para recibir un código.';

  @override
  String get requestCodeEmailLabel => 'Correo electrónico';

  @override
  String get requestCodeEmailHint => 'tu.email@ejemplo.com';

  @override
  String get accountLinkingEmailValidationError => 'Introduce un email válido.';

  @override
  String get requestCodeSendCodeButton => 'Enviar Código';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Reenviar en ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Verificar Código';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'Enviamos un código de 6 dígitos a $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'Revisa tu bandeja de entrada e ingresa el código.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'En modo demo, usa: $code';
  }

  @override
  String get emailCodeVerificationHint => 'Código de 6 dígitos';

  @override
  String get emailCodeValidationEmptyError => 'El código no puede estar vacío.';

  @override
  String get emailCodeValidationLengthError =>
      'El código debe tener 6 dígitos.';

  @override
  String get emailCodeVerificationButtonLabel => 'Verificar Código';

  @override
  String get overview => 'Resumen';

  @override
  String get contentManagement => 'Gestión de Contenido';

  @override
  String get contentManagementPageDescription =>
      'Gestiona titulares, temas y fuentes.';

  @override
  String get headlines => 'Titulares';

  @override
  String get headline => 'Titular';

  @override
  String get topics => 'Temas';

  @override
  String get topic => 'Tema';

  @override
  String get sources => 'Fuentes';

  @override
  String get source => 'Fuente';

  @override
  String get appConfiguration => 'Config. Remota';

  @override
  String get appConfigurationPageDescription =>
      'Ajustes globales de la aplicación móvil.';

  @override
  String get settings => 'Ajustes';

  @override
  String get appConfigurationPageTitle => 'Configuración Remota';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Publicidad';

  @override
  String get systemTab => 'Sistema';

  @override
  String get userContentLimitsTitle => 'Límites de Contenido';

  @override
  String get userContentLimitsDescription =>
      'Límites de seguimiento y guardado por nivel.';

  @override
  String get feedActionsTitle => 'Acciones del Feed';

  @override
  String get feedActionsDescription =>
      'Frecuencia de widgets de acción en el feed.';

  @override
  String get feedDecoratorsTitle => 'Decoradores del Feed';

  @override
  String get feedDecoratorsDescription =>
      'Configuración de presentación visual por rol.';

  @override
  String get adSettingsTitle => 'Ajustes de Publicidad';

  @override
  String get adSettingsDescription =>
      'Frecuencia y ubicación de anuncios por rol.';

  @override
  String get maintenanceModeTitle => 'Modo Mantenimiento';

  @override
  String get maintenanceModeDescription =>
      'Activa la pantalla de mantenimiento global.';

  @override
  String get forceUpdateTitle => 'Actualización Forzada';

  @override
  String get forceUpdateDescription =>
      'Configura actualizaciones obligatorias.';

  @override
  String get forceUpdateTab => 'Actualización';

  @override
  String get appConfigSaveSuccessMessage => 'Configuración guardada con éxito.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Error: $errorMessage';
  }

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get loadingConfigurationHeadline => 'Cargando Configuración';

  @override
  String get loadingConfigurationSubheadline => 'Por favor, espere...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Error al cargar configuración.';

  @override
  String get loadAppSettingsSubheadline => 'Cargar ajustes desde el backend.';

  @override
  String get discardChangesButton => 'Descartar Cambios';

  @override
  String get saveChangesButton => 'Guardar Cambios';

  @override
  String get confirmConfigUpdateDialogTitle => 'Confirmar Actualización';

  @override
  String get confirmConfigUpdateDialogContent =>
      '¿Aplicar cambios a la app en vivo?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get confirmSaveButton => 'Confirmar Guardado';

  @override
  String get guestUserTab => 'Invitado';

  @override
  String get authenticatedUserTab => 'Autenticado';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Límite de Seguimiento (Invitado)';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Máximo de temas o fuentes seguidas.';

  @override
  String get guestSavedHeadlinesLimitLabel => 'Límite de Guardado (Invitado)';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Máximo de titulares guardados.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'Límite de Seguimiento (Estándar)';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Límite para usuarios estándar.';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Límite de Guardado (Estándar)';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Límite para usuarios estándar.';

  @override
  String get premiumFollowedItemsLimitLabel =>
      'Límite de Seguimiento (Premium)';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Límite para usuarios premium.';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Límite de Guardado (Premium)';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Límite para usuarios premium.';

  @override
  String get standardUserAdTab => 'Usuario Estándar';

  @override
  String get guestAdFrequencyLabel => 'Frecuencia de Anuncios (Invitado)';

  @override
  String get guestAdFrequencyDescription =>
      'Anuncios cada X elementos del feed.';

  @override
  String get guestAdPlacementIntervalLabel => 'Intervalo Inicial (Invitado)';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Elementos antes del primer anuncio.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Artículos para Intersticial';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Lecturas antes de anuncio.';

  @override
  String get standardUserAdFrequencyLabel => 'Frecuencia (Estándar)';

  @override
  String get standardUserAdFrequencyDescription =>
      'Frecuencia para usuarios estándar.';

  @override
  String get standardUserAdPlacementIntervalLabel => 'Intervalo (Estándar)';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Intervalo para estándar.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Artículos (Estándar)';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Lecturas para estándar.';

  @override
  String get premiumAdFrequencyLabel => 'Frecuencia (Premium)';

  @override
  String get premiumAdFrequencyDescription =>
      'Frecuencia para premium (0 = sin ads).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Intervalo (Premium)';

  @override
  String get premiumAdPlacementIntervalDescription => 'Intervalo para premium.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Artículos (Premium)';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Lecturas para premium.';

  @override
  String get appOperationalStatusWarning =>
      'ADVERTENCIA: Afecta a todos los usuarios.';

  @override
  String get appOperationalStatusLabel => 'Estado Operativo';

  @override
  String get appOperationalStatusDescription =>
      'Estado actual (activo, mantenimiento).';

  @override
  String get maintenanceMessageLabel => 'Mensaje de Mantenimiento';

  @override
  String get maintenanceMessageDescription =>
      'Mensaje mostrado en mantenimiento.';

  @override
  String get disabledMessageLabel => 'Mensaje de Desactivación';

  @override
  String get disabledMessageDescription =>
      'Mensaje si la app está desactivada.';

  @override
  String get forceUpdateConfigurationTitle => 'Configuración de Actualización';

  @override
  String get minAllowedAppVersionLabel => 'Versión Mínima Permitida';

  @override
  String get minAllowedAppVersionDescription =>
      'Versión más baja permitida (ej. 1.2.0).';

  @override
  String get latestAppVersionLabel => 'Última Versión';

  @override
  String get latestAppVersionDescription => 'Versión más reciente (ej. 1.5.0).';

  @override
  String get updateRequiredMessageLabel =>
      'Mensaje de Actualización Obligatoria';

  @override
  String get updateRequiredMessageDescription =>
      'Mensaje para forzar actualización.';

  @override
  String get updateOptionalMessageLabel => 'Mensaje de Actualización Opcional';

  @override
  String get updateOptionalMessageDescription =>
      'Mensaje para actualización opcional.';

  @override
  String get iosStoreUrlLabel => 'URL App Store (iOS)';

  @override
  String get iosStoreUrlDescription => 'Enlace a la tienda de Apple.';

  @override
  String get androidStoreUrlLabel => 'URL Play Store (Android)';

  @override
  String get androidUpdateUrlDescription => 'Enlace a la tienda de Google.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'Días entre Avisos (Invitado)';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Días mínimos entre avisos.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Días entre Avisos (Estándar)';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Días para estándar.';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get settingsSavedSuccessfully => '¡Ajustes guardados!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Error al guardar: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Cargando Ajustes';

  @override
  String get loadingSettingsSubheadline => 'Por favor, espere...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Error al cargar: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Tema Base';

  @override
  String get baseThemeDescription => 'Apariencia clara u oscura.';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Predeterminado del Sistema';

  @override
  String get accentThemeLabel => 'Color de Acento';

  @override
  String get accentThemeDescription =>
      'Color principal para elementos interactivos.';

  @override
  String get defaultBlueTheme => 'Azul Predeterminado';

  @override
  String get newsRedTheme => 'Rojo Noticias';

  @override
  String get graphiteGrayTheme => 'Gris Grafito';

  @override
  String get fontFamilyLabel => 'Fuente';

  @override
  String get fontFamilyDescription => 'Tipografía de la aplicación.';

  @override
  String get systemDefaultFont => 'Predeterminada';

  @override
  String get textScaleFactorLabel => 'Tamaño de Texto';

  @override
  String get textScaleFactorDescription => 'Ajusta el tamaño de la letra.';

  @override
  String get smallText => 'Pequeño';

  @override
  String get mediumText => 'Mediano';

  @override
  String get largeText => 'Grande';

  @override
  String get extraLargeText => 'Muy Grande';

  @override
  String get fontWeightLabel => 'Grosor de Fuente';

  @override
  String get fontWeightDescription => 'Grosor del texto.';

  @override
  String get lightFontWeight => 'Ligero';

  @override
  String get regularFontWeight => 'Regular';

  @override
  String get boldFontWeight => 'Negrita';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageDescription => 'Selecciona el idioma del panel.';

  @override
  String get edit => 'Editar';

  @override
  String get englishLanguage => 'Inglés';

  @override
  String get arabicLanguage => 'Árabe';

  @override
  String get appearanceSettingsLabel => 'Apariencia';

  @override
  String get languageSettingsLabel => 'Idioma';

  @override
  String get themeSettingsLabel => 'Ajustes de Tema';

  @override
  String get fontSettingsLabel => 'Ajustes de Fuente';

  @override
  String get settingsPageDescription =>
      'Configura tus preferencias visuales e idioma.';

  @override
  String get appearanceSettingsDescription =>
      'Ajusta el tema, colores y tipografía.';

  @override
  String get loadingHeadlines => 'Cargando Titulares';

  @override
  String get pleaseWait => 'Espere...';

  @override
  String get noHeadlinesFound => 'No hay titulares.';

  @override
  String get headlineTitle => 'Título';

  @override
  String get excerpt => 'Extracto';

  @override
  String get countryName => 'País';

  @override
  String get publishedAt => 'Publicado el';

  @override
  String get actions => 'Acciones';

  @override
  String get unknown => 'Desconocido';

  @override
  String get loadingTopics => 'Cargando Temas';

  @override
  String get noTopicsFound => 'No hay temas.';

  @override
  String get topicName => 'Tema';

  @override
  String get description => 'Descripción';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'Cargando Fuentes';

  @override
  String get noSourcesFound => 'No hay fuentes.';

  @override
  String get sourceName => 'Fuente';

  @override
  String get sourceType => 'Tipo';

  @override
  String get language => 'Idioma';

  @override
  String get editTopic => 'Editar Tema';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get loadingTopic => 'Cargando Tema';

  @override
  String get icon => 'Icono';

  @override
  String get topicUpdatedSuccessfully => 'Tema actualizado.';

  @override
  String get cannotUpdateTopicError => 'Error: Datos originales no cargados.';

  @override
  String get createTopic => 'Crear Tema';

  @override
  String get topicCreatedSuccessfully => 'Tema creado.';

  @override
  String get editSource => 'Editar Fuente';

  @override
  String get sourceUpdatedSuccessfully => 'Fuente actualizada.';

  @override
  String get loadingSource => 'Cargando Fuente...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Sede';

  @override
  String get none => 'Ninguno';

  @override
  String get cannotUpdateSourceError => 'Error: Datos originales no cargados.';

  @override
  String get sourceTypeNewsAgency => 'Agencia de Noticias';

  @override
  String get sourceTypeLocalNewsOutlet => 'Medio Local';

  @override
  String get sourceTypeNationalNewsOutlet => 'Medio Nacional';

  @override
  String get sourceTypeInternationalNewsOutlet => 'Medio Internacional';

  @override
  String get sourceTypeSpecializedPublisher => 'Editor Especializado';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Fuente Gubernamental';

  @override
  String get sourceTypeAggregator => 'Agregador';

  @override
  String get sourceTypeOther => 'Otro';

  @override
  String get editHeadline => 'Editar Titular';

  @override
  String get headlineUpdatedSuccessfully => 'Titular actualizado.';

  @override
  String get loadingHeadline => 'Cargando Titular...';

  @override
  String get image => 'Imagen';

  @override
  String get cannotUpdateHeadlineError =>
      'Error: Datos originales no cargados.';

  @override
  String get createHeadline => 'Crear Titular';

  @override
  String get headlineCreatedSuccessfully => 'Titular creado.';

  @override
  String get loadingData => 'Cargando datos...';

  @override
  String get loadingFullList => 'Cargando lista completa...';

  @override
  String get createSource => 'Crear Fuente';

  @override
  String get updateSourceTitle => 'Actualizar Fuente';

  @override
  String get updateSourceMessage =>
      '¿Publicar cambios o guardar como borrador?';

  @override
  String get sourceCreatedSuccessfully => 'Fuente creada.';

  @override
  String get updateTopicTitle => 'Actualizar Tema';

  @override
  String get status => 'Estado';

  @override
  String get updateTopicMessage => '¿Publicar cambios o guardar como borrador?';

  @override
  String get lastUpdated => 'Última Actualización';

  @override
  String get contentStatusActive => 'Activo';

  @override
  String get contentStatusArchived => 'Archivado';

  @override
  String get contentStatusDraft => 'Borrador';

  @override
  String get totalHeadlines => 'Total Titulares';

  @override
  String get totalTopics => 'Total Temas';

  @override
  String get totalSources => 'Total Fuentes';

  @override
  String get loadingOverview => 'Cargando Resumen...';

  @override
  String get loadingOverviewSubheadline => 'Obteniendo estadísticas...';

  @override
  String get overviewLoadFailure => 'Error al cargar datos del resumen.';

  @override
  String get recentHeadlines => 'Titulares Recientes';

  @override
  String get viewAll => 'Ver Todo';

  @override
  String get noRecentHeadlines => 'No hay titulares recientes.';

  @override
  String get systemStatus => 'Estado del Sistema';

  @override
  String get quickActions => 'Acciones Rápidas';

  @override
  String get createHeadlineAction => 'Crear Titular';

  @override
  String get manageContentAction => 'Gestionar Contenido';

  @override
  String get appConfigAction => 'Config. de App';

  @override
  String get appStatusActive => 'Activo';

  @override
  String get appStatusDisabled => 'Desactivado';

  @override
  String demoEmailHint(String email) {
    return 'Para demo, usa: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'Para demo, usa: $code';
  }

  @override
  String get appStatusMaintenance => 'Mantenimiento';

  @override
  String get appStatusOperational => 'Operativo';

  @override
  String get isUnderMaintenanceLabel => 'En Mantenimiento';

  @override
  String get isUnderMaintenanceDescription => 'Activa el modo mantenimiento.';

  @override
  String get isLatestVersionOnlyLabel => 'Forzar Última Versión';

  @override
  String get isLatestVersionOnlyDescription =>
      'Obliga a actualizar para usar la app.';

  @override
  String get iosUpdateUrlLabel => 'URL Actualización iOS';

  @override
  String get iosUpdateUrlDescription => 'Enlace de actualización para iOS.';

  @override
  String get androidUpdateUrlLabel => 'URL Actualización Android';

  @override
  String get followedItemsLimitLabel => 'Límite de Seguimiento';

  @override
  String get followedItemsLimitDescription =>
      'Máximo de elementos seguidos por rol.';

  @override
  String get savedFeedFiltersLimitLabel => 'Límite de Filtros Guardados';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Máximo de filtros guardados por rol.';

  @override
  String get adFrequencyLabel => 'Frecuencia de Anuncios';

  @override
  String get adFrequencyDescription => 'Anuncios cada X elementos.';

  @override
  String get savedFeedFilterLimitsTitle => 'Límites de Filtros';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Configura límites de filtros por nivel.';

  @override
  String get adPlacementIntervalLabel => 'Intervalo de Anuncios';

  @override
  String get adPlacementIntervalDescription =>
      'Elementos antes del primer anuncio.';

  @override
  String get articlesBeforeInterstitialAdsLabel =>
      'Artículos para Intersticial';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Lecturas antes de anuncio.';

  @override
  String get daysSuffix => 'Días';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Días mínimos antes del aviso de $actionType.';
  }

  @override
  String get retryButtonText => 'Reintentar';

  @override
  String get feedActionTypeLinkAccount => 'Vincular Cuenta';

  @override
  String get feedActionTypeRateApp => 'Valorar App';

  @override
  String get feedActionTypeFollowTopics => 'Seguir Temas';

  @override
  String get feedActionTypeFollowSources => 'Seguir Fuentes';

  @override
  String get feedActionTypeUpgrade => 'Mejorar Plan';

  @override
  String get feedActionTypeEnableNotifications => 'Activar Notificaciones';

  @override
  String get countryPickerSearchLabel => 'Buscar';

  @override
  String get countryPickerSearchHint => 'Escribe para buscar...';

  @override
  String get countryPickerSelectCountryLabel => 'Selecciona un país';

  @override
  String get archivedHeadlines => 'Titulares Archivados';

  @override
  String get loadingArchivedHeadlines => 'Cargando Archivados';

  @override
  String get noArchivedHeadlinesFound => 'No hay titulares archivados.';

  @override
  String get restore => 'Restaurar';

  @override
  String get deleteForever => 'Eliminar Permanentemente';

  @override
  String get archivedTopics => 'Temas Archivados';

  @override
  String get loadingArchivedTopics => 'Cargando Temas Archivados';

  @override
  String get noArchivedTopicsFound => 'No hay temas archivados.';

  @override
  String get archivedSources => 'Fuentes Archivadas';

  @override
  String get loadingArchivedSources => 'Cargando Fuentes Archivadas';

  @override
  String get noArchivedSourcesFound => 'No hay fuentes archivadas.';

  @override
  String get archivedItems => 'Elementos Archivados';

  @override
  String get addNewItem => 'Añadir Nuevo';

  @override
  String get archive => 'Archivar';

  @override
  String headlineDeleted(String title) {
    return 'Eliminado \'\'$title\'\'.';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get enabledLabel => 'Activado';

  @override
  String get itemsToDisplayLabel => 'Elementos a Mostrar';

  @override
  String get itemsToDisplayDescription =>
      'Número de elementos en este decorador.';

  @override
  String get roleSpecificSettingsTitle => 'Ajustes por Rol';

  @override
  String get daysBetweenViewsLabel => 'Días entre Visualizaciones';

  @override
  String get daysBetweenViewsDescription =>
      'Días mínimos antes de repetir decorador.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Vincular Cuenta';

  @override
  String get feedDecoratorTypeUpgrade => 'Pasar a Premium';

  @override
  String get feedDecoratorTypeRateApp => 'Valorar App';

  @override
  String get feedDecoratorTypeEnableNotifications => 'Activar Notificaciones';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Temas Sugeridos';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Fuentes Sugeridas';

  @override
  String get guestUserRole => 'Invitado';

  @override
  String get standardUserRole => 'Usuario Estándar';

  @override
  String get premiumUserRole => 'Usuario Premium';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get clearSelection => 'Limpiar Selección';

  @override
  String get search => 'Buscar';

  @override
  String get noResultsFound => 'Sin resultados.';

  @override
  String get close => 'Cerrar';

  @override
  String get apply => 'Aplicar';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visible para $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Plataforma de Publicidad';

  @override
  String get primaryAdPlatformTitle => 'Plataforma Principal';

  @override
  String get primaryAdPlatformDescription => 'Proveedor principal de anuncios.';

  @override
  String get adUnitIdentifiersTitle => 'IDs de Unidades de Anuncios';

  @override
  String get adUnitIdentifiersDescription =>
      'Configura los IDs por plataforma.';

  @override
  String get feedAdSettingsTitle => 'Anuncios en Feed';

  @override
  String get enableFeedAdsLabel => 'Activar Anuncios en Feed';

  @override
  String get feedAdTypeSelectionTitle => 'Tipo de Anuncio en Feed';

  @override
  String get feedAdTypeSelectionDescription => 'Nativo o Banner.';

  @override
  String get userRoleFrequencySettingsTitle => 'Frecuencia por Rol';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Configura intervalos por rol.';

  @override
  String get articleAdSettingsTitle => 'Anuncios en Artículos';

  @override
  String get enableArticleAdsLabel => 'Activar Anuncios en Artículos';

  @override
  String get defaultInArticleAdTypeSelectionTitle =>
      'Tipo de Anuncio Predeterminado';

  @override
  String get defaultInArticleAdTypeSelectionDescription => 'Nativo o Banner.';

  @override
  String get inArticleAdSlotPlacementsTitle => 'Ubicaciones en Artículos';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      'Activa ranuras específicas.';

  @override
  String get feedNativeAdIdLabel => 'ID Anuncio Nativo (Feed)';

  @override
  String get feedNativeAdIdDescription => 'ID para anuncios nativos.';

  @override
  String get feedBannerAdIdLabel => 'ID Banner (Feed)';

  @override
  String get feedBannerAdIdDescription => 'ID para banners.';

  @override
  String get articleInterstitialAdIdLabel => 'ID Intersticial (Artículo)';

  @override
  String get articleInterstitialAdIdDescription => 'ID para intersticiales.';

  @override
  String get inArticleNativeAdIdLabel => 'ID Nativo (En Artículo)';

  @override
  String get inArticleNativeAdIdDescription => 'ID para nativos internos.';

  @override
  String get inArticleBannerAdIdLabel => 'ID Banner (En Artículo)';

  @override
  String get inArticleBannerAdIdDescription => 'ID para banners internos.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Sobre \'Seguir leyendo\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'Bajo \'Seguir leyendo\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' copiado.';
  }

  @override
  String get copyId => 'Copiar ID';

  @override
  String get enableGlobalAdsLabel => 'Activar Publicidad';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'ID Intersticial (Navegación)';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'ID al abrir artículos.';

  @override
  String get interstitialAdSettingsTitle => 'Ajustes de Intersticiales';

  @override
  String get enableInterstitialAdsLabel => 'Activar Intersticiales';

  @override
  String get userRoleInterstitialFrequencyTitle => 'Frecuencia por Rol';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Transiciones antes de anuncio.';

  @override
  String get transitionsBeforeInterstitialAdsLabel =>
      'Transiciones para Anuncio';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'Número de transiciones.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Nativos';

  @override
  String get bannerAdsTab => 'Banners';

  @override
  String get interstitialAdsTab => 'Intersticiales';

  @override
  String get videoAdsTab => 'Vídeo';

  @override
  String get bannerAdType => 'Banner';

  @override
  String get nativeAdType => 'Nativo';

  @override
  String get interstitialAdType => 'Intersticial';

  @override
  String get videoAdType => 'Vídeo';

  @override
  String get rewardedAdType => 'Bonificado';

  @override
  String get bannerAdShapeSelectionTitle => 'Forma del Banner';

  @override
  String get bannerAdShapeSelectionDescription => 'Cuadrado o Rectangular.';

  @override
  String get bannerAdShapeSquare => 'Cuadrado';

  @override
  String get bannerAdShapeRectangle => 'Rectángulo';

  @override
  String get loadingDraftHeadlines => 'Cargando Borradores';

  @override
  String get noDraftHeadlinesFound => 'Sin borradores.';

  @override
  String get publish => 'Publicar';

  @override
  String get saveAsDraft => 'Guardar Borrador';

  @override
  String get invalidFormTitle => 'Formulario Inválido';

  @override
  String get invalidFormMessage => 'Completa los campos obligatorios.';

  @override
  String get completeForm => 'Completar';

  @override
  String get discard => 'Descartar';

  @override
  String get drafts => 'Borradores';

  @override
  String get draftsIconTooltip => 'Borradores';

  @override
  String get draftHeadlines => 'Titulares en Borrador';

  @override
  String get draftTopics => 'Temas en Borrador';

  @override
  String get draftSources => 'Fuentes en Borrador';

  @override
  String get saveHeadlineTitle => 'Guardar Titular';

  @override
  String get saveHeadlineMessage => '¿Publicar o guardar como borrador?';

  @override
  String get saveTopicTitle => 'Guardar Tema';

  @override
  String get saveTopicMessage => '¿Publicar o guardar como borrador?';

  @override
  String get saveSourceTitle => 'Guardar Fuente';

  @override
  String get saveSourceMessage => '¿Publicar o guardar como borrador?';

  @override
  String get loadingDraftTopics => 'Cargando Temas...';

  @override
  String get noDraftTopicsFound => 'Sin temas en borrador.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Tema \"$topicTitle\" eliminado.';
  }

  @override
  String get loadingDraftSources => 'Cargando Fuentes...';

  @override
  String get noDraftSourcesFound => 'Sin fuentes en borrador.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Fuente \"$sourceName\" eliminada.';
  }

  @override
  String get publishTopic => 'Publicar Tema';

  @override
  String get publishSource => 'Publicar Fuente';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Activar Ads en Artículos para $role';
  }

  @override
  String get moreActions => 'Más Acciones';

  @override
  String get filter => 'Filtrar';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get filterHeadlines => 'Filtrar Titulares';

  @override
  String get filterTopics => 'Filtrar Temas';

  @override
  String get filterSources => 'Filtrar Fuentes';

  @override
  String get searchByHeadlineTitle => 'Buscar por título...';

  @override
  String get searchByTopicName => 'Buscar por nombre o ID...';

  @override
  String get searchBySourceName => 'Buscar por nombre o ID...';

  @override
  String get selectSources => 'Seleccionar Fuentes';

  @override
  String get selectTopics => 'Seleccionar Temas';

  @override
  String get countries => 'Países';

  @override
  String get selectCountries => 'Seleccionar Países';

  @override
  String get selectSourceTypes => 'Tipos de Fuente';

  @override
  String get selectLanguages => 'Idiomas';

  @override
  String get selectHeadquarters => 'Sedes';

  @override
  String get resetFiltersButtonText => 'Restablecer Filtros';

  @override
  String get noResultsWithCurrentFilters => 'Sin resultados con estos filtros.';

  @override
  String get aboutIconTooltip => 'Sobre esta página';

  @override
  String get closeButtonText => 'Cerrar';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => 'Gestión de Usuarios';

  @override
  String get userManagementPageDescription =>
      'Gestiona usuarios, roles y permisos.';

  @override
  String get loadingUsers => 'Cargando Usuarios';

  @override
  String get noUsersFound => 'No hay usuarios.';

  @override
  String get email => 'Email';

  @override
  String get appRole => 'Rol en App';

  @override
  String get dashboardRole => 'Rol en Panel';

  @override
  String get createdAt => 'Creado el';

  @override
  String get promoteToPublisher => 'Ascender a Editor';

  @override
  String get demoteToUser => 'Degradar a Usuario';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Editor';

  @override
  String get filterUsers => 'Filtrar Usuarios';

  @override
  String get searchByUserEmail => 'Buscar por email o ID...';

  @override
  String get selectAppRoles => 'Roles de App';

  @override
  String get selectDashboardRoles => 'Roles de Panel';

  @override
  String get authentication => 'Autenticación';

  @override
  String get subscription => 'Suscripción';

  @override
  String get authenticationAnonymous => 'Anónimo';

  @override
  String get authenticationAuthenticated => 'Autenticado';

  @override
  String get subscriptionFree => 'Gratis';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle =>
      'Límites de Filtros de Titulares';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Límites de filtros, fijados y avisos.';

  @override
  String get totalLimitLabel => 'Límite Total';

  @override
  String get totalLimitDescription => 'Total de filtros permitidos.';

  @override
  String get pinnedLimitLabel => 'Límite de Fijados';

  @override
  String get pinnedLimitDescription => 'Máximo de filtros fijados.';

  @override
  String get notificationSubscriptionLimitLabel => 'Límite de Notificaciones';

  @override
  String get notificationSubscriptionLimitDescription =>
      'Máximo de suscripciones.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Última Hora';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Resumen Semanal';

  @override
  String get isBreakingNewsLabel => 'Marcar como Última Hora';

  @override
  String get isBreakingNewsDescription => 'Envía notificación push inmediata.';

  @override
  String get isBreakingNewsDescriptionEdit => 'No enviará push al editar.';

  @override
  String get confirmBreakingNewsTitle => 'Confirmar Última Hora';

  @override
  String get confirmBreakingNewsMessage => '¿Enviar notificación push a todos?';

  @override
  String get confirmPublishButton => 'Confirmar y Publicar';

  @override
  String get cannotDraftBreakingNews => 'No se puede guardar como borrador.';

  @override
  String get ok => 'Aceptar';

  @override
  String get breakingNewsFilterTitle => 'Última Hora';

  @override
  String get breakingNewsFilterAll => 'Todos';

  @override
  String get breakingNewsFilterBreakingOnly => 'Solo Última Hora';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Sin Última Hora';

  @override
  String get notificationsTab => 'Notificaciones';

  @override
  String get pushNotificationSettingsTitle => 'Ajustes de Notificaciones';

  @override
  String get pushNotificationSettingsDescription =>
      'Gestión global de notificaciones.';

  @override
  String get pushNotificationSystemStatusTitle => 'Activar Notificaciones';

  @override
  String get pushNotificationSystemStatusDescription => 'Interruptor global.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Proveedor Principal';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Firebase o OneSignal.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Tipos de Entrega';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Activa tipos específicos.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'General';

  @override
  String get featuresTab => 'Funciones';

  @override
  String get limitsTab => 'Límites';

  @override
  String get maintenanceConfigTitle => 'Modo Mantenimiento';

  @override
  String get maintenanceConfigDescription => 'Activa el modo mantenimiento.';

  @override
  String get updateConfigTitle => 'Ajustes de Actualización';

  @override
  String get updateConfigDescription =>
      'Configura actualizaciones obligatorias.';

  @override
  String get generalAppConfigTitle => 'Ajustes Generales';

  @override
  String get generalAppConfigDescription =>
      'Términos y Política de Privacidad.';

  @override
  String get termsOfServiceUrlLabel => 'URL Términos de Servicio';

  @override
  String get termsOfServiceUrlDescription => 'Enlace a los términos.';

  @override
  String get privacyPolicyUrlLabel => 'URL Política de Privacidad';

  @override
  String get privacyPolicyUrlDescription => 'Enlace a la política.';

  @override
  String get navigationAdConfigTitle => 'Anuncios de Navegación';

  @override
  String get enableNavigationAdsLabel => 'Activar Anuncios de Navegación';

  @override
  String get navigationAdFrequencyTitle => 'Frecuencia de Navegación';

  @override
  String get navigationAdFrequencyDescription =>
      'Transiciones antes de anuncio.';

  @override
  String get internalNavigationsBeforeAdLabel => 'Navegaciones Internas';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'Páginas antes de anuncio.';

  @override
  String get externalNavigationsBeforeAdLabel => 'Navegaciones Externas';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'Salidas antes de anuncio.';

  @override
  String get nativeAdIdLabel => 'ID Anuncio Nativo';

  @override
  String get nativeAdIdDescription => 'ID para anuncios nativos.';

  @override
  String get bannerAdIdLabel => 'ID Banner';

  @override
  String get bannerAdIdDescription => 'ID para banners.';

  @override
  String get interstitialAdIdLabel => 'ID Intersticial';

  @override
  String get interstitialAdIdDescription => 'ID para intersticiales.';

  @override
  String get savedHeadlinesLimitLabel => 'Límite de Guardado';

  @override
  String get savedHeadlinesLimitDescription => 'Máximo de titulares guardados.';

  @override
  String get appUpdateManagementTitle => 'Gestión de Actualizaciones';

  @override
  String get feedItemClickBehaviorTitle => 'Comportamiento al Clic';

  @override
  String get feedItemClickBehaviorDescription =>
      'Navegador interno o del sistema.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'Navegador In-App';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'Navegador del Sistema';

  @override
  String get userLimitsTitle => 'Límites de Usuario';

  @override
  String get userLimitsDescription => 'Define límites por función.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Control de estado y actualizaciones.';

  @override
  String get advertisementsDescription => 'Gestión global de publicidad.';

  @override
  String get notificationsDescription =>
      'Configuración de notificaciones push.';

  @override
  String get feedDescription => 'Control de comportamiento del feed.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Límite para alertas inmediatas.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Límite para resumen semanal.';

  @override
  String get appStatusAndUpdatesTitle => 'Estado y Actualizaciones';

  @override
  String get enableForcedUpdatesLabel => 'Activar Actualizaciones Forzadas';

  @override
  String get enableForcedUpdatesDescription => 'Permite exigir versión mínima.';

  @override
  String get appUrlsTitle => 'URLs de la Aplicación';

  @override
  String get appUrlsDescription => 'Gestiona enlaces internos y externos.';

  @override
  String get communityAndEngagementTitle => 'Comunidad e Interacción';

  @override
  String get communityAndEngagementDescription =>
      'Configura comentarios y reportes.';

  @override
  String get userEngagementTitle => 'Interacción de Usuario';

  @override
  String get userEngagementDescription => 'Configura reacciones y comentarios.';

  @override
  String get contentReportingTitle => 'Reporte de Contenido';

  @override
  String get contentReportingDescription => 'Reglas para reportar contenido.';

  @override
  String get appReviewFunnelTitle => 'Reseñas de la App';

  @override
  String get appReviewFunnelDescription => 'Gestión de satisfacción y reseñas.';

  @override
  String get enableEngagementFeaturesLabel => 'Activar Interacción';

  @override
  String get enableEngagementFeaturesDescription =>
      'Activa reacciones y comentarios.';

  @override
  String get engagementModeLabel => 'Modo de Interacción';

  @override
  String get engagementModeDescription =>
      'Solo reacciones o también comentarios.';

  @override
  String get engagementModeReactionsOnly => 'Solo Reacciones';

  @override
  String get engagementModeReactionsAndComments => 'Reacciones y Comentarios';

  @override
  String get enableReportingSystemLabel => 'Activar Sistema de Reportes';

  @override
  String get enableReportingSystemDescription => 'Activa opciones de reporte.';

  @override
  String get enableHeadlineReportingLabel => 'Reporte de Titulares';

  @override
  String get enableSourceReportingLabel => 'Reporte de Fuentes';

  @override
  String get enableCommentReportingLabel => 'Reporte de Comentarios';

  @override
  String get enableAppFeedbackSystemLabel => 'Activar Feedback Interno';

  @override
  String get enableAppFeedbackSystemDescription =>
      'Pregunta si disfrutan la app.';

  @override
  String get interactionCycleThresholdLabel => 'Umbral de Interacción';

  @override
  String get interactionCycleThresholdDescription =>
      'Acciones positivas para el aviso.';

  @override
  String get initialPromptCooldownLabel => 'Enfriamiento Inicial (Días)';

  @override
  String get initialPromptCooldownDescription =>
      'Espera antes del primer aviso.';

  @override
  String get requestStoreReviewLabel => 'Pedir Reseña en Tienda';

  @override
  String get requestStoreReviewDescription =>
      'Si responden \'Sí\', pedir reseña.';

  @override
  String get requestWrittenFeedbackLabel => 'Pedir Feedback Escrito';

  @override
  String get requestWrittenFeedbackDescription =>
      'Si responden \'No\', pedir motivo.';

  @override
  String get internalPromptLogicTitle => 'Lógica de Avisos';

  @override
  String get eligiblePositiveInteractionsTitle => 'Interacciones Positivas';

  @override
  String get positiveInteractionTypeSaveItem => 'Guardar contenido';

  @override
  String get positiveInteractionTypeFollowItem => 'Seguir entidad';

  @override
  String get positiveInteractionTypeShareContent => 'Compartir contenido';

  @override
  String get positiveInteractionTypeSaveFilter => 'Crear filtro guardado';

  @override
  String get followUpActionsTitle => 'Acciones de Seguimiento';

  @override
  String get enableCommunityFeaturesLabel => 'Activar Funciones de Comunidad';

  @override
  String get enableCommunityFeaturesDescription =>
      'Activa interacción y reportes.';

  @override
  String get communityManagementPageDescription =>
      'Gestiona comentarios, reportes y reseñas.';

  @override
  String get engagements => 'Interacciones';

  @override
  String get reports => 'Reportes';

  @override
  String get appReviews => 'Reseñas';

  @override
  String get user => 'Usuario';

  @override
  String get engagedContent => 'Contenido';

  @override
  String get reaction => 'Reacción';

  @override
  String get comment => 'Comentario';

  @override
  String get commentStatus => 'Estado del Comentario';

  @override
  String get hasCommentFilterLabel => 'Contiene Comentario';

  @override
  String get hasCommentFilterDescription => 'Solo con texto.';

  @override
  String get date => 'Fecha';

  @override
  String get approveComment => 'Aprobar Comentario';

  @override
  String get rejectComment => 'Rechazar Comentario';

  @override
  String get viewEngagedContent => 'Ver Contenido';

  @override
  String get copyUserId => 'Copiar ID de Usuario';

  @override
  String get reporter => 'Informante';

  @override
  String get reportedItem => 'Elemento Reportado';

  @override
  String get reason => 'Motivo';

  @override
  String get reportStatus => 'Estado del Reporte';

  @override
  String get viewReportedItem => 'Ver Elemento';

  @override
  String get markAsInReview => 'Marcar en Revisión';

  @override
  String get resolveReport => 'Resolver Reporte';

  @override
  String get initialFeedback => 'Feedback Inicial';

  @override
  String get osPromptRequested => '¿Aviso de SO?';

  @override
  String get feedbackHistory => 'Historial';

  @override
  String get lastInteraction => 'Última Interacción';

  @override
  String get viewFeedbackHistory => 'Ver Historial';

  @override
  String get reactionTypeLike => 'Me gusta';

  @override
  String get reactionTypeInsightful => 'Interesante';

  @override
  String get reactionTypeAmusing => 'Divertido';

  @override
  String get reactionTypeSad => 'Triste';

  @override
  String get reactionTypeAngry => 'Enojado';

  @override
  String get reactionTypeSkeptical => 'Escéptico';

  @override
  String get initialAppReviewFeedbackPositive => 'Positivo';

  @override
  String get initialAppReviewFeedbackNegative => 'Negativo';

  @override
  String get filterCommunity => 'Filtrar Comunidad';

  @override
  String get searchByEngagementUser => 'Buscar por email...';

  @override
  String get searchByReportReporter => 'Buscar por informante...';

  @override
  String get searchByAppReviewUser => 'Buscar por email...';

  @override
  String get selectCommentStatus => 'Estado del Comentario';

  @override
  String get selectReportStatus => 'Estado del Reporte';

  @override
  String get selectInitialFeedback => 'Feedback Inicial';

  @override
  String get selectReportableEntity => 'Tipo de Elemento';

  @override
  String get reportableEntityHeadline => 'Titular';

  @override
  String get reportableEntitySource => 'Fuente';

  @override
  String get reportableEntityComment => 'Comentario';

  @override
  String get noEngagementsFound => 'Sin interacciones.';

  @override
  String get noReportsFound => 'Sin reportes.';

  @override
  String get noAppReviewsFound => 'Sin reseñas.';

  @override
  String get loadingEngagements => 'Cargando Interacciones';

  @override
  String get loadingReports => 'Cargando Reportes';

  @override
  String get loadingAppReviews => 'Cargando Reseñas';

  @override
  String get userIdCopied => 'ID de usuario copiado.';

  @override
  String get reportStatusUpdated => 'Estado actualizado.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Historial de $email';
  }

  @override
  String get noFeedbackHistory => 'Sin historial disponible.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback el: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get noReasonProvided => 'Sin motivo.';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Desinformación / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Título Clickbait';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Ofensivo / Odio';

  @override
  String get reportReasonSpamOrScam => 'Spam / Estafa';

  @override
  String get reportReasonBrokenLink => 'Enlace Roto';

  @override
  String get reportReasonPaywalled => 'Muro de Pago';

  @override
  String get reportReasonLowQualityJournalism => 'Baja Calidad';

  @override
  String get reportReasonHighAdDensity => 'Exceso de Publicidad';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Fuente Gubernamental';

  @override
  String get reportReasonAggregator => 'Agregador';

  @override
  String get reportReasonOther => 'Otro';

  @override
  String get reportReasonFrequentPaywalls => 'Muros de Pago Frecuentes';

  @override
  String get reportReasonImpersonation => 'Suplantación';

  @override
  String get noNegativeFeedbackHistory => 'Sin feedback negativo.';

  @override
  String get reject => 'Rechazar';

  @override
  String get commentStatusFlaggedByAi => 'Marcado por IA';

  @override
  String get cancel => 'Cancelar';

  @override
  String get rejectCommentConfirmation =>
      '¿Eliminar permanentemente este comentario?';

  @override
  String get searchByUserId => 'Buscar por ID...';

  @override
  String get viewReportedHeadline => 'Ver Titular';

  @override
  String get viewReportedSource => 'Ver Fuente';

  @override
  String get viewReportedComment => 'Ver Comentario';

  @override
  String get entityType => 'Tipo de Entidad';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Detalles del Feedback';

  @override
  String get moderationStatusPendingReview => 'Pendiente';

  @override
  String get moderationStatusResolved => 'Resuelto';

  @override
  String get hasComment => 'Tiene Comentario';

  @override
  String get any => 'Cualquiera';

  @override
  String get withComment => 'Con Comentario';

  @override
  String get withoutComment => 'Sin Comentario';

  @override
  String get reportResolved => 'Reporte resuelto.';

  @override
  String get commentApproved => 'Comentario aprobado.';

  @override
  String get commentRejected => 'Comentario rechazado.';

  @override
  String get copyHeadlineId => 'Copiar ID de Titular';

  @override
  String get copyReportedItemId => 'Copiar ID de Elemento';

  @override
  String get viewFeedbackDetails => 'Ver Detalles';

  @override
  String get reportDetails => 'Detalles del Reporte';

  @override
  String get commentDetails => 'Detalles del Comentario';

  @override
  String get communityManagement => 'Gestión de Comunidad';

  @override
  String get navContent => 'Contenido';

  @override
  String get navUsers => 'Usuarios';

  @override
  String get navCommunity => 'Comunidad';

  @override
  String get confirmPromotionTitle => 'Confirmar Ascenso';

  @override
  String confirmPromotionMessage(String email) {
    return '¿Ascender a $email a Editor?';
  }

  @override
  String get confirmDemotionTitle => 'Confirmar Degradación';

  @override
  String confirmDemotionMessage(String email) {
    return '¿Degradar a $email a usuario estándar?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Editor';

  @override
  String get breakingNewsHint => 'Titular de última hora';

  @override
  String get breakingNewsFilterDescription => 'Solo noticias de última hora';

  @override
  String publishItemTitle(String itemType) {
    return '¿Publicar $itemType?';
  }

  @override
  String publishItemContent(String itemType) {
    return '¿Publicar este $itemType? Será visible.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return '¿Archivar $itemType?';
  }

  @override
  String archiveItemContent(String itemType) {
    return '¿Archivar este $itemType? Se ocultará.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return '¿Restaurar $itemType?';
  }

  @override
  String restoreItemContent(String itemType) {
    return '¿Restaurar este $itemType? Será visible.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return '¿Eliminar $itemType?';
  }

  @override
  String deleteItemContent(String itemType) {
    return '¿Estás seguro de eliminar este $itemType?';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" eliminado.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Proveedor y IDs de anuncios.';

  @override
  String get feedAdSettingsDescription =>
      'Visibilidad y frecuencia en el feed.';

  @override
  String get navigationAdConfigDescription => 'Anuncios durante la navegación.';

  @override
  String get feedDecoratorLinkAccountDescription => 'Aviso para crear cuenta.';

  @override
  String get feedDecoratorUpgradeDescription => 'Aviso para mejorar plan.';

  @override
  String get feedDecoratorRateAppDescription => 'Aviso para valorar la app.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Aviso para notificaciones.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Muestra temas sugeridos.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Muestra fuentes sugeridas.';

  @override
  String get enableGlobalAdsDescription =>
      'Activa o desactiva toda la publicidad.';

  @override
  String get enableFeedAdsDescription => 'Controla anuncios en el feed.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'Activo para usuarios con rol \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription => 'Activa este decorador globalmente.';

  @override
  String get enableNavigationAdsDescription =>
      'Anuncios al navegar entre páginas.';

  @override
  String get enableHeadlineReportingDescription =>
      'Permite reportar titulares.';

  @override
  String get enableSourceReportingDescription => 'Permite reportar fuentes.';

  @override
  String get enableCommentReportingDescription =>
      'Permite reportar comentarios.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Alertas de última hora.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Resumen diario.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Resumen semanal.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Al guardar un titular.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Al seguir un tema o fuente.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Al compartir contenido.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Al crear un filtro.';

  @override
  String get internalPromptLogicDescription =>
      'Condiciones para el aviso de disfrute.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Acciones que cuentan como positivas.';

  @override
  String get followUpActionsDescription => 'Acciones tras responder al aviso.';

  @override
  String get analyticsTab => 'Analíticas';

  @override
  String get analyticsDescription => 'Configura el rastreo de eventos.';

  @override
  String get analyticsSystemStatusTitle => 'Activar Analíticas';

  @override
  String get analyticsSystemStatusDescription =>
      'Interruptor maestro de rastreo.';

  @override
  String get analyticsProviderTitle => 'Proveedor Activo';

  @override
  String get analyticsProviderDescription =>
      'Servicio de analíticas principal.';

  @override
  String get analyticsEventsTitle => 'Configuración de Eventos';

  @override
  String get analyticsEventsDescription =>
      'Ajusta el registro de eventos específicos.';

  @override
  String samplingRateLabel(int rate) {
    return 'Tasa de muestreo: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'Registro de Usuario';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'Rastrea nuevos registros.';

  @override
  String get analyticsEventUserLoginLabel => 'Inicio de Sesión';

  @override
  String get analyticsEventUserLoginDescription => 'Rastrea accesos.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Cuenta Vinculada';

  @override
  String get analyticsEventAccountLinkedDescription => 'Rastrea vinculaciones.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'Cambio de Rol';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Rastrea cambios de nivel.';

  @override
  String get analyticsEventContentViewedLabel => 'Contenido Visto';

  @override
  String get analyticsEventContentViewedDescription => 'Rastrea lecturas.';

  @override
  String get analyticsEventContentSharedLabel => 'Contenido Compartido';

  @override
  String get analyticsEventContentSharedDescription =>
      'Rastrea comparticiones.';

  @override
  String get analyticsEventContentSavedLabel => 'Contenido Guardado';

  @override
  String get analyticsEventContentSavedDescription => 'Rastrea marcadores.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Contenido Eliminado';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Rastrea eliminación de marcadores.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Tiempo de Lectura';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'Rastrea duración de lectura.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Reacción Añadida';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Rastrea nuevas reacciones.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Reacción Eliminada';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Rastrea eliminación de reacciones.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Comentario Publicado';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Rastrea nuevos comentarios.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Comentario Eliminado';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Rastrea eliminación de comentarios.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Reporte Enviado';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Rastrea reportes de usuarios.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'Filtro Creado';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Rastrea creación de filtros.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'Filtro Actualizado';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Rastrea cambios en filtros.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Filtro Usado';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Rastrea aplicación de filtros.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Búsqueda Realizada';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'Rastrea consultas de búsqueda.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel => 'Respuesta a Aviso';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Rastrea respuesta a \'¿Disfrutas la app?\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Reseña en Tienda Pedida';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Rastrea peticiones de reseña oficial.';

  @override
  String get analyticsEventLimitExceededLabel => 'Límite Excedido';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Rastrea cuando se alcanza un límite.';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel =>
      'Clic en CTA de Límite';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Rastrea clics en \'Mejorar\'.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Muro de Pago Visto';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Rastrea impresiones del muro de pago.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Suscripción Iniciada';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Rastrea nuevas compras.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Suscripción Renovada';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'Rastrea renovaciones.';

  @override
  String get analyticsEventSubscriptionCancelledLabel =>
      'Suscripción Cancelada';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Rastrea cancelaciones.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Suscripción Finalizada';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'Rastrea expiraciones.';

  @override
  String get analyticsEventAdImpressionLabel => 'Impresión de Anuncio';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Rastrea visualización de ads.';

  @override
  String get analyticsEventAdClickedLabel => 'Clic en Anuncio';

  @override
  String get analyticsEventAdClickedDescription => 'Rastrea clics en ads.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Error de Carga de Ad';

  @override
  String get analyticsEventAdLoadFailedDescription => 'Rastrea fallos en ads.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Recompensa Ganada';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Rastrea ads bonificados completados.';

  @override
  String get analyticsEventThemeChangedLabel => 'Cambio de Tema';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Rastrea cambios visuales.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Cambio de Idioma';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Rastrea cambios de idioma.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Cambio de Densidad';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Rastrea ajustes del feed.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'Cambio de Navegador';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Rastrea preferencia de enlaces.';

  @override
  String get analyticsEventAppTourStartedLabel => 'Tour Iniciado';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'Rastrea inicio del tour.';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'Paso del Tour Visto';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'Rastrea vistas del tour.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'Tour Completado';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'Rastrea fin del tour.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'Tour Omitido';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'Rastrea si se salta el tour.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'Personalización Iniciada';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'Rastrea inicio de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'Paso de Onboarding Visto';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'Rastrea pasos de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'Personalización Completada';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'Rastrea fin de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'Personalización Omitida';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'Rastrea si se salta el onboarding.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7D';

  @override
  String get timeFrameMonth => '30D';

  @override
  String get timeFrameYear => '1A';

  @override
  String get noDataAvailable => 'Sin datos';

  @override
  String get vsPreviousPeriod => 'vs periodo anterior';

  @override
  String get vsPreviousDay => 'vs últimas 24h';

  @override
  String get vsPreviousWeek => 'vs últimos 7 días';

  @override
  String get vsPreviousMonth => 'vs últimos 30 días';

  @override
  String get vsPreviousYear => 'vs año anterior';

  @override
  String get kpiUsersTotalRegistered => 'Usuarios Registrados';

  @override
  String get kpiUsersNewRegistrations => 'Nuevos Registros';

  @override
  String get kpiUsersActiveUsers => 'Usuarios Activos';

  @override
  String get kpiContentHeadlinesTotalPublished => 'Titulares Publicados';

  @override
  String get kpiContentHeadlinesTotalViews => 'Vistas de Titulares';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Likes en Titulares';

  @override
  String get kpiContentSourcesTotalSources => 'Total Fuentes';

  @override
  String get kpiContentSourcesNewSources => 'Nuevas Fuentes';

  @override
  String get kpiContentSourcesTotalFollowers => 'Seguidores de Fuentes';

  @override
  String get kpiContentTopicsTotalTopics => 'Total Temas';

  @override
  String get kpiContentTopicsNewTopics => 'Nuevos Temas';

  @override
  String get kpiContentTopicsTotalFollowers => 'Seguidores de Temas';

  @override
  String get kpiEngagementsTotalReactions => 'Total Reacciones';

  @override
  String get kpiEngagementsTotalComments => 'Total Comentarios';

  @override
  String get kpiEngagementsAverageEngagementRate => 'Tasa de Interacción Media';

  @override
  String get kpiEngagementsReportsPending => 'Reportes Pendientes';

  @override
  String get kpiEngagementsReportsResolved => 'Reportes Resueltos';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Tiempo Medio de Resolución';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Total Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Feedback Positivo';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Peticiones de Reseña';

  @override
  String get chartUsersRegistrationsOverTime => 'Registros en el Tiempo';

  @override
  String get chartUsersActiveUsersOverTime => 'Tendencia de Activos';

  @override
  String get chartUsersRoleDistribution => 'Distribución por Rol';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Tendencia de Vistas';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Tendencia de Likes';

  @override
  String get chartContentHeadlinesViewsByTopic => 'Vistas por Tema';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime =>
      'Actividad de Fuentes';

  @override
  String get chartContentSourcesFollowersOverTime => 'Crecimiento de Fuentes';

  @override
  String get chartContentSourcesEngagementByType => 'Interacción por Tipo';

  @override
  String get chartContentTopicsFollowersOverTime => 'Crecimiento de Temas';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime =>
      'Actividad de Temas';

  @override
  String get chartContentTopicsEngagementByTopic => 'Interacción por Tema';

  @override
  String get chartEngagementsReactionsOverTime => 'Tendencia de Reacciones';

  @override
  String get chartEngagementsCommentsOverTime => 'Tendencia de Comentarios';

  @override
  String get chartEngagementsReactionsByType => 'Distribución de Reacciones';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'Reportes Enviados';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'Tendencia de Resolución';

  @override
  String get chartEngagementsReportsByReason => 'Reportes por Motivo';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime =>
      'Tendencia de Feedback';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Análisis de Sentimiento';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Tendencia de Peticiones';

  @override
  String get chartContentSourcesStatusDistribution => 'Distribución de Estado';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'Noticias de Última Hora';

  @override
  String get chartOverviewAppTourFunnel => 'Embudo del Tour';

  @override
  String get chartOverviewInitialPersonalizationFunnel =>
      'Embudo de Onboarding';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'Titulares Más Vistos';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'Titulares Más Gustados';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'Fuentes Más Seguidas';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Temas Más Seguidos';

  @override
  String get subscriptionTab => 'Suscripciones';

  @override
  String get subscriptionDescription => 'Configura los planes de suscripción.';

  @override
  String get enableSubscriptionLabel => 'Activar Suscripciones';

  @override
  String get enableSubscriptionDescription =>
      'Permite a los usuarios mejorar su nivel.';

  @override
  String get monthlyPlanTitle => 'Plan Mensual';

  @override
  String get annualPlanTitle => 'Plan Anual';

  @override
  String get planEnabledLabel => 'Plan Activado';

  @override
  String get planRecommendedLabel => 'Plan Recomendado';

  @override
  String get planRecommendedDescription =>
      'Destaca este plan como mejor opción.';

  @override
  String get appleProductIdLabel => 'ID Producto Apple App Store';

  @override
  String get googleProductIdLabel => 'ID Producto Google Play Store';

  @override
  String get subscriptionPlanEnablementError =>
      'Introduce al menos un ID de producto.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Plan desactivado por falta de IDs.';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Suscripciones desactivadas.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Notificaciones desactivadas.';

  @override
  String get analyticsFeatureDisabledNotification => 'Analíticas desactivadas.';

  @override
  String get reportingFeatureDisabledNotification => 'Reportes desactivados.';

  @override
  String get appReviewFeatureDisabledNotification => 'Reseñas desactivadas.';

  @override
  String get subscriptionsName => 'Suscripciones';

  @override
  String get subscriptionProvider => 'Proveedor';

  @override
  String get accessTier => 'Nivel de Acceso';

  @override
  String get expiryDate => 'Fecha de Expiración';

  @override
  String get willAutoRenew => 'Auto-renovación';

  @override
  String get allAccessTiers => 'Todos los Niveles';

  @override
  String get subscriptionActionCopyUserId => 'Copiar ID de Usuario';

  @override
  String get subscriptionActionCopySubscriptionId => 'Copiar ID de Suscripción';

  @override
  String get filterSubscriptions => 'Filtrar Suscripciones';

  @override
  String get selectStatus => 'Estado';

  @override
  String get selectProvider => 'Proveedor';

  @override
  String get selectTier => 'Nivel';

  @override
  String get noSubscriptionsFound => 'Sin suscripciones.';

  @override
  String get loadingSubscriptions => 'Cargando Suscripciones';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Buscar por ID de Usuario o Suscripción...';

  @override
  String get subscriptionsPageDescription =>
      'Monitoreo de suscripciones (solo lectura).';

  @override
  String get subscriptionStatusActive => 'Activo';

  @override
  String get subscriptionStatusGracePeriod => 'Periodo de Gracia';

  @override
  String get subscriptionStatusBillingIssue => 'Problema de Facturación';

  @override
  String get subscriptionStatusCanceled => 'Cancelado';

  @override
  String get subscriptionStatusExpired => 'Expirado';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'Suscripciones Activas';

  @override
  String get chartSubscriptionsStatusDistribution => 'Distribución de Estados';

  @override
  String get chartSubscriptionsByStoreProvider => 'Suscripciones por Tienda';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Total Anuncios Vistos';

  @override
  String get kpiRewardsActiveUsersCount => 'Usuarios con Recompensa';

  @override
  String get rewardsTab => 'Recompensas';

  @override
  String get rewardsDescription => 'Configura recompensas por interacción.';

  @override
  String get enableRewardsLabel => 'Activar Recompensas';

  @override
  String get enableRewardsDescription => 'Permite ganar premios viendo ads.';

  @override
  String get rewardTypeAdFree => 'Experiencia Sin Anuncios';

  @override
  String get rewardDurationDaysLabel => 'Duración (Días)';

  @override
  String get rewardEnabledLabel => 'Activado';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Tendencia de Anuncios Vistos';

  @override
  String get chartRewardsActiveByType => 'Recompensas Activas por Tipo';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Aviso para desbloquear funciones.';

  @override
  String get rewardDurationDaysDescription => 'Días que dura la recompensa.';

  @override
  String get rewardsManagement => 'Gestión de Recompensas';

  @override
  String get rewardsManagementPageDescription =>
      'Gestiona premios de usuarios.';

  @override
  String get loadingRewards => 'Cargando Recompensas';

  @override
  String get noRewardsFound => 'Sin recompensas.';

  @override
  String get userId => 'ID de Usuario';

  @override
  String get activeRewards => 'Recompensas Activas';

  @override
  String get expiry => 'Expiración';

  @override
  String get filterRewards => 'Filtrar Recompensas';

  @override
  String get rewardType => 'Tipo de Recompensa';

  @override
  String get selectRewardTypes => 'Tipos de Recompensa';

  @override
  String get loadingAnalytics => 'Cargando Analíticas';

  @override
  String get noAnalyticsDataHeadline => 'Sin Datos de Analíticas';

  @override
  String get noAnalyticsDataSubheadline => 'No hay datos para mostrar todavía.';

  @override
  String get androidAdUnitsTitle => 'Unidades Android';

  @override
  String get iosAdUnitsTitle => 'Unidades iOS';

  @override
  String get rewardedAdIdLabel => 'ID Anuncio Bonificado';

  @override
  String get rewardedAdIdDescription => 'ID para anuncios con premio.';

  @override
  String get kpiRewardsGrantedTotal => 'Total Premios Otorgados';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'Hub de Recompensas Visto';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'Rastrea visitas al hub.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'Oferta Clicada';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'Rastrea clics en ofertas.';

  @override
  String get analyticsEventRewardGrantedLabel => 'Recompensa Otorgada';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'Rastrea premios entregados.';

  @override
  String get chartRewardsGrantedOverTime => 'Tendencia de Premios';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'Personalización Inicial';

  @override
  String get initialPersonalizationDescription =>
      'Configura el flujo de bienvenida.';

  @override
  String get enableInitialPersonalizationLabel => 'Activar Personalización';

  @override
  String get enableInitialPersonalizationDescription =>
      'Guía a nuevos usuarios.';

  @override
  String get enableCountrySelectionLabel => 'Selección de País';

  @override
  String get enableCountrySelectionDescription =>
      'Permite elegir país al inicio.';

  @override
  String get enableTopicSelectionLabel => 'Selección de Temas';

  @override
  String get enableTopicSelectionDescription =>
      'Permite elegir temas al inicio.';

  @override
  String get enableSourceSelectionLabel => 'Selección de Fuentes';

  @override
  String get enableSourceSelectionDescription =>
      'Permite elegir fuentes al inicio.';

  @override
  String get minSelectionsRequiredLabel => 'Selecciones Mínimas';

  @override
  String get minSelectionsRequiredDescription =>
      'Elementos necesarios para continuar.';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingDescription => 'Gestiona la primera experiencia.';

  @override
  String get enableOnboardingLabel => 'Activar Onboarding';

  @override
  String get enableOnboardingDescription =>
      'Interruptor maestro de bienvenida.';

  @override
  String get appTourTitle => 'Tour de la App';

  @override
  String get appTourDescription => 'Configura el tour previo al login.';

  @override
  String get enableAppTourLabel => 'Activar Tour';

  @override
  String get enableAppTourDescription => 'Muestra funciones antes de entrar.';

  @override
  String get skippableAppTourLabel => 'Tour Omitible';

  @override
  String get skippableAppTourDescription => 'Permite saltar el tour.';

  @override
  String get skippableInitialPersonalizationLabel => 'Personalización Omitible';

  @override
  String get skippableInitialPersonalizationDescription =>
      'Permite saltar onboarding.';

  @override
  String get filePickingErrorMessage => 'Error al seleccionar el archivo.';

  @override
  String get removeImage => 'Quitar imagen';

  @override
  String get clickToUploadImage => 'Clic para subir imagen';

  @override
  String get processingImage => 'Procesando Imagen...';

  @override
  String get processingImageDescription => 'Optimizando imagen...';

  @override
  String get chartMediaUploadsOverTime => 'Subidas en el Tiempo';

  @override
  String get chartMediaUploadsByPurpose => 'Subidas por Propósito';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'Éxito vs Fallo';

  @override
  String get kpiMediaTotalUploads => 'Total Subidas';

  @override
  String get kpiMediaFailedUploads => 'Subidas Fallidas';

  @override
  String get kpiMediaAverageUploadTime => 'Tiempo Medio (s)';

  @override
  String get updateHeadlineTitle => 'Actualizar Titular';

  @override
  String get updateHeadlineMessage => '¿Publicar cambios o guardar borrador?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'Subida Iniciada';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'Rastrea inicio de subida.';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'Subida Completada';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'Rastrea éxito de subida.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'Subida Fallida';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'Rastrea fallos de subida.';

  @override
  String get dashboard => 'Panel';

  @override
  String get aboutOverviewPageTitle => 'Sobre el Resumen';

  @override
  String get aboutOverviewPageDescription =>
      'Métricas clave actualizadas periódicamente.';

  @override
  String get audience => 'Audiencia';

  @override
  String get content => 'Contenido';

  @override
  String get community => 'Comunidad';

  @override
  String get monetization => 'Monetización';

  @override
  String get configuration => 'Configuración';

  @override
  String get loadingConfiguration => 'Cargando Configuración...';

  @override
  String get noConfigurationDataHeadline => 'Sin Datos';

  @override
  String get noConfigurationDataSubheadline =>
      'Error al cargar configuración remota.';

  @override
  String get readOnlyConfigurationView => 'Vista de Solo Lectura';

  @override
  String get readOnlyConfigurationViewDescription =>
      'Instantánea en tiempo real.';

  @override
  String get providers => 'Proveedores';

  @override
  String get summary => 'Resumen';

  @override
  String get about => 'Acerca de';

  @override
  String get localizationConfigDescription =>
      'Idiomas soportados y predeterminado.';

  @override
  String get enabledLanguagesLabel => 'Idiomas Activados';

  @override
  String get cannotDisableDefaultLanguage =>
      'No puedes desactivar el predeterminado.';

  @override
  String get atLeastOneLanguageRequired => 'Se requiere al menos un idioma.';

  @override
  String get defaultLanguageLabel => 'Idioma Predeterminado';

  @override
  String get defaultLanguageDescription => 'Idioma de respaldo.';

  @override
  String get localizationTitle => 'Localización';

  @override
  String get localizationDescription => 'Controla los idiomas activos.';

  @override
  String defaultLanguageRequired(String language) {
    return 'El idioma ($language) es obligatorio.';
  }

  @override
  String get languageNameEn => 'Inglés';

  @override
  String get languageNameEs => 'Español';

  @override
  String get languageNameFr => 'Francés';

  @override
  String get languageNameAr => 'Árabe';

  @override
  String get languageNamePt => 'Portugués';

  @override
  String get languageNameDe => 'Alemán';

  @override
  String get languageNameIt => 'Italiano';

  @override
  String get languageNameZh => 'Chino';

  @override
  String get languageNameHi => 'Hindi';

  @override
  String get languageNameJa => 'Japonés';
}
