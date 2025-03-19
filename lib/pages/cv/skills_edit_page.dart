import 'package:flutter/material.dart';
import '../../services/profile_service.dart';
import '../../util/snackbar_util.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';

class SkillsEditPage extends StatefulWidget {
  final List<String> initialSkills;

  const SkillsEditPage({
    super.key,
    required this.initialSkills,
  });

  @override
  State<SkillsEditPage> createState() => _SkillsEditPageState();
}

class _SkillsEditPageState extends State<SkillsEditPage> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _skillController = TextEditingController();
  final List<String> _skills = [];
  late FocusNode _skillFocusNode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _skills.addAll(widget.initialSkills);
    _skillFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _skillController.dispose();
    _skillFocusNode.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
  }

  Future<void> _saveSkills() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      await _profileService.updateSkills(_skills);
      if (mounted) {
        showSnackBar(context, 'تم تحديث المهارات بنجاح');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ أثناء تحديث المهارات');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'إضافة مهارة',
        showBackButton: true,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _skillController,
                      focusNode: _skillFocusNode,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: _skillFocusNode.hasFocus || _skillController.text.isNotEmpty ? '' : 'بحث',
                        hintStyle: const TextStyle(color: Color(0xFF6A6A6A)),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Color(0xFF6A6A6A)),
                          onPressed: () {},
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFF4CA6A8)),
                          onPressed: _addSkill,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Selected skills display
                  Expanded(
                    child: _skills.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد مهارات مضافة',
                              style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _skills.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    _skills[index],
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  leading: IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () => _removeSkill(_skills[index]),
                                  ),
                                  trailing: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CA6A8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save button
                  GestureDetector(
                    onTap: _saveSkills,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6A8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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