import 'dart:async';

// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:skibble/services/firebase/auth_services/skibble_auth_service.dart';
import 'package:skibble/features/authentication/controllers/custom_auth_service.dart';

import '../../../../models/skibble_user.dart';

import 'mock_auth_service.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements SkibbleAuthService {
  AuthServiceAdapter({required AuthServiceType initialAuthServiceType, required this.context})
      : authServiceTypeNotifier =
  ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final CustomAuthService _customAuthService = CustomAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  BuildContext context;
  SkibbleAuthService get authService => authServiceType == AuthServiceType.firebase
      ? _customAuthService
      : _mockAuthService;

  late final StreamSubscription<SkibbleUser?> _firebaseAuthSubscription;
  late final StreamSubscription<SkibbleUser?> _mockAuthSubscription;

  void _setup() {
    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription =
        _customAuthService.onAuthStateChanged(context).listen((SkibbleUser? user) {
          if (authServiceType == AuthServiceType.firebase) {

            _onAuthStateChangedController.add(user);
          }
        }, onError: (dynamic error) {
          if (authServiceType == AuthServiceType.firebase) {
            _onAuthStateChangedController.addError(error);
          }
        });


    _mockAuthSubscription =
        _mockAuthService.onAuthStateChanged(context).listen((SkibbleUser? user) {
          if (authServiceType == AuthServiceType.mock) {
            _onAuthStateChangedController.add(user);
          }
        }, onError: (dynamic error) {
          if (authServiceType == AuthServiceType.mock) {
            _onAuthStateChangedController.addError(error);
          }
        });

    // print('ololo');
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<SkibbleUser?> _onAuthStateChangedController =
  StreamController<SkibbleUser?>.broadcast();
  @override
  Stream<SkibbleUser?> onAuthStateChanged(BuildContext context) =>
      _onAuthStateChangedController.stream;

  @override
  Future<SkibbleUser?> currentUser() => authService.currentUser();

  @override
  Future<SkibbleUser?> signInAnonymously() => authService.signInAnonymously();

  @override
  Future<SkibbleUser?> createUserWithEmailAndPassword(
      String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);

  @override
  Future<SkibbleUser?> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<SkibbleUser?> signInWithEmailAndLink(String email, String link) => authService.signInWithEmailAndLink(email, link);

  @override
  bool isSignInWithEmailLink(String link) =>
      authService.isSignInWithEmailLink(link);

  @override
  Future<void> sendSignInWithEmailLink({
    required String email,
    required String url,
    required bool handleCodeInApp,
    required String iOSBundleId,
    required String androidPackageName,
    required bool androidInstallApp,
    required String androidMinimumVersion,
  }) =>
      authService.sendSignInWithEmailLink(
        email: email,
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleId: iOSBundleId,
        androidPackageName: androidPackageName,
        androidInstallApp: androidInstallApp,
        androidMinimumVersion: androidMinimumVersion,
      );

  @override
  Future<SkibbleUser?> signInWithFacebook() => authService.signInWithFacebook();

  @override
  Future<SkibbleUser?> signInWithGoogle() => authService.signInWithGoogle();

  // @override
  // Future<SkibbleUser?> signInWithApple({List<Scope> scopes}) =>
  //     authService.signInWithApple();

  @override
  Future<void> signOut() => authService.signOut();

  @override
  Future<void> reload(BuildContext context) => authService.reload(context);

  @override
  Future<void> triggerUserChange(BuildContext context) => authService.triggerUserChange(context);

  // @override
  // Stream<SkibbleUser?> listenToAuthChanges(BuildContext context) => authService.listenToAuthChanges(context);
}