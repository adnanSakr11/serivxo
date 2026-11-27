import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    level: Level.debug,
  );

  static void d(String message, [Object? data]) =>
      _logger.d(data != null ? '$message | $data' : message);

  static void i(String message, [Object? data]) =>
      _logger.i(data != null ? '$message | $data' : message);

  static void w(String message, [Object? data]) =>
      _logger.w(data != null ? '$message | $data' : message);

  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}