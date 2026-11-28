import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/check_email_verified_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/email_verification_cubit.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/google_auth_cubit.dart';

import '../../features/setup/data/image_upload_service.dart';
import '../../features/setup/presentation/cubits/permissions_cubit.dart';
import '../../features/setup/presentation/cubits/profile_photo_cubit.dart';

final sl = GetIt.instance;

/// Web client ID (client_type 3) from android/app/google-services.json
const _googleWebClientId =
    '824198365233-3fq7m636hh6nrjcn2p14sk1cjed43kvl.apps.googleusercontent.com';

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  _registerExternal();
  _registerSetup();
  _registerAuth();
}

void _registerExternal() {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(serverClientId: _googleWebClientId),
  );
}

void _registerSetup() {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton(() => ImageUploadService(sl<http.Client>()));

  sl.registerFactory(
    () => PermissionsCubit(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerFactory(
    () => ProfilePhotoCubit(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      uploader: sl<ImageUploadService>(),
    ),
  );
}

void _registerAuth() {
  // Data
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl<AuthRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => SignInGoogleUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(
    () => SendEmailVerificationUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton(
    () => CheckEmailVerifiedUseCase(sl<AuthRepository>()),
  );

  // Cubits (factory = new instance per BlocProvider)
  sl.registerFactory(
    () => AuthCubit(
      signInUseCase: sl<SignInUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
    ),
  );

  sl.registerFactory(
    () => GoogleAuthCubit(signInGoogleUseCase: sl<SignInGoogleUseCase>()),
  );

  sl.registerFactory(
    () =>
        ForgotPasswordCubit(forgotPasswordUseCase: sl<ForgotPasswordUseCase>()),
  );

  sl.registerFactory(
    () => EmailVerificationCubit(
      sendUseCase: sl<SendEmailVerificationUseCase>(),
      checkUseCase: sl<CheckEmailVerifiedUseCase>(),
    ),
  );
}
