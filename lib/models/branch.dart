class Branch {
  final int id;
  final String name;
  final int schoolId;

  Branch({
    required this.id,
    required this.name,
    required this.schoolId,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
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