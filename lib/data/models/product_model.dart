import 'package:clean_code_challenge/data/models/product_category.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isAvailable;
  final ProductCategory category;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      isAvailable: map['available'] as bool,
      category: ProductCategory.fromCode(map['category'] as String),
    );
  }

  ProductModel copyWith({String? description, double? price}) {
    return ProductModel(
      id: id,
      name: name,
      description: description ?? this.description,
      price: price ?? this.price,
      isAvailable: isAvailable,
      category: category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'available': isAvailable,
      'category': category.code,
    };
  }
}
