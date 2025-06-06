import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heronfit/core/router/app_routes.dart';
import 'package:heronfit/core/theme.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:heronfit/features/home/home_providers.dart'; // Unused import
import 'package:heronfit/features/booking/controllers/booking_providers.dart'; // Import for userActiveBookingProvider

class MainScreenWrapper extends ConsumerWidget {
  final Widget child;

  const MainScreenWrapper({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.home)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.booking)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.workout)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.progress)) {
      return 3;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 4;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, WidgetRef ref) async {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        final activeBooking = await ref.read(userActiveBookingProvider.future);
        bool hasActiveBooking = activeBooking != null;

        if (hasActiveBooking) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Active Booking Found'),
                  content: const Text(
                    'You already have an active booking. Please cancel your current booking or wait for it to complete before booking another session.',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('View Booking Details'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.push(AppRoutes.bookingDetails, extra: activeBooking.toJson());
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        // Optionally, navigate to home or do nothing
                        // context.go(AppRoutes.home);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          context.go(AppRoutes.booking); // Navigate to booking flow / activate pass screen
        }
        break;
      case 2:
        context.go(AppRoutes.workout);
        break;
      case 3:
        context.go(AppRoutes.progress);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context, ref),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> navItems = [
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 0 ? SolarIconsBold.home : SolarIconsOutline.home,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 1
              ? SolarIconsBold.calendar
              : SolarIconsOutline.calendar,
        ),
        label: 'Bookings',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 2
              ? SolarIconsBold.dumbbellLarge
              : SolarIconsOutline.dumbbellLarge,
        ),
        label: 'Workout',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 3 ? SolarIconsBold.graph : SolarIconsOutline.graph,
        ),
        label: 'Progress',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          currentIndex == 4 ? SolarIconsBold.user : SolarIconsOutline.user,
        ),
        label: 'Profile',
      ),
    ];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: HeronFitTheme.bgLight,
      selectedItemColor: HeronFitTheme.primary,
      unselectedItemColor: HeronFitTheme.textMuted,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 4.0,
      items: navItems,
    );
  }
}
