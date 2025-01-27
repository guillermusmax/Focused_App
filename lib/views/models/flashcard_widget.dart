import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para soporte de traducciones

class FlashCardWidget extends StatelessWidget {
  final String question;
  final String answer;
  final int level;
  final GlobalKey<FlipCardState> flipCardKey; // Añadimos flipCardKey

  const FlashCardWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.level,
    required this.flipCardKey, // Lo agregamos a los parámetros requeridos
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
        key: flipCardKey, // Usamos el flipCardKey aquí
        direction: FlipDirection.HORIZONTAL,
        front: _buildCardContent(context, question),
        back: _buildCardContent(context, answer),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, String text) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Container(
        width: 350, // Ajusta el ancho
        height: 250, // Ajusta la altura
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
