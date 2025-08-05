class Student {
  final int id;
  final String name;
  final String? studentNumber;
  final int? classId;
  final String? className;
  final int? branchId;
  final String? branchName;
  final String? photo;

  Student({
    required this.id,
    required this.name,
    this.studentNumber,
    this.classId,
    this.className,
    this.branchId,
    this.branchName,
    this.photo,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      studentNumber: json['student_number'],
      classId: json['class_id'],
      className: json['class_name'],
      branchId: json['branch_id'],
      branchName: json['branch_name'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'student_number': studentNumber,
      'class_id': classId,
      'class_name': className,
      'branch_id': branchId,
      'branch_name': branchName,
      'photo': photo,
    };
  }
}