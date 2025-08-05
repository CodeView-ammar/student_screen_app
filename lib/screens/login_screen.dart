import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/branch.dart';
import '../services/api_service.dart';
import 'student_calls_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  
  Branch? _selectedBranch;
  List<Branch> _branches = [];
  bool _isLoadingBranches = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    setState(() {
      _isLoadingBranches = true;
    });

    try {
      // افتراض أن school_id = 1، يمكن تغييرها حسب الحاجة
      final branches = await _apiService.getBranches(1);
      setState(() {
        _branches = branches;
        _isLoadingBranches = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBranches = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحميل الفصول: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // if (_selectedBranch == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('يرجى اختيار الفصل'),
    //       backgroundColor: Colors.orange,
    //     ),
    //   );
    //   return;
    // }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      _phoneController.text.trim(),
      _passwordController.text.trim(),
      // _selectedBranch!,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const StudentCallsScreen(),
        ),
      );
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage!),
          backgroundColor: Colors.red,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // شعار أو عنوان التطبيق
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.school,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        const Text(
                          'نظام ندائات الطلاب',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        
                        const Text(
                          'تسجيل الدخول للوصول إلى لوحة الندائات',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // حقل البريد الإلكتروني
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال رقم الهاتف';
                            }
                            if (!RegExp(r'^[0-9]{9,15}$').hasMatch(value)) {
                              return 'رقم الهاتف غير صالح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // حقل كلمة المرور
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // قائمة اختيار الفصل
                        // DropdownButtonFormField<Branch>(
                        //   value: _selectedBranch,
                        //   decoration: InputDecoration(
                        //     labelText: 'اختيار الفصل',
                        //     prefixIcon: const Icon(Icons.class_outlined),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     filled: true,
                        //     fillColor: Colors.grey[50],
                        //   ),
                        //   items: _branches.map((branch) {
                        //     return DropdownMenuItem<Branch>(
                        //       value: branch,
                        //       child: Text(branch.name),
                        //     );
                        //   }).toList(),
                        //   onChanged: _isLoadingBranches
                        //       ? null
                        //       : (Branch? value) {
                        //           setState(() {
                        //             _selectedBranch = value;
                        //           });
                        //         },
                        //   validator: (value) {
                        //     if (value == null) {
                        //       return 'يرجى اختيار الفصل';
                        //     }
                        //     return null;
                        //   },
                        //   hint: _isLoadingBranches
                        //       ? const Row(
                        //           children: [
                        //             SizedBox(
                        //               width: 16,
                        //               height: 16,
                        //               child: CircularProgressIndicator(strokeWidth: 2),
                        //             ),
                        //             SizedBox(width: 8),
                        //             Text('جاري تحميل الفصول...'),
                        //           ],
                        //         )
                        //       : const Text('اختر الفصل'),
                        // ),
                        const SizedBox(height: 32),

                        // زر تسجيل الدخول
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: authProvider.isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                        
                        // const SizedBox(height: 16),
                        
                        // // زر إعادة تحميل الفصول
                        // TextButton.icon(
                        //   onPressed: _isLoadingBranches ? null : _loadBranches,
                        //   icon: const Icon(Icons.refresh),
                        //   label: const Text('إعادة تحميل الفصول'),
                        //   style: TextButton.styleFrom(
                        //     foregroundColor: const Color(0xFF1E3A8A),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}