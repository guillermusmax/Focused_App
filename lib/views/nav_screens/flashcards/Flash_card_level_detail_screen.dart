import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/views/models/flashcard_widget.dart';
import 'package:focused_app/constants.dart';
import 'package:flip_card/flip_card.dart';
import 'package:focused_app/generated/l10n.dart';

class FlashCardLevelDetailScreen extends StatefulWidget {
  final int level;
  final List<Map<String, dynamic>> flashcards;
  final Function(Map<String, dynamic>, int) onUpdateLevel;

  const FlashCardLevelDetailScreen({
    super.key,
    required this.level,
    required this.flashcards,
    required this.onUpdateLevel,
  });

  @override
  _FlashCardLevelDetailScreenState createState() =>
      _FlashCardLevelDetailScreenState();
}

class _FlashCardLevelDetailScreenState
    extends State<FlashCardLevelDetailScreen> {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  int currentIndex = 0;
  String? _token;
  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _authStorage.getToken();
    if (token != null) {
      setState(() {
        _token = token;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.invalidToken)),
      );
    }
  }

  void _nextFlashcard() {
    setState(() {
      if (currentIndex < widget.flashcards.length - 1) {
        currentIndex++;
        _flipCardKey.currentState?.controller?.reset();
      }
    });
  }

  void _previousFlashcard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _flipCardKey.currentState?.controller?.reset();
      }
    });
  }


  void _markResponse(bool isCorrect) async {
    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.invalidToken)),
      );
      return;
    }

    final flashcard = widget.flashcards[currentIndex];
    final int flashcardId = flashcard['id'];

    final int? newLevel = await _apiService.updateFlashcardLevel(_token!, flashcardId, isCorrect);

    if (newLevel != null) {
      setState(() {
        flashcard['level'] = newLevel;
        widget.onUpdateLevel(flashcard, newLevel);
      });

      if (newLevel != widget.level) {
        setState(() {
          widget.flashcards.removeAt(currentIndex);
        });

        // Verificar si ya no quedan flashcards y mostrar el diálogo de finalización
        if (widget.flashcards.isEmpty) {
          Future.delayed(Duration(milliseconds: 300), () {
            _showCompletionDialog();
          });
          return; // Detener la ejecución para evitar acceso a índices inválidos
        }

        // Ajustar el índice si es necesario
        if (currentIndex >= widget.flashcards.length) {
          currentIndex = widget.flashcards.length - 1;
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorUpdatingFlashcard)),
      );
    }

    // Si aún hay flashcards, pasar a la siguiente
    if (widget.flashcards.isNotEmpty) {
      _moveToNextFlashcard();
    }
  }


  void _moveToNextFlashcard() {
    if (currentIndex < widget.flashcards.length - 1) {
      setState(() {
        currentIndex++;
        _flipCardKey.currentState?.controller?.reset();
      });
    } else {

    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            S.current.levelComplete,
            style: const TextStyle(color: textTertiaryColor),
          ),
          content: Text(
            S.current.reviewComplete,
            style: const TextStyle(color: textTertiaryColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                S.current.backToLevels,
                style: const TextStyle(color: textTertiaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${S.current.flashcards} - ${S.current.level} ${widget.level}',
          style: const TextStyle(color: textTertiaryColor),
        ),
        backgroundColor: backgroundColor,
      ),
      body: widget.flashcards.isNotEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlashCardWidget(
            question: widget.flashcards[currentIndex]['question']!,
            answer: widget.flashcards[currentIndex]['answer']!,
            level: widget.flashcards[currentIndex]['level'] is int
                ? widget.flashcards[currentIndex]['level']
                : int.parse(widget.flashcards[currentIndex]['level'].toString()),
            flipCardKey: _flipCardKey,
          ),
          const SizedBox(height: 20),

          // Mostrar botones de navegación solo en el nivel 4
          if (widget.level == 4) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _previousFlashcard : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlightColor,
                  ),
                  child: const Icon(Icons.arrow_back, color: backgroundColor),
                ),
                ElevatedButton(
                  onPressed: currentIndex < widget.flashcards.length - 1
                      ? _nextFlashcard
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  child: const Icon(Icons.arrow_forward, color: backgroundColor),
                ),
              ],
            ),
          ] else ...[
            // Mostrar botones de "Correcto" e "Incorrecto" en niveles distintos a 4
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _markResponse(false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlightColor,
                  ),
                  child: Text(
                    S.current.incorrect,
                    style: const TextStyle(color: backgroundColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _markResponse(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  child: Text(
                    S.current.correct,
                    style: const TextStyle(color: backgroundColor),
                  ),
                ),
              ],
            ),
          ],
        ],
      )
          : Center(
        child: Text(
          S.current.noCardsInLevel,
          style: const TextStyle(fontSize: 18, color: textTertiaryColor),
        ),
      ),
    );
  }
}
