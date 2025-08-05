import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:student_screen_app/services/auth_service.dart';
import '../models/user.dart';
import '../models/grade_class.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  GradeClass? _selectedGradeClass;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  GradeClass? get selectedGradeClass => _selectedGradeClass;
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
      await AuthService().logout();
      
      // حذف الفصل المحفوظ
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selected_grade_class');
    } catch (e) {
      // تجاهل أخطاء تسجيل الخروج
    }
    
    _user = null;
    _selectedGradeClass = null;
    setLoading(false);
  }

  void selectGradeClass(GradeClass gradeClass) {
    _selectedGradeClass = gradeClass;
    notifyListeners();
  }

  // حفظ الفصل المختار في التخزين المحلي
  Future<void> selectAndSaveGradeClass(GradeClass gradeClass) async {
    _selectedGradeClass = gradeClass;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_grade_class', jsonEncode(gradeClass.toJson()));
    
    notifyListeners();
  }

  // تحميل الفصل المحفوظ من التخزين المحلي
  Future<GradeClass?> getStoredGradeClass() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gradeClassJson = prefs.getString('selected_grade_class');
      if (gradeClassJson != null) {
        return GradeClass.fromJson(jsonDecode(gradeClassJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // التحقق من وجود فصل محفوظ
  Future<bool> hasSavedGradeClass() async {
    final gradeClass = await getStoredGradeClass();
    return gradeClass != null;
  }

  // تحميل البيانات المحفوظة عند بدء التطبيق
  Future<void> loadSavedData() async {
    _user = await AuthService().getCurrentUser();
    _selectedGradeClass = await getStoredGradeClass();
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      final token = await AuthService().getStoredToken();
      if (token != null) {
        await loadSavedData(); // تحميل البيانات المحفوظة
        final isConnected = await _apiService.checkConnection();
        return isConnected;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}