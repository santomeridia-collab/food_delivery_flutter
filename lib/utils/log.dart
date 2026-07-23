import 'dart:developer';

enum LogLevel {
  info(500),
  fine(800),
  warning(900),
  error(1000);

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

    // bold and grey ASCII
    return "\x1b[1;38;2;185;185;185m[${hour.toString().padLeft(2, '0')}:$minute:$seconds $period]\x1b[0m";
  }

  void ok(String msg, {bool enableStackTrace = false}) {
    // pastel green ASCII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;119;221;119m[OK]\x1b[0m : $msg\n",
      name: _appName,
      level: LogLevel.fine.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void info(String msg, {bool enableStackTrace = false}) {
    // pastel off-white ASCII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;167;199;231m[INFO]\x1b[0m : $msg\n",
      name: _appName,
      level: LogLevel.info.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void warn(String msg, {bool enableStackTrace = true}) {
    // pastel orange ASCII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;255;179;71m[WARN]\x1b[0m : $msg\n",
      name: _appName,
      level: LogLevel.warning.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }

  void error(String msg, {bool enableStackTrace = true}) {
    // pastel red ASCII
    log(
      "${_getAscaiiFormattedTimestamp()}   \x1b[1;38;2;255;105;97m[ERROR]\x1b[0m : $msg\n",
      name: _appName,
      level: LogLevel.error.value,
      stackTrace: enableStackTrace ? StackTrace.current : null,
      error: "",
    );
  }
}

final logger = Logger._("app.log");
