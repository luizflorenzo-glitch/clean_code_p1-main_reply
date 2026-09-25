import 'package:get/get.dart';
import 'package:clean_code_challenge/data/datasources/auth_datasource.dart';
import 'package:clean_code_challenge/data/datasources/product_datasource.dart';
import 'package:clean_code_challenge/data/repositories/auth_repository_impl.dart';
import 'package:clean_code_challenge/data/repositories/product_repository_impl.dart';
import 'package:clean_code_challenge/domain/repositories/auth_repository.dart';
import 'package:clean_code_challenge/domain/repositories/product_repository.dart';
import 'package:clean_code_challenge/ui/auth/controllers/login_controller.dart';
import 'package:clean_code_challenge/ui/home/controllers/home_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthDatasource>(() => AuthDatasource());
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find<AuthDatasource>()),
    );
    Get.lazyPut<ProductDatasource>(() => ProductDatasource());
    Get.lazyPut<ProductRepository>(
      () => ProductRepositoryImpl(Get.find<ProductDatasource>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProductRepository>()),
    );
  }
}
