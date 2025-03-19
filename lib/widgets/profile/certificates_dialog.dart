import 'package:flutter/material.dart';
import '../../models/profile.dart';
import 'section_dialog.dart';

class CertificatesDialog extends StatefulWidget {
  final List<Certificate> initialCertificates;
  final Function(List<Certificate>) onSave;

  const CertificatesDialog({
    super.key,
    required this.initialCertificates,
    required this.onSave,
  });

  @override
  State<CertificatesDialog> createState() => _CertificatesDialogState();
}

class _CertificatesDialogState extends State<CertificatesDialog> {
  late List<Certificate> _certificates;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _certificateIdController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _certificates = List.from(widget.initialCertificates);
  }

  @override
  Widget build(BuildContext context) {
    return SectionDialog(
      title: 'الشهادات',
      onSave: _isLoading ? null : _handleSave,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Certificate Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Certificate Name
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'اسم الشهادة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الشهادة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Issuer
                TextFormField(
                  controller: _issuerController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'الجهة المصدرة',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال الجهة المصدرة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Issue Date
                TextFormField(
                  controller: _issueDateController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الإصدار',
                    hintText: 'يناير 2022',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال تاريخ الإصدار';
                    }
                    return null;
                  },
                  onTap: () => _selectDate(_issueDateController),
                ),
                const SizedBox(height: 16),
                
                // Expiration Date (Optional)
                TextFormField(
                  controller: _expirationDateController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'تاريخ الانتهاء (اختياري)',
                    hintText: 'يناير 2025',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectDate(_expirationDateController),
                ),
                const SizedBox(height: 16),
                
                // Certificate ID (Optional)
                TextFormField(
                  controller: _certificateIdController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    labelText: 'رقم الشهادة (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Add Button
                ElevatedButton(
                  onPressed: _addCertificate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CA6A8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'إضافة الشهادة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          // List of Certificates
          if (_certificates.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'لا توجد شهادات مضافة',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _certificates.length,
              itemBuilder: (context, index) {
                final certificate = _certificates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeCertificate(index);
                              },
                            ),
                            Expanded(
                              child: Text(
                                certificate.name,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          certificate.issuer,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF4CA6A8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'تاريخ الإصدار: ${certificate.issueDate}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          ],
                        ),
                        if (certificate.expirationDate.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'تاريخ الانتهاء: ${certificate.expirationDate}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.event, size: 16, color: Colors.grey),
                            ],
                          ),
                        ],
                        if (certificate.certificateId.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'رقم الشهادة: ${certificate.certificateId}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.numbers, size: 16, color: Colors.grey),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _addCertificate() {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _certificates.add(Certificate(
        name: _nameController.text,
        issuer: _issuerController.text,
        issueDate: _issueDateController.text,
        expirationDate: _expirationDateController.text,
        certificateId: _certificateIdController.text,
      ));
      // Clear form
      _nameController.clear();
      _issuerController.clear();
      _issueDateController.clear();
      _expirationDateController.clear();
      _certificateIdController.clear();
    });
  }

  void _removeCertificate(int index) {
    setState(() {
      _certificates.removeAt(index);
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final initialDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CA6A8),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Format the date as Month Year (e.g., "يناير 2022")
      final String month = _getArabicMonth(pickedDate.month);
      final String formattedDate = '$month ${pickedDate.year}';
      controller.text = formattedDate;
    }
  }
  
  String _getArabicMonth(int month) {
    switch (month) {
      case 1: return 'يناير';
      case 2: return 'فبراير';
      case 3: return 'مارس';
      case 4: return 'أبريل';
      case 5: return 'مايو';
      case 6: return 'يونيو';
      case 7: return 'يوليو';
      case 8: return 'أغسطس';
      case 9: return 'سبتمبر';
      case 10: return 'أكتوبر';
      case 11: return 'نوفمبر';
      case 12: return 'ديسمبر';
      default: return '';
    }
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      await widget.onSave(_certificates);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
} 