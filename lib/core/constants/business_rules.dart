class PricingRules {
  PricingRules._();

  static const double noDiscountRate = 0.0;
  static const double vipDiscountRate = 0.15;
  static const double taxRate = 0.15;
  static const String taxIncludedLabel = '[TAX_INCLUDED]';
}

class AuthRules {
  AuthRules._();

  static const int minPasswordLength = 6;
}
