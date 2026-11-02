import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

/// Authentication service — persists the Sanctum token in the device keychain
/// (iOS Keychain / Android Keystore) via flutter_secure_storage and keeps
/// ApiService in sync so every subsequent request carries the Bearer token.
///
/// Usage:
///   // Restore session on app start
///   await AuthService.instance.restoreSession();
///
///   // After a successful login API call
///   await AuthService.instance.persistLogin(token: '...', buyerName: 'Juan');
///
///   // Check whether a token is stored
///   AuthService.instance.isLoggedIn  →  bool
///
///   // Buyer name for display
///   AuthService.instance.buyerName   →  String?
///
///   // On logout
///   await AuthService.instance.logout();
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _storage = FlutterSecureStorage(
    // Use AES-CBC on Android (widely supported) rather than the newer AES-GCM
    // default so older devices don't have issues.
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const _keyToken = 'sanctum_token';
  static const _keyBuyerName = 'buyer_name';
  static const _keyBuyerId = 'buyer_id';

  // ── In-memory state ───────────────────────────────────────────────────────

  bool _isLoggedIn = false;
  String? _buyerName;
  String? _buyerId;

  bool get isLoggedIn => _isLoggedIn;
  String? get buyerName => _buyerName;
  String? get buyerId => _buyerId;

  // ── Session bootstrap ─────────────────────────────────────────────────────

  /// Call this once in [main] (or in the first splash screen) to restore a
  /// persisted session. If a token exists it is loaded into [ApiService.token]
  /// so the very first authenticated request works without an explicit login.
  Future<void> restoreSession() async {
    final token = await _storage.read(key: _keyToken);
    if (token != null && token.isNotEmpty) {
      ApiService.token = token;
      _buyerName = await _storage.read(key: _keyBuyerName);
      _buyerId = await _storage.read(key: _keyBuyerId);
      _isLoggedIn = true;
    }
  }

  // ── Login / persist ───────────────────────────────────────────────────────

  /// Persist the Sanctum token returned by the login or verify-email endpoint.
  /// Also stores the buyer's display name and id for quick access.
  Future<void> persistLogin({
    required String token,
    String? buyerName,
    String? buyerId,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    if (buyerName != null) {
      await _storage.write(key: _keyBuyerName, value: buyerName);
    }
    if (buyerId != null) {
      await _storage.write(key: _keyBuyerId, value: buyerId);
    }

    ApiService.token = token;
    _isLoggedIn = true;
    _buyerName = buyerName;
    _buyerId = buyerId;
  }

  /// Convenience method used by tests and the mock login flow that only needs
  /// to mark the session as authenticated without a real token.
  /// Remove this once all screens use the real API.
  void login() => _isLoggedIn = true;

  // ── Logout ────────────────────────────────────────────────────────────────

  /// Revoke the token on the server (best-effort — network errors are swallowed)
  /// then clear local storage and reset in-memory state.
  Future<void> logout() async {
    // Best-effort API call — don't block the UI if the server is unreachable.
    if (_isLoggedIn && ApiService.token != null) {
      try {
        await ApiService.post('/buyer/logout');
      } catch (_) {
        // Token is already gone or server unreachable — proceed with local logout.
      }
    }

    ApiService.token = null;
    _isLoggedIn = false;
    _buyerName = null;
    _buyerId = null;

    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyBuyerName);
    await _storage.delete(key: _keyBuyerId);
  }
}
