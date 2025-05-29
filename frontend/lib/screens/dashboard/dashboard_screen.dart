import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanzanian_bms/features/auth/application/auth_controller.dart';
import 'package:tanzanian_bms/screens/home_screen.dart'; // For Routes

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthController authController = Get.find();
  int selectedIndex = 0;
  bool isExpanded = false;

  // Placeholder modules - these will eventually have their own routes and screens
  final List<DashboardItem> dashboardItems = [
    DashboardItem(title: 'Home', icon: Icons.home, widget: const HomeScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        leadingWidth: 300,
        leading: Obx(() {
          final role = authController.currentUser.value?.role;
          final userImage = authController.currentUser.value?.imageUrl;
          final userName = authController.currentUser.value?.fullName ?? 'User';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  userImage ?? 'assets/images/user_icon.png',
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${role?.name.capitalizeFirst ?? 'Undefined'} '),
                    Text(' ${userName.capitalizeFirst}'),
                  ],
                ),
              ],
            ),
          );
        }),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.signOut();
              // Navigation to login screen is handled by the listener in AuthController or HomeScreen
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: Colors.blue,
            width: 70,
            child: NavigationRail(
              extended: false,
              destinations: [
                ...dashboardItems.map(
                  (item) => NavigationRailDestination(
                    icon: HoverMenuButton(
                      isExpanded: isExpanded,
                      menu: Column(
                        children: [
                          TextButton(onPressed: () {}, child: Text('Option 1')),
                          TextButton(onPressed: () {}, child: Text('Option 2')),
                        ],
                      ),
                      child: Icon(item.icon),
                    ),
                    label: Text(item.title),
                  ),
                ),
              ],
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },

              selectedIndex: selectedIndex,
            ),
          ),

          // Content area
          Expanded(child: dashboardItems[selectedIndex].widget),
        ],
      ),
    );
  }
}

class DashboardItem {
  final String title;
  final IconData icon;
  final Widget widget;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.widget,
  });
}

/// A button that shows a hoverable menu and optional submenu.
class HoverMenuButton extends StatefulWidget {
  final Widget child;
  final Widget? menu;
  final bool? isExpanded;
  final Function(bool state)? onChange;
  const HoverMenuButton({
    required this.child,
    this.menu,
    this.onChange,
    this.isExpanded,
    super.key,
  });

  @override
  State<HoverMenuButton> createState() => _HoverMenuButtonState();
}

class _HoverMenuButtonState extends State<HoverMenuButton> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _menuOverlay;

  bool _isHoveringButton = false;
  bool _isHoveringMenu = false;

  void _showMenuOverlay() {
    if (_menuOverlay != null) return;

    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _menuOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            top: offset.dy,
            left: offset.dx + renderBox.size.width + 8,
            child: MouseRegion(
              onEnter: (_) {
                _isHoveringMenu = true;
                widget.onChange?.call(true);
              },
              onExit: (_) {
                widget.onChange?.call(false);
                _isHoveringMenu = false;
                _checkRemoveOverlay();
              },
              child: Material(elevation: 8, child: widget.menu),
            ),
          ),
    );

    Overlay.of(context).insert(_menuOverlay!);
  }

  void _checkRemoveOverlay() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!_isHoveringButton &&
          !_isHoveringMenu &&
          (widget.isExpanded == false || widget.isExpanded == null)) {
        _menuOverlay?.remove();
        _menuOverlay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _buttonKey,
      onEnter: (_) {
        _isHoveringButton = true;
        _showMenuOverlay();
      },
      onExit: (_) {
        _isHoveringButton = false;
        _checkRemoveOverlay();
      },
      child: widget.child,
    );
  }
}
