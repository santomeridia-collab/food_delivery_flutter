import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  String? userId;
  String? identifier;
  String? accessToken;
  String? refreshToken;
  String? role;

  // session data instance should not be made outside of session provider
  SessionData._();

  bool get isLoggedIn =>
      userId != null &&
      identifier != null &&
      accessToken != null &&
      refreshToken != null &&
      role != null;
}

class SessionProvider extends ChangeNotifier {
  SessionData _sessionData = SessionData._();
  final _prefs = SharedPreferencesAsync();
  bool isInitialized = false;

  SessionData get session => _sessionData;

  /// isLoggedIn guarantees that any member of the session is not null
  bool get isLoggedIn => _sessionData.isLoggedIn;

  SessionProvider._();

  Future<void> loadFromPrefs() async {
    _sessionData.userId = await _prefs.getString("userId");
    _sessionData.identifier = await _prefs.getString("identifier");
    _sessionData.accessToken = await _prefs.getString("accessToken");
    _sessionData.refreshToken = await _prefs.getString("refreshToken");
    _sessionData.role = await _prefs.getString("role");

    isInitialized = true;
    notifyListeners();
  }

  Future<void> setSession(
    String userId,
    String identifier,
    String accessToken,
    String refreshToken,
    String role,
  ) async {
    _sessionData.userId = userId;
    _sessionData.identifier = identifier;
    _sessionData.accessToken = accessToken;
    _sessionData.refreshToken = refreshToken;
    _sessionData.role = role;

    await _prefs.setString("userId", userId);
    await _prefs.setString("identifier", identifier);
    await _prefs.setString("accessToken", accessToken);
    await _prefs.setString("refreshToken", refreshToken);
    await _prefs.setString("role", role);

    notifyListeners();
  }

  Future<void> updateAccessToken(String accessToken) async {
    _sessionData.accessToken = accessToken;
    await _prefs.setString("accessToken", accessToken);
    notifyListeners();
  }

  Future<void> clear() async {
    _sessionData = SessionData._();

    await _prefs.remove("userId");
    await _prefs.remove("identifier");
    await _prefs.remove("accessToken");
    await _prefs.remove("refreshToken");
    await _prefs.remove("role");

    notifyListeners();
  }
}

final sessionProvider = SessionProvider._();
