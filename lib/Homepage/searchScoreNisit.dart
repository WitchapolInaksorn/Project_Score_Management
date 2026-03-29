import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/SubjectScoreRequest.dart';

class SearchScoreNisit extends StatefulWidget {
  final String? studentId;
  final int? sysSubjectNo;
  final String? subjectId;
  final String? subjectName;
  final String? year;
  final String? semester;
  final String? section;

  const SearchScoreNisit({
    super.key,
    required this.studentId,
    required this.sysSubjectNo,
    required this.subjectId,
    required this.subjectName,
    required this.year,
    required this.semester,
    required this.section,
  });

  @override
  State<SearchScoreNisit> createState() => _SearchScoreNisitState();
}

class _SearchScoreNisitState extends State<SearchScoreNisit> {
  final List<Map<String, dynamic>> searchResults = [
    {
      "subject": "",
      "code": "",
      "semester": "",
      "year": "",
      "section": "",
      "scores": [
        {"label": "กลางภาค", "score": "0", "color": const Color(0xFFF4C430)},
        {"label": "คะแนนเก็บ", "score": "0", "color": const Color(0xFF49AF6B)},
        {"label": "ปลายภาค", "score": "0", "color": const Color(0xFFFF6B6B)},
        {"label": "รวม", "score": "0", "color": const Color(0xFF63A2FF)},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchScoreData();
    loadscore();
  }

  void _fetchScoreData() {
    setState(() {
      searchResults[0]['subject'] = widget.subjectName ?? "ไม่พบข้อมูล";
      searchResults[0]['code'] = widget.subjectId ?? "ไม่พบข้อมูล";
      searchResults[0]['semester'] = widget.semester ?? "ไม่พบข้อมูล";
      searchResults[0]['year'] = widget.year ?? "ไม่พบข้อมูล";
      searchResults[0]['section'] = widget.section ?? "ไม่พบข้อมูล";
    });
  }

  Future<void> loadscore() async {
    final result = await StudentService.getStudentScore(
      SubjectScoreRequest(
        sysSubjectNo: widget.sysSubjectNo ?? 0,
        studentId: widget.studentId ?? "",
      ),
    );

    if (result.isEmpty) return;

    final score = result.first;

    setState(() {
      searchResults[0]['scores'][0]['score'] =
          score.midtermScore?.toString() ?? "0";
      searchResults[0]['scores'][1]['score'] =
          score.accumulatedScore?.toString() ?? "0";
      searchResults[0]['scores'][2]['score'] =
          score.finalScore?.toString() ?? "0";

      final total =
          (score.midtermScore ?? 0) +
          (score.accumulatedScore ?? 0) +
          (score.finalScore ?? 0);

      searchResults[0]['scores'][3]['score'] = total.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7EC),
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildHeader(),
          Expanded(child: _buildResultList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5), // 👈 ใช้แบบเดียวกับ Notification
      decoration: const BoxDecoration(
        color: Color(0xFFA1BC98),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4E49)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          const SizedBox(width: 4),

          Text(
            "ค้นหาข้อมูลคะแนน",
            style: GoogleFonts.kanit(
              color: const Color(0xFF4A4E49),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Color(0xFFE8EBD0),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return _buildScoreCard(searchResults[index]);
        },
      ),
    );
  }

  Widget _buildScoreCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD2DCB6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2, right: 8),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF4A4E49),
                  size: 20,
                ),
              ),
              // ใช้ Expanded เพื่อให้ Column มีพื้นที่จำกัด ไม่ดันจนหลุดขอบ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ใช้ Wrap แทน Row เพื่อให้รหัสวิชาตัดขึ้นบรรทัดใหม่ได้ถ้าชื่อวิชายาวเกิน
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8, // ระยะห่างแนวนอน
                      runSpacing: 4, // ระยะห่างแนวตั้งกรณีตัดบรรทัด
                      children: [
                        Text(
                          data['subject'],
                          style: GoogleFonts.kanit(
                            color: const Color(0xFF4A4E49),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA1BC98),
                            borderRadius: BorderRadius.circular(500),
                          ),
                          child: Text(
                            data['code'],
                            style: GoogleFonts.kanit(
                              color: const Color(0xFF4A4E49),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "หมู่เรียน ${data['section']} | ${data['semester']} | ปีการศึกษา ${data['year']}",
                      style: GoogleFonts.kanit(
                        fontSize: 12,
                        color: const Color(0xFF656E62),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFA1BC98), thickness: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                (data['scores'] as List).map<Widget>((scoreItem) {
                  return _buildScoreItem(
                    scoreItem['label'],
                    scoreItem['score'],
                    scoreItem['color'],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String score, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.kanit(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4A4E49),
              shadows: [
                const Shadow(
                  blurRadius: 2.0,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          score,
          style: GoogleFonts.kanit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A4E49),
          ),
        ),
      ],
    );
  }
}
