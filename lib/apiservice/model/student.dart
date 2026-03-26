class Student {
  final int? rowId;
  final String? studentId;
  final String? firstname;
  final String? lastname;
  final String? majorCode;
  final String? email;
  final String? activeStatus;
  final DateTime? createDate;
  final String? createBy;
  final DateTime? updateDate;
  final String? updateBy;

  Student({
    this.rowId,
    this.studentId,
    this.firstname,
    this.lastname,
    this.majorCode,
    this.email,
    this.activeStatus,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      rowId: json['row_id'],
      studentId: json['student_id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      majorCode: json['major_code'],
      email: json['email'],
      activeStatus: json['active_status'],
      createDate: json['create_date'] != null
          ? DateTime.parse(json['create_date'])
          : null,
      createBy: json['create_by'],
      updateDate: json['update_date'] != null
          ? DateTime.parse(json['update_date'])
          : null,
      updateBy: json['update_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row_id': rowId,
      'student_id': studentId,
      'firstname': firstname,
      'lastname': lastname,
      'major_code': majorCode,
      'email': email,
      'active_status': activeStatus,
      'create_date': createDate?.toIso8601String(),
      'create_by': createBy,
      'update_date': updateDate?.toIso8601String(),
      'update_by': updateBy,
    };
  }
}