class UserAuth {
  final String? fullName;
  final String? email;
  final String? accessToken;
  final String? refreshToken;

  UserAuth({this.fullName, this.email, this.accessToken, this.refreshToken});

  // Define the toJson method
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // Assuming there is also a fromJson factory constructor
  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}
