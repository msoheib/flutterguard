class CompanyBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onRouteChange; // Add custom route handler

  const CompanyBottomNavigation({
    required this.currentIndex,
    this.onRouteChange,
    super.key,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Use custom route handler if provided
    if (onRouteChange != null) {
      onRouteChange!(index);
      return;
    }

    // Default routing
    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, CompanyRoutes.applicants);
        break;
      // ...
    }
  }
}

// Usage in parent widget:
CompanyBottomNavigation(
  currentIndex = 1,
  onRouteChange = (index) {
    // Custom routing logic
    if (index == 1) {
      Navigator.pushNamed(context, '/your/custom/route');
    }
  },
) 