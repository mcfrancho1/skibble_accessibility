
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/firebase/auth.dart';

class AuthFlowData with ChangeNotifier {
  final AuthService authService;
  late final User? firebaseUser;
  late final StreamSubscription<User?> authSubscription;



  AuthFlowData(this.authService) {
    authSubscription = authService.userAuthChanges().listen((user) {
      firebaseUser = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    // if (authSubscription != null) {
      authSubscription.cancel();
      // authSubscription = null;
    // }
    super.dispose();
  }

}