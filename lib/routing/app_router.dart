import 'package:fluro/fluro.dart';

class ApplicationRouter {
  static late final FluroRouter router;
}












// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import 'package:skibble/splash_screen.dart';
// import 'package:skibble/src/features/authentication/controllers/custom_auth_service.dart';
//
// import 'package:skibble/features/walkthrough/walkthrough_screen.dart';
//
// import '../main_page_parent.dart';
// import '../src/features/authentication/views/shared_screens/register_page.dart';
// import '../src/features/authentication/views/user/user_login_page.dart';
//
// // private navigators
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKey = GlobalKey<NavigatorState>();
//
// enum AppRoute {
//   onboarding,
//   signIn,
//   signUp,
//   splash,
//   home,
//   feed,
//   explore,
//   market,
//   currentUserProfile,
//   userProfile,
//   chats,
//   notifications,
//   verifyEmail,
//   root
// }
//
// final goRouter = GoRouter(
//   initialLocation: '/splash',
//   navigatorKey: _rootNavigatorKey,
//   debugLogDiagnostics: true,
//   redirect: (context, state) async{
//     var authService = Provider.of<CustomAuthService>(context,);
//     // final didCompleteOnboarding = onboardingService.isOnboardingComplete();
//     // if (!didCompleteOnboarding) {
//       // await onboardingService.setOnboardingComplete();
//       // Always check state.subloc before returning a non-null route
//       // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
//       if (state.subloc != '/onboarding') {
//         return '/onboarding';
//       // }
//     }
//     final _isAuthenticated = await authService.currentUser() != null;
//     final _userIsOnLoginPage = state.subloc.startsWith('/signIn');
//     final _userIsOnRegisterPage = state.subloc.startsWith('/signUp');
//     final _userIsOnHomePage = state.subloc.startsWith('/home');
//     final _userIsOnExplorePage = state.subloc.startsWith('/explore');
//     final _userIsOnMarketPage = state.subloc.startsWith('/market');
//     final _userIsOnProfilePage = state.subloc.startsWith('/profile');
//
//
//     if (_isAuthenticated) {
//       final isEmailVerified = await authService.currentUser().then((value) => value == null ? false : value.isEmailVerified!);
//
//       if(_userIsOnLoginPage) {
//         if(isEmailVerified) {
//           // await authService.getCurrentUserDataUsingContext(context);
//           return '/home/feed';
//         }
//         else {
//           return '/verifyEmail';
//         }
//       }
//       else {
//         if(isEmailVerified) {
//           // await authService.getCurrentUserDataUsingContext(context);
//
//           return '/home/feed';
//         }
//         else {
//           return '/verifyEmail';
//         }
//       }
//     }
//     else {
//       if (_userIsOnHomePage || _userIsOnExplorePage || _userIsOnMarketPage || _userIsOnProfilePage) {
//         return '/signIn';
//       }
//
//     }
//     return null;
//   },
//   // refreshListenable: GoRouterRefreshStream(authService.userAuthChanges()),
//   routes: [
//     GoRoute(
//       name: AppRoute.root.name,
//       path: '/',
//       redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.home.name, params: {'tab': 'feed'}),
//     ),
//     GoRoute(
//       path: '/onboarding',
//       name: AppRoute.onboarding.name,
//       pageBuilder: (context, state) => NoTransitionPage(
//         key: state.pageKey,
//         child: WalkThroughScreen(isFromStartScreen: false),
//       ),
//     ),
//     GoRoute(
//       path: '/splash',
//       name: AppRoute.splash.name,
//       pageBuilder: (context, state) => NoTransitionPage(
//         key: state.pageKey,
//         child: LoadingPage(),
//       ),
//     ),
//     GoRoute(
//       path: '/signIn',
//       name: AppRoute.signIn.name,
//       pageBuilder: (context, state) => NoTransitionPage(
//         key: state.pageKey,
//         child: const LoginPage(),
//       ),
//       routes: [
//         // GoRoute(
//         //   path: '/signUp',
//         //   name: AppRoute.signUp.name,
//         //   pageBuilder: (context, state) => MaterialPage(
//         //     key: state.pageKey,
//         //     fullscreenDialog: true,
//         //     child: const UserRegisterPage(),
//         //   ),
//         // ),
//       ],
//     ),
//     GoRoute(
//       path: '/signUp',
//       name: AppRoute.signUp.name,
//       pageBuilder: (context, state) => NoTransitionPage(
//         key: state.pageKey,
//         child: RegisterPage(),
//       ),
//       routes: [
//         // GoRoute(
//         //   path: '/signUp',
//         //   name: AppRoute.signUp.name,
//         //   pageBuilder: (context, state) => MaterialPage(
//         //     key: state.pageKey,
//         //     fullscreenDialog: true,
//         //     child: const UserRegisterPage(),
//         //   ),
//         // ),
//       ],
//     ),
//     GoRoute(
//       name: AppRoute.home.name,
//       path: '/${AppRoute.home.name}/:tab(${AppRoute.feed.name}|${AppRoute.explore.name}|${AppRoute.market.name}|${AppRoute.currentUserProfile.name})',
//       pageBuilder: (context, state) {
//         final tab = state.params['tab']!;
//
//         return MaterialPage<void>(
//           key: state.pageKey,
//           child: MainPageParent(tab: tab),
//         );
//       },
//       // routes: [
//       //   GoRoute(
//       //     name: subDetailsRouteName,
//       //     path: 'details/:item',
//       //     pageBuilder: (context, state) => MaterialPage<void>(
//       //       key: state.pageKey,
//       //       child: Details(description: state.params['item']!),
//       //     ),
//       //   ),
//       //   GoRoute(
//       //     name: profilePersonalRouteName,
//       //     path: 'personal',
//       //     pageBuilder: (context, state) => MaterialPage<void>(
//       //       key: state.pageKey,
//       //       child: const PersonalInfo(),
//       //     ),
//       //   ),
//       //   GoRoute(
//       //     name: profilePaymentRouteName,
//       //     path: 'payment',
//       //     pageBuilder: (context, state) => MaterialPage<void>(
//       //       key: state.pageKey,
//       //       child: const Payment(),
//       //     ),
//       //   ),
//       //   GoRoute(
//       //     name: profileSigninInfoRouteName,
//       //     path: 'signin-info',
//       //     pageBuilder: (context, state) => MaterialPage<void>(
//       //       key: state.pageKey,
//       //       child: const SigninInfo(),
//       //     ),
//       //   ),
//       //   GoRoute(
//       //     name: profileMoreInfoRouteName,
//       //     path: 'more-info',
//       //     pageBuilder: (context, state) => MaterialPage<void>(
//       //       key: state.pageKey,
//       //       child: const MoreInfo(),
//       //     ),
//       //   ),
//       // ],
//     ),
//     GoRoute(
//       path: '/feed',
//       name: AppRoute.feed.name,
//       redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.feed.name, params: {'tab': 'feed'}),
//       // pageBuilder: (context, state) => MaterialPage(
//       //   key: state.pageKey,
//       //   child: MainPageParent(),
//       // ),
//     ),
//     GoRoute(
//       path: '/explore',
//       name: AppRoute.explore.name,
//       redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.explore.name, params: {'tab': 'explore'}),
//
//       // pageBuilder: (context, state) => MaterialPage(
//       //   key: state.pageKey,
//       //   child: const NewExplorePage(feedPostsList: []),
//       // ),
//     ),
//     GoRoute(
//       path: '/market',
//       name: AppRoute.market.name,
//       redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.market.name, params: {'tab': 'market'}),
//
//       // pageBuilder: (context, state) => MaterialPage(
//       //   key: state.pageKey,
//       //   child: const MarketView(),
//       // ),
//     ),
//     GoRoute(
//       path: '/currentUserProfile',
//       name: AppRoute.currentUserProfile.name,
//       redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.currentUserProfile.name, params: {'tab': 'currentUserProfile'}),
//
//       // pageBuilder: (context, state) => MaterialPage(
//       //   key: state.pageKey,
//       //   child: CurrentUserProfilePageView(user: SkibbleUser()),
//       // ),
//     ),
//     // ShellRoute(
//     //   navigatorKey: _shellNavigatorKey,
//     //   // builder: (context, state, child) {
//     //   //   return BottomNavigationBar(child: child);
//     //   // },
//     //   routes: [
//     //
//     //   ],
//     // ),
//   ],
//   //errorBuilder: (context, state) => const NotFoundScreen(),
// );
//
// // final goRouterProvider = Provider<GoRouter>((ref) {
// //   // final authService = ref.watch(authServiceProvider);
// //   // final onboardingService = ref.watch(onboardingServiceProvider);
// //   return GoRouter(
// //     initialLocation: '/splash',
// //     navigatorKey: _rootNavigatorKey,
// //     debugLogDiagnostics: true,
// //     redirect: (context, state) async{
// //       final didCompleteOnboarding = onboardingService.isOnboardingComplete();
// //       if (!didCompleteOnboarding) {
// //         await onboardingService.setOnboardingComplete();
// //         // Always check state.subloc before returning a non-null route
// //         // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
// //         if (state.subloc != '/onboarding') {
// //           return '/onboarding';
// //         }
// //       }
// //       final _isAuthenticated = authService.getCurrentUser() != null;
// //       final _userIsOnLoginPage = state.subloc.startsWith('/signIn');
// //       final _userIsOnRegisterPage = state.subloc.startsWith('/signUp');
// //       final _userIsOnHomePage = state.subloc.startsWith('/home');
// //       final _userIsOnExplorePage = state.subloc.startsWith('/explore');
// //       final _userIsOnMarketPage = state.subloc.startsWith('/market');
// //       final _userIsOnProfilePage = state.subloc.startsWith('/profile');
// //
// //
// //       if (_isAuthenticated) {
// //         final isEmailVerified = authService.getCurrentUser()!.emailVerified;
// //
// //         if(_userIsOnLoginPage) {
// //           if(isEmailVerified) {
// //             await authService.getCurrentUserDataUsingContext(context);
// //             return '/home/feed';
// //           }
// //           else {
// //             return '/verifyEmail';
// //           }
// //         }
// //         else {
// //           if(isEmailVerified) {
// //             await authService.getCurrentUserDataUsingContext(context);
// //
// //             return '/home/feed';
// //           }
// //           else {
// //             return '/verifyEmail';
// //           }
// //         }
// //       }
// //       else {
// //         if (_userIsOnHomePage || _userIsOnExplorePage || _userIsOnMarketPage || _userIsOnProfilePage) {
// //           return '/signIn';
// //         }
// //
// //       }
// //       return null;
// //     },
// //     refreshListenable: GoRouterRefreshStream(authService.userAuthChanges()),
// //     routes: [
// //       GoRoute(
// //         name: AppRoute.root.name,
// //         path: '/',
// //         redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.home.name, params: {'tab': 'feed'}),
// //       ),
// //       GoRoute(
// //         path: '/onboarding',
// //         name: AppRoute.onboarding.name,
// //         pageBuilder: (context, state) => NoTransitionPage(
// //           key: state.pageKey,
// //           child: WalkThroughScreen(isFromStartScreen: false),
// //         ),
// //       ),
// //       GoRoute(
// //         path: '/splash',
// //         name: AppRoute.splash.name,
// //         pageBuilder: (context, state) => NoTransitionPage(
// //           key: state.pageKey,
// //           child: Loading(),
// //         ),
// //       ),
// //       GoRoute(
// //         path: '/signIn',
// //         name: AppRoute.signIn.name,
// //         pageBuilder: (context, state) => NoTransitionPage(
// //           key: state.pageKey,
// //           child: const LoginPage(),
// //         ),
// //         routes: [
// //           // GoRoute(
// //           //   path: '/signUp',
// //           //   name: AppRoute.signUp.name,
// //           //   pageBuilder: (context, state) => MaterialPage(
// //           //     key: state.pageKey,
// //           //     fullscreenDialog: true,
// //           //     child: const UserRegisterPage(),
// //           //   ),
// //           // ),
// //         ],
// //       ),
// //       GoRoute(
// //         path: '/signUp',
// //         name: AppRoute.signUp.name,
// //         pageBuilder: (context, state) => NoTransitionPage(
// //           key: state.pageKey,
// //           child: RegisterPage(),
// //         ),
// //         routes: [
// //           // GoRoute(
// //           //   path: '/signUp',
// //           //   name: AppRoute.signUp.name,
// //           //   pageBuilder: (context, state) => MaterialPage(
// //           //     key: state.pageKey,
// //           //     fullscreenDialog: true,
// //           //     child: const UserRegisterPage(),
// //           //   ),
// //           // ),
// //         ],
// //       ),
// //       GoRoute(
// //         name: AppRoute.home.name,
// //         path: '/${AppRoute.home.name}/:tab(${AppRoute.feed.name}|${AppRoute.explore.name}|${AppRoute.market.name}|${AppRoute.currentUserProfile.name})',
// //         pageBuilder: (context, state) {
// //           final tab = state.params['tab']!;
// //
// //           return MaterialPage<void>(
// //             key: state.pageKey,
// //             child: MainPageParent(tab: tab),
// //           );
// //         },
// //         // routes: [
// //         //   GoRoute(
// //         //     name: subDetailsRouteName,
// //         //     path: 'details/:item',
// //         //     pageBuilder: (context, state) => MaterialPage<void>(
// //         //       key: state.pageKey,
// //         //       child: Details(description: state.params['item']!),
// //         //     ),
// //         //   ),
// //         //   GoRoute(
// //         //     name: profilePersonalRouteName,
// //         //     path: 'personal',
// //         //     pageBuilder: (context, state) => MaterialPage<void>(
// //         //       key: state.pageKey,
// //         //       child: const PersonalInfo(),
// //         //     ),
// //         //   ),
// //         //   GoRoute(
// //         //     name: profilePaymentRouteName,
// //         //     path: 'payment',
// //         //     pageBuilder: (context, state) => MaterialPage<void>(
// //         //       key: state.pageKey,
// //         //       child: const Payment(),
// //         //     ),
// //         //   ),
// //         //   GoRoute(
// //         //     name: profileSigninInfoRouteName,
// //         //     path: 'signin-info',
// //         //     pageBuilder: (context, state) => MaterialPage<void>(
// //         //       key: state.pageKey,
// //         //       child: const SigninInfo(),
// //         //     ),
// //         //   ),
// //         //   GoRoute(
// //         //     name: profileMoreInfoRouteName,
// //         //     path: 'more-info',
// //         //     pageBuilder: (context, state) => MaterialPage<void>(
// //         //       key: state.pageKey,
// //         //       child: const MoreInfo(),
// //         //     ),
// //         //   ),
// //         // ],
// //       ),
// //       GoRoute(
// //         path: '/feed',
// //         name: AppRoute.feed.name,
// //         redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.feed.name, params: {'tab': 'feed'}),
// //         // pageBuilder: (context, state) => MaterialPage(
// //         //   key: state.pageKey,
// //         //   child: MainPageParent(),
// //         // ),
// //       ),
// //       GoRoute(
// //         path: '/explore',
// //         name: AppRoute.explore.name,
// //         redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.explore.name, params: {'tab': 'explore'}),
// //
// //         // pageBuilder: (context, state) => MaterialPage(
// //         //   key: state.pageKey,
// //         //   child: const NewExplorePage(feedPostsList: []),
// //         // ),
// //       ),
// //       GoRoute(
// //         path: '/market',
// //         name: AppRoute.market.name,
// //         redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.market.name, params: {'tab': 'market'}),
// //
// //         // pageBuilder: (context, state) => MaterialPage(
// //         //   key: state.pageKey,
// //         //   child: const MarketView(),
// //         // ),
// //       ),
// //       GoRoute(
// //         path: '/currentUserProfile',
// //         name: AppRoute.currentUserProfile.name,
// //         redirect: (context, state) => GoRouter.of(context).namedLocation(AppRoute.currentUserProfile.name, params: {'tab': 'currentUserProfile'}),
// //
// //         // pageBuilder: (context, state) => MaterialPage(
// //         //   key: state.pageKey,
// //         //   child: CurrentUserProfilePageView(user: SkibbleUser()),
// //         // ),
// //       ),
// //       // ShellRoute(
// //       //   navigatorKey: _shellNavigatorKey,
// //       //   // builder: (context, state, child) {
// //       //   //   return BottomNavigationBar(child: child);
// //       //   // },
// //       //   routes: [
// //       //
// //       //   ],
// //       // ),
// //     ],
// //     //errorBuilder: (context, state) => const NotFoundScreen(),
// //   );
// // });