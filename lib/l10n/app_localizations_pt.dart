// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get authenticationPageHeadline => 'Acesso ao Painel';

  @override
  String get authenticationPageSubheadline =>
      'Login seguro para administradores e editores.';

  @override
  String get authenticationEmailSignInButton => 'Entrar com E-mail';

  @override
  String get emailSignInPageTitle => 'Login Seguro por E-mail';

  @override
  String get requestCodePageHeadline => 'Login Seguro por E-mail';

  @override
  String get requestCodePageSubheadline =>
      'Digite seu e-mail para receber um código.';

  @override
  String get requestCodeEmailLabel => 'E-mail';

  @override
  String get requestCodeEmailHint => 'seu.email@exemplo.com';

  @override
  String get accountLinkingEmailValidationError =>
      'Por favor, insira um e-mail válido.';

  @override
  String get requestCodeSendCodeButton => 'Enviar Código';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return 'Reenviar em ${seconds}s';
  }

  @override
  String get emailCodeSentPageTitle => 'Verificar Código';

  @override
  String emailCodeSentConfirmation(String email) {
    return 'Enviamos um código de 6 dígitos para $email';
  }

  @override
  String get emailCodeSentInstructions =>
      'Verifique sua caixa de entrada e insira o código.';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'No modo demo, use: $code';
  }

  @override
  String get emailCodeVerificationHint => 'Código de 6 dígitos';

  @override
  String get emailCodeValidationEmptyError => 'O código não pode estar vazio.';

  @override
  String get emailCodeValidationLengthError => 'O código deve ter 6 dígitos.';

  @override
  String get emailCodeVerificationButtonLabel => 'Verificar Código';

  @override
  String get overview => 'Visão Geral';

  @override
  String get contentManagement => 'Gestão de Conteúdo';

  @override
  String get contentManagementPageDescription =>
      'Gerencie manchetes, tópicos e fontes.';

  @override
  String get headlines => 'Manchetes';

  @override
  String get headline => 'Manchete';

  @override
  String get topics => 'Tópicos';

  @override
  String get topic => 'Tópico';

  @override
  String get sources => 'Fontes';

  @override
  String get source => 'Fonte';

  @override
  String get appConfiguration => 'Config. Remota';

  @override
  String get appConfigurationPageDescription =>
      'Configurações globais do aplicativo móvel.';

  @override
  String get settings => 'Configurações';

  @override
  String get appConfigurationPageTitle => 'Configuração Remota';

  @override
  String get feedTab => 'Feed';

  @override
  String get advertisementsTab => 'Publicidade';

  @override
  String get systemTab => 'Sistema';

  @override
  String get userContentLimitsTitle => 'Limites de Conteúdo';

  @override
  String get userContentLimitsDescription =>
      'Limites de itens seguidos e salvos por nível.';

  @override
  String get feedActionsTitle => 'Ações do Feed';

  @override
  String get feedActionsDescription => 'Frequência de widgets de ação no feed.';

  @override
  String get feedDecoratorsTitle => 'Decoradores do Feed';

  @override
  String get feedDecoratorsDescription =>
      'Apresentação visual no feed por função.';

  @override
  String get adSettingsTitle => 'Configurações de Anúncios';

  @override
  String get adSettingsDescription =>
      'Gerencie frequência e posicionamento de anúncios.';

  @override
  String get maintenanceModeTitle => 'Modo Manutenção';

  @override
  String get maintenanceModeDescription => 'Ativar tela de manutenção global.';

  @override
  String get forceUpdateTitle => 'Atualização Forçada';

  @override
  String get forceUpdateDescription => 'Configurar atualizações obrigatórias.';

  @override
  String get forceUpdateTab => 'Atualização';

  @override
  String get appConfigSaveSuccessMessage => 'Configuração salva com sucesso.';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'Erro: $errorMessage';
  }

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get loadingConfigurationHeadline => 'Carregando Configuração';

  @override
  String get loadingConfigurationSubheadline => 'Por favor, aguarde...';

  @override
  String get failedToLoadConfigurationMessage =>
      'Falha ao carregar configuração.';

  @override
  String get loadAppSettingsSubheadline => 'Carregar configurações do backend.';

  @override
  String get discardChangesButton => 'Descartar Alterações';

  @override
  String get saveChangesButton => 'Salvar Alterações';

  @override
  String get confirmConfigUpdateDialogTitle => 'Confirmar Atualização';

  @override
  String get confirmConfigUpdateDialogContent =>
      'Aplicar alterações no app ao vivo?';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get confirmSaveButton => 'Confirmar Salvamento';

  @override
  String get guestUserTab => 'Convidado';

  @override
  String get authenticatedUserTab => 'Autenticado';

  @override
  String get premiumUserTab => 'Premium';

  @override
  String get guestFollowedItemsLimitLabel => 'Limite de Seguidos (Convidado)';

  @override
  String get guestFollowedItemsLimitDescription =>
      'Máximo de tópicos ou fontes seguidas.';

  @override
  String get guestSavedHeadlinesLimitLabel => 'Limite de Salvos (Convidado)';

  @override
  String get guestSavedHeadlinesLimitDescription =>
      'Máximo de manchetes salvas.';

  @override
  String get standardUserFollowedItemsLimitLabel =>
      'Limite de Seguidos (Padrão)';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      'Limite para usuários padrão.';

  @override
  String get standardUserSavedHeadlinesLimitLabel =>
      'Limite de Salvos (Padrão)';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      'Limite para usuários padrão.';

  @override
  String get premiumFollowedItemsLimitLabel => 'Limite de Seguidos (Premium)';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'Limite para usuários premium.';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'Limite de Salvos (Premium)';

  @override
  String get premiumSavedHeadlinesLimitDescription =>
      'Limite para usuários premium.';

  @override
  String get standardUserAdTab => 'Usuário Padrão';

  @override
  String get guestAdFrequencyLabel => 'Frequência de Anúncios (Convidado)';

  @override
  String get guestAdFrequencyDescription => 'Anúncios a cada X itens do feed.';

  @override
  String get guestAdPlacementIntervalLabel => 'Intervalo Inicial (Convidado)';

  @override
  String get guestAdPlacementIntervalDescription =>
      'Itens antes do primeiro anúncio.';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'Artigos p/ Intersticial';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      'Leituras antes do anúncio.';

  @override
  String get standardUserAdFrequencyLabel => 'Frequência (Padrão)';

  @override
  String get standardUserAdFrequencyDescription =>
      'Frequência para usuários padrão.';

  @override
  String get standardUserAdPlacementIntervalLabel => 'Intervalo (Padrão)';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      'Intervalo para padrão.';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      'Artigos (Padrão)';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      'Leituras para padrão.';

  @override
  String get premiumAdFrequencyLabel => 'Frequência (Premium)';

  @override
  String get premiumAdFrequencyDescription =>
      'Frequência para premium (0 = sem ads).';

  @override
  String get premiumAdPlacementIntervalLabel => 'Intervalo (Premium)';

  @override
  String get premiumAdPlacementIntervalDescription => 'Intervalo para premium.';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'Artigos (Premium)';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      'Leituras para premium.';

  @override
  String get appOperationalStatusWarning => 'AVISO: Afeta todos os usuários.';

  @override
  String get appOperationalStatusLabel => 'Status Operacional';

  @override
  String get appOperationalStatusDescription =>
      'Status atual (ativo, manutenção).';

  @override
  String get maintenanceMessageLabel => 'Mensagem de Manutenção';

  @override
  String get maintenanceMessageDescription => 'Mensagem exibida na manutenção.';

  @override
  String get disabledMessageLabel => 'Mensagem de Desativação';

  @override
  String get disabledMessageDescription =>
      'Mensagem se o app estiver desativado.';

  @override
  String get forceUpdateConfigurationTitle => 'Configuração de Atualização';

  @override
  String get minAllowedAppVersionLabel => 'Versão Mínima Permitida';

  @override
  String get minAllowedAppVersionDescription =>
      'Versão mais baixa permitida (ex: 1.2.0).';

  @override
  String get latestAppVersionLabel => 'Última Versão';

  @override
  String get latestAppVersionDescription => 'Versão mais recente (ex: 1.5.0).';

  @override
  String get updateRequiredMessageLabel =>
      'Mensagem de Atualização Obrigatória';

  @override
  String get updateRequiredMessageDescription =>
      'Mensagem para forçar atualização.';

  @override
  String get updateOptionalMessageLabel => 'Mensagem de Atualização Opcional';

  @override
  String get updateOptionalMessageDescription =>
      'Mensagem para atualização opcional.';

  @override
  String get iosStoreUrlLabel => 'URL App Store (iOS)';

  @override
  String get iosStoreUrlDescription => 'Link para a loja da Apple.';

  @override
  String get androidStoreUrlLabel => 'URL Play Store (Android)';

  @override
  String get androidUpdateUrlDescription => 'Link para a loja do Google.';

  @override
  String get guestDaysBetweenInAppPromptsLabel =>
      'Dias entre Avisos (Convidado)';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'Dias mínimos entre avisos.';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      'Dias entre Avisos (Padrão)';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      'Dias para padrão.';

  @override
  String get signOut => 'Sair';

  @override
  String get settingsSavedSuccessfully => 'Configurações salvas!';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return 'Erro ao salvar: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => 'Carregando Configurações';

  @override
  String get loadingSettingsSubheadline => 'Por favor, aguarde...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return 'Falha ao carregar: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'Tema Base';

  @override
  String get baseThemeDescription => 'Aparência clara ou escura.';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get systemTheme => 'Padrão do Sistema';

  @override
  String get accentThemeLabel => 'Cor de Destaque';

  @override
  String get accentThemeDescription =>
      'Cor principal para elementos interativos.';

  @override
  String get defaultBlueTheme => 'Azul Padrão';

  @override
  String get newsRedTheme => 'Vermelho Notícias';

  @override
  String get graphiteGrayTheme => 'Cinza Grafite';

  @override
  String get fontFamilyLabel => 'Fonte';

  @override
  String get fontFamilyDescription => 'Tipografia do aplicativo.';

  @override
  String get systemDefaultFont => 'Padrão';

  @override
  String get textScaleFactorLabel => 'Tamanho do Texto';

  @override
  String get textScaleFactorDescription => 'Ajusta o tamanho da fonte.';

  @override
  String get smallText => 'Pequeno';

  @override
  String get mediumText => 'Médio';

  @override
  String get largeText => 'Grande';

  @override
  String get extraLargeText => 'Muito Grande';

  @override
  String get fontWeightLabel => 'Espessura da Fonte';

  @override
  String get fontWeightDescription => 'Espessura do texto.';

  @override
  String get lightFontWeight => 'Leve';

  @override
  String get regularFontWeight => 'Regular';

  @override
  String get boldFontWeight => 'Negrito';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get languageDescription => 'Selecione o idioma do painel.';

  @override
  String get edit => 'Editar';

  @override
  String get englishLanguage => 'Inglês';

  @override
  String get arabicLanguage => 'Árabe';

  @override
  String get appearanceSettingsLabel => 'Aparência';

  @override
  String get languageSettingsLabel => 'Idioma';

  @override
  String get themeSettingsLabel => 'Configurações de Tema';

  @override
  String get fontSettingsLabel => 'Configurações de Fonte';

  @override
  String get settingsPageDescription =>
      'Configure suas preferências visuais e de idioma.';

  @override
  String get appearanceSettingsDescription =>
      'Ajuste tema, cores e tipografia.';

  @override
  String get loadingHeadlines => 'Carregando Manchetes';

  @override
  String get pleaseWait => 'Aguarde...';

  @override
  String get noHeadlinesFound => 'Nenhuma manchete encontrada.';

  @override
  String get headlineTitle => 'Título';

  @override
  String get excerpt => 'Resumo';

  @override
  String get countryName => 'País';

  @override
  String get publishedAt => 'Publicado em';

  @override
  String get actions => 'Ações';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get loadingTopics => 'Carregando Tópicos';

  @override
  String get noTopicsFound => 'Nenhum tópico encontrado.';

  @override
  String get topicName => 'Tópico';

  @override
  String get description => 'Descrição';

  @override
  String get notAvailable => 'N/D';

  @override
  String get loadingSources => 'Carregando Fontes';

  @override
  String get noSourcesFound => 'Nenhuma fonte encontrada.';

  @override
  String get sourceName => 'Fonte';

  @override
  String get sourceType => 'Tipo';

  @override
  String get language => 'Idioma';

  @override
  String get editTopic => 'Editar Tópico';

  @override
  String get saveChanges => 'Salvar Alterações';

  @override
  String get loadingTopic => 'Carregando Tópico';

  @override
  String get icon => 'Ícone';

  @override
  String get topicUpdatedSuccessfully => 'Tópico atualizado.';

  @override
  String get cannotUpdateTopicError => 'Erro: Dados originais não carregados.';

  @override
  String get createTopic => 'Criar Tópico';

  @override
  String get topicCreatedSuccessfully => 'Tópico criado.';

  @override
  String get editSource => 'Editar Fonte';

  @override
  String get sourceUpdatedSuccessfully => 'Fonte atualizada.';

  @override
  String get loadingSource => 'Carregando Fonte...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => 'Sede';

  @override
  String get none => 'Nenhum';

  @override
  String get cannotUpdateSourceError => 'Erro: Dados originais não carregados.';

  @override
  String get sourceTypeNewsAgency => 'Agência de Notícias';

  @override
  String get sourceTypeLocalNewsOutlet => 'Mídia Local';

  @override
  String get sourceTypeNationalNewsOutlet => 'Mídia Nacional';

  @override
  String get sourceTypeInternationalNewsOutlet => 'Mídia Internacional';

  @override
  String get sourceTypeSpecializedPublisher => 'Editor Especializado';

  @override
  String get sourceTypeBlog => 'Blog';

  @override
  String get sourceTypeGovernmentSource => 'Fonte Governamental';

  @override
  String get sourceTypeAggregator => 'Agregador';

  @override
  String get sourceTypeOther => 'Outro';

  @override
  String get editHeadline => 'Editar Manchete';

  @override
  String get headlineUpdatedSuccessfully => 'Manchete atualizada.';

  @override
  String get loadingHeadline => 'Carregando Manchete...';

  @override
  String get image => 'Imagem';

  @override
  String get cannotUpdateHeadlineError =>
      'Erro: Dados originais não carregados.';

  @override
  String get createHeadline => 'Criar Manchete';

  @override
  String get headlineCreatedSuccessfully => 'Manchete criada.';

  @override
  String get loadingData => 'Carregando dados...';

  @override
  String get loadingFullList => 'Carregando lista completa...';

  @override
  String get createSource => 'Criar Fonte';

  @override
  String get updateSourceTitle => 'Atualizar Fonte';

  @override
  String get updateSourceMessage =>
      'Publicar alterações ou salvar como rascunho?';

  @override
  String get sourceCreatedSuccessfully => 'Fonte criada.';

  @override
  String get updateTopicTitle => 'Atualizar Tópico';

  @override
  String get status => 'Status';

  @override
  String get updateTopicMessage =>
      'Publicar alterações ou salvar como rascunho?';

  @override
  String get lastUpdated => 'Última Atualização';

  @override
  String get contentStatusActive => 'Ativo';

  @override
  String get contentStatusArchived => 'Arquivado';

  @override
  String get contentStatusDraft => 'Rascunho';

  @override
  String get totalHeadlines => 'Total Manchetes';

  @override
  String get totalTopics => 'Total Tópicos';

  @override
  String get totalSources => 'Total Fontes';

  @override
  String get loadingOverview => 'Carregando Visão Geral...';

  @override
  String get loadingOverviewSubheadline => 'Obtendo estatísticas...';

  @override
  String get overviewLoadFailure => 'Falha ao carregar visão geral.';

  @override
  String get recentHeadlines => 'Manchetes Recentes';

  @override
  String get viewAll => 'Ver Tudo';

  @override
  String get noRecentHeadlines => 'Nenhuma manchete recente.';

  @override
  String get systemStatus => 'Status do Sistema';

  @override
  String get quickActions => 'Ações Rápidas';

  @override
  String get createHeadlineAction => 'Criar Manchete';

  @override
  String get manageContentAction => 'Gerenciar Conteúdo';

  @override
  String get appConfigAction => 'Config. do App';

  @override
  String get appStatusActive => 'Ativo';

  @override
  String get appStatusDisabled => 'Desativado';

  @override
  String demoEmailHint(String email) {
    return 'Para demo, use: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'Para demo, use: $code';
  }

  @override
  String get appStatusMaintenance => 'Manutenção';

  @override
  String get appStatusOperational => 'Operacional';

  @override
  String get isUnderMaintenanceLabel => 'Em Manutenção';

  @override
  String get isUnderMaintenanceDescription => 'Ativa o modo de manutenção.';

  @override
  String get isLatestVersionOnlyLabel => 'Forçar Última Versão';

  @override
  String get isLatestVersionOnlyDescription =>
      'Obriga atualização para usar o app.';

  @override
  String get iosUpdateUrlLabel => 'URL Atualização iOS';

  @override
  String get iosUpdateUrlDescription => 'Link de atualização para iOS.';

  @override
  String get androidUpdateUrlLabel => 'URL Atualização Android';

  @override
  String get followedItemsLimitLabel => 'Limite de Seguidos';

  @override
  String get followedItemsLimitDescription =>
      'Máximo de itens seguidos por função.';

  @override
  String get savedFeedFiltersLimitLabel => 'Limite de Filtros Salvos';

  @override
  String get savedFeedFiltersLimitDescription =>
      'Máximo de filtros salvos por função.';

  @override
  String get adFrequencyLabel => 'Frequência de Anúncios';

  @override
  String get adFrequencyDescription => 'Anúncios a cada X itens.';

  @override
  String get savedFeedFilterLimitsTitle => 'Limites de Filtros';

  @override
  String get savedFeedFilterLimitsDescription =>
      'Configura limites de filtros por nível.';

  @override
  String get adPlacementIntervalLabel => 'Intervalo de Anúncios';

  @override
  String get adPlacementIntervalDescription =>
      'Itens antes do primeiro anúncio.';

  @override
  String get articlesBeforeInterstitialAdsLabel => 'Artigos p/ Intersticial';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      'Leituras antes do anúncio.';

  @override
  String get daysSuffix => 'Dias';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return 'Dias mínimos antes do aviso de $actionType.';
  }

  @override
  String get retryButtonText => 'Tentar Novamente';

  @override
  String get feedActionTypeLinkAccount => 'Vincular Conta';

  @override
  String get feedActionTypeRateApp => 'Avaliar App';

  @override
  String get feedActionTypeFollowTopics => 'Seguir Tópicos';

  @override
  String get feedActionTypeFollowSources => 'Seguir Fontes';

  @override
  String get feedActionTypeUpgrade => 'Melhorar Plano';

  @override
  String get feedActionTypeEnableNotifications => 'Ativar Notificações';

  @override
  String get countryPickerSearchLabel => 'Buscar';

  @override
  String get countryPickerSearchHint => 'Digite para buscar...';

  @override
  String get countryPickerSelectCountryLabel => 'Selecione um país';

  @override
  String get archivedHeadlines => 'Manchetes Arquivadas';

  @override
  String get loadingArchivedHeadlines => 'Carregando Arquivados';

  @override
  String get noArchivedHeadlinesFound => 'Nenhuma manchete arquivada.';

  @override
  String get restore => 'Restaurar';

  @override
  String get deleteForever => 'Excluir Permanentemente';

  @override
  String get archivedTopics => 'Tópicos Arquivados';

  @override
  String get loadingArchivedTopics => 'Carregando Tópicos Arquivados';

  @override
  String get noArchivedTopicsFound => 'Nenhum tópico arquivado.';

  @override
  String get archivedSources => 'Fontes Arquivadas';

  @override
  String get loadingArchivedSources => 'Carregando Fontes Arquivadas';

  @override
  String get noArchivedSourcesFound => 'Nenhuma fonte arquivada.';

  @override
  String get archivedItems => 'Itens Arquivados';

  @override
  String get addNewItem => 'Adicionar Novo';

  @override
  String get archive => 'Arquivar';

  @override
  String headlineDeleted(String title) {
    return 'Excluído \'\'$title\'\'.';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String get enabledLabel => 'Ativado';

  @override
  String get itemsToDisplayLabel => 'Itens a Exibir';

  @override
  String get itemsToDisplayDescription => 'Número de itens neste decorador.';

  @override
  String get roleSpecificSettingsTitle => 'Config. por Função';

  @override
  String get daysBetweenViewsLabel => 'Dias entre Visualizações';

  @override
  String get daysBetweenViewsDescription =>
      'Dias mínimos antes de repetir decorador.';

  @override
  String get feedDecoratorTypeLinkAccount => 'Vincular Conta';

  @override
  String get feedDecoratorTypeUpgrade => 'Mudar para Premium';

  @override
  String get feedDecoratorTypeRateApp => 'Avaliar App';

  @override
  String get feedDecoratorTypeEnableNotifications => 'Ativar Notificações';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'Tópicos Sugeridos';

  @override
  String get feedDecoratorTypeSuggestedSources => 'Fontes Sugeridas';

  @override
  String get guestUserRole => 'Convidado';

  @override
  String get standardUserRole => 'Usuário Padrão';

  @override
  String get premiumUserRole => 'Usuário Premium';

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get clearSelection => 'Limpar Seleção';

  @override
  String get search => 'Buscar';

  @override
  String get noResultsFound => 'Sem resultados.';

  @override
  String get close => 'Fechar';

  @override
  String get apply => 'Aplicar';

  @override
  String visibleToRoleLabel(String roleName) {
    return 'Visível para $roleName';
  }

  @override
  String get adPlatformConfigurationTitle => 'Plataforma de Publicidade';

  @override
  String get primaryAdPlatformTitle => 'Plataforma Principal';

  @override
  String get primaryAdPlatformDescription => 'Provedor principal de anúncios.';

  @override
  String get adUnitIdentifiersTitle => 'IDs de Unidades de Anúncios';

  @override
  String get adUnitIdentifiersDescription => 'Configure os IDs por plataforma.';

  @override
  String get feedAdSettingsTitle => 'Anúncios no Feed';

  @override
  String get enableFeedAdsLabel => 'Ativar Anúncios no Feed';

  @override
  String get feedAdTypeSelectionTitle => 'Tipo de Anúncio no Feed';

  @override
  String get feedAdTypeSelectionDescription => 'Nativo ou Banner.';

  @override
  String get userRoleFrequencySettingsTitle => 'Frequência por Função';

  @override
  String get userRoleFrequencySettingsDescription =>
      'Configure intervalos por função.';

  @override
  String get articleAdSettingsTitle => 'Anúncios em Artigos';

  @override
  String get enableArticleAdsLabel => 'Ativar Anúncios em Artigos';

  @override
  String get defaultInArticleAdTypeSelectionTitle => 'Tipo de Anúncio Padrão';

  @override
  String get defaultInArticleAdTypeSelectionDescription => 'Nativo ou Banner.';

  @override
  String get inArticleAdSlotPlacementsTitle => 'Posicionamentos em Artigos';

  @override
  String get inArticleAdSlotPlacementsDescription => 'Ativa slots específicos.';

  @override
  String get feedNativeAdIdLabel => 'ID Anúncio Nativo (Feed)';

  @override
  String get feedNativeAdIdDescription => 'ID para anúncios nativos.';

  @override
  String get feedBannerAdIdLabel => 'ID Banner (Feed)';

  @override
  String get feedBannerAdIdDescription => 'ID para banners.';

  @override
  String get articleInterstitialAdIdLabel => 'ID Intersticial (Artigo)';

  @override
  String get articleInterstitialAdIdDescription => 'ID para intersticiais.';

  @override
  String get inArticleNativeAdIdLabel => 'ID Nativo (No Artigo)';

  @override
  String get inArticleNativeAdIdDescription => 'ID para nativos internos.';

  @override
  String get inArticleBannerAdIdLabel => 'ID Banner (No Artigo)';

  @override
  String get inArticleBannerAdIdDescription => 'ID para banners internos.';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      'Acima de \'Continuar lendo\'';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      'Abaixo de \'Continuar lendo\'';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID \'$id\' copiado.';
  }

  @override
  String get copyId => 'Copiar ID';

  @override
  String get enableGlobalAdsLabel => 'Ativar Publicidade';

  @override
  String get feedToArticleInterstitialAdIdLabel =>
      'ID Intersticial (Navegação)';

  @override
  String get feedToArticleInterstitialAdIdDescription => 'ID ao abrir artigos.';

  @override
  String get interstitialAdSettingsTitle => 'Config. de Intersticiais';

  @override
  String get enableInterstitialAdsLabel => 'Ativar Intersticiais';

  @override
  String get userRoleInterstitialFrequencyTitle => 'Frequência por Função';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'Transições antes do anúncio.';

  @override
  String get transitionsBeforeInterstitialAdsLabel => 'Transições para Anúncio';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'Número de transições.';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'Nativos';

  @override
  String get bannerAdsTab => 'Banners';

  @override
  String get interstitialAdsTab => 'Intersticiais';

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
  String get rewardedAdType => 'Premiado';

  @override
  String get bannerAdShapeSelectionTitle => 'Formato do Banner';

  @override
  String get bannerAdShapeSelectionDescription => 'Quadrado ou Retangular.';

  @override
  String get bannerAdShapeSquare => 'Quadrado';

  @override
  String get bannerAdShapeRectangle => 'Retângulo';

  @override
  String get loadingDraftHeadlines => 'Carregando Rascunhos';

  @override
  String get noDraftHeadlinesFound => 'Sem rascunhos.';

  @override
  String get publish => 'Publicar';

  @override
  String get saveAsDraft => 'Salvar Rascunho';

  @override
  String get invalidFormTitle => 'Formulário Inválido';

  @override
  String get invalidFormMessage => 'Preencha os campos obrigatórios.';

  @override
  String get completeForm => 'Completar';

  @override
  String get discard => 'Descartar';

  @override
  String get drafts => 'Rascunhos';

  @override
  String get draftsIconTooltip => 'Rascunhos';

  @override
  String get draftHeadlines => 'Manchetes em Rascunho';

  @override
  String get draftTopics => 'Tópicos em Rascunho';

  @override
  String get draftSources => 'Fontes em Rascunho';

  @override
  String get saveHeadlineTitle => 'Salvar Manchete';

  @override
  String get saveHeadlineMessage => 'Publicar ou salvar como rascunho?';

  @override
  String get saveTopicTitle => 'Salvar Tópico';

  @override
  String get saveTopicMessage => 'Publicar ou salvar como rascunho?';

  @override
  String get saveSourceTitle => 'Salvar Fonte';

  @override
  String get saveSourceMessage => 'Publicar ou salvar como rascunho?';

  @override
  String get loadingDraftTopics => 'Carregando Tópicos...';

  @override
  String get noDraftTopicsFound => 'Sem tópicos em rascunho.';

  @override
  String topicDeleted(String topicTitle) {
    return 'Tópico \"$topicTitle\" excluído.';
  }

  @override
  String get loadingDraftSources => 'Carregando Fontes...';

  @override
  String get noDraftSourcesFound => 'Sem fontes em rascunho.';

  @override
  String sourceDeleted(String sourceName) {
    return 'Fonte \"$sourceName\" excluída.';
  }

  @override
  String get publishTopic => 'Publicar Tópico';

  @override
  String get publishSource => 'Publicar Fonte';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return 'Ativar Ads em Artigos para $role';
  }

  @override
  String get moreActions => 'Mais Ações';

  @override
  String get filter => 'Filtrar';

  @override
  String get applyFilters => 'Aplicar Filtros';

  @override
  String get filterHeadlines => 'Filtrar Manchetes';

  @override
  String get filterTopics => 'Filtrar Tópicos';

  @override
  String get filterSources => 'Filtrar Fontes';

  @override
  String get searchByHeadlineTitle => 'Buscar por título...';

  @override
  String get searchByTopicName => 'Buscar por nome ou ID...';

  @override
  String get searchBySourceName => 'Buscar por nome ou ID...';

  @override
  String get selectSources => 'Selecionar Fontes';

  @override
  String get selectTopics => 'Selecionar Tópicos';

  @override
  String get countries => 'Países';

  @override
  String get selectCountries => 'Selecionar Países';

  @override
  String get selectSourceTypes => 'Tipos de Fonte';

  @override
  String get selectLanguages => 'Idiomas';

  @override
  String get selectHeadquarters => 'Sedes';

  @override
  String get resetFiltersButtonText => 'Redefinir Filtros';

  @override
  String get noResultsWithCurrentFilters => 'Sem resultados com estes filtros.';

  @override
  String get aboutIconTooltip => 'Sobre esta página';

  @override
  String get closeButtonText => 'Fechar';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => 'Gestão de Usuários';

  @override
  String get userManagementPageDescription =>
      'Gerencie usuários, funções e permissões.';

  @override
  String get loadingUsers => 'Carregando Usuários';

  @override
  String get noUsersFound => 'Nenhum usuário encontrado.';

  @override
  String get email => 'E-mail';

  @override
  String get appRole => 'Função no App';

  @override
  String get dashboardRole => 'Função no Painel';

  @override
  String get createdAt => 'Criado em';

  @override
  String get promoteToPublisher => 'Promover a Editor';

  @override
  String get demoteToUser => 'Rebaixar a Usuário';

  @override
  String get adminRole => 'Admin';

  @override
  String get publisherRole => 'Editor';

  @override
  String get filterUsers => 'Filtrar Usuários';

  @override
  String get searchByUserEmail => 'Buscar por e-mail ou ID...';

  @override
  String get selectAppRoles => 'Funções do App';

  @override
  String get selectDashboardRoles => 'Funções do Painel';

  @override
  String get authentication => 'Autenticação';

  @override
  String get subscription => 'Assinatura';

  @override
  String get authenticationAnonymous => 'Anônimo';

  @override
  String get authenticationAuthenticated => 'Autenticado';

  @override
  String get subscriptionFree => 'Grátis';

  @override
  String get subscriptionPremium => 'Premium';

  @override
  String get savedHeadlineFilterLimitsTitle =>
      'Limites de Filtros de Manchetes';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      'Limites de filtros, fixados e avisos.';

  @override
  String get totalLimitLabel => 'Limite Total';

  @override
  String get totalLimitDescription => 'Total de filtros permitidos.';

  @override
  String get pinnedLimitLabel => 'Limite de Fixados';

  @override
  String get pinnedLimitDescription => 'Máximo de filtros fixados.';

  @override
  String get notificationSubscriptionLimitLabel => 'Limite de Notificações';

  @override
  String get notificationSubscriptionLimitDescription =>
      'Máximo de assinaturas.';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly =>
      'Última Hora';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup =>
      'Resumo Semanal';

  @override
  String get isBreakingNewsLabel => 'Marcar como Última Hora';

  @override
  String get isBreakingNewsDescription => 'Envia notificação push imediata.';

  @override
  String get isBreakingNewsDescriptionEdit => 'Não enviará push ao editar.';

  @override
  String get confirmBreakingNewsTitle => 'Confirmar Última Hora';

  @override
  String get confirmBreakingNewsMessage =>
      'Enviar notificação push para todos?';

  @override
  String get confirmPublishButton => 'Confirmar e Publicar';

  @override
  String get cannotDraftBreakingNews => 'Não é possível salvar como rascunho.';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => 'Última Hora';

  @override
  String get breakingNewsFilterAll => 'Todos';

  @override
  String get breakingNewsFilterBreakingOnly => 'Apenas Última Hora';

  @override
  String get breakingNewsFilterNonBreakingOnly => 'Sem Última Hora';

  @override
  String get notificationsTab => 'Notificações';

  @override
  String get pushNotificationSettingsTitle => 'Config. de Notificações';

  @override
  String get pushNotificationSettingsDescription =>
      'Gestão global de notificações.';

  @override
  String get pushNotificationSystemStatusTitle => 'Ativar Notificações';

  @override
  String get pushNotificationSystemStatusDescription => 'Interruptor global.';

  @override
  String get pushNotificationPrimaryProviderTitle => 'Provedor Principal';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      'Firebase ou OneSignal.';

  @override
  String get pushNotificationDeliveryTypesTitle => 'Tipos de Entrega';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      'Ativa tipos específicos.';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => 'Geral';

  @override
  String get featuresTab => 'Recursos';

  @override
  String get limitsTab => 'Limites';

  @override
  String get maintenanceConfigTitle => 'Modo Manutenção';

  @override
  String get maintenanceConfigDescription => 'Ativa o modo de manutenção.';

  @override
  String get updateConfigTitle => 'Config. de Atualização';

  @override
  String get updateConfigDescription => 'Configura atualizações obrigatórias.';

  @override
  String get generalAppConfigTitle => 'Configurações Gerais';

  @override
  String get generalAppConfigDescription => 'Termos e Política de Privacidade.';

  @override
  String get termsOfServiceUrlLabel => 'URL Termos de Serviço';

  @override
  String get termsOfServiceUrlDescription => 'Link para os termos.';

  @override
  String get privacyPolicyUrlLabel => 'URL Política de Privacidade';

  @override
  String get privacyPolicyUrlDescription => 'Link para a política.';

  @override
  String get navigationAdConfigTitle => 'Anúncios de Navegação';

  @override
  String get enableNavigationAdsLabel => 'Ativar Anúncios de Navegação';

  @override
  String get navigationAdFrequencyTitle => 'Frequência de Navegação';

  @override
  String get navigationAdFrequencyDescription => 'Transições antes do anúncio.';

  @override
  String get internalNavigationsBeforeAdLabel => 'Navegações Internas';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'Páginas antes do anúncio.';

  @override
  String get externalNavigationsBeforeAdLabel => 'Navegações Externas';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'Saídas antes do anúncio.';

  @override
  String get nativeAdIdLabel => 'ID Anúncio Nativo';

  @override
  String get nativeAdIdDescription => 'ID para anúncios nativos.';

  @override
  String get bannerAdIdLabel => 'ID Banner';

  @override
  String get bannerAdIdDescription => 'ID para banners.';

  @override
  String get interstitialAdIdLabel => 'ID Intersticial';

  @override
  String get interstitialAdIdDescription => 'ID para intersticiais.';

  @override
  String get savedHeadlinesLimitLabel => 'Limite de Salvos';

  @override
  String get savedHeadlinesLimitDescription => 'Máximo de manchetes salvas.';

  @override
  String get appUpdateManagementTitle => 'Gestão de Atualizações';

  @override
  String get feedItemClickBehaviorTitle => 'Comportamento ao Clicar';

  @override
  String get feedItemClickBehaviorDescription =>
      'Navegador interno ou do sistema.';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'Navegador In-App';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'Navegador do Sistema';

  @override
  String get userLimitsTitle => 'Limites de Usuário';

  @override
  String get userLimitsDescription => 'Define limites por função.';

  @override
  String get appStatusAndUpdatesDescription =>
      'Controle de status e atualizações.';

  @override
  String get advertisementsDescription => 'Gestão global de publicidade.';

  @override
  String get notificationsDescription => 'Configuração de notificações push.';

  @override
  String get feedDescription => 'Controle de comportamento do feed.';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      'Limite para alertas imediatos.';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      'Limite para resumo semanal.';

  @override
  String get appStatusAndUpdatesTitle => 'Status e Atualizações';

  @override
  String get enableForcedUpdatesLabel => 'Ativar Atualizações Forçadas';

  @override
  String get enableForcedUpdatesDescription => 'Permite exigir versão mínima.';

  @override
  String get appUrlsTitle => 'URLs do Aplicativo';

  @override
  String get appUrlsDescription => 'Gerencia links internos e externos.';

  @override
  String get communityAndEngagementTitle => 'Comunidade e Engajamento';

  @override
  String get communityAndEngagementDescription =>
      'Configura comentários e denúncias.';

  @override
  String get userEngagementTitle => 'Engajamento do Usuário';

  @override
  String get userEngagementDescription => 'Configura reações e comentários.';

  @override
  String get contentReportingTitle => 'Denúncia de Conteúdo';

  @override
  String get contentReportingDescription => 'Regras para denunciar conteúdo.';

  @override
  String get appReviewFunnelTitle => 'Avaliações do App';

  @override
  String get appReviewFunnelDescription => 'Gestão de satisfação e avaliações.';

  @override
  String get enableEngagementFeaturesLabel => 'Ativar Engajamento';

  @override
  String get enableEngagementFeaturesDescription =>
      'Ativa reações e comentários.';

  @override
  String get engagementModeLabel => 'Modo de Engajamento';

  @override
  String get engagementModeDescription =>
      'Apenas reações ou também comentários.';

  @override
  String get engagementModeReactionsOnly => 'Apenas Reações';

  @override
  String get engagementModeReactionsAndComments => 'Reações e Comentários';

  @override
  String get enableReportingSystemLabel => 'Ativar Sistema de Denúncias';

  @override
  String get enableReportingSystemDescription => 'Ativa opções de denúncia.';

  @override
  String get enableHeadlineReportingLabel => 'Denúncia de Manchetes';

  @override
  String get enableSourceReportingLabel => 'Denúncia de Fontes';

  @override
  String get enableCommentReportingLabel => 'Denúncia de Comentários';

  @override
  String get enableAppFeedbackSystemLabel => 'Ativar Feedback Interno';

  @override
  String get enableAppFeedbackSystemDescription => 'Pergunta se gostam do app.';

  @override
  String get interactionCycleThresholdLabel => 'Limiar de Interação';

  @override
  String get interactionCycleThresholdDescription =>
      'Ações positivas para o aviso.';

  @override
  String get initialPromptCooldownLabel => 'Resfriamento Inicial (Dias)';

  @override
  String get initialPromptCooldownDescription =>
      'Espera antes do primeiro aviso.';

  @override
  String get requestStoreReviewLabel => 'Pedir Avaliação na Loja';

  @override
  String get requestStoreReviewDescription =>
      'Se responderem \'Sim\', pedir avaliação.';

  @override
  String get requestWrittenFeedbackLabel => 'Pedir Feedback Escrito';

  @override
  String get requestWrittenFeedbackDescription =>
      'Se responderem \'Não\', pedir motivo.';

  @override
  String get internalPromptLogicTitle => 'Lógica de Avisos';

  @override
  String get eligiblePositiveInteractionsTitle => 'Interações Positivas';

  @override
  String get positiveInteractionTypeSaveItem => 'Salvar conteúdo';

  @override
  String get positiveInteractionTypeFollowItem => 'Seguir entidade';

  @override
  String get positiveInteractionTypeShareContent => 'Compartilhar conteúdo';

  @override
  String get positiveInteractionTypeSaveFilter => 'Criar filtro salvo';

  @override
  String get followUpActionsTitle => 'Ações de Acompanhamento';

  @override
  String get enableCommunityFeaturesLabel => 'Ativar Recursos de Comunidade';

  @override
  String get enableCommunityFeaturesDescription =>
      'Ativa engajamento e denúncias.';

  @override
  String get communityManagementPageDescription =>
      'Gerencie comentários, denúncias e avaliações.';

  @override
  String get engagements => 'Interações';

  @override
  String get reports => 'Denúncias';

  @override
  String get appReviews => 'Avaliações';

  @override
  String get user => 'Usuário';

  @override
  String get engagedContent => 'Conteúdo';

  @override
  String get reaction => 'Reação';

  @override
  String get comment => 'Comentário';

  @override
  String get commentStatus => 'Status do Comentário';

  @override
  String get hasCommentFilterLabel => 'Contém Comentário';

  @override
  String get hasCommentFilterDescription => 'Apenas com texto.';

  @override
  String get date => 'Data';

  @override
  String get approveComment => 'Aprovar Comentário';

  @override
  String get rejectComment => 'Rejeitar Comentário';

  @override
  String get viewEngagedContent => 'Ver Conteúdo';

  @override
  String get copyUserId => 'Copiar ID de Usuário';

  @override
  String get reporter => 'Denunciante';

  @override
  String get reportedItem => 'Item Denunciado';

  @override
  String get reason => 'Motivo';

  @override
  String get reportStatus => 'Status da Denúncia';

  @override
  String get viewReportedItem => 'Ver Item';

  @override
  String get markAsInReview => 'Marcar em Revisão';

  @override
  String get resolveReport => 'Resolver Denúncia';

  @override
  String get initialFeedback => 'Feedback Inicial';

  @override
  String get osPromptRequested => 'Aviso de SO?';

  @override
  String get feedbackHistory => 'Histórico';

  @override
  String get lastInteraction => 'Última Interação';

  @override
  String get viewFeedbackHistory => 'Ver Histórico';

  @override
  String get reactionTypeLike => 'Curtir';

  @override
  String get reactionTypeInsightful => 'Interessante';

  @override
  String get reactionTypeAmusing => 'Divertido';

  @override
  String get reactionTypeSad => 'Triste';

  @override
  String get reactionTypeAngry => 'Bravo';

  @override
  String get reactionTypeSkeptical => 'Cético';

  @override
  String get initialAppReviewFeedbackPositive => 'Positivo';

  @override
  String get initialAppReviewFeedbackNegative => 'Negativo';

  @override
  String get filterCommunity => 'Filtrar Comunidade';

  @override
  String get searchByEngagementUser => 'Buscar por e-mail...';

  @override
  String get searchByReportReporter => 'Buscar por denunciante...';

  @override
  String get searchByAppReviewUser => 'Buscar por e-mail...';

  @override
  String get selectCommentStatus => 'Status do Comentário';

  @override
  String get selectReportStatus => 'Status da Denúncia';

  @override
  String get selectInitialFeedback => 'Feedback Inicial';

  @override
  String get selectReportableEntity => 'Tipo de Item';

  @override
  String get reportableEntityHeadline => 'Manchete';

  @override
  String get reportableEntitySource => 'Fonte';

  @override
  String get reportableEntityComment => 'Comentário';

  @override
  String get noEngagementsFound => 'Sem interações.';

  @override
  String get noReportsFound => 'Sem denúncias.';

  @override
  String get noAppReviewsFound => 'Sem avaliações.';

  @override
  String get loadingEngagements => 'Carregando Interações';

  @override
  String get loadingReports => 'Carregando Denúncias';

  @override
  String get loadingAppReviews => 'Carregando Avaliações';

  @override
  String get userIdCopied => 'ID de usuário copiado.';

  @override
  String get reportStatusUpdated => 'Status atualizado.';

  @override
  String feedbackHistoryForUser(String email) {
    return 'Histórico de $email';
  }

  @override
  String get noFeedbackHistory => 'Sem histórico disponível.';

  @override
  String feedbackProvidedAt(String date) {
    return 'Feedback em: $date';
  }

  @override
  String feedbackReason(String reason) {
    return 'Motivo: $reason';
  }

  @override
  String get noReasonProvided => 'Sem motivo.';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get reportReasonMisinformationOrFakeNews =>
      'Desinformação / Fake News';

  @override
  String get reportReasonClickbaitTitle => 'Título Clickbait';

  @override
  String get reportReasonOffensiveOrHateSpeech => 'Ofensivo / Ódio';

  @override
  String get reportReasonSpamOrScam => 'Spam / Golpe';

  @override
  String get reportReasonBrokenLink => 'Link Quebrado';

  @override
  String get reportReasonPaywalled => 'Paywall';

  @override
  String get reportReasonLowQualityJournalism => 'Baixa Qualidade';

  @override
  String get reportReasonHighAdDensity => 'Excesso de Publicidade';

  @override
  String get reportReasonBlog => 'Blog';

  @override
  String get reportReasonGovernmentSource => 'Fonte Governamental';

  @override
  String get reportReasonAggregator => 'Agregador';

  @override
  String get reportReasonOther => 'Outro';

  @override
  String get reportReasonFrequentPaywalls => 'Paywalls Frequentes';

  @override
  String get reportReasonImpersonation => 'Falsificação de Identidade';

  @override
  String get noNegativeFeedbackHistory => 'Sem feedback negativo.';

  @override
  String get reject => 'Rejeitar';

  @override
  String get commentStatusFlaggedByAi => 'Marcado por IA';

  @override
  String get cancel => 'Cancelar';

  @override
  String get rejectCommentConfirmation =>
      'Excluir permanentemente este comentário?';

  @override
  String get searchByUserId => 'Buscar por ID...';

  @override
  String get viewReportedHeadline => 'Ver Manchete';

  @override
  String get viewReportedSource => 'Ver Fonte';

  @override
  String get viewReportedComment => 'Ver Comentário';

  @override
  String get entityType => 'Tipo de Entidade';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackDetails => 'Detalhes do Feedback';

  @override
  String get moderationStatusPendingReview => 'Pendente';

  @override
  String get moderationStatusResolved => 'Resolvido';

  @override
  String get hasComment => 'Tem Comentário';

  @override
  String get any => 'Qualquer';

  @override
  String get withComment => 'Com Comentário';

  @override
  String get withoutComment => 'Sem Comentário';

  @override
  String get reportResolved => 'Denúncia resolvida.';

  @override
  String get commentApproved => 'Comentário aprovado.';

  @override
  String get commentRejected => 'Comentário rejeitado.';

  @override
  String get copyHeadlineId => 'Copiar ID da Manchete';

  @override
  String get copyReportedItemId => 'Copiar ID do Item';

  @override
  String get viewFeedbackDetails => 'Ver Detalhes';

  @override
  String get reportDetails => 'Detalhes da Denúncia';

  @override
  String get commentDetails => 'Detalhes do Comentário';

  @override
  String get communityManagement => 'Gestão de Comunidade';

  @override
  String get navContent => 'Conteúdo';

  @override
  String get navUsers => 'Usuários';

  @override
  String get navCommunity => 'Comunidade';

  @override
  String get confirmPromotionTitle => 'Confirmar Promoção';

  @override
  String confirmPromotionMessage(String email) {
    return 'Promover $email a Editor?';
  }

  @override
  String get confirmDemotionTitle => 'Confirmar Rebaixamento';

  @override
  String confirmDemotionMessage(String email) {
    return 'Rebaixar $email a usuário padrão?';
  }

  @override
  String get premiumUserTooltip => 'Premium';

  @override
  String get adminUserTooltip => 'Admin';

  @override
  String get publisherUserTooltip => 'Editor';

  @override
  String get breakingNewsHint => 'Manchete de última hora';

  @override
  String get breakingNewsFilterDescription => 'Apenas notícias de última hora';

  @override
  String publishItemTitle(String itemType) {
    return 'Publicar $itemType?';
  }

  @override
  String publishItemContent(String itemType) {
    return 'Publicar este $itemType? Será visível.';
  }

  @override
  String archiveItemTitle(String itemType) {
    return 'Arquivar $itemType?';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'Arquivar este $itemType? Será ocultado.';
  }

  @override
  String restoreItemTitle(String itemType) {
    return 'Restaurar $itemType?';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'Restaurar este $itemType? Será visível.';
  }

  @override
  String deleteItemTitle(String itemType) {
    return 'Excluir $itemType?';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'Tem certeza que deseja excluir este $itemType?';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType \"$itemName\" excluído.';
  }

  @override
  String get adPlatformConfigurationDescription =>
      'Provedor e IDs de anúncios.';

  @override
  String get feedAdSettingsDescription => 'Visibilidade e frequência no feed.';

  @override
  String get navigationAdConfigDescription => 'Anúncios durante a navegação.';

  @override
  String get feedDecoratorLinkAccountDescription => 'Aviso para criar conta.';

  @override
  String get feedDecoratorUpgradeDescription => 'Aviso para melhorar plano.';

  @override
  String get feedDecoratorRateAppDescription => 'Aviso para avaliar o app.';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'Aviso para notificações.';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'Mostra tópicos sugeridos.';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'Mostra fontes sugeridas.';

  @override
  String get enableGlobalAdsDescription =>
      'Ativa ou desativa toda a publicidade.';

  @override
  String get enableFeedAdsDescription => 'Controla anúncios no feed.';

  @override
  String visibleToRoleDescription(String roleName) {
    return 'Ativo para usuários com função \'$roleName\'.';
  }

  @override
  String get enableDecoratorDescription => 'Ativa este decorador globalmente.';

  @override
  String get enableNavigationAdsDescription =>
      'Anúncios ao navegar entre páginas.';

  @override
  String get enableHeadlineReportingDescription =>
      'Permite denunciar manchetes.';

  @override
  String get enableSourceReportingDescription => 'Permite denunciar fontes.';

  @override
  String get enableCommentReportingDescription =>
      'Permite denunciar comentários.';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      'Alertas de última hora.';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      'Resumo diário.';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      'Resumo semanal.';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'Ao salvar uma manchete.';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'Ao seguir um tópico ou fonte.';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'Ao compartilhar conteúdo.';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'Ao criar um filtro.';

  @override
  String get internalPromptLogicDescription =>
      'Condições para o aviso de satisfação.';

  @override
  String get eligiblePositiveInteractionsDescription =>
      'Ações que contam como positivas.';

  @override
  String get followUpActionsDescription => 'Ações após responder ao aviso.';

  @override
  String get analyticsTab => 'Analíticas';

  @override
  String get analyticsDescription => 'Configura o rastreamento de eventos.';

  @override
  String get analyticsSystemStatusTitle => 'Ativar Analíticas';

  @override
  String get analyticsSystemStatusDescription =>
      'Interruptor mestre de rastreamento.';

  @override
  String get analyticsProviderTitle => 'Provedor Ativo';

  @override
  String get analyticsProviderDescription => 'Serviço de analíticas principal.';

  @override
  String get analyticsEventsTitle => 'Configuração de Eventos';

  @override
  String get analyticsEventsDescription =>
      'Ajusta o registro de eventos específicos.';

  @override
  String samplingRateLabel(int rate) {
    return 'Taxa de amostragem: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'Registro de Usuário';

  @override
  String get analyticsEventUserRegisteredDescription =>
      'Rastreia novos registros.';

  @override
  String get analyticsEventUserLoginLabel => 'Login de Usuário';

  @override
  String get analyticsEventUserLoginDescription => 'Rastreia acessos.';

  @override
  String get analyticsEventAccountLinkedLabel => 'Conta Vinculada';

  @override
  String get analyticsEventAccountLinkedDescription => 'Rastreia vinculações.';

  @override
  String get analyticsEventUserRoleChangedLabel => 'Mudança de Função';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'Rastreia mudanças de nível.';

  @override
  String get analyticsEventContentViewedLabel => 'Conteúdo Visto';

  @override
  String get analyticsEventContentViewedDescription => 'Rastreia leituras.';

  @override
  String get analyticsEventContentSharedLabel => 'Conteúdo Compartilhado';

  @override
  String get analyticsEventContentSharedDescription =>
      'Rastreia compartilhamentos.';

  @override
  String get analyticsEventContentSavedLabel => 'Conteúdo Salvo';

  @override
  String get analyticsEventContentSavedDescription => 'Rastreia favoritos.';

  @override
  String get analyticsEventContentUnsavedLabel => 'Conteúdo Removido';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'Rastreia remoção de favoritos.';

  @override
  String get analyticsEventContentReadingTimeLabel => 'Tempo de Leitura';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'Rastreia duração de leitura.';

  @override
  String get analyticsEventReactionCreatedLabel => 'Reação Adicionada';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'Rastreia novas reações.';

  @override
  String get analyticsEventReactionDeletedLabel => 'Reação Removida';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'Rastreia remoção de reações.';

  @override
  String get analyticsEventCommentCreatedLabel => 'Comentário Publicado';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'Rastreia novos comentários.';

  @override
  String get analyticsEventCommentDeletedLabel => 'Comentário Excluído';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'Rastreia exclusão de comentários.';

  @override
  String get analyticsEventReportSubmittedLabel => 'Denúncia Enviada';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'Rastreia denúncias de usuários.';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => 'Filtro Criado';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'Rastreia criação de filtros.';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => 'Filtro Atualizado';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'Rastreia mudanças em filtros.';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => 'Filtro Usado';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'Rastreia aplicação de filtros.';

  @override
  String get analyticsEventSearchPerformedLabel => 'Busca Realizada';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'Rastreia consultas de busca.';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel => 'Resposta ao Aviso';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      'Rastreia resposta a \'Gosta do app?\'.';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel =>
      'Avaliação na Loja Pedida';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'Rastreia pedidos de avaliação oficial.';

  @override
  String get analyticsEventLimitExceededLabel => 'Limite Excedido';

  @override
  String get analyticsEventLimitExceededDescription =>
      'Rastreia quando se atinge um limite.';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel =>
      'Clique em CTA de Limite';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      'Rastreia cliques em \'Melhorar\'.';

  @override
  String get analyticsEventPaywallPresentedLabel => 'Paywall Visto';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'Rastreia impressões do paywall.';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'Assinatura Iniciada';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'Rastreia novas compras.';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'Assinatura Renovada';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'Rastreia renovações.';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'Assinatura Cancelada';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'Rastreia cancelamentos.';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'Assinatura Finalizada';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'Rastreia expirações.';

  @override
  String get analyticsEventAdImpressionLabel => 'Impressão de Anúncio';

  @override
  String get analyticsEventAdImpressionDescription =>
      'Rastreia visualização de ads.';

  @override
  String get analyticsEventAdClickedLabel => 'Clique em Anúncio';

  @override
  String get analyticsEventAdClickedDescription => 'Rastreia cliques em ads.';

  @override
  String get analyticsEventAdLoadFailedLabel => 'Erro de Carregamento de Ad';

  @override
  String get analyticsEventAdLoadFailedDescription => 'Rastreia falhas em ads.';

  @override
  String get analyticsEventAdRewardEarnedLabel => 'Recompensa Ganha';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'Rastreia ads premiados completados.';

  @override
  String get analyticsEventThemeChangedLabel => 'Mudança de Tema';

  @override
  String get analyticsEventThemeChangedDescription =>
      'Rastreia mudanças visuais.';

  @override
  String get analyticsEventLanguageChangedLabel => 'Mudança de Idioma';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'Rastreia mudanças de idioma.';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'Mudança de Densidade';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'Rastreia ajustes do feed.';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'Mudança de Navegador';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'Rastreia preferência de links.';

  @override
  String get analyticsEventAppTourStartedLabel => 'Tour Iniciado';

  @override
  String get analyticsEventAppTourStartedDescription =>
      'Rastreia início do tour.';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'Passo do Tour Visto';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'Rastreia vistas do tour.';

  @override
  String get analyticsEventAppTourCompletedLabel => 'Tour Completado';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'Rastreia fim do tour.';

  @override
  String get analyticsEventAppTourSkippedLabel => 'Tour Omitido';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'Rastreia se pula o tour.';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel =>
      'Personalização Iniciada';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      'Rastreia início de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'Passo de Onboarding Visto';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'Rastreia passos de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel =>
      'Personalização Completada';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'Rastreia fim de onboarding.';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel =>
      'Personalização Omitida';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'Rastreia se pula o onboarding.';

  @override
  String get timeFrameDay => '24H';

  @override
  String get timeFrameWeek => '7D';

  @override
  String get timeFrameMonth => '30D';

  @override
  String get timeFrameYear => '1A';

  @override
  String get noDataAvailable => 'Sem dados';

  @override
  String get vsPreviousPeriod => 'vs período anterior';

  @override
  String get vsPreviousDay => 'vs últimas 24h';

  @override
  String get vsPreviousWeek => 'vs últimos 7 dias';

  @override
  String get vsPreviousMonth => 'vs últimos 30 dias';

  @override
  String get vsPreviousYear => 'vs ano anterior';

  @override
  String get kpiUsersTotalRegistered => 'Usuários Registrados';

  @override
  String get kpiUsersNewRegistrations => 'Novos Registros';

  @override
  String get kpiUsersActiveUsers => 'Usuários Ativos';

  @override
  String get kpiContentHeadlinesTotalPublished => 'Manchetes Publicadas';

  @override
  String get kpiContentHeadlinesTotalViews => 'Vistas de Manchetes';

  @override
  String get kpiContentHeadlinesTotalLikes => 'Curtidas em Manchetes';

  @override
  String get kpiContentSourcesTotalSources => 'Total Fontes';

  @override
  String get kpiContentSourcesNewSources => 'Novas Fontes';

  @override
  String get kpiContentSourcesTotalFollowers => 'Seguidores de Fontes';

  @override
  String get kpiContentTopicsTotalTopics => 'Total Tópicos';

  @override
  String get kpiContentTopicsNewTopics => 'Novos Tópicos';

  @override
  String get kpiContentTopicsTotalFollowers => 'Seguidores de Tópicos';

  @override
  String get kpiEngagementsTotalReactions => 'Total Reações';

  @override
  String get kpiEngagementsTotalComments => 'Total Comentários';

  @override
  String get kpiEngagementsAverageEngagementRate => 'Taxa de Engajamento Média';

  @override
  String get kpiEngagementsReportsPending => 'Denúncias Pendentes';

  @override
  String get kpiEngagementsReportsResolved => 'Denúncias Resolvidas';

  @override
  String get kpiEngagementsReportsAverageResolutionTime =>
      'Tempo Médio de Resolução';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'Total Feedback';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'Feedback Positivo';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'Pedidos de Avaliação';

  @override
  String get chartUsersRegistrationsOverTime => 'Registros no Tempo';

  @override
  String get chartUsersActiveUsersOverTime => 'Tendência de Ativos';

  @override
  String get chartUsersRoleDistribution => 'Distribuição por Função';

  @override
  String get chartContentHeadlinesViewsOverTime => 'Tendência de Vistas';

  @override
  String get chartContentHeadlinesLikesOverTime => 'Tendência de Curtidas';

  @override
  String get chartContentHeadlinesViewsByTopic => 'Vistas por Tópico';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime =>
      'Atividade de Fontes';

  @override
  String get chartContentSourcesFollowersOverTime => 'Crescimento de Fontes';

  @override
  String get chartContentSourcesEngagementByType => 'Engajamento por Tipo';

  @override
  String get chartContentTopicsFollowersOverTime => 'Crescimento de Tópicos';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime =>
      'Atividade de Tópicos';

  @override
  String get chartContentTopicsEngagementByTopic => 'Engajamento por Tópico';

  @override
  String get chartEngagementsReactionsOverTime => 'Tendência de Reações';

  @override
  String get chartEngagementsCommentsOverTime => 'Tendência de Comentários';

  @override
  String get chartEngagementsReactionsByType => 'Distribuição de Reações';

  @override
  String get chartEngagementsReportsSubmittedOverTime => 'Denúncias Enviadas';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime =>
      'Tendência de Resolução';

  @override
  String get chartEngagementsReportsByReason => 'Denúncias por Motivo';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime =>
      'Tendência de Feedback';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative =>
      'Análise de Sentimento';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime =>
      'Tendência de Pedidos';

  @override
  String get chartContentSourcesStatusDistribution => 'Distribuição de Status';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution =>
      'Notícias de Última Hora';

  @override
  String get chartOverviewAppTourFunnel => 'Funil do Tour';

  @override
  String get chartOverviewInitialPersonalizationFunnel => 'Funil de Onboarding';

  @override
  String get rankedListOverviewHeadlinesMostViewed => 'Manchetes Mais Vistas';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'Manchetes Mais Curtidas';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'Fontes Mais Seguidas';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'Tópicos Mais Seguidos';

  @override
  String get subscriptionTab => 'Assinaturas';

  @override
  String get subscriptionDescription => 'Configura os planos de assinatura.';

  @override
  String get enableSubscriptionLabel => 'Ativar Assinaturas';

  @override
  String get enableSubscriptionDescription =>
      'Permite aos usuários melhorar seu nível.';

  @override
  String get monthlyPlanTitle => 'Plano Mensal';

  @override
  String get annualPlanTitle => 'Plano Anual';

  @override
  String get planEnabledLabel => 'Plano Ativado';

  @override
  String get planRecommendedLabel => 'Plano Recomendado';

  @override
  String get planRecommendedDescription =>
      'Destaca este plano como melhor opção.';

  @override
  String get appleProductIdLabel => 'ID Produto Apple App Store';

  @override
  String get googleProductIdLabel => 'ID Produto Google Play Store';

  @override
  String get subscriptionPlanEnablementError =>
      'Insira pelo menos um ID de produto.';

  @override
  String get subscriptionPlanDisabledNotification =>
      'Plano desativado por falta de IDs.';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'Assinaturas desativadas.';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'Notificações desativadas.';

  @override
  String get analyticsFeatureDisabledNotification => 'Analíticas desativadas.';

  @override
  String get reportingFeatureDisabledNotification => 'Denúncias desativadas.';

  @override
  String get appReviewFeatureDisabledNotification => 'Avaliações desativadas.';

  @override
  String get subscriptionsName => 'Assinaturas';

  @override
  String get subscriptionProvider => 'Provedor';

  @override
  String get accessTier => 'Nível de Acesso';

  @override
  String get expiryDate => 'Data de Expiração';

  @override
  String get willAutoRenew => 'Renovação Automática';

  @override
  String get allAccessTiers => 'Todos os Níveis';

  @override
  String get subscriptionActionCopyUserId => 'Copiar ID de Usuário';

  @override
  String get subscriptionActionCopySubscriptionId => 'Copiar ID de Assinatura';

  @override
  String get filterSubscriptions => 'Filtrar Assinaturas';

  @override
  String get selectStatus => 'Status';

  @override
  String get selectProvider => 'Provedor';

  @override
  String get selectTier => 'Nível';

  @override
  String get noSubscriptionsFound => 'Sem assinaturas.';

  @override
  String get loadingSubscriptions => 'Carregando Assinaturas';

  @override
  String get searchByUserIdOrSubscriptionId =>
      'Buscar por ID de Usuário ou Assinatura...';

  @override
  String get subscriptionsPageDescription =>
      'Monitoramento de assinaturas (somente leitura).';

  @override
  String get subscriptionStatusActive => 'Ativo';

  @override
  String get subscriptionStatusGracePeriod => 'Período de Carência';

  @override
  String get subscriptionStatusBillingIssue => 'Problema de Faturamento';

  @override
  String get subscriptionStatusCanceled => 'Cancelado';

  @override
  String get subscriptionStatusExpired => 'Expirado';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'Assinaturas Ativas';

  @override
  String get chartSubscriptionsStatusDistribution => 'Distribuição de Status';

  @override
  String get chartSubscriptionsByStoreProvider => 'Assinaturas por Loja';

  @override
  String get kpiRewardsAdsWatchedTotal => 'Total Anúncios Vistos';

  @override
  String get kpiRewardsActiveUsersCount => 'Usuários com Recompensa';

  @override
  String get rewardsTab => 'Recompensas';

  @override
  String get rewardsDescription => 'Configura recompensas por interação.';

  @override
  String get enableRewardsLabel => 'Ativar Recompensas';

  @override
  String get enableRewardsDescription => 'Permite ganhar prêmios vendo ads.';

  @override
  String get rewardTypeAdFree => 'Experiência Sem Anúncios';

  @override
  String get rewardDurationDaysLabel => 'Duração (Dias)';

  @override
  String get rewardEnabledLabel => 'Ativado';

  @override
  String get chartRewardsAdsWatchedOverTime => 'Tendência de Anúncios Vistos';

  @override
  String get chartRewardsActiveByType => 'Recompensas Ativas por Tipo';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'Aviso para desbloquear funções.';

  @override
  String get rewardDurationDaysDescription => 'Dias que dura a recompensa.';

  @override
  String get rewardsManagement => 'Gestão de Recompensas';

  @override
  String get rewardsManagementPageDescription =>
      'Gerencia prêmios de usuários.';

  @override
  String get loadingRewards => 'Carregando Recompensas';

  @override
  String get noRewardsFound => 'Sem recompensas.';

  @override
  String get userId => 'ID de Usuário';

  @override
  String get activeRewards => 'Recompensas Ativas';

  @override
  String get expiry => 'Expiração';

  @override
  String get filterRewards => 'Filtrar Recompensas';

  @override
  String get rewardType => 'Tipo de Recompensa';

  @override
  String get selectRewardTypes => 'Tipos de Recompensa';

  @override
  String get loadingAnalytics => 'Carregando Analíticas';

  @override
  String get noAnalyticsDataHeadline => 'Sem Dados de Analíticas';

  @override
  String get noAnalyticsDataSubheadline => 'Não há dados para mostrar ainda.';

  @override
  String get androidAdUnitsTitle => 'Unidades Android';

  @override
  String get iosAdUnitsTitle => 'Unidades iOS';

  @override
  String get rewardedAdIdLabel => 'ID Anúncio Premiado';

  @override
  String get rewardedAdIdDescription => 'ID para anúncios com prêmio.';

  @override
  String get kpiRewardsGrantedTotal => 'Total Prêmios Concedidos';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'Hub de Recompensas Visto';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'Rastreia visitas ao hub.';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'Oferta Clicada';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'Rastreia cliques em ofertas.';

  @override
  String get analyticsEventRewardGrantedLabel => 'Recompensa Concedida';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'Rastreia prêmios entregues.';

  @override
  String get chartRewardsGrantedOverTime => 'Tendência de Prêmios';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => 'Personalização Inicial';

  @override
  String get initialPersonalizationDescription =>
      'Configura o fluxo de boas-vindas.';

  @override
  String get enableInitialPersonalizationLabel => 'Ativar Personalização';

  @override
  String get enableInitialPersonalizationDescription => 'Guia novos usuários.';

  @override
  String get enableCountrySelectionLabel => 'Seleção de País';

  @override
  String get enableCountrySelectionDescription =>
      'Permite escolher país no início.';

  @override
  String get enableTopicSelectionLabel => 'Seleção de Tópicos';

  @override
  String get enableTopicSelectionDescription =>
      'Permite escolher tópicos no início.';

  @override
  String get enableSourceSelectionLabel => 'Seleção de Fontes';

  @override
  String get enableSourceSelectionDescription =>
      'Permite escolher fontes no início.';

  @override
  String get minSelectionsRequiredLabel => 'Seleções Mínimas';

  @override
  String get minSelectionsRequiredDescription =>
      'Itens necessários para continuar.';

  @override
  String get onboardingTitle => 'Onboarding';

  @override
  String get onboardingDescription => 'Gerencia a primeira experiência.';

  @override
  String get enableOnboardingLabel => 'Ativar Onboarding';

  @override
  String get enableOnboardingDescription =>
      'Interruptor mestre de boas-vindas.';

  @override
  String get appTourTitle => 'Tour do App';

  @override
  String get appTourDescription => 'Configura o tour pré-login.';

  @override
  String get enableAppTourLabel => 'Ativar Tour';

  @override
  String get enableAppTourDescription => 'Mostra funções antes de entrar.';

  @override
  String get skippableAppTourLabel => 'Tour Ignorável';

  @override
  String get skippableAppTourDescription => 'Permite pular o tour.';

  @override
  String get skippableInitialPersonalizationLabel => 'Personalização Ignorável';

  @override
  String get skippableInitialPersonalizationDescription =>
      'Permite pular onboarding.';

  @override
  String get filePickingErrorMessage => 'Erro ao selecionar o arquivo.';

  @override
  String get removeImage => 'Remover imagem';

  @override
  String get clickToUploadImage => 'Clique para enviar imagem';

  @override
  String get processingImage => 'Processando Imagem...';

  @override
  String get processingImageDescription => 'Otimizando imagem...';

  @override
  String get chartMediaUploadsOverTime => 'Envios no Tempo';

  @override
  String get chartMediaUploadsByPurpose => 'Envios por Propósito';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'Sucesso vs Falha';

  @override
  String get kpiMediaTotalUploads => 'Total Envios';

  @override
  String get kpiMediaFailedUploads => 'Envios Falhos';

  @override
  String get kpiMediaAverageUploadTime => 'Tempo Médio (s)';

  @override
  String get updateHeadlineTitle => 'Atualizar Manchete';

  @override
  String get updateHeadlineMessage => 'Publicar alterações ou salvar rascunho?';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'Envio Iniciado';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'Rastreia início de envio.';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'Envio Completado';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'Rastreia sucesso de envio.';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'Envio Falho';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'Rastreia falhas de envio.';

  @override
  String get dashboard => 'Painel';

  @override
  String get aboutOverviewPageTitle => 'Sobre a Visão Geral';

  @override
  String get aboutOverviewPageDescription =>
      'Métricas chave atualizadas periodicamente.';

  @override
  String get audience => 'Audiência';

  @override
  String get content => 'Conteúdo';

  @override
  String get community => 'Comunidade';

  @override
  String get monetization => 'Monetização';

  @override
  String get configuration => 'Configuração';

  @override
  String get loadingConfiguration => 'Carregando Configuração...';

  @override
  String get noConfigurationDataHeadline => 'Sem Dados';

  @override
  String get noConfigurationDataSubheadline =>
      'Erro ao carregar configuração remota.';

  @override
  String get readOnlyConfigurationView => 'Visualização Somente Leitura';

  @override
  String get readOnlyConfigurationViewDescription =>
      'Instantâneo em tempo real.';

  @override
  String get providers => 'Provedores';

  @override
  String get summary => 'Resumo';

  @override
  String get about => 'Sobre';

  @override
  String get localizationConfigDescription => 'Idiomas suportados e padrão.';

  @override
  String get enabledLanguagesLabel => 'Idiomas Ativados';

  @override
  String get cannotDisableDefaultLanguage => 'Não pode desativar o padrão.';

  @override
  String get atLeastOneLanguageRequired => 'Pelo menos um idioma é necessário.';

  @override
  String get defaultLanguageLabel => 'Idioma Padrão';

  @override
  String get defaultLanguageDescription => 'Idioma de fallback.';

  @override
  String get localizationTitle => 'Localização';

  @override
  String get localizationDescription => 'Controla os idiomas ativos.';

  @override
  String defaultLanguageRequired(String language) {
    return 'O idioma padrão ($language) é obrigatório.';
  }

  @override
  String get languageNameEn => 'Inglês';

  @override
  String get languageNameEs => 'Espanhol';

  @override
  String get languageNameFr => 'Francês';

  @override
  String get languageNameAr => 'Árabe';

  @override
  String get languageNamePt => 'Português';

  @override
  String get languageNameDe => 'Alemão';

  @override
  String get languageNameIt => 'Italiano';

  @override
  String get languageNameZh => 'Chinês';

  @override
  String get languageNameHi => 'Hindi';

  @override
  String get languageNameJa => 'Japonês';
}
