class AppConstants {
// API Constants
  static const String baseUrl = 'http://192.168.186.146:8000/api';
  static const Duration timeout = Duration(seconds: 30);

  // أسماء الحالات
  static const String statusPending = 'pending';
  static const String statusAnswered = 'answered';
  static const String statusNotAnswered = 'not_answered';
  
  // أسماء الفترات
  static const String periodMorning = 'morning';
  static const String periodAfternoon = 'afternoon';
  static const String periodEvening = 'evening';
  
  // الألوان
  static const int primaryBlue = 0xFF1E3A8A;
  static const int lightBlue = 0xFF3B82F6;
  static const int warningYellow = 0xFFF59E0B;
  static const int successGreen = 0xFF10B981;
  static const int errorRed = 0xFFEF4444;
  static const int neutralGray = 0xFF6B7280;
  
  // مفاتيح التخزين المحلي
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String branchKey = 'selected_branch';
  
  // إعدادات التحديث التلقائي
  static const Duration autoRefreshInterval = Duration(minutes: 2);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // رسائل النظام
  static const String connectionErrorMessage = 'خطأ في الاتصال بالخادم';
  static const String authErrorMessage = 'فشل في تسجيل الدخول';
  static const String dataLoadErrorMessage = 'فشل في تحميل البيانات';
  static const String updateSuccessMessage = 'تم التحديث بنجاح';
  static const String updateErrorMessage = 'فشل في التحديث';
  
  // أحجام الشاشة
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // أحجام الخطوط للشاشات الكبيرة
  static const double largeTitleFontSize = 32;
  static const double titleFontSize = 24;
  static const double subtitleFontSize = 18;
  static const double bodyFontSize = 16;
  static const double captionFontSize = 14;
}