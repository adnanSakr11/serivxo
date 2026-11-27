part of 'google_auth_cubit.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();
  @override
  List<Object?> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthSuccess extends GoogleAuthState {
  final AppUser user;
  const GoogleAuthSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

class GoogleAuthError extends GoogleAuthState {
  final String message;
  const GoogleAuthError(this.message);
  @override
  List<Object?> get props => [message];
}