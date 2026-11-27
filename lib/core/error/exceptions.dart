class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error']);
}

class AuthException implements Exception {
  final String code;
  final String message;
  const AuthException({required this.code, required this.message});
}

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission denied']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Not found']);
}

class UploadException implements Exception {
  final String message;
  const UploadException([this.message = 'Upload failed']);
}

class LocationException implements Exception {
  final String message;
  const LocationException([this.message = 'Location error']);
}