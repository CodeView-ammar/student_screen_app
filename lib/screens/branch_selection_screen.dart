import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/grade_class.dart';
import '../services/api_service.dart';
import 'student_calls_screen.dart';

class BranchSelectionScreen extends StatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  State<BranchSelectionScreen> createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  final _apiService = ApiService();
  
  List<GradeClass> _gradeClasses = [];
  GradeClass? _selectedGradeClass;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGradeClasses();
  }

  Future<void> _loadGradeClasses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      if (user?.schoolId != null) {
        final gradeClasses = await _apiService.getGradeClasses(user!.schoolId!);
        setState(() {
          _gradeClasses = gradeClasses;
          _isLoading = false;
        });
      } else {
        throw Exception('لم يتم العثور على معرف المدرسة');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل الفصول: $e';
      });
    }
  }

  Future<void> _selectGradeClass() async {
    if (_selectedGradeClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار فصل'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // حفظ الفصل المختار
    await authProvider.selectAndSaveGradeClass(_selectedGradeClass!);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StudentCallsScreen(),
        ),
      );
    }
  }

  Future<void> _selectAllGradeClasses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // إنشاء فصل افتراضي يمثل "كل الفصول"
    final allGradeClasses = GradeClass(
      id: -1, // معرف خاص للدلالة على كل الفصول
      name: 'كل الفصول',
      schoolId: authProvider.user!.schoolId!,
    );
    
    await authProvider.selectAndSaveGradeClass(allGradeClasses);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StudentCallsScreen(),
        ),
      );
    }
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
              Color(0xFF1E3A8A), // أزرق داكن
              Color(0xFF3B82F6), // أزرق فاتح
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // أيقونة
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.class_outlined,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      const Text(
                        'اختيار الفصل',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      const Text(
                        'اختر الفصل الذي تريد عرض ندائاته',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      if (_isLoading)
                        const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('جاري تحميل الفصول...'),
                          ],
                        )
                      else if (_errorMessage != null)
                        Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadGradeClasses,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            // خيار كل الفصول
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ElevatedButton(
                                onPressed: _selectAllGradeClasses,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.select_all),
                                    SizedBox(width: 8),
                                    Text(
                                      'كل الفصول',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const Divider(thickness: 1),
                            const SizedBox(height: 16),
                            
                            // قائمة الفصول
                            if (_gradeClasses.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'أو اختر فصل محدد:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // قائمة الفصول المتاحة
                                  Container(
                                    constraints: const BoxConstraints(maxHeight: 300),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: _gradeClasses.map((gradeClass) {
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            child: RadioListTile<GradeClass>(
                                              title: Text(
                                                gradeClass.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              value: gradeClass,
                                              groupValue: _selectedGradeClass,
                                              onChanged: (GradeClass? value) {
                                                setState(() {
                                                  _selectedGradeClass = value;
                                                });
                                              },
                                              activeColor: const Color(0xFF1E3A8A),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              tileColor: Colors.grey[50],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // زر التأكيد للفصل المحدد
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _selectedGradeClass != null ? _selectGradeClass : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1E3A8A),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'تأكيد الاختيار',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}