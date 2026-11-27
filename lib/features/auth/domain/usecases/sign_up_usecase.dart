import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    required String displayName,
  }) =>
      _repository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
}