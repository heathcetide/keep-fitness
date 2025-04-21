import 'log_database_helper.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void log(String message) {
    _logger.i(message);
    LogDatabaseHelper().insertLog('INFO', message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    // 如果有错误和堆栈信息，将它们一起存储
    _logger.e(message, error, stackTrace);
    LogDatabaseHelper().insertLog('ERROR', message, error, stackTrace);
  }

  static void warning(String message) {
    _logger.w(message);
    LogDatabaseHelper().insertLog('WARNING', message);
  }

  static void debug(String message) {
    _logger.d(message);
    LogDatabaseHelper().insertLog('DEBUG', message);
  }

  static void verbose(String message) {
    _logger.v(message);
    LogDatabaseHelper().insertLog('VERBOSE', message);
  }

  static Future<List<Map<String, dynamic>>> getLogs(String level) async {
    return await LogDatabaseHelper().getLogs(level); // 获取特定级别的日志
  }

  static void clearLogs() {
    LogDatabaseHelper().clearLogs(); // 清除所有日志
  }
}