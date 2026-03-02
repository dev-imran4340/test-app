import 'package:get/get.dart';
import 'package:test_app/app/middlewares/route_middleware.dart';
import 'package:test_app/app/routes/app_routes.dart';
import 'package:test_app/app/screens/admin/dashboard/controller/admin_dashboard_controller.dart';
import 'package:test_app/app/screens/admin/history/controller/admin_history_controller.dart';
import 'package:test_app/app/screens/admin/index/controller/admin_index_controller.dart';
import 'package:test_app/app/screens/admin/index/page/admin_index_page.dart';
import 'package:test_app/app/screens/admin/orders/controller/admin_orders_controller.dart';
import 'package:test_app/app/screens/admin/tracking/controller/admin_tracking_controller.dart';
import 'package:test_app/app/screens/checkout/controller/checkout_controller.dart';
import 'package:test_app/app/screens/checkout/page/checkout_page.dart';
import 'package:test_app/app/screens/history/controller/history_controller.dart';
import 'package:test_app/app/screens/index/controller/index_controller.dart';
import 'package:test_app/app/screens/index/page/index_page.dart';
import 'package:test_app/app/screens/login/controller/login_controller.dart';
import 'package:test_app/app/screens/login/page/login_page.dart';
import 'package:test_app/app/screens/main/controller/main_controller.dart';
import 'package:test_app/app/screens/signup/controller/signup_controller.dart';
import 'package:test_app/app/screens/signup/page/signup_page.dart';
import 'package:test_app/app/screens/tracking/controller/tracking_controller.dart';

class AppPages {
  static const initial = AppRoutes.initail;
  
  static final routes = [
    GetPage(
      name: AppRoutes.initail,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignupController());
      }),
      middlewares: [GuestMiddleware()],
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const IndexPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => IndexController());
        Get.lazyPut(() => MainController());
        Get.lazyPut(() => HistoryController());
        Get.lazyPut(() => TrackingController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CheckoutController());
      }),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminIndexPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AdminIndexController());
        Get.lazyPut(() => AdminDashboardController());
        Get.lazyPut(() => AdminOrdersController());
        Get.lazyPut(() => AdminTrackingController());
        Get.lazyPut(() => AdminHistoryController());
      }),
      middlewares: [AdminMiddleware()],
    ),
  ];
}
