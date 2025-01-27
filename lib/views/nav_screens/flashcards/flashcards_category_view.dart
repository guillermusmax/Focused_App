import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
// import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_pop_up.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_rectangle_darkgreen.dart';
import 'package:focused_app/views/models/widget_rectangle_green.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/views/nav_screens/flashcards/flashcard_level_screen.dart';
import 'package:focused_app/generated/l10n.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

import '../../../api/state_models.dart';

class FlashCardCategoryView extends StatefulWidget {
  const FlashCardCategoryView({super.key});

  @override
  _FlashCardCategoryViewState createState() => _FlashCardCategoryViewState();
}

class _FlashCardCategoryViewState extends State<FlashCardCategoryView> {
  final ApiService apiService = ApiService();
  // final AuthStorage _authStorage = AuthStorage();
  List<Map<String, dynamic>> categories = [];
  final TextEditingController nameController = TextEditingController();
  // String? _token; // Token dinámico del usuario
  // bool _isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    Provider.of<FlashcardCategoryState>(context, listen: false).fetchCategories();
  }

  // Future<void> _fetchTokenAndCategories() async {
  //   try {
  //     final String? token = await _authStorage.getToken();
  //
  //     if (token != null && !JwtDecoder.isExpired(token)) {
  //       setState(() {
  //         _token = token; // Guarda el token
  //       });
  //       await _fetchCategories(); // Cargar categorías
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(S.current.invalidToken)),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error al obtener el token: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(S.current.errorLoading)),
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _fetchCategories() async {
  //   if (_token == null) return;
  //   final data = await apiService.getCategoriesFlashcards(_token!);
  //   if (data != null) {
  //     setState(() {
  //       categories = List<Map<String, dynamic>>.from(data);
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(S.current.errorLoading)),
  //     );
  //   }
  // }


  void _showPopup({int? categoryId, String? initialName}) {
    final isEditing = categoryId != null;
    nameController.text = initialName ?? "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          controller: nameController,
          title: isEditing ? S.current.editCategory : S.current.addCategory,
          buttonText: isEditing ? S.current.flashcardUpdated : S.current.save,
          isEditing: isEditing,
          onSave: () {
            if (nameController.text.isNotEmpty) {
              if (isEditing) {
                Provider.of<FlashcardCategoryState>(context, listen: false)
                    .updateCategory(
                  Provider.of<FlashcardCategoryState>(context, listen: false).token!,
                  categoryId,
                  nameController.text,
                );
              } else {
                Provider.of<FlashcardCategoryState>(context, listen: false)
                    .createCategory(nameController.text);
              }
              Navigator.of(context).pop();
            }
          },
          onDelete: () async {
            if (isEditing) {
              await Provider.of<FlashcardCategoryState>(context, listen: false)
                  .deleteCategory(
                Provider.of<FlashcardCategoryState>(context, listen: false).token!,
                categoryId,
              );
              Navigator.of(context).pop();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          S.current.flashcardCategories,
          style: const TextStyle(color: textTertiaryColor),
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Consumer<FlashcardCategoryState>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              Positioned(
                top: 10,
                left: 16,
                right: 16,
                child: CustomRectangle(
                  title: S.current.flashcardCategories,
                  buttonText: S.current.add,
                  backgroundColor: secondaryColor,
                  buttonColor: backgroundColor,
                  textColor: textPrimaryColor,
                  iconColor: backgroundColor,
                  onPressed: () => _showPopup(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, left: 8.0, right: 8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EditableButton(
                        initialText: category['name'],
                        categoryId: category['id'],
                        token: state.token!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardLevelScreen(
                                categoryName: category['name'],
                                categoryId: category['id'], // Pasamos el ID de la categoría
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}
