import 'package:logger/logger.dart';

class LogHelper {
  static late Logger _logger;

  static void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        colors: true,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  /// Info
  static void i(dynamic message) {
    _logger.i(message);
  }

  /// Debug
  static void d(dynamic message) {
    _logger.d(message);
  }

  /// Warning
  static void w(dynamic message) {
    _logger.w(message);
  }

  /// Error
  static void e(dynamic message) {
    _logger.e(message);
  }
}
