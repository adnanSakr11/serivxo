import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:servixo/core/config/app_config.dart';
import 'package:servixo/core/logging/app_logger.dart';

class PermissionsState extends Equatable {
  final bool location;
  final bool notifications;
  final bool busy;

  const PermissionsState({
    this.location = false,
    this.notifications = false,
    this.busy = false,
  });

  PermissionsState copyWith({bool? location, bool? notifications, bool? busy}) =>
      PermissionsState(
        location: location ?? this.location,
        notifications: notifications ?? this.notifications,
        busy: busy ?? this.busy,
      );

  @override
  List<Object?> get props => [location, notifications, busy];
}

class PermissionsCubit extends Cubit<PermissionsState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  PermissionsCubit({required FirebaseAuth auth, required FirebaseFirestore firestore})
      : _auth = auth,
        _db = firestore,
        super(const PermissionsState());

  /// Reads the current OS permission state (also called when the app resumes
  /// after the user returns from system settings).
  Future<void> refresh() async {
    final loc = await Permission.locationWhenInUse.isGranted;
    final notif = await Permission.notification.isGranted;
    if (isClosed) return;
    emit(state.copyWith(location: loc, notifications: notif));
  }

  Future<PermissionStatus> requestLocation() async {
    emit(state.copyWith(busy: true));
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) await _saveLocation();
    if (!isClosed) emit(state.copyWith(location: status.isGranted, busy: false));
    return status;
  }

  Future<PermissionStatus> requestNotifications() async {
    emit(state.copyWith(busy: true));
    final status = await Permission.notification.request();
    if (!isClosed) {
      emit(state.copyWith(notifications: status.isGranted, busy: false));
    }
    return status;
  }

  Future<void> _saveLocation() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      await _db.collection(AppConfig.usersCollection).doc(uid).update({
        AppConfig.fieldLocation: GeoPoint(pos.latitude, pos.longitude),
        AppConfig.fieldLocationUpdatedAt: FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      AppLogger.e('Saving location failed', e, st);
    }
  }
}