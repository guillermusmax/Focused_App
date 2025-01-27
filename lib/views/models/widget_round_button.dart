import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback para definir la acción
  final Color color;
  final IconData icon;

  const RoundButton({
    super.key,
    required this.onPressed,
    this.color = highlightColor, // Color por defecto
    this.icon = Icons.add, // Ícono por defecto
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, size: 30, color: Colors.white),
    );
  }
}
