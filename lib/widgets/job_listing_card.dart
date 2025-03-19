import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/job_post.dart';
import '../services/job_service.dart';

class JobListingCard extends StatefulWidget {
  final JobPost? job;
  final String? jobId;
  final String? title;
  final String? company;
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? salary;
  final String? jobType;
  final String? workType;
  final String? status;
  final VoidCallback onTap;
  final String? buttonText;
  final Color? buttonColor;
  final VoidCallback? onCancelPressed;

  const JobListingCard({
    super.key,
    this.job,
    this.jobId,
    this.title,
    this.company,
    this.location,
    this.salary,
    this.jobType,
    this.workType,
    this.status,
    required this.onTap,
    this.buttonText,
    this.buttonColor,
    this.onCancelPressed,
  });

  @override
  State<JobListingCard> createState() => _JobListingCardState();
}

class _JobListingCardState extends State<JobListingCard> {
  final JobService _jobService = JobService();
  bool _isFavorited = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Use post-frame callback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFavoriteStatus();
    });
  }

  void _checkFavoriteStatus() {
    String? jobId;
    
    if (widget.job != null) {
      jobId = widget.job!.id;
    } else {
      // Try to get the jobId from the JobListingCard parameters
      jobId = widget.jobId;
    }
    
    if (jobId == null || jobId.isEmpty) return;
    
    _jobService.isJobFavorited(jobId).listen((isFavorited) {
      if (mounted) {
        setState(() {
          _isFavorited = isFavorited;
        });
      }
    });
  }

  Future<void> _toggleFavorite() async {
    String? jobId;
    
    if (widget.job != null) {
      jobId = widget.job!.id;
    } else {
      // Try to get the jobId from the JobListingCard parameters
      // This is likely an application card from applications_history_page.dart
      jobId = widget.jobId;
    }
    
    if (jobId == null || jobId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن حفظ هذه الوظيفة')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current status before toggling
      final wasBookmarked = _isFavorited;
      
      // Toggle favorite status
      await _jobService.toggleFavoriteJob(jobId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(wasBookmarked 
              ? 'تم إزالة الوظيفة من المحفوظات' 
              : 'تم حفظ الوظيفة بنجاح'),
            backgroundColor: const Color(0xFF4CA6A8),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error if something goes wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = widget.job?.title ?? widget.title ?? '';
    final displayCompany = widget.job?.company ?? widget.company ?? '';
    final displayLocation = widget.job?.location ?? widget.location ?? {};
    final displaySalary = widget.job?.salary ?? widget.salary ?? {};
    final displayJobType = widget.job?.type ?? widget.jobType ?? '';
    final displayWorkType = widget.job?.workType ?? widget.workType ?? '';
    final displayButtonText = widget.buttonText ?? 'عرض التفاصيل';
    final displayButtonColor = widget.buttonColor ?? Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 319,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2D99AAC5),
              blurRadius: 62,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 168,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (widget.onCancelPressed != null)
                                GestureDetector(
                                  onTap: widget.onCancelPressed,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFEEEE),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xFFE53935),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: _isLoading ? null : _toggleFavorite,
                                child: _isLoading 
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CA6A8)),
                                      ),
                                    )
                                  : widget.job != null || widget.jobId != null
                                    ? SvgPicture.asset(
                                        'assets/media/icons/bookmark.svg',
                                        width: 24,
                                        height: 24,
                                        colorFilter: ColorFilter.mode(
                                          _isFavorited ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
                                          BlendMode.srcIn,
                                        ),
                                      )
                                    : const SizedBox(width: 24, height: 24),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              const Text(
                                'شهريا',
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 10,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                '${displaySalary['amount']} ${displaySalary['currency']} /',
                                style: const TextStyle(
                                  color: Color(0xFF1A1D1E),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                displayTitle,
                                style: const TextStyle(
                                  color: Color(0xFF1A1D1E),
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 33,
                                height: 33,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFF3F3F3),
                                  shape: OvalBorder(),
                                ),
                                child: const Icon(Icons.business, color: Color(0xFF6A6A6A)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                displayLocation['city'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 2,
                                height: 2,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF6A6A6A),
                                  shape: OvalBorder(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayCompany,
                                style: const TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF6F7F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          displayJobType,
                          style: const TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 10,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF6F7F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          displayWorkType,
                          style: const TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 10,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: displayButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        displayButtonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 