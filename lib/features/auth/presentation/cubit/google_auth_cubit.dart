import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/sign_in_google_usecase.dart';


part 'google_auth_state.dart';

class GoogleAuthCubit extends Cubit<GoogleAuthState> {
  final SignInGoogleUseCase _signInGoogleUseCase;

  GoogleAuthCubit({required SignInGoogleUseCase signInGoogleUseCase})
      : _signInGoogleUseCase = signInGoogleUseCase,
        super(const GoogleAuthInitial());

  Future<void> signInWithGoogle() async {
    emit(const GoogleAuthLoading());
    final result = await _signInGoogleUseCase();
    result.fold(
      (failure) => emit(GoogleAuthError(failure.message)),
      (user) => emit(GoogleAuthSuccess(user)),
    );
  }

  void updateUser(AppUser user) => emit(GoogleAuthSuccess(user));
  void reset() => emit(const GoogleAuthInitial());
}