import 'package:clean_code_challenge/core/constants/mock_api.dart';
import 'package:clean_code_challenge/core/errors/exceptions.dart';

class AuthDatasource {
  static const Map<String, dynamic> _registeredUser = {
    'id': 'usr_991',
    'email': 'aluno@senai.br',
    'name': 'Aluno SENAI',
    'token': 'jwt_mock_token_senai_2026',
    'password': '123456',
  };

  Future<Map<String, dynamic>> authenticate(
    String email,
    String password,
  ) async {
    await Future.delayed(MockApiLatency.auth);

    if (!_matchesRegisteredUser(email.trim(), password.trim())) {
      throw const AuthException(ApiStatusCode.authFailed);
    }

    return {
      'id': _registeredUser['id'],
      'email': _registeredUser['email'],
      'name': _registeredUser['name'],
      'token': _registeredUser['token'],
      'status': ApiStatusCode.authOk,
    };
  }

  bool _matchesRegisteredUser(String email, String password) {
    return email == _registeredUser['email'] &&
        password == _registeredUser['password'];
  }
}
