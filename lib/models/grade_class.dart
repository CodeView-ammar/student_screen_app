class GradeClass {
  final int id;
  final String name;
  final int schoolId;

  GradeClass({
    required this.id,
    required this.name,
    required this.schoolId,
  });

 factory GradeClass.fromJson(Map<String, dynamic> json) {
    return GradeClass(
      id: json['id'] ?? 0,
      name: 
        (json['name'] ?? '') + '' + (json['name_en'] ?? ''),
      schoolId: json['school_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'school_id': schoolId,
    };
  }

  @override
  String toString() => name;
}