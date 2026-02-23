import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryDashboardLecture extends StatefulWidget {
  const SummaryDashboardLecture({super.key});

  @override
  State<SummaryDashboardLecture> createState() =>
      _SummaryDashboardLectureState();
}

class _SummaryDashboardLectureState extends State<SummaryDashboardLecture> {
  final Color bgColor = const Color(0xFFF5F7EC);
  final Color headerColor = const Color(0xFF8FAE80);
  final Color contentAreaColor = const Color(0xFFE8EBD0);
  final Color cardColor = const Color(0xFFD2DCB6);
  final Color textColor = const Color(0xFF4A4E49);
  final Color subTextColor = const Color(0xFF656E62);

  String selectedScoreType = "คะแนนทั้งหมด";

  final List<String> scoreTypes = [
    "คะแนนทั้งหมด",
    "คะแนนเก็บ",
    "คะแนนกลางภาค",
    "คะแนนปลายภาค",
  ];

  int touchedIndex = -1;

  final List<double> scoreData = [10, 8, 7, 6, 5, 4, 3, 2];

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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFA1BC98),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_rounded,
            color: Color(0xFF4A4E49),
            size: 28,
          ),
          const SizedBox(width: 10),
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
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "📚 Computer Programming (01418113-65)",
                      style: GoogleFonts.kanit(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            "หมู่เรียน 870 | ภาคต้น | ปีการศึกษา 2568",
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: subTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildScoreDropdown()],
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
                "47",
                "จำนวนนิสิตของรายวิชานี้",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "📊 คะแนนเฉลี่ย",
                "71.63",
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
                "90",
                "คะแนนสูงสุดของรายวิชานี้",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                "🔽 คะแนนต่ำสุด",
                "53",
                "คะแนนต่ำสุดของรายวิชานี้",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChartCard() {
    final total = scoreData.reduce((a, b) => a + b);

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
                    sections: List.generate(scoreData.length, (index) {
                      final isTouched = index == touchedIndex;

                      return PieChartSectionData(
                        value: scoreData[index],
                        color: gradeColors[index],
                        radius: isTouched ? 75 : 65,
                        showTitle: false,
                      );
                    }),
                  ),
                ),

                if (touchedIndex != -1)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gradeLabels[touchedIndex],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.kanit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${((scoreData[touchedIndex] / total) * 100).toStringAsFixed(1)}%",
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "${scoreData[touchedIndex].toInt()} คน",
                        style: GoogleFonts.kanit(
                          fontSize: 13,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Legend
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
              fontSize: 34,
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
