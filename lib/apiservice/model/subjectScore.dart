class SubjectScore {

  final int sysSubjectNo;
  final String? studentId;
  final String? seatNo;
  final double? accumulatedScore;
  final double? midtermScore;
  final double? finalScore;

  SubjectScore({
    required this.sysSubjectNo,
    this.studentId,
    this.seatNo,
    this.accumulatedScore,
    this.midtermScore,
    this.finalScore,
  });

  factory SubjectScore.fromJson(Map<String, dynamic> json) {
    return SubjectScore(
      sysSubjectNo: json["sys_subject_no"],
      studentId: json["student_id"],
      seatNo: json["seat_no"],
      accumulatedScore: (json["accumulated_score"] as num?)?.toDouble(),
      midtermScore: (json["midterm_score"] as num?)?.toDouble(),
      finalScore: (json["final_score"] as num?)?.toDouble(),
    );
  }
}