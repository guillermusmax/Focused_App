import 'package:flutter/material.dart';

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
        height: 10.0, // Ajuste de altura de la tarjeta
        width: 100.0, // Ajuste de ancho de la tarjeta
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor, // Color de fondo
          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 40.0, // Tamaño del icono
            ),
            const SizedBox(height: 8.0), // Espaciado entre el icono y el texto
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0, // Tamaño más pequeño para el texto
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
