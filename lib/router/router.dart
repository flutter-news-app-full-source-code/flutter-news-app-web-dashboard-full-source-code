import 'package:auth_repository/auth_repository.dart';
import 'package:core/core.dart' hide AppStatus;
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/bloc/app_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart'
    as local_config;
import 'package:flutter_news_app_web_dashboard_full_source_code/app/view/app_shell.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app_configuration/view/app_configuration_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/authentication_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/email_code_verification_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/authentication/view/request_code_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/content_management_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/headlines_filter/headlines_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/sources_filter/sources_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/bloc/topics_filter/topics_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/content_management_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_source_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/create_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_headline_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_source_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/view/edit_topic_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/filter_dialog/bloc/filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/content_management/widgets/filter_dialog/filter_dialog.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/overview/view/overview_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/route_permissions.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/router/routes.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/settings/view/settings_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/selection_page/searchable_selection_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/widgets/selection_page/selection_page_arguments.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/bloc/user_filter/user_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/view/user_management_page.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_filter_dialog/bloc/user_filter_dialog_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/user_management/widgets/user_filter_dialog/user_filter_dialog.dart';
import 'package:go_router/go_router.dart';

/// Creates and configures the GoRouter instance for the application.
///
/// Requires an [authStatusNotifier] to trigger route re-evaluation when
/// authentication state changes.
GoRouter createRouter({
  required ValueNotifier<AppStatus> authStatusNotifier,
  required AuthRepository authenticationRepository,
  required local_config.AppEnvironment environment,
}) {
  return GoRouter(
    refreshListenable: authStatusNotifier,
    initialLocation: Routes.authentication,
    debugLogDiagnostics: true,
    // --- Redirect Logic ---
    redirect: (BuildContext context, GoRouterState state) {
      final appStatus = context.read<AppBloc>().state.status;
      final currentLocation = state.matchedLocation;

      print(
        'GoRouter Redirect Check:\n'
        '  Current Location (Matched): $currentLocation\n'
        '  AppStatus: $appStatus\n',
      );

      // --- Define Key Paths ---
      const authenticationPath = Routes.authentication;
      const overviewPath = Routes.overview;
      final isGoingToAuth = currentLocation.startsWith(authenticationPath);

      // --- Case 1: Unauthenticated User ---
      if (appStatus == AppStatus.unauthenticated ||
          appStatus == AppStatus.initial) {
        print('  Redirect Decision: User is UNauthenticated or INITIAL.');
        if (!isGoingToAuth) {
          print(
            '    Action: Not going to auth. Redirecting to $authenticationPath',
          );
          return authenticationPath;
        }
        print('    Action: Already going to auth. Allowing navigation.');
        return null;
      }

      // --- Case 2: Authenticated User ---
      if (appStatus == AppStatus.authenticated) {
        print('  Redirect Decision: User is $appStatus.');

        // --- Role-Based Access Control (RBAC) ---
        final userRole = context.read<AppBloc>().state.user?.dashboardRole;

        // Allow navigation if the user role isn't determined yet.
        if (userRole == null) {
          return null;
        }

        // A local map to resolve top-level route names to their base paths.
        // This is the single source for this mapping within the redirect logic.
        const topLevelPaths = {
          Routes.overviewName: Routes.overview,
          Routes.contentManagementName: Routes.contentManagement,
          Routes.userManagementName: Routes.userManagement,
          Routes.appConfigurationName: Routes.appConfiguration,
        };

        // Get the set of authorized route *names* for the user's role from
        // the single source of truth: route_permissions.dart.
        final allowedRouteNames = routePermissions[userRole] ?? {};

        // Convert the allowed route names into a list of their base paths.
        final authorizedPaths = allowedRouteNames
            .map((name) => topLevelPaths[name])
            .whereType<
              String
            >() // Filter out any nulls if a name is not in the map.
            .toList();

        // Check if the destination path starts with any of the authorized base
        // paths, or if it's the universally accessible settings page.
        final isAuthorized =
            authorizedPaths.any(
              currentLocation.startsWith,
            ) ||
            currentLocation.startsWith(Routes.settings);

        if (!isAuthorized) {
          print(
            '    Action: Unauthorized access to "$currentLocation" for role '
            '$userRole. Authorized base paths: $authorizedPaths. '
            'Redirecting to $overviewPath.',
          );
          // Redirect unauthorized users to the overview page. This is a safe
          // redirect without side effects.
          return Routes.overview;
        }
        // --- End of RBAC ---

        // If an authenticated user is on any authentication-related path:
        if (isGoingToAuth) {
          print(
            '    Action: Authenticated user on auth path ($currentLocation). '
            'Redirecting to $overviewPath',
          );
          return overviewPath;
        }
        // Allow access to other routes (non-auth paths), which should only be dashboard overview for now
        print(
          '    Action: Allowing navigation to $currentLocation for $appStatus '
          'user (non-auth path).',
        );
        return null;
      }

      // Fallback (should ideally not be reached if all statuses are handled)
      print(
        '  Redirect Decision: Fallback, no specific condition met for $appStatus. '
        'Allowing navigation.',
      );
      return null;
    },
    // --- Routes ---
    routes: [
      GoRoute(
        path: Routes.authentication,
        name: Routes.authenticationName,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: context.read<AuthRepository>(),
            ),
            child: const AuthenticationPage(),
          );
        },
        routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.overview,
                name: Routes.overviewName,
                builder: (context, state) => const OverviewPage(),
                routes: [
                  // The settings page is a sub-route of the dashboard overview.
                  // This allows it to be displayed within the AppShell
                  // (with sidebar and top bar visible) without adding
                  // a new item to the main navigation sidebar.
                  GoRoute(
                    path: Routes.settings,
                    name: Routes.settingsName,
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.contentManagement,
                name: Routes.contentManagementName,
                builder: (context, state) => const ContentManagementPage(),
                routes: [
                  // The create/edit routes are now direct children of
                  // content-management, so navigating back will always land on
                  // the ContentManagementPage with the correct AppBar/TabBar.
                  GoRoute(
                    path: Routes.createHeadline,
                    name: Routes.createHeadlineName,
                    builder: (context, state) => const CreateHeadlinePage(),
                  ),
                  GoRoute(
                    path: Routes.editHeadline,
                    name: Routes.editHeadlineName,
                    builder: (context, state) {
                      final headlineId = state.pathParameters['id']!;
                      return EditHeadlinePage(headlineId: headlineId);
                    },
                  ),
                  GoRoute(
                    path: Routes.createTopic,
                    name: Routes.createTopicName,
                    builder: (context, state) => const CreateTopicPage(),
                  ),
                  GoRoute(
                    path: Routes.editTopic,
                    name: Routes.editTopicName,
                    builder: (context, state) {
                      final topicId = state.pathParameters['id']!;
                      return EditTopicPage(topicId: topicId);
                    },
                  ),
                  GoRoute(
                    path: Routes.createSource,
                    name: Routes.createSourceName,
                    builder: (context, state) => const CreateSourcePage(),
                  ),
                  GoRoute(
                    path: Routes.editSource,
                    name: Routes.editSourceName,
                    builder: (context, state) {
                      final sourceId = state.pathParameters['id']!;
                      return EditSourcePage(sourceId: sourceId);
                    },
                  ),
                  // Moved searchableSelection as a sub-route of content-management
                  GoRoute(
                    path: Routes.searchableSelection,
                    name: Routes.searchableSelectionName,
                    pageBuilder: (context, state) {
                      final arguments = state.extra! as SelectionPageArguments;
                      return MaterialPage(
                        fullscreenDialog: true,
                        child: SearchableSelectionPage(arguments: arguments),
                      );
                    },
                  ),
                  // New route for the FilterDialog
                  GoRoute(
                    path: Routes.filterDialog,
                    name: Routes.filterDialogName,
                    pageBuilder: (context, state) {
                      final args = state.extra! as Map<String, dynamic>;
                      final activeTab =
                          args['activeTab'] as ContentManagementTab;
                      final sourcesRepository =
                          args['sourcesRepository'] as DataRepository<Source>;
                      final topicsRepository =
                          args['topicsRepository'] as DataRepository<Topic>;
                      final countriesRepository =
                          args['countriesRepository']
                              as DataRepository<Country>;
                      final languagesRepository =
                          args['languagesRepository']
                              as DataRepository<Language>;

                      return MaterialPage(
                        fullscreenDialog: true,
                        child: BlocProvider<FilterDialogBloc>(
                          create: (providerContext) {
                            final filterDialogBloc =
                                FilterDialogBloc(
                                    activeTab: activeTab,
                                    sourcesRepository: sourcesRepository,
                                    topicsRepository: topicsRepository,
                                    countriesRepository: countriesRepository,
                                    languagesRepository: languagesRepository,
                                  )
                                  // Dispatch initial state after creation
                                  ..add(
                                    FilterDialogInitialized(
                                      activeTab: activeTab,
                                      headlinesFilterState: providerContext
                                          .read<HeadlinesFilterBloc>()
                                          .state,
                                      topicsFilterState: providerContext
                                          .read<TopicsFilterBloc>()
                                          .state,
                                      sourcesFilterState: providerContext
                                          .read<SourcesFilterBloc>()
                                          .state,
                                    ),
                                  );
                            return filterDialogBloc;
                          },
                          child: FilterDialog(
                            activeTab: activeTab,
                            sourcesRepository: sourcesRepository,
                            topicsRepository: topicsRepository,
                            countriesRepository: countriesRepository,
                            languagesRepository: languagesRepository,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.userManagement,
                name: Routes.userManagementName,
                builder: (context, state) => const UserManagementPage(),
                routes: [
                  // Route for the UserFilterDialog.
                  GoRoute(
                    path: Routes.userFilterDialog,
                    name: Routes.userFilterDialogName,
                    pageBuilder: (context, state) {
                      final args = state.extra! as Map<String, dynamic>;
                      final userFilterState =
                          args['userFilterState'] as UserFilterState;

                      return MaterialPage(
                        fullscreenDialog: true,
                        child: BlocProvider<UserFilterDialogBloc>(
                          create: (providerContext) =>
                              UserFilterDialogBloc()..add(
                                UserFilterDialogInitialized(
                                  userFilterState: userFilterState,
                                ),
                              ),
                          child: const UserFilterDialog(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.appConfiguration,
                name: Routes.appConfigurationName,
                builder: (context, state) => const AppConfigurationPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
