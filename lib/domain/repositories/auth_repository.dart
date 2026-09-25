import 'package:clean_code_challenge/core/errors/failures.dart';
import 'package:clean_code_challenge/core/result/result.dart';
import 'package:clean_code_challenge/data/models/auth_user_model.dart';

abstract class AuthRepository {
  Future<Result<AuthUserModel, Failure>> login(String email, String password);
}
