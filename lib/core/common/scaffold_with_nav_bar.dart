import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../../navigation/view/widgets/custom_bottom_navbar.dart';

/// Scaffold wrapper untuk StatefulShellRoute yang menyediakan Docked Bottom Navigation Bar
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(BuildContext context, int index) {
    context.read<NavigationProvider>().setTabIndex(index);
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      extendBody: false,
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
