import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_management/Dashboard/dashboardSearch.dart';
import 'package:score_management/Homepage/homepageNisit.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [Homepage(), Dashboard()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: const BoxDecoration(
          color: Color(0xFFA1BC98),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _CustomNavButton(
                activeIcon: Icons.home,
                inactiveIcon: Icons.home_outlined,
                text: "Homepage",
                isActive: _currentIndex == 0,
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _CustomNavButton(
                activeIcon: Icons.assignment,
                inactiveIcon: Icons.assignment_outlined,
                text: "Dashboard",
                isActive: _currentIndex == 1,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomNavButton extends StatelessWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _CustomNavButton({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF1F3E0) : const Color(0xFFD2DCB6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color: const Color(0xFF778873),
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.kanit(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFF778873),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
