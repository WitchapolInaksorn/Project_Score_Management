import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NisitFormPage extends StatefulWidget {
  const NisitFormPage({super.key});

  @override
  State<NisitFormPage> createState() => _NisitFormPageState();
}

class _NisitFormPageState extends State<NisitFormPage> {
  final TextEditingController prefixController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedPrefix;

  final List<String> prefixes = ["นาย", "นาง", "นางสาว"];

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    emailController.text = user?.email ?? "";
  }

  void _showDialog({
    required String title,
    required String desc,
    required DialogType type,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void _validateForm() {
    if (selectedPrefix == null) {
      _showDialog(
        title: "ข้อมูลไม่ครบ",
        desc: "กรุณาเลือกคำนำหน้า",
        type: DialogType.warning,
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      _showDialog(
        title: "ข้อมูลไม่ครบ",
        desc: "กรุณากรอกชื่อ - นามสกุล",
        type: DialogType.warning,
      );
      return;
    }

    if (idController.text.trim().isEmpty) {
      _showDialog(
        title: "ข้อมูลไม่ครบ",
        desc: "กรุณากรอกรหัสนิสิต",
        type: DialogType.warning,
      );
      return;
    }

    if (majorController.text.trim().isEmpty) {
      _showDialog(
        title: "ข้อมูลไม่ครบ",
        desc: "กรุณากรอกรหัสสาขา",
        type: DialogType.warning,
      );
      return;
    }

    String major =
        majorController.text.replaceAll(RegExp(r"\s+"), "").toLowerCase();

    if (major.length != 3) {
      _showDialog(
        title: "รหัสสาขาไม่ถูกต้อง",
        desc: "รหัสสาขาต้องมี 3 ตัวอักษร",
        type: DialogType.error,
      );
      return;
    }

    String studentId = idController.text.replaceAll(" ", "");

    if (studentId.length != 10) {
      _showDialog(
        title: "รหัสนิสิตไม่ถูกต้อง",
        desc: "รหัสนิสิตต้องมี 10 หลัก",
        type: DialogType.error,
      );
      return;
    }

    _showDialog(
      title: "สำเร็จ",
      desc: "บันทึกข้อมูลเรียบร้อย",
      type: DialogType.success,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    majorController.dispose();
    emailController.dispose();
    super.dispose();
  }

  TextStyle kanit({
    double size = 16,
    FontWeight weight = FontWeight.w500,
    Color color = const Color(0xFF4A4E49),
  }) {
    return GoogleFonts.kanit(fontSize: size, fontWeight: weight, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD2DCB6), Color(0xFFA1BC98), Color(0xFF8AAE92)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 80),

                        Image.asset("assets/images/logo.png", height: 34),
                        const SizedBox(width: 10),
                        Text(
                          "Score Management",
                          style: kanit(size: 28, weight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "ก่อนเริ่มต้นใช้งาน",
                      style: kanit(size: 22, weight: FontWeight.w600),
                    ),

                    Text(
                      "กรอกข้อมูลนิสิตก่อนเริ่มใช้งานระบบ",
                      style: kanit(
                        size: 15,
                        color: const Color(0xFF4A4E49).withOpacity(0.9),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.15),
          ],
        ),

        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📝 กรอกข้อมูลของนิสิต",
            style: kanit(size: 20, weight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          _buildPrefixDropdown(),
          _buildTextField("👤 ชื่อ - นามสกุล", nameController),
          _buildTextField("🎓 รหัสนิสิต", idController),
          _buildTextField("📚 รหัสสาขา", majorController),

          _buildReadOnlyField("✉️ บัญชี Google", emailController),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _validateForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA1BC98),
                elevation: 2,
                shadowColor: Colors.black26,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "บันทึกข้อมูล",
                style: kanit(
                  size: 16,
                  weight: FontWeight.w600,
                  color: Color(0xFF2F3E2C).withOpacity(0.65),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        style: kanit(weight: FontWeight.w500),

        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF1F3E0),

          labelText: hint,
          labelStyle: kanit(color: const Color(0xFF4A4E49).withOpacity(0.85)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: true,
        style: kanit(weight: FontWeight.w500),

        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFE8ECD8),

          labelText: hint,
          labelStyle: kanit(color: const Color(0xFF778873)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPrefixDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedPrefix,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF1F3E0),

          labelText: "🪪 คำนำหน้าชื่อ",
          labelStyle: kanit(color: const Color(0xFF4A4E49).withOpacity(0.85)),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),

        items:
            prefixes.map((prefix) {
              return DropdownMenuItem(
                value: prefix,
                child: Text(prefix, style: kanit(weight: FontWeight.w500)),
              );
            }).toList(),

        onChanged: (value) {
          setState(() {
            selectedPrefix = value;
          });
        },
      ),
    );
  }
}
