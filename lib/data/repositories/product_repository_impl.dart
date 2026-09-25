import 'package:clean_code_challenge/core/constants/business_rules.dart';
import 'package:clean_code_challenge/core/errors/exceptions.dart';
import 'package:clean_code_challenge/core/errors/failures.dart';
import 'package:clean_code_challenge/core/result/result.dart';
import 'package:clean_code_challenge/data/datasources/product_datasource.dart';
import 'package:clean_code_challenge/data/models/product_model.dart';
import 'package:clean_code_challenge/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<Result<List<ProductModel>, Failure>> getProducts() {
    return _loadProducts(
      _datasource.fetchAllProducts,
      PricingRules.noDiscountRate,
    );
  }

  @override
  Future<Result<List<ProductModel>, Failure>> getVipProducts() {
    return _loadProducts(
      _datasource.fetchVipProducts,
      PricingRules.vipDiscountRate,
    );
  }

  Future<Result<List<ProductModel>, Failure>> _loadProducts(
    Future<List<Map<String, dynamic>>> Function() fetchProducts,
    double discountRate,
  ) async {
    try {
      final rawProducts = await fetchProducts();
      return Success(_toPricedProducts(rawProducts, discountRate));
    } on ServerException catch (exception) {
      return FailureResult(ServerFailure(exception.message));
    } on FormatException {
      return const FailureResult(
        ServerFailure('Dados de produto em formato invalido'),
      );
    } on TypeError {
      return const FailureResult(
        ServerFailure('Dados de produto em formato invalido'),
      );
    }
  }

  List<ProductModel> _toPricedProducts(
    List<Map<String, dynamic>> rawProducts,
    double discountRate,
  ) {
    return rawProducts
        .map(ProductModel.fromMap)
        .where((product) => product.isAvailable)
        .map((product) => _withFinalPrice(product, discountRate))
        .toList();
  }

  ProductModel _withFinalPrice(ProductModel product, double discountRate) {
    final discountedPrice = _applyDiscount(product.price, discountRate);

    return product.copyWith(
      price: _roundToCurrency(_applyTax(discountedPrice)),
      description: '${product.description} - ${PricingRules.taxIncludedLabel}',
    );
  }

  double _applyDiscount(double price, double discountRate) =>
      price * (1 - discountRate);

  double _applyTax(double price) => price * (1 + PricingRules.taxRate);

  double _roundToCurrency(double value) =>
      double.parse(value.toStringAsFixed(2));
}
