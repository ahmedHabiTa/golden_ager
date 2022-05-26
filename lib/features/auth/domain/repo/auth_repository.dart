import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../models/user.dart';
import '../usecases/login.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({required LoginParams params});
}
