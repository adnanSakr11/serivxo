import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:servixo/core/config/app_config.dart';
import 'package:servixo/core/di/injection.dart';
import 'package:servixo/features/auth/presentation/screens/login_screen.dart';
import 'package:servixo/features/setup/presentation/screens/permissions_screen.dart';

import '../../features/home/presentation/home_screen.dart';

Future<String> resolvePostVerifiedRoute() async {
  final uid = sl<FirebaseAuth>().currentUser?.uid;
  if (uid == null) return LoginScreen.id;
  try {
    final doc = await sl<FirebaseFirestore>()
        .collection(AppConfig.usersCollection)
        .doc(uid)
        .get();
    final done = doc.data()?[AppConfig.fieldSetupComplete] == true;
    return done ? HomeScreen.id : PermissionsScreen.id;
  } catch (_) {
    return HomeScreen.id;
  }
}