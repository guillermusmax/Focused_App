import 'package:flutter/material.dart';
import 'package:focused_app/api/models/auth_storage.dart'; // Para manejar el token
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/faq_view.dart';
import 'package:focused_app/views/auth/login_view.dart';
import 'package:focused_app/views/nav_screens/appointment/appointment_view.dart';
import 'package:focused_app/views/nav_screens/home_screen.dart';
import 'package:focused_app/views/nav_screens/medication/medication_view.dart';
import 'package:focused_app/views/nav_screens/pomodoro/pomodoro_view.dart';
import 'package:focused_app/views/nav_screens/task/task_category_view.dart';
import 'package:focused_app/views/nav_screens/flashcards/flashcards_category_view.dart';
import 'package:focused_app/views/nav_screens/meditation/meditation_select.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa traducciones
import 'package:focused_app/main.dart'; // Para cambiar el idioma
import '../nav_screens/profile/profile_view.dart';

class WidgetSideBar extends StatelessWidget {
  const WidgetSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthStorage authStorage = AuthStorage();

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        backgroundColor: secondaryColor,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 60),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/icons/Focused_Icon.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FAQScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded,
                  color: textPrimaryColor),
              title: Text(S.current.profile,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const EditProfilePopup(); // Muestra el popup
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: textPrimaryColor),
              title: Text(S.current.home,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomeScreen();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: textPrimaryColor),
              title: Text(S.current.pomodoro,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const PomodoroView();
                  },
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books, color: textPrimaryColor),
              title: Text(S.current.flashcards,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlashCardCategoryView(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
              const Icon(Icons.medical_services, color: textPrimaryColor),
              title: Text(S.current.medication,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MedicationView();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist, color: textPrimaryColor),
              title: Text(S.current.toDo,
                  maxLines: 1,
                  style: const TextStyle(color: textPrimaryColor)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TaskCategoryView();
                }));
              },
            ),
            ListTile(
              leading:
              const Icon(Icons.self_improvement, color: textPrimaryColor),
              title: Text(
                S.current.meditation,
                maxLines: 1,
                style: const TextStyle(color: textPrimaryColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeditationSelectionScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
              const Icon(Icons.calendar_today, color: textPrimaryColor),
              title: Text(
                S.current.appointment,
                maxLines: 1,
                style: const TextStyle(color: textPrimaryColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentView(),
                  ),
                );
              },
            ),
            SizedBox(height: 2), // O ajusta según el espacio necesario
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      MyApp.of(context)?.setLocale(const Locale('en'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      'English',
                      style: TextStyle(color: textPrimaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      MyApp.of(context)?.setLocale(const Locale('es'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      'Español',
                      style: TextStyle(color: textPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: Text(S.current.logout,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.orange)),
                onTap: () async {
                  await authStorage.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
