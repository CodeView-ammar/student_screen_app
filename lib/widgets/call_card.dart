import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_call.dart';

class CallCard extends StatelessWidget {
  final StudentCall call;
  final Function(String) onStatusChanged;

  const CallCard({
    super.key,
    required this.call,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor(call.status).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Student Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getStatusColor(call.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _getStatusColor(call.status),
                      width: 2,
                    ),
                  ),
                  child: call.studentPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            call.studentPhoto!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: _getStatusColor(call.status),
                                size: 30,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: _getStatusColor(call.status),
                          size: 30,
                        ),
                ),
                const SizedBox(width: 16),
                
                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.studentName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (call.className != null) ...[
                            Icon(
                              Icons.class_,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              call.className!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (call.className != null && call.branchName != null)
                            const SizedBox(width: 12),
                          if (call.branchName != null) ...[
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              call.branchName!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(call.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    call.statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Call Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          Icons.access_time,
                          'وقت النداء',
                          DateFormat('HH:mm').format(call.createdAt),
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          Icons.wb_sunny,
                          'الفترة',
                          call.callPeriodText,
                        ),
                      ),
                    ],
                  ),
                  
                  if (call.answeredAt != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            Icons.check_circle,
                            'وقت الرد',
                            DateFormat('HH:mm').format(call.answeredAt!),
                          ),
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            Icons.timer,
                            'مدة الانتظار',
                            _getDuration(call.createdAt, call.answeredAt!),
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (call.notes != null && call.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.note,
                                size: 16,
                                color: Colors.blue[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'ملاحظات:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            call.notes!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Action Buttons
            if (call.status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChanged('answered'),
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text('تم الرد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onStatusChanged('not_answered'),
                      icon: const Icon(Icons.close, size: 20),
                      label: const Text('لم يتم الرد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'answered':
        return const Color(0xFF10B981);
      case 'not_answered':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    
    if (minutes > 0) {
      return '${minutes}د ${seconds}ث';
    } else {
      return '${seconds}ث';
    }
  }
}