class StudentInfo {
  final String? smaStudentId;
  final String? prefix;
  final String? firstname;
  final String? lastname;
  final String? studentId;
  final String? email;
  final String? majorId;
  final bool? status;

  StudentInfo({
    this.smaStudentId,
    this.prefix,
    this.firstname,
    this.lastname,
    this.studentId,
    this.email,
    this.majorId,
    this.status,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      smaStudentId: json['smA_Student_Id'] ?? json['SMA_Student_Id'],
      prefix: json['prefix'] ?? json['Prefix'],
      firstname: json['firstname'] ?? json['Firstname'],
      lastname: json['lastname'] ?? json['Lastname'],
      studentId: json['student_Id'] ?? json['Student_Id'],
      email: json['email'] ?? json['Email'],
      majorId: json['major_Id'] ?? json['Major_Id'],
      status: json['status'] ?? json['Status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SMA_Student_Id': smaStudentId,
      'Prefix': prefix,
      'Firstname': firstname,
      'Lastname': lastname,
      'Student_Id': studentId,
      'Email': email,
      'Major_Id': majorId,
      'Status': status,
    };
  }
}
