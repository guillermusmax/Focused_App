import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart'; // Importa el BottomNavBar
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones

class FlashcardScreen extends StatefulWidget {
  final int initialLevel; // El nivel inicial de las tarjetas

  const FlashcardScreen({super.key, required this.initialLevel});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;

  // Lista de flashcards con niveles
  List<Flashcard> flashcards = [
    Flashcard(question: S.current.whatIsFlutter, level: 1),
    Flashcard(question: S.current.explainDart, level: 1),
    Flashcard(question: S.current.whatIsStateManagement, level: 2),
    Flashcard(question: S.current.whatIsWidgetTree, level: 3),
    Flashcard(question: S.current.explainHotReload, level: 4),
  ];

  void _markCorrect() {
    setState(() {
      // Sube la tarjeta de nivel si es correcta, hasta el nivel 5
      flashcards[currentIndex].level = (flashcards[currentIndex].level < 5)
          ? flashcards[currentIndex].level + 1
          : flashcards[currentIndex].level;
      currentIndex = (currentIndex + 1) % flashcards.length;
    });
  }

  void _markIncorrect() {
    setState(() {
      // Baja la tarjeta de nivel o la deja en el nivel 1
      flashcards[currentIndex].level = (flashcards[currentIndex].level > 1)
          ? flashcards[currentIndex].level - 1
          : 1;
      currentIndex = (currentIndex + 1) % flashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtra las tarjetas del nivel inicial
    final List<Flashcard> filteredCards =
        flashcards.where((card) => card.level == widget.initialLevel).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${S.current.level} ${widget.initialLevel} - ${S.current.flashcards}',
        ),
        backgroundColor: backgroundColor,
      ),
      body: filteredCards.isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tarjeta de pregunta
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        filteredCards[currentIndex % filteredCards.length]
                            .question,
                        style: const TextStyle(
                            fontSize: 24, color: textTertiaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Botones de "Correcto" e "Incorrecto"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _markIncorrect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: highlightColor,
                      ),
                      child: Text(S.current.incorrect),
                    ),
                    ElevatedButton(
                      onPressed: _markCorrect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(S.current.correct),
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: Text(
                S.current.noFlashcardsForThisLevel,
                style: const TextStyle(fontSize: 18, color: textTertiaryColor),
              ),
            ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}

class Flashcard {
  String question;
  int level;
  Flashcard({required this.question, this.level = 1});
}
