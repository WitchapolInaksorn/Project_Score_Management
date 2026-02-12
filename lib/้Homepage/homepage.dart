import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // ================= COLORS =================
  static const primary = Color(0xFFA1BC98);
  static const secondary = Color(0xFFD2DCB6);
  static const light = Color(0xFFF1F3E0);
  static const textDark = Color(0xFF4F5F52);
  static const textSoft = Color(0xFF778873);

  // ================= TEXT STYLE =================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Center(child: _buildSearchForm()),
            ),
          ),

          _buildBottomNav(),
        ],
      ),
    );
  }

  // ================= HEADER =================
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
          const SizedBox(height: 10),
          _buildGreeting(),
          const SizedBox(height: 15),
          _buildProfileCard(),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ).copyWith(height: 1.0),
            ),
            SizedBox(height: 5),
            Text(
              "ขอให้วันนี้เป็นวันที่ดีนะ 😊",
              style: kanit(size: 16, weight: FontWeight.w400, color: light),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundColor: Color(0xFFD9D9D9),
          child: Icon(Icons.notifications, color: Color(0xFF383838)),
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
                    "นาย วิชญ์พล อินทร์อักษร",
                    style: kanit(weight: FontWeight.w500),
                  ),
                  Text(
                    "รหัสนิสิต : 6530250476",
                    style: kanit(weight: FontWeight.w500),
                  ),
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

  // ================= SEARCH FORM =================
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
            "🔎 ค้นหาข้อมูลคะแนน",
            style: kanit(size: 20, weight: FontWeight.w500, color: textSoft),
          ),
          const SizedBox(height: 20),
          ...[
            "📚 รหัสรายวิชา / ชื่อรายวิชา",
            "🗓️ ปีการศึกษา",
            "🎒 ภาคเรียน",
            "🎓 หมู่เรียน",
          ].map(
            (hint) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTextField(hint),
            ),
          ),
          const SizedBox(height: 10),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: light,
        hintText: hint,
        hintStyle: kanit(color: textSoft),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildButton("🔍 ค้นหา", const Color(0xFF8FAF8A))),
        const SizedBox(width: 15),
        Expanded(child: _buildButton("🔄 รีเซ็ต", primary)),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: kanit(color: textDark, weight: FontWeight.w600)),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: const [
          Expanded(child: _NavButton(icon: Icons.home, text: "Homepage")),
          SizedBox(width: 15),
          Expanded(
            child: _NavButton(
              icon: Icons.assignment_outlined,
              text: "Dashboard",
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NavButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF778873), size: 34),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.kanit(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF778873),
            ),
          ),
        ],
      ),
    );
  }
}
