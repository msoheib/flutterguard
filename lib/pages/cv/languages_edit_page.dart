import 'package:flutter/material.dart';
import '../../models/profile.dart';
import '../../services/profile_service.dart';
import '../../util/snackbar_util.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';

class LanguagesEditPage extends StatefulWidget {
  final List<Language> initialLanguages;

  const LanguagesEditPage({
    super.key,
    required this.initialLanguages,
  });

  @override
  State<LanguagesEditPage> createState() => _LanguagesEditPageState();
}

class _LanguagesEditPageState extends State<LanguagesEditPage> {
  final ProfileService _profileService = ProfileService();
  final TextEditingController _searchController = TextEditingController();
  final List<Language> _languages = [];
  late FocusNode _searchFocusNode;
  final List<String> _languageOptions = [
    'العربية',
    'الإنجليزية',
    'الفرنسية',
    'الألمانية',
    'الإسبانية',
    'البرتغالية',
    'الإيطالية',
    'الروسية',
    'الصينية',
    'اليابانية',
  ];
  
  final List<String> _proficiencyLevels = [
    'مبتدئ',
    'متوسط',
    'متقدم',
    'طلاقة',
  ];
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _languages.addAll(widget.initialLanguages);
    _searchFocusNode = FocusNode();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
  
  void _toggleLanguage(String languageName) {
    // Check if language is already selected
    final existingIndex = _languages.indexWhere((lang) => lang.name == languageName);
    
    if (existingIndex >= 0) {
      // If found, remove it
      setState(() {
        _languages.removeAt(existingIndex);
      });
    } else {
      // If not found, add with default proficiency
      setState(() {
        _languages.add(Language(
          name: languageName,
          proficiency: _proficiencyLevels.first,
        ));
      });
    }
  }
  
  void _updateProficiency(Language language, String newProficiency) {
    final index = _languages.indexWhere((lang) => lang.name == language.name);
    if (index >= 0) {
      setState(() {
        _languages[index] = Language(
          name: language.name,
          proficiency: newProficiency,
        );
      });
    }
  }
  
  Future<void> _saveLanguages() async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    try {
      await _profileService.updateLanguages(_languages);
      if (mounted) {
        showSnackBar(context, 'تم تحديث اللغات بنجاح');
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) showSnackBar(context, 'حدث خطأ أثناء تحديث اللغات');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'إضافة لغة',
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
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: _searchFocusNode.hasFocus || _searchController.text.isNotEmpty ? '' : 'بحث',
                        hintStyle: const TextStyle(color: Color(0xFF6A6A6A)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF6A6A6A)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onTap: () {
                        setState(() {});
                      },
                      onChanged: (query) {
                        setState(() {});
                        // Filter languages based on search query
                        // Not implemented in this prototype
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Selected languages and all languages
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // Tab bar
                          const TabBar(
                            tabs: [
                              Tab(
                                child: Text('جميع اللغات', style: TextStyle(color: Colors.black)),
                              ),
                              Tab(
                                child: Text('لغاتي', style: TextStyle(color: Colors.black)),
                              ),
                            ],
                            indicatorColor: Color(0xFF4CA6A8),
                          ),
                          const SizedBox(height: 10),
                          // Tab content
                          Expanded(
                            child: TabBarView(
                              children: [
                                // All Languages Tab
                                _buildAllLanguagesTab(),
                                // My Languages Tab
                                _buildMyLanguagesTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Save button
                  GestureDetector(
                    onTap: _saveLanguages,
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
  
  Widget _buildAllLanguagesTab() {
    return ListView.builder(
      itemCount: _languageOptions.length,
      itemBuilder: (context, index) {
        final language = _languageOptions[index];
        final isSelected = _languages.any((lang) => lang.name == language);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              language,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: isSelected 
              ? Container(
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
                )
              : const SizedBox(width: 24),
            onTap: () => _toggleLanguage(language),
          ),
        );
      },
    );
  }
  
  Widget _buildMyLanguagesTab() {
    return _languages.isEmpty
        ? const Center(
            child: Text(
              'لا توجد لغات مضافة',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        : ListView.builder(
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    language.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _proficiencyLevels.map((level) {
                      final isSelected = language.proficiency == level;
                      return GestureDetector(
                        onTap: () => _updateProficiency(language, level),
                        child: Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4CA6A8) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            level,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _toggleLanguage(language.name),
                  ),
                ),
              );
            },
          );
  }
} 