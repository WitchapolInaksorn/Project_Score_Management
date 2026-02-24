import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

// --- Constants & Styles ---
const kPrimaryColor = Color(0xFFA1BC98);
const kSecondaryColor = Color(0xFFD2DCB6);
const kAccentColor = Color(0xFF94AF86);
const kBackgroundColor = Color(0xFFF5F7EC);
const kSurfaceColor = Color(0xFFE8EBD0);
const kTextColor = Color(0xFF4A4E49);
const kSubTextColor = Color(0xFF667A66);

class SearchScoreLecture extends StatefulWidget {
  const SearchScoreLecture({super.key});

  @override
  State<SearchScoreLecture> createState() => _SearchScoreLectureState();
}

class _SearchScoreLectureState extends State<SearchScoreLecture> {
  // 🔹 State variables: สำหรับจัดการข้อมูลในหน้า UI
  late ConfettiController _confettiController;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  final List<Map<String, String>> studentResults = [
    {"id": "001", "name": "นาย พัสกร ธีระรุจินันท์", "studentId": "6530250573"},
    {"id": "002", "name": "นาย วิชญ์พล อินทร์อักษร", "studentId": "6530250476"},
    {"id": "003", "name": "นาย ธนวัฒน์ ศรีสุวรรณ", "studentId": "6530250488"},
    {"id": "004", "name": "นาย พิชิตชัย ศรีสุวรรณ", "studentId": "6530250499"},
    {"id": "005", "name": "นาย ธนภัทร ศรีสุวรรณ", "studentId": "6530250500"},
    {"id": "006", "name": "นาย ธนวัฒน์ ศรีสุวรรณ", "studentId": "6530250501"},
    {"id": "007", "name": "นาย พิชิตชัย ศรีสุวรรณ", "studentId": "6530250502"},
    {"id": "008", "name": "นาย ธนภัทร ศรีสุวรรณ", "studentId": "6530250503"},
  ];

  List<Map<String, String>> filteredResults = [];

  // 🔹 Lifecycle (initState / dispose): จัดการทรัพยากรเมื่อ Widget เกิดและดับไป
  @override
  void initState() {
    super.initState();
    filteredResults = List.from(studentResults);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    nameController.dispose();
    studentIdController.dispose();
    super.dispose();
  }

  // 🔹 Action / Logic functions: ส่วนคำนวณและการทำงานเบื้องหลัง
  void _searchStudent() {
    final nameQuery = nameController.text.trim().toLowerCase();
    final idQuery = studentIdController.text.trim().toLowerCase();

    setState(() {
      filteredResults =
          studentResults.where((student) {
            final matchName = student["name"]!.toLowerCase().contains(
              nameQuery,
            );
            final matchId = student["studentId"]!.toLowerCase().contains(
              idQuery,
            );
            return matchName && matchId;
          }).toList();
    });
  }

  void _resetSearch() {
    nameController.clear();
    studentIdController.clear();
    setState(() => filteredResults = List.from(studentResults));
  }

  // 🔹 Build method: โครงสร้างหลักของหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 5),
            _buildHeader(),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  // ส่วนหัวของหน้าจอ
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: kTextColor, size: 28),
          const SizedBox(width: 10),
          Text(
            "ค้นหาข้อมูลคะแนน",
            style: GoogleFonts.kanit(
              color: kTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // พื้นที่เนื้อหาหลัก
  Widget _buildMainContent() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: LayoutBuilder(
        builder:
            (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    _buildSearchForm(),
                    const SizedBox(height: 10),
                    _buildStudentListContainer(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  // ฟอร์มกรอกข้อมูลค้นหา
  Widget _buildSearchForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: nameController,
                  hint: "👤 ชื่อ-นามสกุล",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  controller: studentIdController,
                  hint: "🆔 รหัสนิสิต",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton("🔍 ค้นหา", kAccentColor, _searchStudent),
              const SizedBox(width: 50),
              _buildActionButton("🔄 รีเซ็ต", kPrimaryColor, _resetSearch),
            ],
          ),
        ],
      ),
    );
  }

  // ส่วนแสดงรายชื่อนิสิต
  Widget _buildStudentListContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSubjectHeader(),
          if (filteredResults.isEmpty) _buildEmptyState() else _buildListView(),
        ],
      ),
    );
  }

  // หัวข้อรายวิชา
  Widget _buildSubjectHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "📚 Computer Programming",
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: kTextColor,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "01418113-65",
                style: GoogleFonts.kanit(
                  fontSize: 12,
                  color: kTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            "หมู่เรียน 870 | ภาคต้น | ปีการศึกษา 2568",
            style: GoogleFonts.kanit(
              fontSize: 11,
              color: const Color(0xFF656E62),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Divider(color: kPrimaryColor, thickness: 1, height: 1),
      ],
    );
  }

  // รายการนิสิตแต่ละแถว
  Widget _buildListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredResults.length,
      separatorBuilder:
          (_, __) =>
              const Divider(color: kPrimaryColor, thickness: 1, height: 5),
      itemBuilder: (_, index) => _buildStudentItem(filteredResults[index]),
    );
  }

  Widget _buildStudentItem(Map<String, String> student) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            student["id"]!,
            style: GoogleFonts.kanit(
              fontSize: 18,
              color: kSubTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student["name"]!,
                  style: GoogleFonts.kanit(
                    fontSize: 15,
                    color: kSubTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "รหัสนิสิต : ${student["studentId"]}",
                  style: GoogleFonts.kanit(
                    fontSize: 14,
                    color: kSubTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildViewScoreButton(student),
        ],
      ),
    );
  }

  // 🔹 Dialog / Bottom Sheet: ส่วนแสดงผลข้อมูลคะแนนแบบ Overlay
  void _showScoreDialog(Map<String, String> student) {
    final List<Map<String, dynamic>> scores = [
      {"label": "กลางภาค", "score": 22, "color": const Color(0xFFF4C430)},
      {"label": "คะแนนเก็บ", "score": 35, "color": const Color(0xFF49AF6B)},
      {"label": "ปลายภาค", "score": 25, "color": const Color(0xFFFF6B6B)},
      {"label": "รวม", "score": 82, "color": const Color(0xFF63A2FF)},
    ];

    final totalScore = scores.fold<int>(
      0,
      (sum, item) => sum + (item["score"] as int),
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black12,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        Future.delayed(
          const Duration(milliseconds: 300),
          () => _confettiController.play(),
        );
        return Align(
          alignment: Alignment.bottomCenter,
          child: _buildSuperSheet(student, scores, totalScore),
        );
      },
      transitionBuilder:
          (_, animation, __, child) => SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
    );
  }

  Widget _buildSuperSheet(
    Map<String, String> student,
    List<Map<String, dynamic>> scores,
    int totalScore,
  ) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: const BoxDecoration(color: kBackgroundColor),
          child: Stack(
            children: [
              _buildAnimatedBackground(),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDragHandle(),
                    const SizedBox(height: 10),
                    Text(
                      "คะแนนนิสิต",
                      style: GoogleFonts.kanit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      student["name"]!,
                      style: GoogleFonts.kanit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      "รหัสนิสิต : ${student["studentId"]}",
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: kTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildScoreRow(scores),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Animated Background: เลเยอร์เอฟเฟกต์ Confetti
  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: IgnorePointer(
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 25,
          gravity: 0.3,
        ),
      ),
    );
  }

  // --- Widgets ย่อยอื่นๆ ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        style: GoogleFonts.kanit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: kSubTextColor,
        ),
        decoration: InputDecoration(
          labelText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: GoogleFonts.kanit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kSubTextColor,
          ),
          filled: true,
          fillColor: const Color(0xFFF1F3E0),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3F4F45),
          ),
        ),
      ),
    );
  }

  Widget _buildViewScoreButton(Map<String, String> student) {
    return InkWell(
      onTap: () => _showScoreDialog(student),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF8FAF8A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "📊 ดูคะแนน",
          style: GoogleFonts.kanit(
            fontSize: 14,
            color: const Color(0xFF3F4F45),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "ไม่พบข้อมูล",
        style: GoogleFonts.kanit(fontSize: 14, color: kTextColor),
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      onTap: () {
        _confettiController.stop();
        Navigator.pop(context);
      },
      child: Container(
        width: 50,
        height: 6,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: kTextColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildScoreRow(List<Map<String, dynamic>> scores) {
    // แยก 3 คะแนนแรก
    final normalScores = scores.where((e) => e["label"] != "รวม").toList();

    // หาคะแนนรวม
    final totalScore = scores.firstWhere((e) => e["label"] == "รวม");

    return Column(
      children: [
        Row(
          children:
              normalScores
                  .map(
                    (item) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: item["color"],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item["label"],
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${item["score"]}",
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),

        const SizedBox(height: 10),

        Container(
          width: 150,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: totalScore["color"],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                totalScore["label"],
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "${totalScore["score"]}",
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
