import 'package:flutter/material.dart';

class CustomRectangle extends StatelessWidget {
  final String title;
  final String buttonText;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onPressed;
  final VoidCallback? onAddCategory; // Nueva función para agregar categorías

  const CustomRectangle({
    super.key,
    required this.title,
    required this.buttonText,
    required this.backgroundColor,
    required this.buttonColor,
    required this.textColor,
    required this.iconColor,
    required this.onPressed,
    this.onAddCategory, // Parámetro opcional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                buttonText,
                style: TextStyle(color: textColor, fontSize: 10),
              ),
              const SizedBox(width: 0.5),
              IconButton(
                icon: Icon(Icons.add, color: iconColor),
                onPressed: () {
                  onPressed();
                  if (onAddCategory != null) {
                    onAddCategory!(); // Llama a la función POST si está definida
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
