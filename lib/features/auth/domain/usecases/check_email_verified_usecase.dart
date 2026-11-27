import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository _repository;
  CheckEmailVerifiedUseCase(this._repository);

  Future<Either<Failure, bool>> call() => _repository.reloadAndCheckVerified();
}