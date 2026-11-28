import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImpl({required AuthRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.signIn(email: email, password: password);
      return Right(user);
    } on AuthException catch (e) {
      AppLogger.w('SignIn failed', e.message);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.e('SignIn unknown error', e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    required String displayName,
    required String phone,
    required UserRole role,
  }) async {
    try {
      final user = await _dataSource.signUp(
        email: email,
        password: password,
        displayName: displayName,
        phone: phone,
        role: role,
      );
      return Right(user);
    } on AuthException catch (e) {
      AppLogger.w('SignUp failed', e.message);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.e('SignUp unknown error', e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final user = await _dataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      AppLogger.w('Google SignIn failed', e.message);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.e('Google SignIn unknown error', e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      AppLogger.e('SignOut error', e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      AppLogger.w('ForgotPassword failed', e.message);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.e('ForgotPassword unknown error', e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> reloadAndCheckVerified() async {
    try {
      final verified = await _dataSource.reloadAndCheckVerified();
      return Right(verified);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  bool get isEmailVerified => _dataSource.isEmailVerified;
}