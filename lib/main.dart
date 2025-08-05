import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:student_screen_app/splash_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/student_calls_provider.dart';
import 'screens/login_screen.dart';
import 'screens/branch_selection_screen.dart';
import 'screens/student_calls_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentCallsProvider()),
      ],
      child: MaterialApp(
        title: 'تطبيق ندائات الطلاب',
        debugShowCheckedModeBanner: false,
        
        // إعدادات اللغة العربية
        locale: const Locale('ar', 'SA'),
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        
        // الثيم العام للتطبيق
        theme: ThemeData(
          // الألوان الأساسية
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1E3A8A),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.light,
          ),
          
          // تصميم الأزرار
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          
          // تصميم حقول الإدخال
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: Color(0xFFFAFAFA),
          ),
          
          // تصميم شريط التطبيق
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          
          // الخط الافتراضي - يدعم العربية
          // fontFamily: 'Cairo',
          
          // إعدادات النصوص
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF374151),
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          
          // تحسينات للشاشات الكبيرة
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        
        // الشاشة الرئيسية
        home: const SplashScreen(),
        
        // إعدادات التوجه للشاشات الكبيرة
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // منع تغيير حجم النص من إعدادات النظام
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

// Widget للتحقق من حالة المصادقة عند بدء التطبيق
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return FutureBuilder<bool>(
          future: authProvider.checkAuthStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'جاري التحميل...',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // إذا كان المستخدم مسجل الدخول
            if (snapshot.data == true && authProvider.isAuthenticated) {
              // التحقق من وجود فصل محفوظ
              if (authProvider.selectedGradeClass != null) {
                // الانتقال لشاشة الندائات إذا كان هناك فصل محفوظ
                return const StudentCallsScreen();
              } else {
                // الانتقال لشاشة اختيار الفصل إذا لم يكن هناك فصل محفوظ
                return const BranchSelectionScreen();
              }
            }
            
            // الانتقال لشاشة تسجيل الدخول
            return const LoginScreen();
          },
        );
      },
    );
  }
}