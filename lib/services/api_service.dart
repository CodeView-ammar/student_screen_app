import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_screen_app/services/auth_service.dart';
import 'package:student_screen_app/utils/constants.dart';
import '../models/grade_class.dart';
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



  // الحصول على قائمة الفصول حسب المدرسة
  Future<List<GradeClass>> getGradeClasses(int schoolId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/schools/$schoolId/classes'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> gradeClassesJson = data['data'] ?? data['gradeClasses'] ?? [];
        return gradeClassesJson.map((json) => GradeClass.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الفصول');
      }
    } catch (e) {
      throw Exception('خطأ في جلب الفصول: $e');
    }
  }

  // الحصول على ندائات الطلاب
  Future<List<StudentCall>> getStudentCalls({
    int? gradeClassId,
    String? callPeriod,
    String? status,
    String? date,
  }) async {
    // try {
      final queryParams = <String, String>{};
      
      // إذا تم تمرير gradeClassId، استخدمه للتصفية
      if (gradeClassId != null) queryParams['grade_class_id'] = gradeClassId.toString();
      if (callPeriod != null) queryParams['call_period'] = callPeriod;
      if (status != null) queryParams['status'] = status;
      if (date != null) queryParams['date'] = date;
      
      // إضافة فلتر اليوم الحالي افتراضياً
      if (date == null) {
        queryParams['date'] = DateTime.now().toIso8601String().split('T')[0];
      }

      final uri = Uri.parse('${AppConstants.baseUrl}/student-calls').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: await _getHeaders(),
      );

     if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data); // تحقق من البيانات
        final List<dynamic> callsJson = data; // لا حاجة لـ 'data['data']' إذا كانت البيانات في الجذر
        return callsJson.map((json) => StudentCall.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب الندائات: ${response.statusCode} - ${response.body}');
      }
    // } catch (e) {
    //   throw Exception('خطأ في جلب الندائات: $e');
    // }
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