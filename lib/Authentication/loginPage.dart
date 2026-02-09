import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

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

      // 🔒 บังคับเฉพาะ @ku.th
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

      // ✅ Login สำเร็จ
      _showDialog(
        title: "เข้าสู่ระบบสำเร็จ 🎉",
        desc: "ยินดีต้อนรับ $email",
        type: DialogType.success,
      );

      debugPrint("Login success: $email");
    } catch (e) {
      debugPrint("Google Sign-in Error: $e");
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
        color: const Color(0xFFD2DCB6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 110),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "📚 Score Management",
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF4A4E49),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "เริ่มต้นใช้งานได้ทันที",
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF4A4E49),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "เข้าสู่ระบบเพื่อสำรวจและใช้งานแอปของเรา",
                    style: GoogleFonts.kanit(
                      color: const Color(0xFF4A4E49),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFA1BC98),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(top: 30, bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 231, 228, 207),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset('assets/images/user.png'),
                        ),
                      ),
                      const SizedBox(height: 30),

                      /// 🔥 ปุ่ม Login with Google
                      GestureDetector(
                        onTap: _signInWithGoogle,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 231, 228, 207),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Log In with Google",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 53, 52, 52),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
