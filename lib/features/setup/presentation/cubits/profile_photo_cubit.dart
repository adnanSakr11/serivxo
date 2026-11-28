import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servixo/core/config/app_config.dart';
import 'package:servixo/core/error/exceptions.dart';
import 'package:servixo/features/setup/data/image_upload_service.dart';

class ProfilePhotoState extends Equatable {
  final Uint8List? bytes;
  final bool busy;
  final bool completed;
  final String? error;

  const ProfilePhotoState({
    this.bytes,
    this.busy = false,
    this.completed = false,
    this.error,
  });

  // `error` is intentionally not carried over: any new state clears it.
  ProfilePhotoState copyWith({
    Uint8List? bytes,
    bool? busy,
    bool? completed,
    String? error,
  }) =>
      ProfilePhotoState(
        bytes: bytes ?? this.bytes,
        busy: busy ?? this.busy,
        completed: completed ?? this.completed,
        error: error,
      );

  @override
  List<Object?> get props => [bytes, busy, completed, error];
}

class ProfilePhotoCubit extends Cubit<ProfilePhotoState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final ImageUploadService _uploader;
  final ImagePicker _picker = ImagePicker();

  ProfilePhotoCubit({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required ImageUploadService uploader,
  })  : _auth = auth,
        _db = firestore,
        _uploader = uploader,
        super(const ProfilePhotoState());

  Future<void> pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 80,
      );
      if (file == null) return;
      emit(state.copyWith(bytes: await file.readAsBytes()));
    } catch (_) {
      emit(state.copyWith(error: 'Could not open the camera or gallery.'));
    }
  }

  /// Marks setup as done. Uploads the photo first unless [skipPhoto] is true.
  Future<void> finish({bool skipPhoto = false}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    emit(state.copyWith(busy: true));
    try {
      final data = <String, dynamic>{
        AppConfig.fieldSetupComplete: true,
        AppConfig.fieldUpdatedAt: FieldValue.serverTimestamp(),
      };
      if (!skipPhoto && state.bytes != null) {
        final url = await _uploader.upload(state.bytes!);
        await user.updatePhotoURL(url);
        data[AppConfig.fieldPhoto] = url;
      }
      await _db.collection(AppConfig.usersCollection).doc(user.uid).update(data);
      emit(state.copyWith(busy: false, completed: true));
    } on UploadException catch (e) {
      emit(state.copyWith(busy: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(busy: false, error: 'Something went wrong. Try again.'));
    }
  }
}