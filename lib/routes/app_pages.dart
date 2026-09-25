import 'package:get/get.dart';
import 'package:clean_code_challenge/ui/auth/views/login_view.dart';
import 'package:clean_code_challenge/ui/home/views/home_view.dart';

class AppPages {
  AppPages._();

  static const String login = '/login';
  static const String home = '/home';

  static const String initial = login;

  static final routes = [
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: home, page: () => const HomeView()),
  ];
}
