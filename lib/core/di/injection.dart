import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/http_client.dart';

// Auth
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/check_email_verified_usecase.dart';
import '../../features/auth/presentation/cubit/email_verification_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/google_auth_cubit.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';

// // Profile
// import '../../features/profile/data/datasources/profile_remote_datasource.dart';
// import '../../features/profile/data/repositories/profile_repository_impl.dart';
// import '../../features/profile/domain/repositories/profile_repository.dart';
// import '../../features/profile/domain/usecases/update_display_name_usecase.dart';
// import '../../features/profile/domain/usecases/update_profile_picture_usecase.dart';
// import '../../features/profile/presentation/cubit/profile_cubit.dart';

// // Shared
// import '../../shared/services/location_service.dart';
// import '../../shared/services/image_upload_service.dart';
// import '../../shared/services/presence_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  // External
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      serverClientId:
          '780867026107-7lmj62f198qpljrur40po0olgnh80atr.apps.googleusercontent.com',
    ),
  );
  sl.registerLazySingleton<AppHttpClient>(() => AppHttpClient());

  // // Shared services
  // sl.registerLazySingleton<LocationService>(() => LocationService());
  // sl.registerLazySingleton<ImageUploadService>(
  //   () => ImageUploadService(httpClient: sl<AppHttpClient>()),
  // );
  // sl.registerLazySingleton<PresenceService>(
  //   () => PresenceService(
  //     firestore: sl<FirebaseFirestore>(),
  //     auth: sl<FirebaseAuth>(),
  //   ),
  // );

  //   _registerAuth();
  //   _registerProfile();
  //   _registerMap();
  //   _registerSavedLocations();
  //   _registerTrips();
  // }

  // void _registerAuth() {
  //   sl.registerLazySingleton<AuthRemoteDataSource>(
  //     () => AuthRemoteDataSourceImpl(
  //       auth: sl<FirebaseAuth>(),
  //       firestore: sl<FirebaseFirestore>(),
  //       googleSignIn: sl<GoogleSignIn>(),
  //     ),
  //   );
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: sl<AuthRemoteDataSource>()),
    );

    // inside _registerAuth(), after existing registrations
    sl.registerLazySingleton(
      () => SendEmailVerificationUseCase(sl<AuthRepository>()),
    );
    sl.registerLazySingleton(
      () => CheckEmailVerifiedUseCase(sl<AuthRepository>()),
    );
    sl.registerFactory(
      () => EmailVerificationCubit(
        sendUseCase: sl<SendEmailVerificationUseCase>(),
        checkUseCase: sl<CheckEmailVerifiedUseCase>(),
      ),
    );
    sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => SignInGoogleUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));

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
      () => ForgotPasswordCubit(
        forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      ),
    );
  }

  // void _registerProfile() {
  //   sl.registerLazySingleton<ProfileRemoteDataSource>(
  //     () => ProfileRemoteDataSourceImpl(
  //       auth: sl<FirebaseAuth>(),
  //       firestore: sl<FirebaseFirestore>(),
  //       imageUploadService: sl<ImageUploadService>(),
  //     ),
  //   );
  //   sl.registerLazySingleton<ProfileRepository>(
  //     () => ProfileRepositoryImpl(dataSource: sl<ProfileRemoteDataSource>()),
  //   );
  //   sl.registerLazySingleton(
  //       () => UpdateDisplayNameUseCase(sl<ProfileRepository>()));
  //   sl.registerLazySingleton(
  //       () => UpdateProfilePictureUseCase(sl<ProfileRepository>()));

  //   sl.registerFactory(
  //     () => ProfileCubit(
  //       updateDisplayNameUseCase: sl<UpdateDisplayNameUseCase>(),
  //       updateProfilePictureUseCase: sl<UpdateProfilePictureUseCase>(),
  //     ),
  //   );
  // }

  // void _registerMap() {
  //   sl.registerLazySingleton<GeocodingDataSource>(
  //     () => GeocodingDataSourceImpl(),
  //   );
  //   sl.registerLazySingleton<RoutingDataSource>(
  //     () => RoutingDataSourceImpl(),
  //   );
  //   sl.registerLazySingleton<GeocodingRepository>(
  //     () => GeocodingRepositoryImpl(dataSource: sl<GeocodingDataSource>()),
  //   );
  //   sl.registerLazySingleton<RoutingRepository>(
  //     () => RoutingRepositoryImpl(dataSource: sl<RoutingDataSource>()),
  //   );
  //   sl.registerLazySingleton(
  //       () => SearchPlacesUseCase(sl<GeocodingRepository>()));
  //   sl.registerLazySingleton(() => GetRouteUseCase(sl<RoutingRepository>()));
  //   sl.registerLazySingleton(
  //       () => ReverseGeocodeUseCase(sl<GeocodingRepository>()));

  //   sl.registerFactory(
  //     () => MapCubit(
  //       searchPlacesUseCase: sl<SearchPlacesUseCase>(),
  //       getRouteUseCase: sl<GetRouteUseCase>(),
  //       locationService: sl<LocationService>(),
  //     ),
  //   );
  // }

  // void _registerSavedLocations() {
  //   sl.registerLazySingleton<SavedLocationsDataSource>(
  //     () => SavedLocationsDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  //   );
  //   sl.registerLazySingleton<SavedLocationsRepository>(
  //     () => SavedLocationsRepositoryImpl(
  //         dataSource: sl<SavedLocationsDataSource>()),
  //   );
  //   sl.registerLazySingleton(
  //       () => AddLocationUseCase(sl<SavedLocationsRepository>()));
  //   sl.registerLazySingleton(
  //       () => DeleteLocationUseCase(sl<SavedLocationsRepository>()));
  //   sl.registerLazySingleton(
  //       () => UpdateLocationUseCase(sl<SavedLocationsRepository>()));
  //   sl.registerLazySingleton(
  //       () => WatchLocationsUseCase(sl<SavedLocationsRepository>()));

  //   sl.registerFactory(
  //     () => SavedLocationsCubit(
  //       addLocationUseCase: sl<AddLocationUseCase>(),
  //       deleteLocationUseCase: sl<DeleteLocationUseCase>(),
  //       updateLocationUseCase: sl<UpdateLocationUseCase>(),
  //       watchLocationsUseCase: sl<WatchLocationsUseCase>(),
  //     ),
  //   );
  // }

  // void _registerTrips() {
  //   sl.registerLazySingleton<TripsDataSource>(
  //     () => TripsDataSourceImpl(
  //       firestore: sl<FirebaseFirestore>(),
  //       auth: sl<FirebaseAuth>(),
  //     ),
  //   );
  //   sl.registerLazySingleton<TripsRepository>(
  //     () => TripsRepositoryImpl(dataSource: sl<TripsDataSource>()),
  //   );
  //   sl.registerLazySingleton(() => StartTripSearchUseCase(sl<TripsRepository>()));
  //   sl.registerLazySingleton(
  //       () => CancelRideRequestUseCase(sl<TripsRepository>()));
  //   sl.registerLazySingleton(
  //       () => WatchRideRequestUseCase(sl<TripsRepository>()));
  //   sl.registerLazySingleton(() => WatchActiveTripUseCase(sl<TripsRepository>()));
  //   sl.registerLazySingleton(
  //       () => WatchTripHistoryUseCase(sl<TripsRepository>()));

  //   sl.registerFactory(
  //     () => TripCubit(
  //       startTripSearchUseCase: sl<StartTripSearchUseCase>(),
  //       cancelRideRequestUseCase: sl<CancelRideRequestUseCase>(),
  //       watchRideRequestUseCase: sl<WatchRideRequestUseCase>(),
  //       watchActiveTripUseCase: sl<WatchActiveTripUseCase>(),
  //     ),
  //   );
  //   sl.registerFactory(
  //     () => HistoryCubit(
  //       watchTripHistoryUseCase: sl<WatchTripHistoryUseCase>(),
  //     ),
  //   );
  // }

