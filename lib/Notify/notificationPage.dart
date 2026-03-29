import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/apiservice/apiservice.dart';
import 'package:score_management/apiservice/model/StudentNotification.dart';
import 'package:score_management/signalr_service/signalr_service.dart';

class Notificationpage extends StatefulWidget {
  final String studentId;
  const Notificationpage({super.key, required this.studentId});

  @override
  State<Notificationpage> createState() => _NotificationpageState();
}

class _NotificationpageState extends State<Notificationpage> {
  List<Map<String, dynamic>> notifications = [];

  // SignalRService? signalRService;

  void _clearAllNotifications() async {
    if (notifications.isEmpty) return;

    try {
      await StudentService.deleteAllNotification(widget.studentId);

      setState(() {
        notifications.clear();
      });
    } catch (e) {
      print("ลบทั้งหมด error: $e");
    }
  }

  @override
  void dispose() {
    SignalRService().removeListener(_listener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadNotifications();
    // setupSignalR();
    setupListener();
  }

  late Function(dynamic) _listener;

  void setupListener() {
    final service = SignalRService();

    _listener = (data) {
      if (!mounted) return;

      final subjectId = data['subjectId'];
      DateTime newDate = DateTime.parse(data['sendTime']);

      // เตรียมข้อมูลใหม่
      final semesterMap = {"1": "ภาคต้น", "2": "ภาคปลาย", "3": "ภาคฤดูร้อน"};
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
      final yearMap = {
        "1": "2564",
        "2": "2565",
        "3": "2566",
        "4": "2567",
        "5": "2568",
      };

      final newItem = {
        "key": "${subjectId}_${data['sendTime']}",
        "subject":
            data['subject_name'] ?? data['subjectName'] ?? "ไม่ระบุชื่อวิชา",
        "code": subjectId,
        "section": sectionMap[data['section'].toString()] ?? data['section'],
        "semester":
            semesterMap[data['semester'].toString()] ?? data['semester'],
        "year":
            yearMap[data['academicYear'].toString()] ??
            data['academicYear'].toString(),
        "message": data['sendDesc'],
        "date": "${newDate.day}/${newDate.month}/${newDate.year}",
        "dateObj": newDate,
      };

      setState(() {
        // ✅ หาตำแหน่งของวิชาเดิมใน List
        final existingIndex = notifications.indexWhere(
          (item) => item["code"] == subjectId,
        );

        if (existingIndex != -1) {
          // ถ้ามีอยู่แล้ว ให้เช็คว่าตัวใหม่ที่ส่งมา "ใหม่กว่า" ของเดิมที่มีในหน้าจอไหม
          if (newDate.isAfter(notifications[existingIndex]['dateObj'])) {
            notifications.removeAt(existingIndex); // เอาตัวเก่าออก
            notifications.insert(0, newItem); // ใส่ตัวใหม่เข้าข้างบนสุด
          }
        } else {
          // ถ้าเป็นวิชาใหม่ที่ยังไม่มีในหน้าจอเลย
          notifications = [newItem, ...notifications];
        }
        sortNotifications();
      });
    };

    service.addListener(_listener);
  }
  // void setupSignalR() async {
  //   final service = SignalRService();

  //   await service.connect(
  //     studentId: widget.studentId,
  //     onReceive: (data) {
  //       print("🔥 Received notification: $data");
  //       if (!mounted) return;

  //       DateTime date = DateTime.parse(data['sendTime']);

  //       final semesterMap = {"1": "ภาคต้น", "2": "ภาคปลาย", "3": "ภาคฤดูร้อน"};
  //       final sectionMap = {
  //         "1": "800",
  //         "2": "801",
  //         "3": "802",
  //         "4": "803",
  //         "5": "830",
  //         "6": "831",
  //         "7": "850",
  //         "8": "851",
  //         "9": "870",
  //         "10": "880",
  //         "11": "881",
  //       };

  //       final yearMap = {
  //         "1": "2564",
  //         "2": "2565",
  //         "3": "2566",
  //         "4": "2567",
  //         "5": "2568",
  //       };

  //       setState(() {
  //         final newItem = {
  //           "subject":
  //               data['subject_name'] ??
  //               data['subjectName'] ??
  //               "ไม่ระบุชื่อวิชา",
  //           "code": data['subjectId'],

  //           "section":
  //               sectionMap[data['section'].toString()] ?? data['section'],
  //           "semester":
  //               semesterMap[data['semester'].toString()] ?? data['semester'],

  //           "year":
  //               yearMap[data['academicYear'].toString()] ??
  //               data['academicYear'].toString(),

  //           "message": data['sendDesc'],
  //           "date": "${date.day}/${date.month}/${date.year}",
  //           "dateObj": date,
  //         };

  //         notifications = [newItem, ...notifications];
  //         sortNotifications();
  //       });
  //     },
  //   );

  //   signalRService = service;
  // }

  Future<void> loadNotifications() async {
    try {
      final List<StudentNotification> data =
          await StudentService.getStudentNotification(widget.studentId);

      final semesterMap = {"1": "ภาคต้น", "2": "ภาคปลาย", "3": "ภาคฤดูร้อน"};
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
      final yearMap = {
        "1": "2564",
        "2": "2565",
        "3": "2566",
        "4": "2567",
        "5": "2568",
      };

      // ✅ ใช้ Map เพื่อดึงเฉพาะรายการล่าสุดของแต่ละวิชา
      final Map<String, Map<String, dynamic>> latestMap = {};

      for (var item in data) {
        final subjectId = item.subjectId;
        final sendTime = item.sendTime;

        // ถ้ายังไม่มีวิชานี้ใน Map หรือรายการที่กำลังอ่านอยู่ 'ใหม่กว่า' ที่มีอยู่เดิม
        if (!latestMap.containsKey(subjectId) ||
            sendTime.isAfter(latestMap[subjectId]!['dateObj'])) {
          bool isSuccess = item.sendStatus == "success";
          final uniqueKey =
              "${item.subjectId}_${item.sendTime.toIso8601String()}";

          latestMap[subjectId] = {
            "key": uniqueKey,
            "subject": item.subjectName,
            "code": item.subjectId,
            "section": sectionMap[item.section.toString()] ?? item.section,
            "semester": semesterMap[item.semester.toString()] ?? item.semester,
            "year": yearMap[item.academicYear.toString()] ?? item.academicYear,
            "tagColors": [
              isSuccess ? Colors.green.shade300 : Colors.red.shade300,
            ],
            "message": item.sendDesc ?? "อาจารย์ประกาศคะแนนแล้ว",
            "date":
                "${item.sendTime.day}/${item.sendTime.month}/${item.sendTime.year}",
            "dateObj": item.sendTime,
          };
        }
      }

      setState(() {
        // ✅ แปลงค่าจาก Map กลับเป็น List
        notifications = latestMap.values.toList();
        sortNotifications();
      });
    } catch (e) {
      print("โหลด noti error: $e");
    }
  }

  void sortNotifications() {
    notifications.sort((a, b) {
      DateTime dateA = a['dateObj'];
      DateTime dateB = b['dateObj'];

      return dateB.compareTo(dateA);
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
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

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
          // ปุ่มย้อนกลับ + ชื่อหน้ารวมกัน
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF4A4E49)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 4),
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
            onPressed: _clearAllNotifications,
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

  Widget _buildNotificationList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Color(0xFFE8EBD0)),
      child:
          notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                key: ValueKey(notifications.length),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(notifications[index], index);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 80,
            color: const Color(0xFF778873),
          ),
          const SizedBox(height: 10),
          Text(
            "ยังไม่มีการแจ้งเตือนในขณะนี้",
            textAlign: TextAlign.center,
            style: GoogleFonts.kanit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A4E49),
            ),
          ),
          Text(
            "กรุณารอการอัปเดตคะแนนจากระบบ",
            textAlign: TextAlign.center,
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF656E62),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> data, int index) {
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
          _buildCloseButton(index),
        ],
      ),
    );
  }

  Widget _buildTitle(Map<String, dynamic> data) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "📚 ${data['subject']}  ",
            style: GoogleFonts.kanit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF656E62),
            ),
          ),
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFFA1BC98),
                borderRadius: BorderRadius.circular(500),
              ),
              child: Text(
                data['code'],
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF656E62),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> data) {
    return Text(
      data['message'],
      style: GoogleFonts.kanit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF656E62),
      ),
    );
  }

  Widget _buildFooterInfo(Map<String, dynamic> data) {
    return Text(
      "หมู่เรียน ${data['section']} | ${data['semester']} | ปีการศึกษา ${data['year']}",
      style: GoogleFonts.kanit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF656E62),
      ),
    );
  }

  Widget _buildDate(Map<String, dynamic> data) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        data['date'],
        style: GoogleFonts.kanit(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF656E62),
        ),
      ),
    );
  }

  Widget _buildCloseButton(int index) {
    return Positioned(
      top: 3,
      right: 9,
      child: GestureDetector(
        onTap: () async {
          try {
            final noti = notifications[index];

            DateTime date = noti["dateObj"];

            await StudentService.deleteNotificationByDate(date);

            setState(() {
              notifications.removeAt(index);
            });
          } catch (e) {
            print("ลบ noti error: $e");

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("ลบไม่สำเร็จ")));
          }
        },
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 133, 165, 133),
          ),
          child: const Text('X'),
        ),
      ),
    );
  }
}
