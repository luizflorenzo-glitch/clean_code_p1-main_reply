import 'package:clean_code_challenge/core/errors/failures.dart';
import 'package:clean_code_challenge/core/result/result.dart';
import 'package:clean_code_challenge/data/models/product_model.dart';

abstract class ProductRepository {
  Future<Result<List<ProductModel>, Failure>> getProducts();

  Future<Result<List<ProductModel>, Failure>> getVipProducts();
}
