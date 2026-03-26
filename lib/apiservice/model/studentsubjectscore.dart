class StudentSubjectScore {
  final String? studentId;
  final int? sysSubjectNo;
  final String? subjectId;
  final String? subjectName;
  final String? activeStatus;
  final String? sendStatus; // เพิ่มฟิลด์ score

  StudentSubjectScore({
    this.studentId,
    this.sysSubjectNo,
    this.subjectId,
    this.subjectName,
    this.activeStatus,
    this.sendStatus, // เพิ่มฟิลด์ score
  });

  factory StudentSubjectScore.fromJson(Map<String, dynamic> json) {
    return StudentSubjectScore(
      studentId: json['student_id'],
      sysSubjectNo: json['sys_subject_no'],
      subjectId: json['subject_id'],
      subjectName: json['subject_name'],
      activeStatus: json['active_status'],
      sendStatus: json['send_status'], // เพิ่มการแปลงฟิลด์ score
    );
  }
}