class MProfileInfo {
  final num id;
  final num isActive;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final num isSuperAdmin;
  final num isAdmin;
  final num roleId;
  final String roleName;
  final String accessToken;
  final num locationId;

  MProfileInfo({
    required this.id,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.isSuperAdmin,
    required this.isAdmin,
    required this.roleId,
    required this.roleName,
    required this.accessToken,
    required this.locationId,
  });

  factory MProfileInfo.fromJson(Map<String, dynamic> json) {
    return MProfileInfo(
      id: json['id'] ?? 0,
      isActive: json['is_active'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      isSuperAdmin: json['is_super_admin'] ?? 0,
      isAdmin: json['is_admin'] ?? 0,
      roleId: json['role_id'] ?? 0,
      roleName: json['role_name'] ?? '',
      accessToken: json['access_token'] ?? '',
      locationId: json['location_id'] ?? 0,
    );
  }

  Map<String, dynamic> toMapLocal() {
    return {
      "id": id,
      "is_active": isActive,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile": mobile,
      "is_super_admin": isSuperAdmin,
      "is_admin": isAdmin,
      "role_id": roleId,
      "role_name": roleName,
      "location_id": locationId,
    };
  }

  bool get isAdminUser => roleId == 1;
  bool get isFactoryAdminUser => roleId == 2;
  bool get isFactorySupervisorUser => roleId == 3;
}
