import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_screen_app/services/auth_service.dart';
import 'package:student_screen_app/utils/constants.dart';
import '../models/branch.dart';
import '../models/student_call.dart';

class ApiService {



  // إضافة Headers للطلبات
  Future<Map<String, String>> _getHeaders() async {
    final authService = AuthService(); // إنشاء كائن من AuthService
    final token = await authService.getStoredToken(); // استدعاء الدالة عبر الكائن


    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }



  // الحصول على قائمة الفروع حسب المدرسة
  Future<List<Branch>> getBranches(int schoolId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/schools/$schoolId/branches'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> branchesJson = data['data'] ?? data['branches'] ?? [];
        return branchesJson.map((json) => Branch.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الفروع');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الفروع: $e');
    }
  }

  // الحصول على ندائات الطلاب
  Future<List<StudentCall>> getStudentCalls({
    int? branchId,
    String? callPeriod,
    String? status,
    String? date,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (branchId != null) queryParams['branch_id'] = branchId.toString();
      if (callPeriod != null) queryParams['call_period'] = callPeriod;
      if (status != null) queryParams['status'] = status;
      if (date != null) queryParams['date'] = date;

      final uri = Uri.parse('${AppConstants.baseUrl}/student-calls').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> callsJson = data['data'] ?? data['student_calls'] ?? [];
        return callsJson.map((json) => StudentCall.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الندائات');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الندائات: $e');
    }
  }

  // تحديث حالة النداء
  Future<bool> updateCallStatus(int callId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}/student-calls/$callId/status'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'status': status,
          'answered_at': status == 'answered' ? DateTime.now().toIso8601String() : null,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // إنشاء نداء جديد
  Future<bool> createStudentCall({
    required int studentId,
    required String callPeriod,
    String? notes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/student-calls'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'student_id': studentId,
          'call_period': callPeriod,
          'status': 'pending',
          'notes': notes,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // فحص حالة الاتصال
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/auth/user'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}