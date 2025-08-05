import 'package:flutter/foundation.dart';
import '../models/student_call.dart';
import '../services/api_service.dart';

class StudentCallsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<StudentCall> _studentCalls = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentFilter = 'all'; // all, pending, answered, not_answered
  String _currentPeriod = 'all'; // all, morning, afternoon, evening

  List<StudentCall> get studentCalls => _studentCalls;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  String get currentPeriod => _currentPeriod;

  List<StudentCall> get filteredCalls {
    List<StudentCall> filtered = _studentCalls;

    // تصفية حسب الحالة
    if (_currentFilter != 'all') {
      filtered = filtered.where((call) => call.status == _currentFilter).toList();
    }

    // تصفية حسب الفترة
    if (_currentPeriod != 'all') {
      filtered = filtered.where((call) => call.callPeriod == _currentPeriod).toList();
    }

    // ترتيب حسب التاريخ (الأحدث أولاً)
    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
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

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setPeriod(String period) {
    _currentPeriod = period;
    notifyListeners();
  }

  Future<void> loadStudentCalls({
    int? gradeClassId,
    String? date,
    bool forceRefresh = false,
  }) async {
    if (_isLoading && !forceRefresh) return;

    setLoading(true);
    clearError();

    try {
      final calls = await _apiService.getStudentCalls(
        gradeClassId: gradeClassId == -1 ? null : gradeClassId, // إذا كان -1 فهذا يعني كل الفصول
        date: date ?? DateTime.now().toIso8601String().split('T')[0],
      );
      
      _studentCalls = calls;
      setLoading(false);
    } catch (e) {
      setError('خطأ في تحميل الندائات: $e');
      setLoading(false);
    }
  }

  Future<bool> updateCallStatus(int callId, String status) async {
    try {
      final success = await _apiService.updateCallStatus(callId, status);
      
      if (success) {
        // تحديث الحالة محلياً
        final callIndex = _studentCalls.indexWhere((call) => call.id == callId);
        if (callIndex != -1) {
          final updatedCall = StudentCall(
            id: _studentCalls[callIndex].id,
            studentId: _studentCalls[callIndex].studentId,
            studentName: _studentCalls[callIndex].studentName,
            studentPhoto: _studentCalls[callIndex].studentPhoto,
            className: _studentCalls[callIndex].className,
            branchName: _studentCalls[callIndex].branchName,
            callPeriod: _studentCalls[callIndex].callPeriod,
            status: status,
            createdAt: _studentCalls[callIndex].createdAt,
            answeredAt: status == 'answered' ? DateTime.now() : _studentCalls[callIndex].answeredAt,
            notes: _studentCalls[callIndex].notes,
          );
          
          _studentCalls[callIndex] = updatedCall;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      setError('خطأ في تحديث حالة النداء: $e');
      return false;
    }
  }

  Future<void> refreshCalls({int? gradeClassId}) async {
    await loadStudentCalls(gradeClassId: gradeClassId, forceRefresh: true);
  }

  // إحصائيات سريعة
  Map<String, int> get callsStatistics {
    return {
      'total': _studentCalls.length,
      'pending': _studentCalls.where((call) => call.status == 'pending').length,
      'answered': _studentCalls.where((call) => call.status == 'answered').length,
      'not_answered': _studentCalls.where((call) => call.status == 'not_answered').length,
    };
  }
}