import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'dart:math'; // Para la aleatoriedad en el nivel 4
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/views/nav_screens/flashcards/Flash_card_level_detail_screen.dart';
import 'package:focused_app/views/nav_screens/flashcards/all_flashcard_screen.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Importación de las traducciones

class FlashcardLevelScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;

  const FlashcardLevelScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  _FlashcardLevelScreenState createState() => _FlashcardLevelScreenState();
}

class _FlashcardLevelScreenState extends State<FlashcardLevelScreen> {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();

  List<Map<String, dynamic>> flashcards = [];
  bool _isLoading = true;
  String? _token;
// Cambio el tipo a List<Map<String, dynamic>> en flashcardsByLevel
  List<List<Map<String, dynamic>>> flashcardsByLevel = [
    [], // Nivel 1
    [], // Nivel 2
    [], // Nivel 3
    []  // Nivel 4: "Review what you've learned"
  ];


  @override
  void initState() {
    super.initState();
    _fetchFlashcards();
  }

  Future<void> _fetchFlashcards() async {
    try {
      final String? token = await _authStorage.getToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        setState(() {
          _token = token;
        });

        final data = await _apiService.getFlashcardsByCategory(token, widget.categoryId);

        if (data != null && data.isNotEmpty) {
          // Limpiar los niveles antes de asignar nuevos flashcards
          setState(() {
            flashcardsByLevel = [[], [], [], []];
          });

          // Organizar flashcards en los niveles correspondientes
          for (var card in data) {
            final int level = card['level'] ?? 1; // Nivel predeterminado: 1
            if (level >= 1 && level <= 4) {
              flashcardsByLevel[level - 1].add(card);
            } else {
              print('Nivel desconocido para flashcard: ${card['id']}');
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.current.noFlashcardsFound)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.invalidToken)),
        );
      }
    } catch (e) {
      print("Error al obtener flashcards: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorLoading)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  void _showAddFlashcardPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            S.current.createNewFlashcard,
            style: const TextStyle(color: textTertiaryColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: S.current.question,
                    labelStyle: const TextStyle(color: textTertiaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: textTertiaryColor),
                    ),
                  ),
                ),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: S.current.answer,
                    labelStyle: const TextStyle(color: textTertiaryColor),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: textTertiaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                S.current.cancel,
                style: const TextStyle(color: textTertiaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  final success = await _apiService.createFlashcard(
                    _token!,
                    widget.categoryId,
                    questionController.text,
                    answerController.text,
                  );

                  if (success) {
                    Navigator.of(context).pop();
                    _fetchFlashcards(); // Refresca la lista de flashcards
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.current.createNewFlashcard)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.current.errorCreatingFlashcard)),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: textTertiaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(S.current.save),
            ),
          ],
        );
      },
    );
  }


  void updateFlashcardLevel(Map<String, dynamic> flashcard, int newLevel) {
    setState(() {
      final currentLevel = int.tryParse(flashcard['level']?.toString() ?? '1') ?? 1;

      // Eliminar la flashcard del nivel actual
      flashcardsByLevel[currentLevel - 1].remove(flashcard);

      // Mover la flashcard al nuevo nivel
      if (newLevel >= 1 && newLevel <= flashcardsByLevel.length) {
        flashcard['level'] = newLevel.toString();
        flashcardsByLevel[newLevel - 1].add(flashcard);
      }
    });
  }



  void deleteFlashcardFromLevel(int level, int index) {
    setState(() {
      flashcardsByLevel[level].removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${S.current.levels} - ${widget.categoryName}',
          style: const TextStyle(color: textTertiaryColor),
        ),
        backgroundColor: backgroundColor,
      ),
      drawer: const WidgetSideBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              children: [
                _buildLevelCard(
                    context, S.current.level1, flashcardsByLevel[0], 0),
                _buildLevelCard(
                    context, S.current.level2, flashcardsByLevel[1], 1),
                _buildLevelCard(
                    context, S.current.level3, flashcardsByLevel[2], 2),
                _buildReviewLevelCard(
                  context,
                  S.current.reviewWhatYouLearned,
                  flashcardsByLevel[3],
                  3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textPrimaryColor,
                    ),
                    onPressed: _showAddFlashcardPopup,
                    child: Text(S.current.createNewFlashcard),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: textPrimaryColor,
                    ),
                    onPressed: () {
                      //final allFlashcards =flashcardsByLevel.expand((x) => x).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllFlashcardsScreen(
                            categoryId: widget.categoryId, // ID de la categoría
                            categoryName: widget.categoryName, // Nombre de la categoría
                          ),
                        ),
                      );
                    },
                    child: Text(S.current.viewAllFlashcards),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }

  Widget _buildLevelCard(
      BuildContext context, String levelText, List<Map<String, dynamic>> flashcards, int levelIndex) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Card(
        color: secondaryColor,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            levelText,
            style: const TextStyle(
              color: textPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: textPrimaryColor),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashCardLevelDetailScreen(
                  level: levelIndex + 1,
                  flashcards: flashcards, // Pasamos la lista de flashcards
                  onUpdateLevel: updateFlashcardLevel,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewLevelCard(
      BuildContext context, String levelText, List<Map<String, dynamic>> flashcards, int levelIndex) {
    return SizedBox(
      width: 300,
      height: 200,
      child: Card(
        color: secondaryColor,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          title: Text(
            levelText,
            style: const TextStyle(
              color: textPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.shuffle, color: textPrimaryColor),
          onTap: () {
            final randomFlashcards = [...flashcards]..shuffle(Random());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashCardLevelDetailScreen(
                  level: levelIndex + 1,
                  flashcards: randomFlashcards,
                  onUpdateLevel: updateFlashcardLevel,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
