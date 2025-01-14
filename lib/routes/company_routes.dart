class CompanyRoutes {
  static String applicantsWithId(String jobId) => '/company/applicants/$jobId';
  
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Dynamic route with parameters
      '/company/applicants/:jobId': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map;
        return ApplicantsPage(jobId: args['jobId']);
      },
    };
  }
}

// Usage in navigation:
Navigator.pushReplacementNamed(
  context,
  CompanyRoutes.applicantsWithId('job_123'),
  arguments = {'jobId': 'job_123'},
); 