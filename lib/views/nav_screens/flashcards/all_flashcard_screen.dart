import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa las traducciones
import 'package:jwt_decoder/jwt_decoder.dart';

class AllFlashcardsScreen extends StatefulWidget {
  final int categoryId; // ID de la categoría seleccionada
  final String categoryName;

  const AllFlashcardsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _AllFlashcardsScreenState createState() => _AllFlashcardsScreenState();
}

class _AllFlashcardsScreenState extends State<AllFlashcardsScreen> {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();

  List<Map<String, dynamic>> flashcards = [];
  bool _isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _fetchFlashcards(); // Inicia la carga de flashcards
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
          setState(() {
            flashcards = List<Map<String, dynamic>>.from(data);
          });
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

  Future<void> _updateFlashcard(int flashcardId, String question, String answer) async {
    if (_token == null) return;
    final success = await _apiService.updateFlashcard(_token!, flashcardId, question, answer);
    if (success) {
      _fetchFlashcards();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.flashcardUpdated)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorUpdatingFlashcard)),
      );
    }
  }

  Future<void> _deleteFlashcard(int flashcardId) async {
    if (_token == null) return;
    final success = await _apiService.deleteFlashcard(_token!, flashcardId);
    if (success) {
      setState(() {
        flashcards.removeWhere((flashcard) => flashcard['id'] == flashcardId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.deleteFlashcard)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.errorCreatingFlashcard)),
      );
    }
  }

  void _showEditFlashcardDialog(int index) {
    final flashcard = flashcards[index];
    final TextEditingController questionController =
    TextEditingController(text: flashcard['question']);
    final TextEditingController answerController =
    TextEditingController(text: flashcard['answer']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            S.current.editFlashcard,
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
              onPressed: () {
                if (questionController.text.isNotEmpty &&
                    answerController.text.isNotEmpty) {
                  _updateFlashcard(
                    flashcard['id'],
                    questionController.text,
                    answerController.text,
                  );
                  Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${S.current.allFlashcards} - ${widget.categoryName}',
          style: const TextStyle(color: textTertiaryColor),
        ),
        backgroundColor: backgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : flashcards.isNotEmpty
          ? ListView.builder(
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: secondaryColor,
            child: ListTile(
              title: Text(
                flashcards[index]['question'] ?? S.current.noQuestion,
                style: const TextStyle(color: textPrimaryColor),
              ),
              subtitle: Text(
                '${flashcards[index]['answer'] ?? S.current.noAnswer}\n${S.current.level}: ${flashcards[index]['level'] ?? S.current.unknown}',
                style: const TextStyle(color: textSecondaryColor),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: primaryColor),
                    onPressed: () => _showEditFlashcardDialog(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: highlightColor),
                    onPressed: () =>
                        _deleteFlashcard(flashcards[index]['id']),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(
        child: Text(
          S.current.noFlashcardsAvailable,
          style: const TextStyle(color: textTertiaryColor),
        ),
      ),
    );
  }
}
