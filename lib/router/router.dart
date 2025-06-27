import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_dashboard/app/bloc/app_bloc.dart';
import 'package:ht_dashboard/app/config/config.dart' as local_config;
import 'package:ht_dashboard/app/view/app_shell.dart';
import 'package:ht_dashboard/authentication/bloc/authentication_bloc.dart';
import 'package:ht_dashboard/authentication/view/authentication_page.dart';
import 'package:ht_dashboard/authentication/view/email_code_verification_page.dart';
import 'package:ht_dashboard/authentication/view/request_code_page.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/routes.dart';
import 'package:ht_shared/ht_shared.dart';

/// Creates and configures the GoRouter instance for the application.
///
/// Requires an [authStatusNotifier] to trigger route re-evaluation when
/// authentication state changes.
GoRouter createRouter({
  required ValueNotifier<AppStatus> authStatusNotifier,
  required HtAuthRepository htAuthenticationRepository,
  required HtDataRepository<Headline> htHeadlinesRepository,
  required HtDataRepository<Category> htCategoriesRepository,
  required HtDataRepository<Country> htCountriesRepository,
  required HtDataRepository<Source> htSourcesRepository,
  required HtDataRepository<UserAppSettings> htUserAppSettingsRepository,
  required HtDataRepository<UserContentPreferences>
  htUserContentPreferencesRepository,
  required HtDataRepository<AppConfig> htAppConfigRepository,
  required local_config.AppEnvironment environment,
}) {
  // Instantiate AccountBloc once to be shared
  final accountBloc = AccountBloc(
    authenticationRepository: htAuthenticationRepository,
    userContentPreferencesRepository: htUserContentPreferencesRepository,
    environment: environment,
  );

  return GoRouter(
    refreshListenable: authStatusNotifier,
    initialLocation: Routes.feed,
    debugLogDiagnostics: true,
    // --- Redirect Logic ---
    redirect: (BuildContext context, GoRouterState state) {
      final appStatus = context.read<AppBloc>().state.status;
      final appConfig = context.read<AppBloc>().state.appConfig;
      final currentLocation = state.matchedLocation;
      final currentUri = state.uri;

      print(
        'GoRouter Redirect Check:\n'
        '  Current Location (Matched): $currentLocation\n'
        '  Current URI (Full): $currentUri\n'
        '  AppStatus: $appStatus\n'
        '  AppConfig isNull: ${appConfig == null}',
      );

      // --- Define Key Paths ---
      const authenticationPath = Routes.authentication;
      const feedPath = Routes.feed;
      final isGoingToAuth = currentLocation.startsWith(authenticationPath);

      // --- Case 0: App is Initializing or Config is being fetched/failed ---
      if (appStatus == AppStatus.initial ||
          appStatus == AppStatus.configFetching ||
          appStatus == AppStatus.configFetchFailed) {
        // If AppStatus is initial and trying to go to a non-auth page (e.g. initial /feed)
        // redirect to auth immediately to settle auth status first.
        if (appStatus == AppStatus.initial && !isGoingToAuth) {
          print(
            '  Redirect Decision: AppStatus is INITIAL and not going to auth. Redirecting to $authenticationPath to settle auth first.',
          );
          return authenticationPath;
        }
        // For configFetching or configFetchFailed, or initial going to auth,
        // let the App widget's builder handle the UI (loading/error screen).
        print(
          '  Redirect Decision: AppStatus is $appStatus. Allowing App widget to handle display or navigation to auth.',
        );
        return null;
      }

      // --- Case 1: Unauthenticated User (after initial phase, config not relevant yet for this decision) ---
      if (appStatus == AppStatus.unauthenticated) {
        print('  Redirect Decision: User is UNauthenticated.');
        if (!isGoingToAuth) {
          print(
            '    Action: Not going to auth. Redirecting to $authenticationPath',
          );
          return authenticationPath;
        }
        print('    Action: Already going to auth. Allowing navigation.');
        return null;
      }

      // --- Case 2: Anonymous or Authenticated User ---
      // (Covers AppStatus.anonymous and AppStatus.authenticated)
      // At this point, AppConfig should be loaded or its loading/error state is handled by App widget.
      // The main concern here is preventing authenticated users from re-entering basic auth flows.
      if (appStatus == AppStatus.anonymous ||
          appStatus == AppStatus.authenticated) {
        print('  Redirect Decision: User is $appStatus.');

        final isLinkingContextQueryPresent =
            state.uri.queryParameters['context'] == 'linking';
        final isLinkingPathSegmentPresent = currentLocation.contains(
          '/linking/',
        );

        // Determine if the current location is part of any linking flow (either via query or path segment)
        final isAnyLinkingContext =
            isLinkingContextQueryPresent || isLinkingPathSegmentPresent;

        // If an authenticated/anonymous user is on any authentication-related path:
        if (currentLocation.startsWith(authenticationPath)) {
          print(
            '    Debug: Auth path detected. Current Location: $currentLocation',
          );
          print(
            '    Debug: URI Query Parameters: ${state.uri.queryParameters}',
          );
          print(
            '    Debug: isLinkingContextQueryPresent: $isLinkingContextQueryPresent',
          );
          print(
            '    Debug: isLinkingPathSegmentPresent: $isLinkingPathSegmentPresent',
          );
          print(
            '    Debug: isAnyLinkingContext evaluated to: $isAnyLinkingContext',
          );

          // If the user is authenticated, always redirect away from auth paths.
          if (appStatus == AppStatus.authenticated) {
            print(
              '    Action: Authenticated user on auth path ($currentLocation). Redirecting to $feedPath',
            );
            return feedPath;
          }

          // If the user is anonymous, allow navigation within auth paths if in a linking context.
          // Otherwise, redirect anonymous users trying to access non-linking auth paths to feed.
          if (isAnyLinkingContext) {
            print(
              '    Action: Anonymous user on auth linking path ($currentLocation). Allowing navigation.',
            );
            return null;
          } else {
            print(
              '    Action: Anonymous user trying to access non-linking auth path ($currentLocation). Redirecting to $feedPath',
            );
            return feedPath;
          }
        }
        // Allow access to other routes (non-auth paths)
        print(
          '    Action: Allowing navigation to $currentLocation for $appStatus user (non-auth path).',
        );
        return null;
      }

      // Fallback (should ideally not be reached if all statuses are handled)
      print(
        '  Redirect Decision: Fallback, no specific condition met for $appStatus. Allowing navigation.',
      );
      return null;
    },
    // --- Authentication Routes ---
    routes: [
      GoRoute(
        path: Routes.authentication,
        name: Routes.authenticationName,
        builder: (BuildContext context, GoRouterState state) {
          final l10n = context.l10n;
          // Determine context from query parameter
          final isLinkingContext =
              state.uri.queryParameters['context'] == 'linking';

          // Define content based on context
          final String headline;
          final String subHeadline;
          final bool showAnonymousButton;

          if (isLinkingContext) {
            headline = l10n.authenticationLinkingHeadline;
            subHeadline = l10n.authenticationLinkingSubheadline;
            showAnonymousButton = false;
          } else {
            headline = l10n.authenticationSignInHeadline;
            subHeadline = l10n.authenticationSignInSubheadline;
            showAnonymousButton = true;
          }

          return BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: context.read<HtAuthRepository>(),
            ),
            child: AuthenticationPage(
              headline: headline,
              subHeadline: subHeadline,
              showAnonymousButton: showAnonymousButton,
              isLinkingContext: isLinkingContext,
            ),
          );
        },
        routes: [
          // Nested route for account linking flow (defined first for priority)
          GoRoute(
            path: Routes.accountLinking,
            name: Routes.accountLinkingName,
            builder: (context, state) => const SizedBox.shrink(),
            routes: [
              GoRoute(
                path: Routes.requestCode,
                name: Routes.linkingRequestCodeName,
                builder: (context, state) =>
                    const RequestCodePage(isLinkingContext: true),
              ),
              GoRoute(
                path: '${Routes.verifyCode}/:email',
                name: Routes.linkingVerifyCodeName,
                builder: (context, state) {
                  final email = state.pathParameters['email']!;
                  return EmailCodeVerificationPage(email: email);
                },
              ),
            ],
          ),
          // Non-linking authentication routes (defined after linking routes)
          GoRoute(
            path: Routes.requestCode,
            name: Routes.requestCodeName,
            builder: (context, state) =>
                const RequestCodePage(isLinkingContext: false),
          ),
          GoRoute(
            path: '${Routes.verifyCode}/:email',
            name: Routes.verifyCodeName,
            builder: (context, state) {
              final email = state.pathParameters['email']!;
              return EmailCodeVerificationPage(email: email);
            },
          ),
        ],
      ),
      // --- Entity Details Routes (Top Level) ---
      GoRoute(
        path: Routes.categoryDetails,
        name: Routes.categoryDetailsName,
        builder: (context, state) {
          final args = state.extra as EntityDetailsPageArguments?;
          if (args == null) {
            return const Scaffold(
              body: Center(
                child: Text('Error: Missing category details arguments'),
              ),
            );
          }
          return BlocProvider.value(
            value: accountBloc,
            child: EntityDetailsPage(args: args),
          );
        },
      ),
      GoRoute(
        path: Routes.sourceDetails,
        name: Routes.sourceDetailsName,
        builder: (context, state) {
          final args = state.extra as EntityDetailsPageArguments?;
          if (args == null) {
            return const Scaffold(
              body: Center(
                child: Text('Error: Missing source details arguments'),
              ),
            );
          }
          return BlocProvider.value(
            value: accountBloc,
            child: EntityDetailsPage(args: args),
          );
        },
      ),
      // --- Global Article Details Route (Top Level) ---
      // This GoRoute provides a top-level, globally accessible way to view the
      // HeadlineDetailsPage.
      //
      // Purpose:
      // It is specifically designed for navigating to article details from contexts
      // that are *outside* the main StatefulShellRoute's branches (e.g., from
      // EntityDetailsPage, which is itself a top-level route, or potentially
      // from other future top-level pages or deep links).
      //
      // Why it's necessary:
      // Attempting to push a route that is deeply nested within a specific shell
      // branch (like '/feed/article/:id') from a BuildContext outside of that
      // shell can lead to navigator context issues and assertion failures.
      // This global route avoids such problems by providing a clean, direct path
      // to the HeadlineDetailsPage.
      //
      // How it differs:
      // This route is distinct from the article detail routes nested within the
      // StatefulShellRoute branches (e.g., Routes.articleDetailsName under /feed,
      // Routes.searchArticleDetailsName under /search). Those nested routes are
      // intended for navigation *within* their respective shell branches,
      // preserving the shell's UI (like the bottom navigation bar).
      // This global route, being top-level, will typically cover the entire screen.
      GoRoute(
        path: Routes.globalArticleDetails,
        name: Routes.globalArticleDetailsName,
        builder: (context, state) {
          final headlineFromExtra = state.extra as Headline?;
          final headlineIdFromPath = state.pathParameters['id'];

          // Ensure accountBloc is available if needed by HeadlineDetailsPage
          // or its descendants for actions like saving.
          // If AccountBloc is already provided higher up (e.g., in AppShell or App),
          // this specific BlocProvider.value might not be strictly necessary here,
          // but it's safer to ensure it's available for this top-level route.
          // We are using the `accountBloc` instance created at the top of `createRouter`.
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: accountBloc),
              BlocProvider(
                create: (context) => HeadlineDetailsBloc(
                  headlinesRepository: context
                      .read<HtDataRepository<Headline>>(),
                ),
              ),
              BlocProvider(
                create: (context) => SimilarHeadlinesBloc(
                  headlinesRepository: context
                      .read<HtDataRepository<Headline>>(),
                ),
              ),
            ],
            child: HeadlineDetailsPage(
              initialHeadline: headlineFromExtra,
              headlineId: headlineFromExtra?.id ?? headlineIdFromPath,
            ),
          );
        },
      ),
      // --- Main App Shell ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the shell widget which contains the AdaptiveScaffold
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: accountBloc),
              BlocProvider(
                create: (context) {
                  // Instantiate FeedInjectorService here as it's stateless for now
                  final feedInjectorService = FeedInjectorService();
                  return HeadlinesFeedBloc(
                    headlinesRepository: context
                        .read<HtDataRepository<Headline>>(),
                    feedInjectorService: feedInjectorService,
                    appBloc: context.read<AppBloc>(),
                  )..add(const HeadlinesFeedFetchRequested());
                },
              ),
              BlocProvider(
                create: (context) {
                  final feedInjectorService = FeedInjectorService();
                  return HeadlinesSearchBloc(
                    headlinesRepository: context
                        .read<HtDataRepository<Headline>>(),
                    categoryRepository: context
                        .read<HtDataRepository<Category>>(),
                    sourceRepository: context.read<HtDataRepository<Source>>(),
                    appBloc: context.read<AppBloc>(),
                    feedInjectorService: feedInjectorService,
                  );
                },
              ),
              // Removed separate AccountBloc creation here
            ],
            child: AppShell(navigationShell: navigationShell),
          );
        },
        branches: [
          // --- Branch 1: Feed ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.feed,
                name: Routes.feedName,
                builder: (context, state) => const HeadlinesFeedPage(),
                routes: [
                  // Sub-route for article details
                  GoRoute(
                    path: 'article/:id',
                    name: Routes.articleDetailsName,
                    builder: (context, state) {
                      final headlineFromExtra = state.extra as Headline?;
                      final headlineIdFromPath = state.pathParameters['id'];

                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: accountBloc),
                          BlocProvider(
                            create: (context) => HeadlineDetailsBloc(
                              headlinesRepository: context
                                  .read<HtDataRepository<Headline>>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SimilarHeadlinesBloc(
                              headlinesRepository: context
                                  .read<HtDataRepository<Headline>>(),
                            ),
                          ),
                        ],
                        child: HeadlineDetailsPage(
                          initialHeadline: headlineFromExtra,
                          // Ensure headlineId is non-null if initialHeadline is null
                          headlineId:
                              headlineFromExtra?.id ?? headlineIdFromPath,
                        ),
                      );
                    },
                  ),
                  // Sub-route for notifications (placeholder) - MOVED HERE
                  GoRoute(
                    path: Routes.notifications,
                    name: Routes.notificationsName,
                    builder: (context, state) {
                      // TODO(fulleni): Replace with actual NotificationsPage
                      return const Placeholder(
                        child: Center(child: Text('NOTIFICATIONS PAGE')),
                      );
                    },
                  ),

                  // --- Filter Routes (Nested under Feed) ---
                  GoRoute(
                    path: Routes.feedFilter,
                    name: Routes.feedFilterName,
                    // Use MaterialPage with fullscreenDialog for modal presentation
                    pageBuilder: (context, state) {
                      // Access the HeadlinesFeedBloc from the context
                      BlocProvider.of<HeadlinesFeedBloc>(context);
                      return const MaterialPage(
                        fullscreenDialog: true,
                        child: HeadlinesFilterPage(),
                      );
                    },
                    routes: [
                      // Sub-route for category selection
                      GoRoute(
                        path: Routes.feedFilterCategories,
                        name: Routes.feedFilterCategoriesName,
                        // Wrap with BlocProvider
                        builder: (context, state) => BlocProvider(
                          create: (context) => CategoriesFilterBloc(
                            categoriesRepository: context
                                .read<HtDataRepository<Category>>(),
                          ),
                          child: const CategoryFilterPage(),
                        ),
                      ),
                      // Sub-route for source selection
                      GoRoute(
                        path: Routes.feedFilterSources,
                        name: Routes.feedFilterSourcesName,
                        // Wrap with BlocProvider
                        builder: (context, state) => BlocProvider(
                          create: (context) => SourcesFilterBloc(
                            sourcesRepository: context
                                .read<HtDataRepository<Source>>(),
                            countriesRepository: // Added missing repository
                            context
                                .read<HtDataRepository<Country>>(),
                          ),
                          // Pass initialSelectedSources, country ISO codes, and source types from state.extra
                          child: Builder(
                            builder: (context) {
                              final extraData =
                                  state.extra as Map<String, dynamic>? ??
                                  const {};
                              final initialSources =
                                  extraData[keySelectedSources]
                                      as List<Source>? ??
                                  const [];
                              final initialCountryIsoCodes =
                                  extraData[keySelectedCountryIsoCodes]
                                      as Set<String>? ??
                                  const {};
                              final initialSourceTypes =
                                  extraData[keySelectedSourceTypes]
                                      as Set<SourceType>? ??
                                  const {};

                              return SourceFilterPage(
                                initialSelectedSources: initialSources,
                                initialSelectedCountryIsoCodes:
                                    initialCountryIsoCodes,
                                initialSelectedSourceTypes: initialSourceTypes,
                              );
                            },
                          ),
                        ),
                      ),
                      // Sub-route for country selection REMOVED
                    ],
                  ),
                ],
              ),
            ],
          ),
          // --- Branch 2: Search ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.search,
                name: Routes.searchName,
                builder: (context, state) => const HeadlinesSearchPage(),
                routes: [
                  // Sub-route for article details from search
                  GoRoute(
                    path: 'article/:id',
                    name: Routes.searchArticleDetailsName,
                    builder: (context, state) {
                      final headlineFromExtra = state.extra as Headline?;
                      final headlineIdFromPath = state.pathParameters['id'];
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: accountBloc),
                          BlocProvider(
                            create: (context) => HeadlineDetailsBloc(
                              headlinesRepository: context
                                  .read<HtDataRepository<Headline>>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SimilarHeadlinesBloc(
                              headlinesRepository: context
                                  .read<HtDataRepository<Headline>>(),
                            ),
                          ),
                        ],
                        child: HeadlineDetailsPage(
                          initialHeadline: headlineFromExtra,
                          headlineId:
                              headlineFromExtra?.id ?? headlineIdFromPath,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // --- Branch 3: Account ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                name: Routes.accountName,
                builder: (context, state) => const AccountPage(),
                routes: [
                  // ShellRoute for settings to provide SettingsBloc to children
                  ShellRoute(
                    builder: (BuildContext context, GoRouterState state, Widget child) {
                      // This builder provides SettingsBloc to all routes within this ShellRoute.
                      // 'child' will be SettingsPage, AppearanceSettingsPage, etc.
                      final appBloc = context.read<AppBloc>();
                      final userId = appBloc.state.user?.id;

                      return BlocProvider<SettingsBloc>(
                        create: (context) {
                          final settingsBloc = SettingsBloc(
                            userAppSettingsRepository: context
                                .read<HtDataRepository<UserAppSettings>>(),
                          );
                          // Only load settings if a userId is available
                          if (userId != null) {
                            settingsBloc.add(
                              SettingsLoadRequested(userId: userId),
                            );
                          } else {
                            // Handle case where user is unexpectedly null.
                            print(
                              'ShellRoute/SettingsBloc: User ID is null when creating SettingsBloc. Settings will not be loaded.',
                            );
                          }
                          return settingsBloc;
                        },
                        child:
                            child, // child is the actual page widget (SettingsPage, AppearanceSettingsPage, etc.)
                      );
                    },
                    routes: [
                      GoRoute(
                        path: Routes.settings,
                        name: Routes.settingsName,
                        builder: (context, state) => const SettingsPage(),
                        // --- Settings Sub-Routes ---
                        routes: [
                          GoRoute(
                            path: Routes.settingsAppearance,
                            name: Routes.settingsAppearanceName,
                            builder: (context, state) =>
                                const AppearanceSettingsPage(),
                            routes: [
                              // Children of AppearanceSettingsPage
                              GoRoute(
                                path: Routes.settingsAppearanceTheme,
                                name: Routes.settingsAppearanceThemeName,
                                builder: (context, state) =>
                                    const ThemeSettingsPage(),
                              ),
                              GoRoute(
                                path: Routes.settingsAppearanceFont,
                                name: Routes.settingsAppearanceFontName,
                                builder: (context, state) =>
                                    const FontSettingsPage(),
                              ),
                            ],
                          ),
                          GoRoute(
                            path: Routes.settingsFeed,
                            name: Routes.settingsFeedName,
                            builder: (context, state) =>
                                const FeedSettingsPage(),
                          ),
                          GoRoute(
                            path: Routes.settingsNotifications,
                            name: Routes.settingsNotificationsName,
                            builder: (context, state) =>
                                const NotificationSettingsPage(),
                          ),
                          GoRoute(
                            path: Routes.settingsLanguage,
                            name: Routes.settingsLanguageName,
                            builder: (context, state) =>
                                const LanguageSettingsPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // New routes for Account sub-pages
                  GoRoute(
                    path: Routes.manageFollowedItems,
                    name: Routes.manageFollowedItemsName,
                    builder: (context, state) =>
                        const ManageFollowedItemsPage(),
                    routes: [
                      GoRoute(
                        path: Routes.followedCategoriesList,
                        name: Routes.followedCategoriesListName,
                        builder: (context, state) =>
                            const FollowedCategoriesListPage(),
                        routes: [
                          GoRoute(
                            path: Routes.addCategoryToFollow,
                            name: Routes.addCategoryToFollowName,
                            builder: (context, state) =>
                                const AddCategoryToFollowPage(),
                          ),
                        ],
                      ),
                      GoRoute(
                        path: Routes.followedSourcesList,
                        name: Routes.followedSourcesListName,
                        builder: (context, state) =>
                            const FollowedSourcesListPage(),
                        routes: [
                          GoRoute(
                            path: Routes.addSourceToFollow,
                            name: Routes.addSourceToFollowName,
                            builder: (context, state) =>
                                const AddSourceToFollowPage(),
                          ),
                        ],
                      ),
                      // GoRoute for followedCountriesList removed
                    ],
                  ),
                  GoRoute(
                    path: Routes.accountSavedHeadlines,
                    name: Routes.accountSavedHeadlinesName,
                    builder: (context, state) {
                      return const SavedHeadlinesPage();
                    },
                    routes: [
                      GoRoute(
                        path: Routes.accountArticleDetails,
                        name: Routes.accountArticleDetailsName,
                        builder: (context, state) {
                          final headlineFromExtra = state.extra as Headline?;
                          final headlineIdFromPath = state.pathParameters['id'];
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: accountBloc),
                              BlocProvider(
                                create: (context) => HeadlineDetailsBloc(
                                  headlinesRepository: context
                                      .read<HtDataRepository<Headline>>(),
                                ),
                              ),
                              BlocProvider(
                                create: (context) => SimilarHeadlinesBloc(
                                  headlinesRepository: context
                                      .read<HtDataRepository<Headline>>(),
                                ),
                              ),
                            ],
                            child: HeadlineDetailsPage(
                              initialHeadline: headlineFromExtra,
                              headlineId:
                                  headlineFromExtra?.id ?? headlineIdFromPath,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Placeholder pages were moved to their respective files:
// - lib/headlines-feed/view/headlines_filter_page.dart
// - lib/headlines-feed/view/category_filter_page.dart
// - lib/headlines-feed/view/source_filter_page.dart
// - lib/headlines-feed/view/country_filter_page.dart
