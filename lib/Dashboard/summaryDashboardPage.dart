import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryDashboardPage extends StatefulWidget {
  const SummaryDashboardPage({super.key});

  @override
  State<SummaryDashboardPage> createState() => _SummaryDashboardPageState();
}

class _SummaryDashboardPageState extends State<SummaryDashboardPage> {
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
              _buildBigScoreItem("82", "คะแนนของฉันในรายวิชานี้"),
              _buildBigScoreItem("100", "คะแนนเต็มในรายวิชานี้"),
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

  Widget _buildBigScoreItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.kanit(
            fontSize: 48,
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
