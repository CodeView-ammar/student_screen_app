class StudentCall {
  final int id;
  final int studentId;
  final String studentName;
  final String? studentPhoto;
  final String? className;
  final String? branchName;
  final String callPeriod; // morning, afternoon, evening
  final String status; // leave, pending, answered, etc.
  final DateTime createdAt;
  final DateTime? answeredAt;
  final String? notes;

  StudentCall({
    required this.id,
    required this.studentId,
    required this.studentName,
    this.studentPhoto,
    this.className,
    this.branchName,
    required this.callPeriod,
    required this.status,
    required this.createdAt,
    this.answeredAt,
    this.notes,
  });

  factory StudentCall.fromJson(Map<String, dynamic> json) {
    return StudentCall(
      id: json['call_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: json['student']['name_en'] ?? '',
      studentPhoto: json['student']['photo'] ?? '',
      className: json['student']['grade_class']?['name_en'], // أو 'name_en' حسب الحاجة
      branchName: json['branch']?['name_en'], // تأكد من أن هذا صحيح
      callPeriod: json['call_period'] ?? 'morning',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      answeredAt: json['call_edate'] != null ? DateTime.parse(json['call_edate']) : null,
      notes: "", // أو استخدم ملاحظات إذا كانت موجودة
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_id': id,
      'student_id': studentId,
      'student_name': studentName,
      'student_photo': studentPhoto,
      'class_name': className,
      'branch_name': branchName,
      'call_period': callPeriod,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'answered_at': answeredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'في الانتظار';
      case 'answered':
        return 'تم الرد';
      case 'not_answered':
        return 'لم يتم الرد';
      default:
        return status;
    }
  }

  String get callPeriodText {
    switch (callPeriod) {
      case 'morning':
        return 'الصباح';
      case 'afternoon':
        return 'الظهر';
      case 'evening':
        return 'المساء';
      default:
        return callPeriod;
    }
  }
}