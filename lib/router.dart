import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import 'package:surface/screens/account.dart';
import 'package:surface/screens/account/profile_edit.dart';
import 'package:surface/screens/account/publishers/publisher_edit.dart';
import 'package:surface/screens/account/publishers/publisher_new.dart';
import 'package:surface/screens/account/publishers/publishers.dart';
import 'package:surface/screens/album.dart';
import 'package:surface/screens/auth/login.dart';
import 'package:surface/screens/auth/register.dart';
import 'package:surface/screens/chat.dart';
import 'package:surface/screens/explore.dart';
import 'package:surface/screens/home.dart';
import 'package:surface/screens/post/post_detail.dart';
import 'package:surface/screens/post/post_editor.dart';
import 'package:surface/screens/settings.dart';
import 'package:surface/types/post.dart';
import 'package:surface/widgets/navigation/app_background.dart';
import 'package:surface/widgets/navigation/app_scaffold.dart';

final _appRoutes = [
  ShellRoute(
    builder: (context, state, child) => AppPageScaffold(
      body: child,
      showAppBar: false,
    ),
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/posts',
        name: 'explore',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ExploreScreen(),
        ),
        routes: [
          GoRoute(
            path: '/post/write/:mode',
            name: 'postEditor',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: PostEditorScreen(
                mode: state.pathParameters['mode']!,
                postEditId: int.tryParse(
                  state.uri.queryParameters['editing'] ?? '',
                ),
                postReplyId: int.tryParse(
                  state.uri.queryParameters['replying'] ?? '',
                ),
                postRepostId: int.tryParse(
                  state.uri.queryParameters['reposting'] ?? '',
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: AppBackground(isLessOptimization: true, child: child),
                );
              },
            ),
          ),
          GoRoute(
            path: '/post/:slug',
            name: 'postDetail',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: PostDetailScreen(
                slug: state.pathParameters['slug']!,
                preload: state.extra as SnPost?,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: AppBackground(isLessOptimization: true, child: child),
                );
              },
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AccountScreen(),
        ),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ChatScreen(),
        ),
      ),
      GoRoute(
        path: '/album',
        name: 'album',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AlbumScreen(),
        ),
      ),
    ],
  ),
  ShellRoute(
    builder: (context, state, child) => AppPageScaffold(body: child),
    routes: [
      GoRoute(
        path: '/auth/login',
        name: 'authLogin',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'authRegister',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/account/profile/edit',
        name: 'accountProfileEdit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/account/publishers',
        name: 'accountPublishers',
        builder: (context, state) => const PublisherScreen(),
      ),
      GoRoute(
        path: '/account/publishers/new',
        name: 'accountPublisherNew',
        builder: (context, state) => const AccountPublisherNewScreen(),
      ),
      GoRoute(
        path: '/account/publishers/edit/:name',
        name: 'accountPublisherEdit',
        builder: (context, state) => AccountPublisherEditScreen(
          name: state.pathParameters['name']!,
        ),
      ),
    ],
  ),
  ShellRoute(
    builder: (context, state, child) => AppPageScaffold(body: child),
    routes: [
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  ),
];

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      routes: _appRoutes,
      builder: (context, state, child) => AppRootScaffold(body: child),
    ),
  ],
);
