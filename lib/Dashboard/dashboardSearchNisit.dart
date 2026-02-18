import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/Dashboard/summaryDashboardPageNisit.dart';
import 'package:score_management/Notify/notificationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:score_management/Authentication/loginPage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const primary = Color(0xFFA1BC98);
  static const secondary = Color(0xFFD2DCB6);
  static const light = Color(0xFFF1F3E0);
  static const textDark = Color(0xFF4F5F52);
  static const textSoft = Color(0xFF778873);

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
                  Text("นาย วิชญ์พล อินทร์อักษร", style: kanit()),
                  Text("รหัสนิสิต : 6530250476", style: kanit()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildInfoCard("📖 สาขา", "S06")),
              const SizedBox(width: 10),
              Expanded(child: _buildInfoCard("✉️ อีเมล", "witphon.i@ku.th")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          _buildTextField("📚 รหัสรายวิชา / ชื่อรายวิชา", subjectController),
          _buildTextField("🗓️ ปีการศึกษา", yearController),
          _buildTextField("🎒 ภาคเรียน", semesterController),
          _buildTextField("🎓 หมู่เรียน", sectionController),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SummaryDashboardPage()),
    );
  }

  void _onResetPressed() {
    subjectController.clear();
    yearController.clear();
    semesterController.clear();
    sectionController.clear();

    setState(() {
      selectedScore = "คะแนนทั้งหมด";
    });
  }
}
