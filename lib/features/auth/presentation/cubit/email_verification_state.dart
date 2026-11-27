part of 'email_verification_cubit.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();
  @override
  List<Object?> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {
  const EmailVerificationInitial();
}

class EmailVerificationSending extends EmailVerificationState {
  const EmailVerificationSending();
}

class EmailVerificationSent extends EmailVerificationState {
  const EmailVerificationSent();
}

class EmailVerificationCooldown extends EmailVerificationState {
  final int secondsRemaining;
  const EmailVerificationCooldown(this.secondsRemaining);
  @override
  List<Object?> get props => [secondsRemaining];
}

class EmailVerificationChecking extends EmailVerificationState {
  const EmailVerificationChecking();
}

class EmailVerificationVerified extends EmailVerificationState {
  const EmailVerificationVerified();
}

class EmailVerificationUnverified extends EmailVerificationState {
  const EmailVerificationUnverified();
}

class EmailVerificationError extends EmailVerificationState {
  final String message;
  const EmailVerificationError(this.message);
  @override
  List<Object?> get props => [message];
}