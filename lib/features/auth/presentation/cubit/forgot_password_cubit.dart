import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/forgot_password_usecase.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit({required ForgotPasswordUseCase forgotPasswordUseCase})
      : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordInitial());

  Future<void> sendResetEmail(String email) async {
    emit(const ForgotPasswordLoading());
    final result = await _forgotPasswordUseCase(email);
    result.fold(
      (failure) => emit(ForgotPasswordError(failure.message)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  void reset() => emit(const ForgotPasswordInitial());
}