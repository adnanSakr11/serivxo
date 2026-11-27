import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isOnline;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.isOnline = false,
  });

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    bool? isOnline,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [uid, name, email, photoUrl, isOnline];
}