import 'package:clean_code_challenge/core/constants/mock_api.dart';
import 'package:clean_code_challenge/data/models/product_category.dart';

class ProductDatasource {
  static const List<Map<String, dynamic>> _products = [
    {
      'id': 'prod_001',
      'name': 'Notebook Gamer Pro',
      'description': 'Processador i7, 16GB RAM, SSD 512GB',
      'price': 4500.0,
      'available': true,
      'category': 'VIP_CAT_01',
    },
    {
      'id': 'prod_002',
      'name': 'Mouse Sem Fio Ultra',
      'description': 'Sensor optico 16000 DPI, bateria recarregavel',
      'price': 250.0,
      'available': true,
      'category': 'STD_CAT_02',
    },
    {
      'id': 'prod_003',
      'name': 'Teclado Mecanico RGB',
      'description': 'Switches azuis, iluminacao RGB customizavel',
      'price': 420.0,
      'available': true,
      'category': 'STD_CAT_02',
    },
    {
      'id': 'prod_004',
      'name': 'Monitor Curvo 27 pol',
      'description': '144Hz, 1ms, resolucao Quad HD',
      'price': 1850.0,
      'available': false,
      'category': 'VIP_CAT_01',
    },
    {
      'id': 'prod_005',
      'name': 'Headset Bluetooth Noise Cancelling',
      'description': 'Cancelamento ativo de ruido, 30h de bateria',
      'price': 690.0,
      'available': true,
      'category': 'STD_CAT_02',
    },
  ];

  Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    await Future.delayed(MockApiLatency.products);
    return _products;
  }

  Future<List<Map<String, dynamic>>> fetchVipProducts() async {
    await Future.delayed(MockApiLatency.products);
    return _products
        .where((product) => product['category'] == ProductCategory.vip.code)
        .toList();
  }
}
