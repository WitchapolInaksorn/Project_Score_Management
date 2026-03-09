import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:score_management/Navigation/mainNavbar.dart';

import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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

  Future<void> _signInWithGoogle() async {
    try {
      // บังคับเลือกบัญชีใหม่ทุกครั้ง
      await _googleSignIn.signOut();
      await _auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _showDialog(
          title: "ยกเลิกการเข้าสู่ระบบ",
          desc: "คุณยังไม่ได้เลือกบัญชี Google",
          type: DialogType.warning,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        _showDialog(
          title: "เกิดข้อผิดพลาด",
          desc: "ไม่สามารถเข้าสู่ระบบได้",
          type: DialogType.error,
        );
        return;
      }

      final email = user.email ?? "";

      if (!email.endsWith("@ku.th")) {
        await _googleSignIn.signOut();
        await _auth.signOut();

        _showDialog(
          title: "อีเมลไม่ถูกต้อง",
          desc: "กรุณาใช้บัญชี @ku.th เท่านั้น",
          type: DialogType.error,
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } catch (e) {
      _showDialog(
        title: "Error",
        desc: "เกิดข้อผิดพลาดในการเข้าสู่ระบบ\n$e",
        type: DialogType.error,
      );
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/logo.png", height: 34),

                      const SizedBox(width: 10),

                      Text(
                        "Score Management",
                        style: GoogleFonts.kanit(
                          color: const Color(0xFF4A4E49),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "เริ่มต้นใช้งานได้ทันที",
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF4A4E49),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "เข้าสู่ระบบเพื่อใช้งานแอปของเรา (ใช้บัญชี @ku.th เท่านั้น)",
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF4A4E49),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _glassAvatar(),

                      const SizedBox(height: 45),

                      _googleButton(),

                      const SizedBox(height: 30),

                      _featureCard(
                        "assets/images/score_management.png",
                        "Manage Scores",
                        "ดูคะแนนรายวิชาได้ง่าย",
                      ),

                      const SizedBox(height: 12),

                      _featureCard(
                        "assets/images/tracking.png",
                        "Track Courses",
                        "ติดตามผลการเรียนของคุณ",
                      ),

                      const SizedBox(height: 12),

                      _featureCard(
                        "assets/images/update_instant.png",
                        "Instant Updates",
                        "รับแจ้งเตือนจากอาจารย์",
                      ),

                      const SizedBox(height: 40),
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

  Widget _glassAvatar() {
    return Container(
      width: 190,
      height: 190,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.45),
            Colors.white.withOpacity(0.15),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        "assets/images/user.png",
        filterQuality: FilterQuality.low,
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _signInWithGoogle,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 3,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png", height: 22),
            const SizedBox(width: 10),
            Text(
              "Continue with Google",
              style: GoogleFonts.kanit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(String imagePath, String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.35),
            Colors.white.withOpacity(0.12),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.low,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.kanit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4A4E49),
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.kanit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4A4E49),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
