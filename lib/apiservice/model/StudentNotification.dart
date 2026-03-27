class StudentNotification {
  final String studentId;
  final int sysSubjectNo;
  final String subjectId;
  final String sendStatus;
  final String? sendDesc;
  final String semester;
  final String academicYear;
  final String section;
  final String subjectName;
  final DateTime sendTime;

  StudentNotification({
    required this.studentId,
    required this.sysSubjectNo,
    required this.subjectId,
    required this.sendStatus,
    this.sendDesc,
    required this.semester,
    required this.academicYear,
    required this.section,
    required this.subjectName,
    required this.sendTime,
  });

  factory StudentNotification.fromJson(Map<String, dynamic> json) {
    return StudentNotification(
      studentId: json['student_id'] ?? '',
      sysSubjectNo: json['sys_subject_no'] ?? 0,
      subjectId: json['subject_id'] ?? '',
      sendStatus: json['send_status'] ?? '',
      sendDesc: json['send_desc'],
      semester: json['semester'] ?? '',
      academicYear: json['academic_year'] ?? '',
      section: json['section'] ?? '',
      subjectName: json['subject_name'] ?? '',
      sendTime: DateTime.parse(json['send_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'sys_subject_no': sysSubjectNo,
      'subject_id': subjectId,
      'send_status': sendStatus,
      'send_desc': sendDesc,
      'semester': semester,
      'academic_year': academicYear,
      'section': section,
      'subject_name': subjectName,
      'send_time': sendTime.toIso8601String(),
    };
  }
}
