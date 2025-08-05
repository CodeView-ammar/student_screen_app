import 'package:flutter/foundation.dart';
import 'package:student_screen_app/services/auth_service.dart';
import '../models/user.dart';
import '../models/branch.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  Branch? _selectedBranch;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  Branch? get selectedBranch => _selectedBranch;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  Future<void> loadSavedCredentials() async {
    _user = await AuthService().getCurrentUser(); // تحقق من وجود المستخدم
    notifyListeners();
  }
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
Future<bool> login(String phone, String password) async {
  setLoading(true);
  clearError();

  try {
    final loginResponse = await AuthService().login(phone, password); // إنشاء كائن من AuthService
    _user = loginResponse.user; // استرجاع المستخدم من LoginResponse
    setLoading(false);
    return true;
  } catch (e) {
    setError(e.toString());
    setLoading(false);
    return false;
  }
}

  Future<void> logout() async {
    setLoading(true);
    
    try {
      await AuthService().login;
    } catch (e) {
      // تجاهل أخطاء تسجيل الخروج
    }
    
    _user = null;
    _selectedBranch = null;
    setLoading(false);
  }

  void selectBranch(Branch branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final token = await AuthService().getStoredToken();
      if (token != null) {
        final isConnected = await _apiService.checkConnection();
        return isConnected;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}