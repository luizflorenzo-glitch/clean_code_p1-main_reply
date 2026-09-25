class AuthUserModel {
  final String id;
  final String email;
  final String name;
  final String token;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'name': name, 'token': token};
  }
}
