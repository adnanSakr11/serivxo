import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    super.photoUrl,
    super.isOnline,
  });

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photo'] as String?,
      isOnline: map['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'email': email,
        'photo': photoUrl,
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      };

  Map<String, dynamic> toCreateMap() => {
        'name': name,
        'email': email,
        'photo': photoUrl,
        'friends': <String>[],
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory UserModel.fromAppUser(AppUser user) => UserModel(
        uid: user.uid,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        isOnline: user.isOnline,
      );
}