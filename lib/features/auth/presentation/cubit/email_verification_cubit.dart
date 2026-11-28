import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';
import '../../domain/usecases/check_email_verified_usecase.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
 void startCooldown() => _startCooldown();
  final SendEmailVerificationUseCase _sendUseCase;
  final CheckEmailVerifiedUseCase _checkUseCase;

  Timer? _pollTimer;
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  EmailVerificationCubit({
    required SendEmailVerificationUseCase sendUseCase,
    required CheckEmailVerifiedUseCase checkUseCase,
  })  : _sendUseCase = sendUseCase,
        _checkUseCase = checkUseCase,
        super(const EmailVerificationInitial());

  Future<void> sendVerificationEmail() async {
    if (isClosed) return;

    emit(const EmailVerificationSending());

    final result = await _sendUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(EmailVerificationError(failure.message));
        }
      },
      (_) {
        if (!isClosed) {
          emit(const EmailVerificationSent());
          _startCooldown();
        }
      },
    );
  }

  void _startCooldown() {
    if (isClosed) return;

    _cooldownSeconds = 60;

    _cooldownTimer?.cancel();

    emit(EmailVerificationCooldown(_cooldownSeconds));

    _cooldownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (isClosed) {
          timer.cancel();
          return;
        }

        _cooldownSeconds--;

        if (_cooldownSeconds <= 0) {
          timer.cancel();

          if (!isClosed) {
            _cooldownTimer?.cancel();
            emit(const EmailVerificationUnverified());
          }

          return;
        }

        if (!isClosed) {
          emit(EmailVerificationCooldown(_cooldownSeconds));
        }
      },
    );
  }

  Future<void> checkVerification() async {
    if (isClosed) return;

    emit(const EmailVerificationChecking());

    final result = await _checkUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(EmailVerificationError(failure.message));
        }
      },
      (verified) {
        if (isClosed) return;

        if (verified) {
          emit(const EmailVerificationVerified());
        } else {
          emit(const EmailVerificationUnverified());
        }
      },
    );
  }

  void startAutoPolling() {
    _pollTimer?.cancel();

    _pollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) async {
        if (isClosed) {
          _pollTimer?.cancel();
          return;
        }

        final result = await _checkUseCase();

        if (isClosed) return;

        result.fold(
          (_) {},
          (verified) {
            if (verified && !isClosed) {
              emit(const EmailVerificationVerified());
              _pollTimer?.cancel();
            }
          },
        );
      },
    );
  }

  void stopAutoPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  Future<void> close() async {
    _pollTimer?.cancel();
    _cooldownTimer?.cancel();

    _pollTimer = null;
    _cooldownTimer = null;

    return super.close();
  }
}