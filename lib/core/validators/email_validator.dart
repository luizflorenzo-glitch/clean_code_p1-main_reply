class EmailValidator {
  EmailValidator._();

  static final RegExp _pattern = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static bool isValid(String email) => _pattern.hasMatch(email);
}
