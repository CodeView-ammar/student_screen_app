class StudentCall {
  final int id;
  final int studentId;
  final String studentName;
  final String? studentPhoto;
  final String? className;
  final String? branchName;
  final String callPeriod; // morning, afternoon, evening
  final String status; // pending, answered, not_answered
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
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: json['student_name'] ?? json['student']?['name'] ?? '',
      studentPhoto: json['student_photo'] ?? json['student']?['photo'],
      className: json['class_name'] ?? json['student']?['class_name'],
      branchName: json['branch_name'] ?? json['student']?['branch_name'],
      callPeriod: json['call_period'] ?? 'morning',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      answeredAt: json['answered_at'] != null ? DateTime.parse(json['answered_at']) : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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