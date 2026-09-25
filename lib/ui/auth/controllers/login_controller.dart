import 'package:get/get.dart';
import 'package:clean_code_challenge/core/validators/email_validator.dart';
import 'package:clean_code_challenge/domain/repositories/auth_repository.dart';
import 'package:clean_code_challenge/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _repository;

  LoginController(this._repository);

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> autenticar(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (!EmailValidator.isValid(email)) {
        errorMessage.value = 'Formato de email invalido';
        return;
      }

      final result = await _repository.login(email, password);

      result.fold<void>(
        (failure) => errorMessage.value = failure.message,
        (user) => Get.offNamed(AppPages.home),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
