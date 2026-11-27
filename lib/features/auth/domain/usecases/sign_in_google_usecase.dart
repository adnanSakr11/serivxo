import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInGoogleUseCase {
  final AuthRepository _repository;
  SignInGoogleUseCase(this._repository);

  Future<Either<Failure, AppUser>> call() => _repository.signInWithGoogle();
}