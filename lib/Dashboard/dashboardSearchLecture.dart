import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/Dashboard/summaryDashboardLecture.dart';
import 'package:score_management/Notify/notificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:score_management/Authentication/loginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/teacher.dart';
import 'package:score_management/apiservice/model/subject.dart';

class DashboardSearchLecture extends StatefulWidget {
  const DashboardSearchLecture({super.key});

  @override
  State<DashboardSearchLecture> createState() => _DashboardSearchLectureState();
}

class _DashboardSearchLectureState extends State<DashboardSearchLecture> {
  Teacher? teacher;
  List<Subject> subjects = [];
  static const primary = Color(0xFFA1BC98);
  static const secondary = Color(0xFFD2DCB6);
  static const light = Color(0xFFF1F3E0);
  static const textDark = Color(0xFF4F5F52);
  static const textSoft = Color(0xFF778873);

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  int? yearValue;
  String? semesterValue;
  String? sectionValue;
  String? subjectValue;
  String? selectedSubjectName;

  TextStyle kanit({
    double size = 16,
    FontWeight weight = FontWeight.w500,
    Color color = textDark,
    FontStyle? style,
  }) {
    return GoogleFonts.kanit(
      fontSize: size,
      fontWeight: weight,
      color: color,
      fontStyle: style,
    );
  }

  String? selectedScore = "คะแนนทั้งหมด";

  @override
  void initState() {
    super.initState();
    loadTeacher();
  }

  Future<void> loadTeacher() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final result = await TeacherService.getTeacherByEmail(currentUser.email!);

    if (!mounted) return;

    setState(() {
      teacher = result;
    });

    if (result != null) {
      await loadSubjects();
    }
  }

  Future<void> loadSubjects() async {
    final result = await SubjectService.getSubjectByTeacher(teacher!.username!);

    if (!mounted) return;

    setState(() {
      subjects = result;
    });
  }

  String getPrefix(String? prefix) {
    switch (prefix) {
      case '1':
        return 'นาย';
      case '2':
        return 'ด.ช.';
      case '3':
        return 'นาย';
      case '4':
        return 'นาง';
      case '5':
        return 'นางสาว';
      default:
        return 'ผู้ช่วยศาสตราจารย์';
    }
  }

  @override
  void dispose() {
    subjectController.dispose();
    yearController.dispose();
    semesterController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  void _logout() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: "ออกจากระบบ",
      desc: "คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ ?",
      btnCancelText: "ยกเลิก",
      btnOkText: "ออกจากระบบ",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    if (teacher == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(child: _buildSearchForm()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreeting(),
          const SizedBox(height: 15),
          _buildProfileCard(),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "สวัสดี 👋",
              style: kanit(
                size: 30,
                weight: FontWeight.w400,
                color: Colors.white,
                style: FontStyle.italic,
              ),
            ),
            Text(
              "ขอให้วันนี้เป็นวันที่ดีนะ 😊",
              style: kanit(size: 16, color: light),
            ),
          ],
        ),

        const Spacer(),

        Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE7ECD9),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFF5F705C)),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: primary,
                child: Icon(Icons.person, size: 38, color: secondary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getPrefix(teacher?.prefix ?? '')} ${teacher?.firstname ?? ''} ${teacher?.lastname ?? ''}",
                    style: kanit(),
                  ),
                  Text(
                    "รหัสอาจารย์ : ${teacher!.teacherCode ?? ''}",
                    style: kanit(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearDropdown() {
    final years = {1: "2564", 2: "2565", 3: "2566", 4: "2567", 5: "2568"};

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: yearValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: light,
          labelText: "🗓️ ปีการศึกษา",
          labelStyle: kanit(color: textSoft),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        items:
            years.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value, style: kanit(color: textSoft)),
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            yearValue = value;
            yearController.text = years[value] ?? "";
          });
        },
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownSearch<String>(
        selectedItem: subjectValue,
        items:
            subjects
                .where((subject) => subject.activeStatus == "active")
                .map((subject) => subject.subjectId!)
                .toList(),

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: light,
            labelText: "📚 รหัสรายวิชา / ชื่อรายวิชา",
            labelStyle: kanit(color: textSoft),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        popupProps: PopupProps.menu(
          showSearchBox: true, // 🔥 เปิด search
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(hintText: "ค้นหารายวิชา..."),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),

        itemAsString: (value) {
          final subject = subjects.firstWhere((s) => s.subjectId == value);
          return "${subject.subjectId} ${subject.subjectName}";
        },

        onChanged: (value) {
          setState(() {
            subjectValue = value;
            selectedSubjectName =
                subjects
                    .firstWhere((subject) => subject.subjectId == value)
                    .subjectName;
          });
        },
      ),
    );
  }

  Widget _buildSemesterDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: semesterValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: light,
          labelText: "🎒 ภาคเรียน",
          labelStyle: kanit(color: textSoft),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          DropdownMenuItem(
            value: "1",
            child: Text("ภาคต้น", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "2",
            child: Text("ภาคปลาย", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "3",
            child: Text("ภาคฤดูร้อน", style: kanit(color: textSoft)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            semesterValue = value;
            semesterController.text = switch (value) {
              "1" => "ภาคต้น",
              "2" => "ภาคปลาย",
              "3" => "ภาคฤดูร้อน",
              _ => "",
            };
          });
        },
      ),
    );
  }

  Widget _buildSectionDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: sectionValue,
        decoration: InputDecoration(
          filled: true,
          fillColor: light,
          labelText: "🎓 หมู่เรียน",
          labelStyle: kanit(color: textSoft),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        items: [
          DropdownMenuItem(
            value: "1",
            child: Text("800", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "2",
            child: Text("801", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "3",
            child: Text("802", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "4",
            child: Text("803", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "5",
            child: Text("830", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "6",
            child: Text("831", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "7",
            child: Text("850", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "8",
            child: Text("851", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "9",
            child: Text("870", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "10",
            child: Text("880", style: kanit(color: textSoft)),
          ),
          DropdownMenuItem(
            value: "11",
            child: Text("881", style: kanit(color: textSoft)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            sectionValue = value;
            final sectionMap = {
              "1": "800",
              "2": "801",
              "3": "802",
              "4": "803",
              "5": "830",
              "6": "831",
              "7": "850",
              "8": "851",
              "9": "870",
              "10": "880",
              "11": "881",
            };
            sectionController.text = sectionMap[value] ?? "";
          });
        },
      ),
    );
  }

  Widget _buildSearchForm() {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🔎 ค้นหาข้อมูลภาพรวมคะแนน",
            style: kanit(size: 20, color: textSoft),
          ),
          const SizedBox(height: 10),
          _buildSubjectDropdown(),
          _buildYearDropdown(),
          _buildSemesterDropdown(),
          _buildSectionDropdown(),
          _buildDropdownScore(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: light,
          labelText: hint,
          labelStyle: kanit(color: textSoft),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownScore() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: selectedScore,
        decoration: InputDecoration(
          filled: true,
          fillColor: light,
          labelText: "📊 ประเภทคะแนน",
          labelStyle: kanit(color: textSoft),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        style: kanit(),
        dropdownColor: Colors.white,
        items:
            ["คะแนนทั้งหมด", "คะแนนเก็บ", "คะแนนกลางภาค", "คะแนนปลายภาค"]
                .map(
                  (score) => DropdownMenuItem(
                    value: score,
                    child: Text(score, style: kanit()),
                  ),
                )
                .toList(),
        onChanged: (value) {
          setState(() {
            selectedScore = value;
          });
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: "🔍 ค้นหา",
            color: const Color(0xFF8FAF8A),
            onPressed: _onSearchPressed,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildButton(
            text: "🔄 รีเซ็ต",
            color: primary,
            onPressed: _onResetPressed,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: kanit(weight: FontWeight.w600)),
    );
  }

  void _goToNotification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Notificationpage()),
    );
  }

  void _onSearchPressed() async {
    if (subjectValue == null ||
        yearValue == null ||
        semesterValue == null ||
        sectionValue == null ||
        selectedScore == null) {
      if (!mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "ข้อมูลไม่ครบ",
        desc: "กรุณากรอกข้อมูลให้ครบทุกช่องก่อนทำการค้นหา",
        btnOkText: "ตกลง",
        btnOkColor: Colors.orange,
        btnOkOnPress: () {},
      ).show();

      return;
    }

    int? sysSubjectNo = await SubjectService.getSubjectNo(
      subjectId: subjectValue!,
      academicYear: yearValue!.toString(),
      semester: int.parse(semesterValue!),
      section: sectionValue!,
    );

    if (!mounted) return; // 🔥 สำคัญที่สุด

    if (sysSubjectNo == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: "ไม่พบข้อมูล",
        desc: "ไม่พบข้อมูลสำหรับการแสดง Dashboard\nกรุณาตรวจสอบข้อมูลอีกครั้ง",
        btnOkText: "ตกลง",
        btnOkColor: Colors.red,
        btnOkOnPress: () {},
      ).show();

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SummaryDashboardLecture(
              sysSubjectNo: sysSubjectNo,
              subjectId: subjectValue!,
              subjectName: selectedSubjectName!,
              academicYear: yearController.text,
              semester: semesterController.text,
              section: sectionController.text,
              scoreType: selectedScore!,
            ),
      ),
    );
  }

  void _onResetPressed() {
    subjectController.clear();
    yearController.clear();
    semesterController.clear();
    sectionController.clear();
    selectedSubjectName = null;
    sectionValue = null;
    semesterValue = null;
    yearValue = null;
    subjectValue = null;

    setState(() {
      selectedScore = "คะแนนทั้งหมด";
    });
  }
}
