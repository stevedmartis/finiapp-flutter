class UserAuth {
  final String? userId;
  final String? fullName;
  final String? email;
  final String? accessToken;
  final String? refreshToken;

  UserAuth(
      {this.userId,
      this.fullName,
      this.email,
      this.accessToken,
      this.refreshToken});

  // Define the toJson method
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // Assuming there is also a fromJson factory constructor
  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      userId: json['userId'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
