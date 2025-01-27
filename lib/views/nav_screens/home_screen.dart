import 'package:flutter/material.dart';
import 'package:focused_app/api/state_models.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:focused_app/views/nav_screens/medication/medication_view.dart';
import 'package:focused_app/views/nav_screens/meditation/meditation_select.dart';
import 'package:focused_app/views/nav_screens/pomodoro/pomodoro_view.dart';
import 'package:focused_app/views/nav_screens/task/task_category_view.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../models/widget_side_bar.dart';
import '../models/widget_bottom_navbar.dart';
import '../models/widget_opcion_button.dart';
import 'appointment/appointment_view.dart';
import 'flashcards/flashcards_category_view.dart';
import 'notifications/notifications_view.dart';
import 'package:auto_size_text/auto_size_text.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
    });
  }

  void _showNotificationSidebar(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const NotificationSidebarScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final notificationProvider = Provider.of<NotificationProvider>(context);
    // notificationProvider.fetchNotifications();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(''),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, notificationProvider, _) {
              bool hasNotifications = notificationProvider.notifications.isNotEmpty;
              return IconButton(
                icon: Icon(
                  hasNotifications ? Icons.notifications_active : Icons.notifications,
                  color: secondaryColor,
                ),
                onPressed: () {
                  _showNotificationSidebar(context);
                },
              );
            },
          ),
        ],
      ),
      drawer: const WidgetSideBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto "Hi User! Welcome to Focused"
            AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${S.of(context).hiUser}\n',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textTertiaryColor,
                    ),
                  ),
                  TextSpan(
                    text: S.of(context).welcomeMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: textTertiaryColor,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              minFontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),

            // Rectángulo de bienvenida
            CustomRectangle(
              title: S.of(context).welcome,
              backgroundColor: secondaryColor,
            ),
            const SizedBox(height: 20),

            // Título "Tools"
            AutoSizeText(
              S.of(context).tools,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: textSecondaryColor,
              ),
              maxLines: 1,
              minFontSize: 16,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),

            // Botones
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).pomodoro,
                        icon: Icons.timer,
                        backgroundColor: primaryColor,
                        text: S.of(context).pomodoro,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const PomodoroView();
                              }));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).toDo,
                        icon: Icons.checklist,
                        backgroundColor: primaryColor,
                        text: S.of(context).toDo,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const TaskCategoryView();
                              }));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).meditation,
                        icon: Icons.self_improvement,
                        backgroundColor: primaryColor,
                        text: S.of(context).meditation,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const MeditationSelectionScreen();
                              }));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).appointments,
                        icon: Icons.calendar_today,
                        backgroundColor: primaryColor,
                        text: S.of(context).appointments,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const AppointmentView();
                              }));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).flashcards,
                        icon: Icons.library_books,
                        backgroundColor: primaryColor,
                        text: S.of(context).flashcards,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const FlashCardCategoryView();
                              }));
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        title: S.of(context).medication,
                        icon: Icons.medical_services,
                        backgroundColor: primaryColor,
                        text: S.of(context).medication,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const MedicationView();
                              }));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}

class CustomRectangle extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  final double iconSize;

  const CustomRectangle({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.iconSize = 24.0,
  });

  @override
  _CustomRectangleState createState() => _CustomRectangleState();
}

class _CustomRectangleState extends State<CustomRectangle> {
  int _currentIndex = 0;
  bool _isDisposed = false; // Bandera para detener el ciclo

  final List<Map<String, dynamic>> _options = [
    {'text': 'Try Pomodoro', 'icon': Icons.timer},
    {'text': 'Try To do', 'icon': Icons.checklist},
    {'text': 'Try Meditation', 'icon': Icons.self_improvement},
    {'text': 'Try Appointments', 'icon': Icons.calendar_today},
    {'text': 'Try Flashcards', 'icon': Icons.library_books},
    {'text': 'Try Medication', 'icon': Icons.medical_services},
  ];

  @override
  void initState() {
    super.initState();
    _changeTextAndIcon();
  }

  void _changeTextAndIcon() async {
    while (!_isDisposed) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _options.length;
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Detener el ciclo
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _options[_currentIndex]['text'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Icon(
            _options[_currentIndex]['icon'],
            size: widget.iconSize * 3,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

