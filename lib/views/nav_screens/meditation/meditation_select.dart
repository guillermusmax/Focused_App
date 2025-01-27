import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/views/nav_screens/meditation/meditation_reproductor.dart';
import 'package:focused_app/views/models/widget_rectangle_darkgreen.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones

class MeditationSelectionScreen extends StatelessWidget {
  const MeditationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          S.current.meditationSelection, // Traducción del título
          style: const TextStyle(
            color: textTertiaryColor,
          ),
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: CustomRectangle(
              title: S.current.selectMeditation, // Traducción del subtítulo
              buttonText: '',
              backgroundColor: secondaryColor,
              buttonColor: Colors.transparent,
              textColor: textPrimaryColor,
              iconColor: Colors.transparent,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              padding: const EdgeInsets.all(16.0),
              children: [
                // Guided Breathing
                MeditationCardWidget(
                  title: S.current.guidedBreathing, // Traducción
                  icon: Icons.self_improvement,
                  backgroundColor: primaryColor,
                  textColor: textPrimaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationAudioPlayerScreen(
                          audioTitle: S.current.guidedBreathing,
                          audioAsset:
                              'https://drive.google.com/uc?export=download&id=1z_9FdKJJs9IRFEfuTVy7B5XKs4IDSB7D',
                          meditationIcon: Icons.self_improvement,
                        ),
                      ),
                    );
                  },
                ),
                // Mindfulness
                MeditationCardWidget(
                  title: S.current.mindfulness, // Traducción
                  icon: Icons.spa,
                  backgroundColor: primaryColor,
                  textColor: textPrimaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationAudioPlayerScreen(
                          audioTitle: S.current.mindfulness,
                          audioAsset:
                              'https://drive.google.com/uc?export=download&id=1RgkChGfE88zTbocQdHsyZclnHyjl3WHY',
                          meditationIcon: Icons.spa,
                        ),
                      ),
                    );
                  },
                ),
                // Body Scan
                MeditationCardWidget(
                  title: S.current.bodyScan, // Traducción
                  icon: Icons.bubble_chart,
                  backgroundColor: primaryColor,
                  textColor: textPrimaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationAudioPlayerScreen(
                          audioTitle: S.current.bodyScan,
                          audioAsset:
                              'https://drive.google.com/uc?export=download&id=1No50qLYqVE4aPI40bdN9m-wSJ5IB7Zn3',
                          meditationIcon: Icons.bubble_chart,
                        ),
                      ),
                    );
                  },
                ),
                // Loving-Kindness
                MeditationCardWidget(
                  title: S.current.lovingKindness, // Traducción
                  icon: Icons.favorite,
                  backgroundColor: primaryColor,
                  textColor: textPrimaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MeditationAudioPlayerScreen(
                          audioTitle: S.current.lovingKindness,
                          audioAsset:
                              'https://drive.google.com/uc?export=download&id=1Z93MUYInj_wcGx3P7xhDiFw0IJO2FSP5',
                          meditationIcon: Icons.favorite,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}

class MeditationCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const MeditationCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.0,
        width: 120.0,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 40.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
