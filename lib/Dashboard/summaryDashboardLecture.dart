import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/student.dart';
import 'package:score_management/apiservice/model/subjectScore.dart';

class SummaryDashboardLecture extends StatefulWidget {
  const SummaryDashboardLecture({
    super.key,
    required this.sysSubjectNo,
    required this.subjectId,
    required this.subjectName,
    required this.academicYear,
    required this.semester,
    required this.section,
    required this.scoreType,
  });

  final int? sysSubjectNo;
  final String subjectId;
  final String subjectName;
  final String academicYear;
  final String semester;
  final String section;
  final String scoreType;

  @override
  State<SummaryDashboardLecture> createState() =>
      _SummaryDashboardLectureState();
}

class _SummaryDashboardLectureState extends State<SummaryDashboardLecture> {
  Student? studentInfo;

  List<SubjectScore> scores = [];
  double totalScore = 0;
  double grade_score = 0;
  double averageScore = 0;
  double maxScore = 0;
  double minScore = 0;

  List<Map<String, String>> studentResults = [];

  final Color bgColor = const Color(0xFFF5F7EC);
  final Color headerColor = const Color(0xFF8FAE80);
  final Color contentAreaColor = const Color(0xFFE8EBD0);
  final Color cardColor = const Color(0xFFD2DCB6);
  final Color textColor = const Color(0xFF4A4E49);
  final Color subTextColor = const Color(0xFF656E62);

  String selectedScoreType = "";

  final List<String> scoreTypes = [
    "คะแนนทั้งหมด",
    "คะแนนเก็บ",
    "คะแนนกลางภาค",
    "คะแนนปลายภาค",
  ];

  int touchedIndex = -1;

  final Map<String, double> scoreData = {
    "A": 0,
    "B+": 0,
    "B": 0,
    "C+": 0,
    "C": 0,
    "D+": 0,
    "D": 0,
    "F": 0,
  };
  final gradeKeys = ["A", "B+", "B", "C+", "C", "D+", "D", "F"];
  final List<String> gradeLabels = [
    "A (80-100)",
    "B+ (75-79)",
    "B (70-74)",
    "C+ (65-69)",
    "C (60-64)",
    "D+ (55-59)",
    "D (50-54)",
    "F (<50)",
  ];

  final List<Color> gradeColors = [
    Color(0xFF2E7D32), // A
    Color(0xFF43A047), // B+
    Color(0xFF66BB6A), // B
    Color(0xFFFFB300), // C+
    Color(0xFFFFCA28), // C
    Color(0xFFFF7043), // D+
    Color(0xFFE53935), // D
    Color(0xFF8E0000), // F
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
    final gradeRanges = [
      (80, 100),
      (75, 79),
      (70, 74),
      (65, 69),
      (60, 64),
      (55, 59),
      (50, 54),
      (0, 49),
    ];

    scoreData.updateAll((key, value) => 0);

    if (selectedScoreType == "คะแนนทั้งหมด") {
      totalScore = scores.fold(
        0,
        (sum, score) =>
            sum +
            (score.accumulatedScore ?? 0) +
            (score.midtermScore ?? 0) +
            (score.finalScore ?? 0),
      );
      averageScore = scores.isNotEmpty ? totalScore / scores.length : 0;
      maxScore = scores.fold(0, (max, score) {
        final total =
            (score.accumulatedScore ?? 0) +
            (score.midtermScore ?? 0) +
            (score.finalScore ?? 0);
        return total > max ? total : max;
      });
      minScore = scores.fold(double.infinity, (min, score) {
        final total =
            (score.accumulatedScore ?? 0) +
            (score.midtermScore ?? 0) +
            (score.finalScore ?? 0);
        return total < min ? total : min;
      });
      for (var score in scores) {
        final total =
            (score.accumulatedScore ?? 0) +
            (score.midtermScore ?? 0) +
            (score.finalScore ?? 0);
        for (int i = 0; i < gradeRanges.length; i++) {
          final range = gradeRanges[i];
          if (total >= range.$1 && total <= range.$2) {
            scoreData[gradeKeys[i]] = (scoreData[gradeKeys[i]] ?? 0) + 1;
            break;
          }
        }
      }
    } else if (selectedScoreType == "คะแนนเก็บ") {
      totalScore = scores.fold(
        0,
        (sum, score) => sum + (score.accumulatedScore ?? 0),
      );
      averageScore = scores.isNotEmpty ? totalScore / scores.length : 0;
      maxScore = scores.fold(
        0,
        (max, score) =>
            (score.accumulatedScore ?? 0) > max
                ? (score.accumulatedScore ?? 0)
                : max,
      );
      minScore = scores.fold(
        double.infinity,
        (min, score) =>
            (score.accumulatedScore ?? 0) < min
                ? (score.accumulatedScore ?? 0)
                : min,
      );
      for (var score in scores) {
        final acc = score.accumulatedScore ?? 0;
        for (int i = 0; i < gradeRanges.length; i++) {
          if (acc >= gradeRanges[i].$1 && acc <= gradeRanges[i].$2) {
            scoreData[gradeKeys[i]] = (scoreData[gradeKeys[i]] ?? 0) + 1;
            break;
          }
        }
      }
    } else if (selectedScoreType == "คะแนนกลางภาค") {
      totalScore = scores.fold(
        0,
        (sum, score) => sum + (score.midtermScore ?? 0),
      );
      averageScore = scores.isNotEmpty ? totalScore / scores.length : 0;
      maxScore = scores.fold(
        0,
        (max, score) =>
            (score.midtermScore ?? 0) > max ? (score.midtermScore ?? 0) : max,
      );
      minScore = scores.fold(
        double.infinity,
        (min, score) =>
            (score.midtermScore ?? 0) < min ? (score.midtermScore ?? 0) : min,
      );
      for (var score in scores) {
        final mid = score.midtermScore ?? 0;
        for (int i = 0; i < gradeRanges.length; i++) {
          if (mid >= gradeRanges[i].$1 && mid <= gradeRanges[i].$2) {
            scoreData[gradeKeys[i]] = (scoreData[gradeKeys[i]] ?? 0) + 1;
            break;
          }
        }
      }
    } else if (selectedScoreType == "คะแนนปลายภาค") {
      totalScore = scores.fold(
        0,
        (sum, score) => sum + (score.finalScore ?? 0),
      );
      averageScore = scores.isNotEmpty ? totalScore / scores.length : 0;
      maxScore = scores.fold(
        0,
        (max, score) =>
            (score.finalScore ?? 0) > max ? (score.finalScore ?? 0) : max,
      );
      minScore = scores.fold(
        double.infinity,
        (min, score) =>
            (score.finalScore ?? 0) < min ? (score.finalScore ?? 0) : min,
      );
      for (var score in scores) {
        final fin = score.finalScore ?? 0;
        for (int i = 0; i < gradeRanges.length; i++) {
          if (fin >= gradeRanges[i].$1 && fin <= gradeRanges[i].$2) {
            scoreData[gradeKeys[i]] = (scoreData[gradeKeys[i]] ?? 0) + 1;
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        // ✅ เพิ่มตรงนี้
        child: Column(
          children: [
            // ❌ ลบตัวนี้ออก
            // const SizedBox(height: 50),
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
                      _buildStatisticsGrid(),
                      const SizedBox(height: 12),
                      _buildPieChartCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            "หมู่เรียน ${widget.section} | ${widget.semester} | ปีการศึกษา ${widget.academicYear}",
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

  Widget _buildPieChartCard() {
    final total = scoreData.values.fold(0.0, (a, b) => a + b);

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "ไม่มีข้อมูล",
            style: GoogleFonts.kanit(fontSize: 16, color: textColor),
          ),
        ),
      );
    }

    final visibleIndexes =
        List.generate(
          gradeKeys.length,
          (i) => i,
        ).where((i) => (scoreData[gradeKeys[i]] ?? 0) > 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📊 สัดส่วนเกรดของนิสิต",
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),

                    sections: List.generate(visibleIndexes.length, (i) {
                      final index = visibleIndexes[i];
                      final isTouched = i == touchedIndex;

                      return PieChartSectionData(
                        value: scoreData[gradeKeys[index]] ?? 0,
                        color: gradeColors[index],
                        radius: isTouched ? 75 : 65,
                        showTitle: false,
                      );
                    }),
                  ),
                ),

                if (touchedIndex != -1 && touchedIndex < visibleIndexes.length)
                  Builder(
                    builder: (_) {
                      final realIndex = visibleIndexes[touchedIndex];
                      final value = scoreData[gradeKeys[realIndex]] ?? 0;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            gradeLabels[realIndex],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.kanit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${((value / total) * 100).toStringAsFixed(1)}%",
                            style: GoogleFonts.kanit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "${value.toInt()} คน",
                            style: GoogleFonts.kanit(
                              fontSize: 13,
                              color: subTextColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(
              gradeLabels.length,
              (index) =>
                  _buildLegendItem(gradeColors[index], gradeLabels[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.kanit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
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
