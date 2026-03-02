import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (kDebugMode) print('[AUTH MIDDLEWARE] Checking authentication for route: $route');
    
    final storage = GetStorage();
    final userId = storage.read('userId');
    final currentUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print('[AUTH MIDDLEWARE] Local userId: $userId');
      print('[AUTH MIDDLEWARE] Firebase currentUser: ${currentUser?.uid}');
    }

    if (currentUser == null && userId == null) {
      if (kDebugMode) print('[AUTH MIDDLEWARE] No authentication found, redirecting to login');
      return const RouteSettings(name: AppRoutes.login);
    }
    
    if (kDebugMode) print('[AUTH MIDDLEWARE] Authentication verified, proceeding to route');
    return null;
  }
}

class AdminMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (kDebugMode) print('[ADMIN MIDDLEWARE] Checking admin authentication for route: $route');
    
    final storage = GetStorage();
    final userId = storage.read('userId');
    final isAdmin = storage.read('isAdmin') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print('[ADMIN MIDDLEWARE] Local userId: $userId');
      print('[ADMIN MIDDLEWARE] Is Admin: $isAdmin');
    }

    if (currentUser == null && userId == null) {
      if (kDebugMode) print('[ADMIN MIDDLEWARE] No authentication found, redirecting to login');
      return const RouteSettings(name: AppRoutes.login);
    }

    if (!isAdmin) {
      if (kDebugMode) print('[ADMIN MIDDLEWARE] Not admin, redirecting to main');
      return const RouteSettings(name: AppRoutes.main);
    }
    
    if (kDebugMode) print('[ADMIN MIDDLEWARE] Admin verified, proceeding to route');
    return null;
  }
}

class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    if (kDebugMode) print('[GUEST MIDDLEWARE] Checking authentication for route: $route');
    
    final storage = GetStorage();
    final userId = storage.read('userId');
    final isAdmin = storage.read('isAdmin') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (kDebugMode) {
      print('[GUEST MIDDLEWARE] Local userId: $userId');
      print('[GUEST MIDDLEWARE] Firebase currentUser: ${currentUser?.uid}');
    }

    if (currentUser != null || userId != null) {
      if (isAdmin) {
        if (kDebugMode) print('[GUEST MIDDLEWARE] Admin authenticated, redirecting to admin dashboard');
        return const RouteSettings(name: AppRoutes.adminDashboard);
      } else {
        if (kDebugMode) print('[GUEST MIDDLEWARE] User already authenticated, redirecting to main');
        return const RouteSettings(name: AppRoutes.main);
      }
    }
    
    if (kDebugMode) print('[GUEST MIDDLEWARE] No authentication found, proceeding to route');
    return null;
  }
}
