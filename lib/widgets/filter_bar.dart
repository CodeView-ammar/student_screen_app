import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_calls_provider.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentCallsProvider>(
      builder: (context, callsProvider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'تصفية الندائات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // تصفية حسب الحالة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الحالة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip(
                              context,
                              'all',
                              'الكل',
                              callsProvider.currentFilter == 'all',
                              callsProvider.setFilter,
                              const Color(0xFF6366F1),
                            ),
                            _buildFilterChip(
                              context,
                              'pending',
                              'في الانتظار',
                              callsProvider.currentFilter == 'pending',
                              callsProvider.setFilter,
                              const Color(0xFFF59E0B),
                            ),
                            _buildFilterChip(
                              context,
                              'answered',
                              'تم الرد',
                              callsProvider.currentFilter == 'answered',
                              callsProvider.setFilter,
                              const Color(0xFF10B981),
                            ),
                            _buildFilterChip(
                              context,
                              'not_answered',
                              'لم يتم الرد',
                              callsProvider.currentFilter == 'not_answered',
                              callsProvider.setFilter,
                              const Color(0xFFEF4444),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 24),
                  
                  // تصفية حسب الفترة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الفترة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            _buildFilterChip(
                              context,
                              'all',
                              'الكل',
                              callsProvider.currentPeriod == 'all',
                              callsProvider.setPeriod,
                              const Color(0xFF6366F1),
                            ),
                            _buildFilterChip(
                              context,
                              'morning',
                              'الصباح',
                              callsProvider.currentPeriod == 'morning',
                              callsProvider.setPeriod,
                              const Color(0xFFF59E0B),
                            ),
                            _buildFilterChip(
                              context,
                              'afternoon',
                              'الظهر',
                              callsProvider.currentPeriod == 'afternoon',
                              callsProvider.setPeriod,
                              const Color(0xFF3B82F6),
                            ),
                            _buildFilterChip(
                              context,
                              'evening',
                              'المساء',
                              callsProvider.currentPeriod == 'evening',
                              callsProvider.setPeriod,
                              const Color(0xFF8B5CF6),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildFilterChip(
    BuildContext context,
    String value,
    String label,
    bool isSelected,
    Function(String) onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}