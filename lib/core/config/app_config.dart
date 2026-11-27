class AppConfig {
  AppConfig._();

  static const String appName = 'Drift';
  static const String fontFamily = 'SpaceGrotesk';

  static const String logoPath = 'assets/images/drift_logo.png';
  static const String logoPath2 = 'assets/images/logo02.png';

  static const String darkTileUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png';
  static const String lightTileUrl =
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png';
  static const List<String> tileSubdomains = ['a', 'b', 'c', 'd'];

  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String nominatimUserAgent = 'DriftApp/1.0';

  static const String osrmBaseUrl =
      'http://router.project-osrm.org/route/v1/driving';

  static const String imgbbApiKey = '25f2fdda3a7d61543363500454a371de';
  static const String imgbbUploadUrl = 'https://api.imgbb.com/1/upload';

  static const double defaultLat = 30.0444;
  static const double defaultLng = 31.2357;
  static const int locationDistanceFilter = 10;
  static const int uploadTimeoutSeconds = 30;
  static const int routeTimeoutSeconds = 10;

  static const double priceRidePerKm = 3.5;
  static const double priceCityPerKm = 5.0;
  static const double priceDeliveryPerKm = 4.0;
  static const double priceTakeMeOutPerKm = 6.0;
  static const double minPrice = 25.0;
  static const double maxPrice = 9999.0;
  static const double priceStep = 5.0;
  static const double minPriceAfterAdjust = 30.0;

  static const double driverRadiusKm = 15.0;

  static const String usersCollection = 'users';
  static const String driversCollection = 'drivers';
  static const String rideRequestsCollection = 'ride_requests';
  static const String tripsCollection = 'trips';
  static const String savedLocationsCollection = 'saved_locations';

  static const String fieldIsOnline = 'isOnline';
  static const String fieldLastSeen = 'lastSeen';
  static const String fieldName = 'name';
  static const String fieldEmail = 'email';
  static const String fieldPhoto = 'photo';
  static const String fieldPhotoUrl = 'photoURL';
  static const String fieldFriends = 'friends';
  static const String fieldStatus = 'status';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';

  static const String prefIsDarkMode = 'isDarkMode';
}
