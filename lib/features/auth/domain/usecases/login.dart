import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/user.dart';
import '../repo/auth_repository.dart';

class Login extends UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login({required this.repository});

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params: params);
  }
}

class LoginParams {
  String? email;
  String? password;

  LoginParams({
    this.email,
    this.password,
  });
}
