import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_pop_up.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_rectangle_darkgreen.dart';
import 'package:focused_app/views/models/widget_rectangle_green.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/views/nav_screens/task/task_view.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import '../../../api/state_models.dart';

class TaskCategoryView extends StatefulWidget {
  const TaskCategoryView({super.key});

  @override
  _TaskCategoryViewState createState() => _TaskCategoryViewState();
}

class _TaskCategoryViewState extends State<TaskCategoryView> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Evita actualizar la UI mientras se está construyendo
    Future.microtask(() {
      if (mounted) {
        Provider.of<TaskCategoryState>(context, listen: false).fetchCategories();
      }
    });
  }

  void _showPopup({int? categoryId, String? initialName}) {
    final isEditing = categoryId != null;
    nameController.text = initialName ?? "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final taskCategoryState = Provider.of<TaskCategoryState>(context, listen: false);

        return CustomPopup(
          controller: nameController,
          title: isEditing ? S.current.editCategory : S.current.addCategory,
          buttonText: isEditing ? S.current.flashcardUpdated : S.current.save,
          isEditing: isEditing,
          onSave: () {
            if (nameController.text.isNotEmpty) {
              if (isEditing) {
                taskCategoryState.updateCategory(
                  taskCategoryState.token!,
                  categoryId,
                  nameController.text,
                );
              } else {
                taskCategoryState.createCategory(nameController.text);
              }
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.current.selectDueDate)),
              );
            }
          },
          onDelete: () async {
            if (isEditing) {
              await taskCategoryState.deleteCategory(
                taskCategoryState.token!,
                categoryId,
              );
              Navigator.of(context).pop();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
          isPomodoroView: false,
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
          S.current.todoCategories,
          style: const TextStyle(color: textTertiaryColor),
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Consumer<TaskCategoryState>(
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;
              if (constraints.maxWidth >= 1200) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth >= 800) {
                crossAxisCount = 3;
              } else {
                crossAxisCount = 2;
              }

              return Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 16,
                    right: 16,
                    child: CustomRectangle(
                      title: S.current.todoCategories,
                      buttonText: S.current.add,
                      backgroundColor: secondaryColor,
                      buttonColor: backgroundColor,
                      textColor: textPrimaryColor,
                      iconColor: backgroundColor,
                      onPressed: () => _showPopup(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 100.0, left: 8.0, right: 8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
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
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (_) {
                                      final taskProvider = TaskProvider();
                                      Future.delayed(const Duration(milliseconds: 200), () {
                                        taskProvider.fetchTasks(category['id']);
                                      });
                                      return taskProvider;
                                    },
                                    child: TaskView(
                                      categoryName: category['name'],
                                      categoryId: category['id'],
                                    ),
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
          );
        },
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}
