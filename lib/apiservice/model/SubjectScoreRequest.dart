class SubjectScoreRequest {
  final int sysSubjectNo;
  final String? studentId;

  SubjectScoreRequest({
    required this.sysSubjectNo,
    this.studentId,
  });

  Map<String, dynamic> toJson() {
    return {
      "sys_subject_no": sysSubjectNo,
      "student_id": studentId,
    };
  }
}
