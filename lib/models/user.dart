class User {
  final int id;
  final String name;
  final String email;
  final String? role;
  final String? token;
  final int? schoolId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.token,
    this.schoolId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      token: json['token'],
      schoolId: json['school_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'school_id': schoolId,
    };
  }

}

class LoginResponse {
  final String token;
  final User user;
  final String tokenType;

  LoginResponse({
    required this.token,
    required this.user,
    this.tokenType = 'Bearer',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }
}