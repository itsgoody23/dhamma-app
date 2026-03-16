import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/onboarding_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/library/book_list_screen.dart';
import '../../features/reader/reader_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/daily/daily_screen.dart';
import '../../features/daily/plan_detail_screen.dart';
import '../../features/study_tools/study_tools_screen.dart';
import '../../features/downloads/downloads_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../shared/widgets/main_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.daily,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_complete') ?? false;
      if (!onboardingDone && state.uri.path != Routes.onboarding) {
        return Routes.onboarding;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.library,
              builder: (context, state) => const LibraryScreen(),
              routes: [
                GoRoute(
                  path: ':nikaya',
                  builder: (context, state) => BookListScreen(
                    nikaya: state.pathParameters['nikaya']!,
                  ),
                  routes: [
                    GoRoute(
                      path: ':book',
                      builder: (context, state) => BookListScreen(
                        nikaya: state.pathParameters['nikaya']!,
                        book: state.pathParameters['book'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.daily,
              builder: (context, state) => const DailyScreen(),
              routes: [
                GoRoute(
                  path: 'plan/:planId',
                  builder: (context, state) => PlanDetailScreen(
                    planId: state.pathParameters['planId']!,
                  ),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.study,
              builder: (context, state) => const StudyToolsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.downloads,
              builder: (context, state) => const DownloadsScreen(),
            ),
          ]),
        ],
      ),
      // Reader is pushed on top of the shell (not a tab)
      GoRoute(
        path: Routes.reader,
        builder: (context, state) => ReaderScreen(
          uid: state.pathParameters['uid']!,
          language: state.uri.queryParameters['lang'] ?? 'en',
        ),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
