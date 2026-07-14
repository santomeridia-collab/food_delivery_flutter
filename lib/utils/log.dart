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
  String _appName = "app.log";

  Logger._(String name) {
    _appName = name;
  }

  String _getAscaiiFormattedTimestamp() {
    final now = DateTime.now();

    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, "0");
    final seconds = now.second.toString().padLeft(2, "0");
    final period = now.hour >= 12 ? "PM" : "AM";

    // bold and grey ASCAII
    return "\x1b[1;38;2;185;185;185m[${hour.toString().padLeft(2, '0')}:$minute:$seconds $period]\x1b[0m";
  }

  void ok(String msg, {bool enableStackTrace = false}) {
    // pastel green ASCAII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;119;221;119m[OK]\x1b[0m : \x1b[1;37m$msg\x1b[0m\n",
      name: _appName,
      level: LogLevel.FINE.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void info(String msg, {bool enableStackTrace = false}) {
    // pastel off-white ASCAII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;250;249;246m[INFO]\x1b[0m : \x1b[1;37m$msg\x1b[0m\n",
      name: _appName,
      level: LogLevel.INFO.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void warn(String msg, {bool enableStackTrace = true}) {
    // pastel orange ASCAII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;255;179;71m[WARN]\x1b[0m : \x1b[1;37m$msg\x1b[0m\n",
      name: _appName,
      level: LogLevel.WARNING.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void error(String msg, {bool enableStackTrace = true}) {
    // pastel red ASCAII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;255;105;97m[ERROR]\x1b[0m : \x1b[1;37m$msg\x1b[0m\n",
      name: _appName,
      level: LogLevel.ERROR.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }
}

final logger = Logger._("app.log");
