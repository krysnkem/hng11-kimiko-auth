class KimikoUser {
  final String id;
  final String? firstName;
  final String? lastName;
  final bool? isActive;
  final String email;
  final String teamId;
  final String? avatarUrl;

  KimikoUser({
    required this.id,
    this.firstName,
    this.lastName,
    required this.isActive,
    required this.email,
    required this.teamId,
    this.avatarUrl,
  });

  // Factory constructor to create a KimikoUser from a JSON map
  factory KimikoUser.fromJson(Map<String, dynamic> json) {
    return KimikoUser(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      isActive: json['is_active'] as bool?,
      email: json['email'] as String,
      teamId: json['team_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  // Method to convert a KimikoUser to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'is_active': isActive,
      'email': email,
      'team_id': teamId,
      'avatar_url': avatarUrl,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
