import 'dart:developer';

enum LogLevel {
  INFO(500),
  FINE(800),
  WARNING(900),
  ERROR(1000);

  final int value;

  const LogLevel(this.value);
}

class Logger {
  String _appName = "app.logger.default";

  Logger._(String name) {
    _appName = name;
  }

  String _timestamp() {
    final now = DateTime.now();

    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final seconds = now.second.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    return '${hour.toString().padLeft(2, '0')}:$minute:$seconds $period';
  }

  String _getFormattedHeader({String? tag}) {
    return "[${_timestamp()}] ${tag != null ? "[${tag.toUpperCase()}]" : ""}";
  }

  void ok(String msg, {String? tag, bool enableStackTrace = false}) {
    log(
      "${_getFormattedHeader(tag: tag)} 🟢: $msg",
      name: _appName,
      level: LogLevel.FINE.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void info(String msg, {String? tag, bool enableStackTrace = false}) {
    log(
      "${_getFormattedHeader(tag: tag)} ⚪: $msg",
      name: _appName,
      level: LogLevel.INFO.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void warn(String msg, {String? tag, bool enableStackTrace = true}) {
    log(
      "${_getFormattedHeader(tag: tag)} 🟠: $msg",
      name: _appName,
      level: LogLevel.WARNING.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void error(String msg, {String? tag, bool enableStackTrace = true}) {
    log(
      "${_getFormattedHeader(tag: tag)} 🔴: $msg",
      name: _appName,
      level: LogLevel.ERROR.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }
}

final logger = Logger._("app.delivery.santomeridia");
