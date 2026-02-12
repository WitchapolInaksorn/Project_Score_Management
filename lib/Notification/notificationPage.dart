import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notificationpage extends StatefulWidget {
  const Notificationpage({super.key});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  // =======================
  // Mock Notification Data
  // =======================
  final List<Map<String, dynamic>> notifications = [
    {
      "subject": "Computer Programming",
      "code": "01418113-65",
      "message": "อาจารย์ได้ประกาศคะแนนของคุณเรียบร้อยแล้ว",
      "section": "870",
      "semester": "ภาคต้น",
      "year": "2568",
      "date": "17/10/67 14:23",
      "tags": ["กลางภาค", "คะแนนเก็บ", "ปลายภาค"],
      "tagColors": [Color(0xFFF4C430), Color(0xFF49AF6B), Color(0xFFFF6B6B)],
    },
    {
      "subject": "Computer Programming ",
      "code": "01418113-65",
      "message": "อาจารย์ได้ประกาศคะแนนของคุณเรียบร้อยแล้ว",
      "section": "880",
      "semester": "ภาคต้น",
      "year": "2568",
      "date": "27/09/67 19:10",
      "tags": ["กลางภาค", "คะแนนเก็บ"],
      "tagColors": [Color(0xFFF4C430), Color(0xFF49AF6B)],
    },
    {
      "subject": "Computer Programming",
      "code": "01418113-65",
      "message": "อาจารย์ได้ประกาศคะแนนของคุณเรียบร้อยแล้ว",
      "section": "870",
      "semester": "ภาคต้น",
      "year": "2568",
      "date": "17/04/67 15:45",
      "tags": ["กลางภาค"],
      "tagColors": [Color(0xFFF4C430)],
    },
    {
      "subject": "Computer Programming",
      "code": "01418113-65",
      "message": "อาจารย์ได้ประกาศคะแนนของคุณเรียบร้อยแล้ว",
      "section": "880",
      "semester": "ภาคต้น",
      "year": "2568",
      "date": "15/04/67 16:30",
      "tags": ["กลางภาค"],
      "tagColors": [Color(0xFFF4C430)],
    },
  ];

  // =======================
  // Main Build
  // =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7EC),
      body: Column(
        children: [
          const SizedBox(height: 50),
          _buildHeader(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  // =======================
  // Header
  // =======================
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Color(0xFFA1BC98),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFF4A4E49)),
              const SizedBox(width: 8),
              Text(
                "การแจ้งเตือน",
                style: GoogleFonts.kanit(
                  color: const Color(0xFF4A4E49),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "ลบทิ้งหมด",
              style: GoogleFonts.kanit(
                color: const Color(0xFF4A4E49),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  // Notification List
  // =======================
  Widget _buildNotificationList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Color(0xFFE8EBD0)),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return _buildNotificationCard(notifications[index]);
        },
      ),
    );
  }

  // =======================
  // Notification Card
  // =======================
  Widget _buildNotificationCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFD2DCB6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(data),
                      const SizedBox(height: 5),
                      _buildTags(data),
                      const SizedBox(height: 5),
                      _buildMessage(data),
                      _buildFooterInfo(data),
                      const SizedBox(height: 5),
                      _buildDate(data),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  // =======================
  // Sub Widgets
  // =======================

  Widget _buildTitle(Map<String, dynamic> data) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "📚 ${data['subject']}  ",
            style: GoogleFonts.kanit(
              color: const Color(0xFF4A4E49),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFA1BC98),
                borderRadius: BorderRadius.circular(500),
              ),
              child: Text(
                data['code'],
                style: GoogleFonts.kanit(
                  color: const Color(0xFF4A4E49),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(Map<String, dynamic> data) {
    return Wrap(
      spacing: 3,
      children: List.generate(data['tags'].length, (index) {
        return _buildTag(data['tags'][index], data['tagColors'][index]);
      }),
    );
  }

  Widget _buildMessage(Map<String, dynamic> data) {
    return Text(
      data['message'],
      style: GoogleFonts.kanit(
        fontSize: 14,
        color: const Color(0xFF4A4E49),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFooterInfo(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "หมู่เรียน ${data['section']} | ${data['semester']} | ปีการศึกษา ${data['year']}",
            style: GoogleFonts.kanit(
              fontSize: 12,
              color: const Color(0xFF656E62),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildDate(Map<String, dynamic> data) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        data['date'],
        style: GoogleFonts.kanit(
          fontSize: 12,
          color: const Color(0xFF656E62),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 3,
      right: 9,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1F3E0),
          ),
          child: Text(
            'X',
            style: GoogleFonts.kanit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A4E49),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(500),
      ),
      child: Text(
        text,
        style: GoogleFonts.kanit(
          fontSize: 13,
          color: const Color(0xFF4A4E49),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
