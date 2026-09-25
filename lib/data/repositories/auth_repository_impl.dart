import 'package:clean_code_challenge/core/constants/business_rules.dart';
import 'package:clean_code_challenge/core/errors/exceptions.dart';
import 'package:clean_code_challenge/core/errors/failures.dart';
import 'package:clean_code_challenge/core/result/result.dart';
import 'package:clean_code_challenge/core/validators/email_validator.dart';
import 'package:clean_code_challenge/data/datasources/auth_datasource.dart';
import 'package:clean_code_challenge/data/models/auth_user_model.dart';
import 'package:clean_code_challenge/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<Result<AuthUserModel, Failure>> login(
    String email,
    String password,
  ) async {
    final validationFailure = _validateCredentials(email, password);

    if (validationFailure != null) {
      return FailureResult(validationFailure);
    }

    try {
      final rawUser = await _datasource.authenticate(email, password);
      return Success(AuthUserModel.fromMap(rawUser));
    } on AuthException {
      return const FailureResult(AuthFailure('Email ou senha invalidos'));
    } on ServerException catch (exception) {
      return FailureResult(ServerFailure(exception.message));
    }
  }

  ValidationFailure? _validateCredentials(String email, String password) {
    if (email.isEmpty) {
      return const ValidationFailure('Email nao pode ser vazio');
    }

    if (password.isEmpty) {
      return const ValidationFailure('Senha nao pode ser vazia');
    }

    if (!EmailValidator.isValid(email)) {
      return const ValidationFailure('Formato de email invalido');
    }

    if (password.length < AuthRules.minPasswordLength) {
      return const ValidationFailure(
        'A senha deve possuir pelo menos ${AuthRules.minPasswordLength} caracteres',
      );
    }

    return null;
  }
}
