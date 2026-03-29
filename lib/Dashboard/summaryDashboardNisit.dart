import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/SubjectScoreRequest.dart';
import 'package:score_management/apiservice/model/subjectScore.dart';
import 'package:score_management/apiservice/model/student.dart';

class SummaryDashboardNisit extends StatefulWidget {
  final String? studentId;
  final int? sysSubjectNo;
  final String? subjectId;
  final String? subjectName;
  final String? year;
  final String? semester;
  final String? section;
  final String scoreType;

  const SummaryDashboardNisit({
    super.key,
    required this.studentId,
    required this.sysSubjectNo,
    required this.subjectId,
    required this.subjectName,
    required this.year,
    required this.semester,
    required this.section,
    required this.scoreType,
  });

  @override
  State<SummaryDashboardNisit> createState() => _SummaryDashboardNisitState();
}

class _SummaryDashboardNisitState extends State<SummaryDashboardNisit> {
  final Color bgColor = const Color(0xFFF5F7EC);
  final Color headerColor = const Color(0xFF8FAE80);
  final Color contentAreaColor = const Color(0xFFE8EBD0);
  final Color cardColor = const Color(0xFFD2DCB6);
  final Color textColor = const Color(0xFF4A4E49);
  final Color subTextColor = const Color(0xFF656E62);

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

  Student? studentInfo;

  List<SubjectScore> scores = [];
  double totalScore = 0;
  double grade_score = 0;
  double averageScore = 0;
  double maxScore = 0;
  double minScore = 0;
  double selfTotalScore = 0;
  int rank = 0;

  List<Map<String, String>> studentResults = [];

  String selectedScoreType = "";

  final List<String> scoreTypes = [
    "คะแนนทั้งหมด",
    "คะแนนเก็บ",
    "คะแนนกลางภาค",
    "คะแนนปลายภาค",
  ];

  @override
  void initState() {
    super.initState();
    // filteredResults = List.from(studentResults);

    loadScores();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadStudentScore() async {
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

      selfTotalScore =
          (score.midtermScore ?? 0) +
          (score.accumulatedScore ?? 0) +
          (score.finalScore ?? 0);

      searchResults[0]['scores'][3]['score'] = selfTotalScore.toString();
    });
  }

  Future<void> loadScores() async {
    selectedScoreType = widget.scoreType;
    final result = await StudentService.getScoreBySubjectNo(
      widget.sysSubjectNo!,
    );

    setState(() {
      scores = result;
      _setScore();
    });

    if (scores.isNotEmpty) {
      final List<Map<String, String>> results = [];
      for (var score in scores) {
        studentInfo = await StudentService.getStudentById(
          score.studentId ?? "",
        );
        results.add({
          "id": (score.seatNo ?? 0).toString().padLeft(3, '0'),
          "name":
              "${studentInfo?.firstname ?? ''} ${studentInfo?.lastname ?? ''}",
          "studentId": score.studentId ?? "",
        });
      }
      setState(() {
        studentResults = results;
      });
    }
  }

  void _setScore() {
    if (scores.isEmpty) {
      totalScore = 0;
      averageScore = 0;
      maxScore = 0;
      minScore = 0;
      rank = 0;
      return;
    }

    double getScore(SubjectScore s) {
      switch (selectedScoreType) {
        case "คะแนนทั้งหมด":
          return (s.accumulatedScore ?? 0) +
              (s.midtermScore ?? 0) +
              (s.finalScore ?? 0);
        case "คะแนนเก็บ":
          return s.accumulatedScore ?? 0;
        case "คะแนนกลางภาค":
          return s.midtermScore ?? 0;
        case "คะแนนปลายภาค":
          return s.finalScore ?? 0;
        default:
          return 0;
      }
    }

    totalScore = scores.fold(0, (sum, s) => sum + getScore(s));
    averageScore = totalScore / scores.length;

    maxScore = scores.map((s) => getScore(s)).reduce((a, b) => a > b ? a : b);

    minScore = scores.map((s) => getScore(s)).reduce((a, b) => a < b ? a : b);

    final sorted = [...scores];
    sorted.sort((a, b) => getScore(b).compareTo(getScore(a)));

    final myScoreObj = sorted.firstWhere(
      (s) => s.studentId == widget.studentId,
    );

    final myScore = getScore(myScoreObj);

    rank = sorted.indexWhere((s) => getScore(s) == myScore) + 1;
    selfTotalScore = myScore;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          const SizedBox(height: 50),

          _buildHeader(),

          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFE8EBD0),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSubjectInfoCard(),
                    const SizedBox(height: 12),
                    _buildMyScoreCard(),
                    const SizedBox(height: 12),
                    _buildStatisticsGrid(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
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
            "ภาพรวมคะแนนรายวิชา",
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

  Widget _buildSubjectInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // ปรับให้ชิดบน
            children: [
              // 1. ส่วนของชื่อวิชา - ใช้ Expanded เพื่อป้องกัน Overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📚 ${widget.subjectName}",
                      style: GoogleFonts.kanit(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "(${widget.subjectId})",
                      style: GoogleFonts.kanit(
                        color: subTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 2. Dropdown - แยกออกมาให้ชัดเจน
              _buildScoreDropdown(),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: textColor.withOpacity(0.1),
            thickness: 1,
          ), // เพิ่มเส้นคั่นบางๆ
          const SizedBox(height: 8),
          Text(
            "หมู่เรียน ${widget.section} | ${widget.semester} | ปีการศึกษา ${widget.year}",
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF9FB88E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedScoreType,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          style: GoogleFonts.kanit(
            color: const Color(0xFF4A4E49),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: Colors.white,
          items:
              scoreTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              selectedScoreType = value!;
              _setScore();
            });
          },
        ),
      ),
    );
  }

  Widget _buildMyScoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "🎯 คะแนนของฉัน",
                style: GoogleFonts.kanit(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBigScoreItem(
                "${rank == 0 ? "ไม่มีคะแนน" : rank.toString()}",
                "ลำดับของฉันในรายวิชานี้",
              ),
              _buildBigScoreItem(
                "${selfTotalScore == 0 ? "ไม่มีคะแนน" : selfTotalScore.toStringAsFixed(2)}",
                "คะแนนของฉันในรายวิชานี้",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "👥 จำนวนนิสิต",
                "${scores.length}",
                "จำนวนนิสิตของรายวิชานี้",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "📊 คะแนนเฉลี่ย",
                "${averageScore == 0 ? "ไม่มีคะแนน" : averageScore.toStringAsFixed(2)}",
                "คะแนนเฉลี่ยของรายวิชานี้",
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "🔼️ คะแนนสูงสุด",
                "${maxScore == 0 ? "ไม่มีคะแนน" : maxScore.toStringAsFixed(2)}",
                "คะแนนสูงสุดของรายวิชานี้",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "🔽 คะแนนต่ำสุด",
                "${minScore == 0 ? "ไม่มีคะแนน" : minScore.toStringAsFixed(2)}",
                "คะแนนต่ำสุดของรายวิชานี้",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBigScoreItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kanit(
            fontSize: 12,
            color: subTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Align(
            alignment: const Alignment(-0.8, 0),
            child: Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: GoogleFonts.kanit(
              fontSize: value == "ไม่มีคะแนน" ? 20 : 34,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
