import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'model/studentinfo.dart';
import 'model/teacher.dart';
import 'model/subject.dart';
import 'model/subjectScore.dart';
import 'model/student.dart';
import 'model/studentsubjectscore.dart';
import 'model/SubjectScoreRequest.dart';
import 'model/StudentNotification.dart';

class StudentService {
  static const String baseUrl = "https://10.0.2.2:7060/api/User";

  static Future<bool> insertStudent(StudentInfo student) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse("$baseUrl/InsertStudentInfo");

    final response = await ioClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(student.toJson()),
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    return response.statusCode == 200;
  }

  static Future<List<SubjectScore>> getScoreBySubjectNo(
    int sysSubjectNo,
  ) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/GetSubjectScore/$sysSubjectNo",
    );

    final response = await ioClient.get(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => SubjectScore.fromJson(e)).toList();
    }

    return [];
  }

  static Future<StudentInfo?> getStudentByEmail(String email) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse("$baseUrl/GetStudentInfo");

    final response = await ioClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ✅ เช็ค success ก่อน
      if (data["isSuccess"] == true && data["objectResponse"] != null) {
        return StudentInfo.fromJson(data["objectResponse"]);
      }
    }

    return null;
  }

  static Future<Student?> getStudentById(String studentId) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/GetStudentById/${Uri.encodeComponent(studentId)}",
    );

    final response = await ioClient.get(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Student.fromJson(data);
    }

    return null;
  }

  static Future<List<StudentSubjectScore>> getSubjectScore(
    String studentId,
  ) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/GetStudentSubjectScore/$studentId",
    );

    final response = await ioClient.get(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => StudentSubjectScore.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load data");
    }
  }

  static Future<List<SubjectScore>> getStudentScore(
    SubjectScoreRequest request,
  ) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/GetStudentScore",
    );

    final response = await ioClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => SubjectScore.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load data: ${response.body}");
    }
  }

  static Future<List<StudentNotification>> getStudentNotification(
    String studentId,
  ) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/GetStudentNotification/$studentId",
    );

    final response = await ioClient.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((e) => StudentNotification.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception("Failed to load notification: ${response.body}");
    }
  }

  static Future<String> deleteNotificationByDate(DateTime date) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final formattedDate = date.toIso8601String();

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/DeleteNotificationByDate?date=$formattedDate",
    );

    final response = await ioClient.delete(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete: ${response.body}");
    }
  }

  static Future<String> deleteAllNotification(String studentId) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "https://10.0.2.2:7060/api/MasterData/DeleteAllNotification/$studentId",
    );

    final response = await ioClient.delete(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete: ${response.body}");
    }
  }
}

class TeacherService {
  static const String baseUrl = "https://10.0.2.2:7060/api/User";

  static Future<bool> checkEmail(String email) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse("$baseUrl/CheckEmail");

    final response = await ioClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["exists"];
    }

    return false;
  }

  static Future<Teacher?> getTeacherByEmail(String email) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse("$baseUrl/GetUserByEmail/$email");

    final response = await ioClient.get(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Teacher.fromJson(data);
    }

    return null;
  }
}

class SubjectService {
  static const String baseUrl = "https://10.0.2.2:7060/api/MasterData";

  static Future<List<Subject>> getSubjectByTeacher(String username) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse(
      "$baseUrl/GetSubjectByTeacher/${Uri.encodeComponent(username)}",
    );

    final response = await ioClient.get(url);

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => Subject.fromJson(e)).toList();
    }

    return [];
  }

  static Future<int?> getSubjectNo({
    required String subjectId,
    required String academicYear,
    required int semester,
    required String section,
  }) async {
    HttpClient client =
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    IOClient ioClient = IOClient(client);

    final url = Uri.parse("$baseUrl/GetSubjectNo");

    final body = jsonEncode({
      "subject_id": subjectId,
      "academic_year": academicYear,
      "semester": semester,
      "section": section,
    });

    final response = await ioClient.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("status: ${response.statusCode}");
    print("body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}
