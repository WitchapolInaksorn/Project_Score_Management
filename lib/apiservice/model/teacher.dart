class Teacher {
  final int? rowId;
  final String? username;
  final String? password;
  final String? role;
  final String? teacherCode;
  final String? prefix;
  final String? firstname;
  final String? lastname;
  final String? email;
  final int? totalFailed;
  final DateTime? dateLogin;
  final String? activeStatus;
  final DateTime? createDate;
  final String? createBy;
  final DateTime? updateDate;
  final String? updateBy;
  final String? prefixDescriptionTh;
  final String? prefixDescriptionEn;
  final String? roleDescriptionTh;
  final String? roleDescriptionEn;

  Teacher({
    this.rowId,
    this.username,
    this.password,
    this.role,
    this.teacherCode,
    this.prefix,
    this.firstname,
    this.lastname,
    this.email,
    this.totalFailed,
    this.dateLogin,
    this.activeStatus,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
    this.prefixDescriptionTh,
    this.prefixDescriptionEn,
    this.roleDescriptionTh,
    this.roleDescriptionEn,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      rowId: json['row_id'],
      username: json['username'],
      password: json['password'],
      role: json['role']?.toString(),
      teacherCode: json['teacher_code'],
      prefix: json['prefix'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      totalFailed: json['total_failed'],
      dateLogin: json['date_login'] != null
          ? DateTime.parse(json['date_login'])
          : null,
      activeStatus: json['active_status'],
      createDate: json['create_date'] != null
          ? DateTime.parse(json['create_date'])
          : null,
      createBy: json['create_by'],
      updateDate: json['update_date'] != null
          ? DateTime.parse(json['update_date'])
          : null,
      updateBy: json['update_by'],
      prefixDescriptionTh: json['prefix_description_th'],
      prefixDescriptionEn: json['prefix_description_en'],
      roleDescriptionTh: json['role_description_th'],
      roleDescriptionEn: json['role_description_en'],
    );
  }
}