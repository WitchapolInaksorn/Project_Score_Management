import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/Dashboard/summaryDashboardNisit.dart';
import 'package:score_management/Notify/notificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:score_management/Authentication/loginPage.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/subject.dart';
import 'package:score_management/apiservice/model/studentinfo.dart';
import 'package:score_management/apiservice/model/studentsubjectscore.dart';

class DashboardSearchNisit extends StatefulWidget {
  const DashboardSearchNisit({super.key});

  @override
  State<DashboardSearchNisit> createState() => _DashboardSearchNisitState();
}

class _DashboardSearchNisitState extends State<DashboardSearchNisit> {
  static const primary = Color(0xFFA1BC98);
  static const secondary = Color(0xFFD2DCB6);
  static const light = Color(0xFFF1F3E0);
  static const textDark = Color(0xFF4F5F52);
  static const textSoft = Color(0xFF778873);

  StudentInfo? studentInfo;
  List<StudentSubjectScore>? Subject;
  StudentSubjectScore? selectedSubject;
  bool isLoading = false;

  int? yearValue;
  String? semesterValue;
  String? sectionValue;
  String? subjectValue;
  String? selectedSubjectName;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

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
  void dispose() {
    subjectController.dispose();
    yearController.dispose();
    semesterController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  Future<void> loadStudent() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final result = await StudentService.getStudentByEmail(
      currentUser.email ?? "",
    );

    setState(() {
      studentInfo = result;
      loadStudentSubject(studentInfo?.studentId ?? "");
    });

    print("Loaded student info: ${studentInfo?.toJson()}");
  }

  Future<void> loadStudentSubject(String studentId) async {
    setState(() {
      isLoading = true;
    });

    final result = await StudentService.getSubjectScore(studentId);

    setState(() {
      Subject = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadStudent();
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
    if (studentInfo == null) {
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
                icon: const Icon(Icons.notifications, color: Color(0xFF5F705C)),
                onPressed: _goToNotification,
              ),
            ),
            const SizedBox(width: 10),
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
                    "${studentInfo?.prefix} ${studentInfo?.firstname} ${studentInfo?.lastname}",
                    style: kanit(),
                  ),
                  Text("รหัสนิสิต : ${studentInfo?.studentId}", style: kanit()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard("📖 สาขา", "${studentInfo?.majorId}"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildInfoCard("✉️ อีเมล", "${studentInfo?.email}"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kanit(color: textDark)),
          Text(value, style: kanit(color: textDark)),
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
      child: DropdownSearch<StudentSubjectScore>(
        selectedItem: selectedSubject,

        // ✅ ใช้ object ทั้งก้อน (ไม่ต้อง map เป็น String)
        items: Subject?.where((s) => s.activeStatus == "active").toList() ?? [],

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
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(hintText: "ค้นหารายวิชา..."),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableSuggestions: false,
            autocorrect: false,
          ),
        ),

        // ✅ แสดงผลใน dropdown
        itemAsString: (s) => "${s.subjectId} ${s.subjectName}",

        // ✅ เวลาเลือก
        onChanged: (value) {
          setState(() {
            selectedSubject = value;
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

  void _onSearchPressed() {
    if (selectedSubject?.sendStatus == "1") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "ไม่สามารถค้นหาได้",
        desc: "คะแนนของรายวิชานี้ยังไม่ถูกส่งโดยอาจารย์ผู้สอน",
        btnOkText: "ตกลง",
        btnOkOnPress: () {},
      ).show();
      return;
    }else if(selectedSubject?.sendStatus == "2") {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: "ไม่สามารถค้นหาได้",
        desc: "คะแนนของรายวิชานี้ยังไม่ถูกส่งโดยอาจารย์ผู้สอน",
        btnOkText: "ตกลง",
        btnOkOnPress: () {},
      ).show();
      return;
    }
    else{


    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) =>  SummaryDashboardNisit(
        studentId: studentInfo?.studentId,
        sysSubjectNo: selectedSubject?.sysSubjectNo,
        subjectId: selectedSubject?.subjectId ?? "",
        subjectName: selectedSubject?.subjectName ?? "",
        year: yearController.text,
        semester: semesterController.text,
        section: sectionController.text,
        scoreType: selectedScore!,
      )),
    );}
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const SummaryDashboardNisit()),
    // );
  }

  void _onResetPressed() {
    subjectController.clear();
    yearController.clear();
    semesterController.clear();
    sectionController.clear();
    selectedSubject = null;
    sectionValue = null;
    semesterValue = null;
    yearValue = null;
    subjectValue = null;


    setState(() {
      selectedScore = "คะแนนทั้งหมด";
    });
  }
}
