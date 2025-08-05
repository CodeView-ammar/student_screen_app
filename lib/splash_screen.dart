import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_screen_app/screens/login_screen.dart';
import 'package:student_screen_app/screens/branch_selection_screen.dart';
import 'package:student_screen_app/screens/student_calls_screen.dart';
import '../providers/auth_provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadSavedData(); // تحميل جميع البيانات المحفوظة

    // انتقل إلى الشاشة المناسبة بناءً على حالة تسجيل الدخول
    if (authProvider.isAuthenticated) {
      // التحقق من وجود فصل محفوظ
      if (authProvider.selectedGradeClass != null) {
        // إذا كان هناك فصل محفوظ، انتقل لشاشة الندائات
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StudentCallsScreen()),
        );
      } else {
        // إذا لم يكن هناك فصل محفوظ، انتقل لشاشة اختيار الفصل
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BranchSelectionScreen()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(), // يمكنك إضافة شعار هنا
            const SizedBox(height: 20),
            const Text('جاري التحميل...'),
          ],
        ),
      ),
    );
  }
}