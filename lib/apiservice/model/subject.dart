class Subject {
  final int? rowId;
  final String? subjectId;
  final String? subjectName;
  final DateTime? createDate;
  final String? activeStatus;
  final String? createBy;
  final DateTime? updateDate;
  final String? updateBy;
  final String? subjectSearch;
  final String? teacherCode;
  final int? role;

  Subject({
    this.rowId,
    this.subjectId,
    this.subjectName,
    this.createDate,
    this.activeStatus,
    this.createBy,
    this.updateDate,
    this.updateBy,
    this.subjectSearch,
    this.teacherCode,
    this.role,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      rowId: json['row_id'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      createDate: json['create_date'] != null
          ? DateTime.parse(json['create_date'])
          : null,
      activeStatus: json['active_status'],
      createBy: json['create_by'],
      updateDate: json['update_date'] != null
          ? DateTime.parse(json['update_date'])
          : null,
      updateBy: json['update_by'],
      subjectSearch: json['subjectSearch'],
      teacherCode: json['teacher_code'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row_id': rowId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'create_date': createDate?.toIso8601String(),
      'active_status': activeStatus,
      'create_by': createBy,
      'update_date': updateDate?.toIso8601String(),
      'update_by': updateBy,
      'subjectSearch': subjectSearch,
      'teacher_code': teacherCode,
      'role': role,
    };
  }
}