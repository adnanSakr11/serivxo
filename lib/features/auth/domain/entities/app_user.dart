import 'package:equatable/equatable.dart';

enum UserRole {
  customer,
  provider;

  String get value => name;

  static UserRole from(String? v) => UserRole.values.firstWhere(
        (e) => e.name == v,
        orElse: () => UserRole.customer,
      );
}

class AppUser extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? photoUrl;
  final bool isOnline;
  final bool emailVerified;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.role = UserRole.customer,
    this.photoUrl,
    this.isOnline = false,
    this.emailVerified = false,
  });

  AppUser copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? photoUrl,
    bool? isOnline,
    bool? emailVerified,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  List<Object?> get props =>
      [uid, name, email, phone, role, photoUrl, isOnline, emailVerified];
}