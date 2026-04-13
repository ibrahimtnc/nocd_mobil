import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ocdcoach/src/core/theme/app_colors.dart';
import 'package:ocdcoach/src/shared/providers/localization_provider.dart';

/// Main scaffold with bottom navigation
/// Provides bottom navigation bar for Home, History, and Settings
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationAsync = ref.watch(localizationProvider);

    return Scaffold(
      backgroundColor: AppColors.background, // Phase 4 solid background
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface, // White surface
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          elevation: 0, // Flat look - Phase 4
        items: localizationAsync.when(
          data: (service) => [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: service.getString('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: service.getString('history'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: service.getString('settings'),
            ),
          ],
          loading: () => [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          error: (_, __) => [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        ),
      ),
    );
  }
}

