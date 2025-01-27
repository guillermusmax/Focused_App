import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/nav_screens/appointment/appointment_view.dart';
import 'package:focused_app/views/nav_screens/home_screen.dart';
import 'package:focused_app/views/nav_screens/pomodoro/pomodoro_view.dart';
import 'package:focused_app/views/nav_screens/task/task_category_view.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones

class WidgetBottomNavBar extends StatelessWidget {
  const WidgetBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: BottomAppBar(
        color: secondaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildNavItem(
                context,
                icon: Icons.home,
                label: S.current.home,
                destination: const HomeScreen(),
              ),
              _buildNavItem(
                context,
                icon: Icons.timer,
                label: S.current.pomodoro,
                destination: const PomodoroView(),
              ),
              _buildNavItem(
                context,
                icon: Icons.checklist,
                label: S.current.taskManager,
                destination: const TaskCategoryView(),
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today,
                label: S.current.appointments,
                destination: const AppointmentView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget destination,
  }) {
    return Tooltip(
      message: label,
      child: IconButton(
        icon: Icon(icon, color: textPrimaryColor),
        onPressed: () {
          // Evitar acumulación de vistas
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => destination),
            (route) => true,
          );
        },
      ),
    );
  }
}
