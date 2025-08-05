import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/student_calls_provider.dart';

import '../widgets/call_card.dart';
import '../widgets/statistics_card.dart';
import '../widgets/filter_bar.dart';
import 'login_screen.dart';
import 'branch_selection_screen.dart';

class StudentCallsScreen extends StatefulWidget {
  const StudentCallsScreen({super.key});

  @override
  State<StudentCallsScreen> createState() => _StudentCallsScreenState();
}

class _StudentCallsScreenState extends State<StudentCallsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final callsProvider = Provider.of<StudentCallsProvider>(context, listen: false);
    
    if (authProvider.selectedGradeClass != null) {
      callsProvider.loadStudentCalls(
        gradeClassId: authProvider.selectedGradeClass!.id,
      );
    }
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final callsProvider = Provider.of<StudentCallsProvider>(context, listen: false);
    
    if (authProvider.selectedGradeClass != null) {
      await callsProvider.refreshCalls(
        gradeClassId: authProvider.selectedGradeClass!.id,
      );
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  void _changeBranch() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const BranchSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFE2E8F0),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // إضافة هنا
            child: Column(
              children: [
                // Header
                _buildHeader(),
                
                // Statistics Cards
                _buildStatisticsSection(),
                
                // Filter Bar
                const FilterBar(),
                
                // Calls List
                _buildCallsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final now = DateTime.now();
        final formatter = DateFormat('EEEE, dd MMMM yyyy', 'ar');
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // معلومات التطبيق
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.campaign,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'لوحة ندائات الطلاب',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                authProvider.selectedGradeClass?.name ?? 'غير محدد',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatter.format(now),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat('HH:mm').format(now),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // أزرار الإجراءات
              Row(
                children: [
                  // زر التحديث
                  Consumer<StudentCallsProvider>(
                    builder: (context, callsProvider, child) {
                      return IconButton(
                        onPressed: callsProvider.isLoading ? null : _refreshData,
                        icon: callsProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh),
                        tooltip: 'تحديث البيانات',
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  
                  // زر تغيير الفصل
                  IconButton(
                    onPressed: _changeBranch,
                    icon: const Icon(Icons.swap_horiz),
                    tooltip: 'تغيير الفصل',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // زر تسجيل الخروج
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    tooltip: 'تسجيل الخروج',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsSection() {
    return Consumer<StudentCallsProvider>(
      builder: (context, callsProvider, child) {
        final stats = callsProvider.callsStatistics;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: StatisticsCard(
                  title: 'إجمالي الندائات',
                  value: stats['total'].toString(),
                  color: const Color(0xFF6366F1),
                  icon: Icons.campaign,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticsCard(
                  title: 'في الانتظار',
                  value: stats['pending'].toString(),
                  color: const Color(0xFFF59E0B),
                  icon: Icons.hourglass_empty,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticsCard(
                  title: 'تم الرد',
                  value: stats['answered'].toString(),
                  color: const Color(0xFF10B981),
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatisticsCard(
                  title: 'لم يتم الرد',
                  value: stats['not_answered'].toString(),
                  color: const Color(0xFFEF4444),
                  icon: Icons.cancel,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCallsList() {
    return Consumer<StudentCallsProvider>(
      builder: (context, callsProvider, child) {
        if (callsProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'جاري تحميل الندائات...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          );
        }

        if (callsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  callsProvider.errorMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshData,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final filteredCalls = callsProvider.filteredCalls;

        if (filteredCalls.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'لا توجد ندائات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'لم يتم العثور على أي ندائات في الوقت الحالي',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(), // منع التمرير هنا
            shrinkWrap: true, // يجعل القائمة تأخذ المساحة المطلوبة
            padding: const EdgeInsets.all(16),
            itemCount: filteredCalls.length,
            itemBuilder: (context, index) {
              final call = filteredCalls[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CallCard(
                  call: call,
                  onStatusChanged: (newStatus) async {
                    final success = await callsProvider.updateCallStatus(
                      call.id,
                      newStatus,
                    );
                    
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم تحديث حالة النداء إلى "${call.statusText}"'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('فشل في تحديث حالة النداء'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}