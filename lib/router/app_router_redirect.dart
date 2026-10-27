import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:health_calculator/core/di/injection.dart';
import 'package:health_calculator/features/auth/view/viewmodels/auth_view_models.dart';
import 'package:health_calculator/router/app_routes.dart';

class AppRouterRedirect {
  const AppRouterRedirect._();

  static FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final authViewModel = locator<AuthViewModel>();
    final isLogin = authViewModel.isAuthenticated;

    final unGuardPaths = [
      AppRoutes.loginPath,
      AppRoutes.signupPath,
    ];

    final isAtUnGuardPath = unGuardPaths.contains(state.matchedLocation);

    if (!isLogin && !isAtUnGuardPath) {
      return AppRoutes.loginPath;
    }

    if (isLogin && isAtUnGuardPath) {
      return AppRoutes.mapPath;
    }

    return null;
  }
}