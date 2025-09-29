import 'package:hive/hive.dart';
import '../../features/auth/login/data/login_model.dart';

class AuthStorageService {
  static const String _boxName = 'auth_box';
  static const String _loginKey = 'login_response';
  static const String _tokenKey = 'auth_token';

  static Box<LoginResponseModel>? _authBox;

  // Initialize Hive box
  static Future<void> init() async {
    _authBox = await Hive.openBox<LoginResponseModel>(_boxName);
  }

  // Simpan data login response
  static Future<void> saveLoginResponse(
    LoginResponseModel loginResponse,
  ) async {
    await _authBox?.put(_loginKey, loginResponse);
  }

  // Ambil data login response
  static LoginResponseModel? getLoginResponse() {
    return _authBox?.get(_loginKey);
  }

  // Simpan token terpisah untuk akses cepat
  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox('token_box');
    await box.put(_tokenKey, token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    final box = await Hive.openBox('token_box');
    return box.get(_tokenKey);
  }

  // Cek apakah user sudah login
  static bool isLoggedIn() {
    final loginResponse = getLoginResponse();
    return loginResponse != null && loginResponse.token.isNotEmpty;
  }

  // Hapus data login (logout)
  static Future<void> clearLoginData() async {
    await _authBox?.delete(_loginKey);
    final tokenBox = await Hive.openBox('token_box');
    await tokenBox.delete(_tokenKey);
  }

  // Cek validitas token (bisa ditambahkan logic untuk expired token)
  static bool isTokenValid() {
    final loginResponse = getLoginResponse();
    if (loginResponse == null || loginResponse.token.isEmpty) {
      return false;
    }

    // TODO: Tambahkan logic untuk cek expired token jika ada
    // Misalnya dengan decode JWT token dan cek exp field

    return true;
  }

  // Get current user data
  static UserModel? getCurrentUser() {
    final loginResponse = getLoginResponse();
    return loginResponse?.user;
  }

  // Update user data
  static Future<void> updateUserData(UserModel user) async {
    final loginResponse = getLoginResponse();
    if (loginResponse != null) {
      final updatedResponse = LoginResponseModel(
        code: loginResponse.code,
        status: loginResponse.status,
        message: loginResponse.message,
        user: user,
        token: loginResponse.token,
      );
      await saveLoginResponse(updatedResponse);
    }
  }
}
