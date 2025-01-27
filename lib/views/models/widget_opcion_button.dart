import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomButton extends StatelessWidget {
  final String title; // Parámetro title reintroducido
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.title, // Asegúrate de proporcionar este parámetro al instanciar el widget
    required this.text,
    required this.icon,
    this.backgroundColor = const Color(0xFF3CA2A2),
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Texto en la parte superior izquierda
            Align(
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Icono en la parte inferior izquierda
            Align(
              alignment: Alignment.bottomLeft,
              child: Icon(
                icon,
                size: 60,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
