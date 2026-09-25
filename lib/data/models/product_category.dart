enum ProductCategory {
  vip('VIP_CAT_01'),
  standard('STD_CAT_02');

  const ProductCategory(this.code);

  final String code;

  static ProductCategory fromCode(String code) {
    return ProductCategory.values.firstWhere(
      (category) => category.code == code,
      orElse: () =>
          throw FormatException('Categoria de produto desconhecida: $code'),
    );
  }
}
