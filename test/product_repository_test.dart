import 'package:flutter_test/flutter_test.dart';
import 'package:clean_code_challenge/data/datasources/product_datasource.dart';
import 'package:clean_code_challenge/data/repositories/product_repository_impl.dart';

void main() {
  late ProductRepositoryImpl repository;

  setUp(() {
    repository = ProductRepositoryImpl(ProductDatasource());
  });

  test('deve retornar apenas os produtos disponiveis', () async {
    final result = await repository.getProducts();

    expect(result.isSuccess, isTrue);
    expect(result.data, isNotNull);
    expect(result.data!, isNotEmpty);
    expect(result.data!.every((product) => product.isAvailable), isTrue);
  });

  test('deve retornar apenas produtos vip com desconto aplicado', () async {
    final standardResult = await repository.getProducts();
    final vipResult = await repository.getVipProducts();

    expect(vipResult.isSuccess, isTrue);
    expect(vipResult.data!, isNotEmpty);

    final vipProduct = vipResult.data!.first;
    final standardProduct = standardResult.data!.firstWhere(
      (product) => product.id == vipProduct.id,
    );

    expect(vipProduct.price, lessThan(standardProduct.price));
  });
}
