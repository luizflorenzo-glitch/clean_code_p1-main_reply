import 'package:get/get.dart';
import 'package:clean_code_challenge/data/models/product_model.dart';
import 'package:clean_code_challenge/domain/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _repository;

  HomeController(this._repository);

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getProducts();

      result.fold<void>(
        (failure) => errorMessage.value = failure.message,
        (loadedProducts) => products.assignAll(loadedProducts),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
