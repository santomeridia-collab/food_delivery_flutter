import 'dart:developer';

// import 'package:logging/logging.dart';

enum Level {
  FINE(500),
  INFO(800),
  WARNING(900),
  ERROR(1000),
  FATAL(2000);

  final int value;

  const Level(this.value);
}

class Logger {
  String _appName = "app.logger.default";

  Logger._(String name) {
    _appName = name;
  }

  void ok(String msg) {
    log(
      "🟢: $msg",
      name: _appName,
      level: Level.FINE.value,
      time: DateTime.now(),
      error: "",
    );
  }

  void info(String msg) {
    log(
      "⚪: $msg",
      name: _appName,
      level: Level.INFO.value,
      time: DateTime.now(),
      error: "",
    );
  }

  void warn(String msg) {
    log(
      "🟠: $msg",
      name: _appName,
      level: Level.WARNING.value,
      time: DateTime.now(),
      error: "",
    );
  }

  void error(String msg) {
    log(
      "🔴: $msg",
      name: _appName,
      level: Level.ERROR.value,
      time: DateTime.now(),
      error: "",
    );
  }
}

final logger = Logger._("app.delivery.santomeridia");
