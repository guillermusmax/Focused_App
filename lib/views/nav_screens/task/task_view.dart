import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para las traducciones
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_pop_up.dart';
import 'package:focused_app/views/models/widget_rectangle_darkgreen.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/views/models/task_item_widget.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:focused_app/api/state_models.dart';

class TaskView extends StatefulWidget {
  final String categoryName; // Recibe el nombre de la categoría
  final int categoryId; // Recibe el ID de la categoría

  const TaskView({super.key, required this.categoryName, required this.categoryId});

  @override
  _TaskCategoryViewState createState() => _TaskCategoryViewState();
}

class _TaskCategoryViewState extends State<TaskView> {
  final TextEditingController taskController = TextEditingController();
  DateTime? selectedDateTime;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks(widget.categoryId); // Cargar las tareas iniciales
    });
  }


  void _showAddTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          controller: taskController,
          title: 'Agregar Tarea',
          buttonText: 'Agregar',
          onSave: () {
            if (taskController.text.isNotEmpty && selectedDateTime != null) {
              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
              taskProvider.addTask(
                widget.categoryId,
                taskController.text,
                selectedDateTime!,
              );
              taskController.clear();
              Navigator.of(context).pop();
              Future.delayed(Duration(milliseconds: 150), () {
                _refreshTasks();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Por favor, completa todos los campos.')),
              );
            }
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          onDateSelected: (dateTime) {
            setState(() {
              selectedDateTime = dateTime;
            });
          },
        );
      },
    );
  }


  void _showEditTaskPopup(Map<String, dynamic> task) {
    final TextEditingController titleController = TextEditingController(text: task['title']);
    final TextEditingController descriptionController = TextEditingController(text: task['description'] ?? '');
    final TextEditingController priorityController = TextEditingController(text: task['priority']?.toString() ?? '0');

    // Asegúrate de que el formato de 'due_date' sea compatible con DateTime.parse
    DateTime? selectedDate = task['due_date'] != null ? DateTime.tryParse(task['due_date']) : null;
    TimeOfDay? selectedTime = selectedDate != null ? TimeOfDay.fromDateTime(selectedDate) : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Editar Tarea',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textTertiaryColor,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        style: const TextStyle(
                          color: textPrimaryColor,
                          fontSize: 13,
                        ),
                        selectedDate == null
                            ? 'Seleccionar Fecha'
                            : 'Fecha: ${selectedDate!.toLocal()}'.split(' ')[1],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(
                        style: const TextStyle(
                          color: textPrimaryColor,
                          fontSize: 13,
                        ),
                        selectedTime == null
                            ? 'Seleccionar Hora'
                            : 'Hora: ${selectedTime!.format(context)}',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: const TextStyle(
                  color: textTertiaryColor,
                  fontSize: 13,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                final priority = int.tryParse(priorityController.text);

                if (priority != null && selectedDate != null && selectedTime != null) {
                  final DateTime dueDate = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedTime!.hour,
                    selectedTime!.minute,
                  );

                  taskProvider.updateTask(
                    task['id'],
                    titleController.text,
                    widget.categoryId,
                    description: descriptionController.text,
                    priority: priority,
                    dueDate: dueDate,
                  );
                  Navigator.pop(context);
                  // Agregar un delay antes de refrescar las tareas
                  Future.delayed(const Duration(milliseconds: 150), () {
                    _refreshTasks();
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos.')),
                  );
                }
              },
              child: Text(
                'Guardar',
                style: const TextStyle(
                  color: textPrimaryColor,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void _refreshTasks() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks(widget.categoryId);
  }

  void _toggleTaskComplete(Map<String, dynamic> task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.updateTaskStatus(task['id'], widget.categoryId);
  }

  void _showDeleteTaskPopup(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            S.current.confirmDelete,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textTertiaryColor,
            ),
          ),
          content: Text(
            S.current.deleteTaskConfirmation,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    S.current.cancel,
                    style: const TextStyle(
                      color: textTertiaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                    final success = await taskProvider.deleteTask(task['id'], widget.categoryId);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.current.deleteTask)),
                      );

                      // Aquí se hace el fetch nuevamente tras la eliminación exitosa
                      await taskProvider.fetchTasks(widget.categoryId);

                      // Actualiza la UI para reflejar los cambios
                      setState(() {});
                        Future.delayed(Duration(milliseconds: 150), () {
                        _refreshTasks();
                      });
                      Navigator.pop(context); // Cierra el popup de confirmación
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.current.errorDeletingFlashcard)),
                      );
                    }
                  },
                  child: Text(
                    S.current.delete,
                    style: const TextStyle(
                      color: textPrimaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
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
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "To-Do",
              style: const TextStyle(color: textTertiaryColor),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                  Future.delayed(Duration(milliseconds: 150), () {
                    _refreshTasks();
                  });
              },
            ),
          ],
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomRectangle(
                  title: widget.categoryName,
                  buttonText: S.current.addTask,
                  backgroundColor: secondaryColor,
                  buttonColor: backgroundColor,
                  textColor: textPrimaryColor,
                  iconColor: backgroundColor,
                  onPressed: _showAddTaskPopup,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Consumer<TaskProvider>(
                      builder: (context, taskProvider, _) {
                        if (taskProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final tasks = taskProvider.tasks;

                        if (tasks.isEmpty) {
                          return Center(
                            child: Text(
                              S.current.noTasks,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];

                              // Aplicamos la misma lógica de manejo de fecha que en _showEditTaskPopup
                              DateTime? selectedDate = task['due_date'] != null
                                  ? DateTime.tryParse(task['due_date'])
                                  : null;
                              TimeOfDay? selectedTime = selectedDate != null
                                  ? TimeOfDay.fromDateTime(selectedDate)
                                  : null;

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TaskItemWidget(
                                  key: ValueKey(task['id']),
                                  taskText: task['title'],
                                  isCompleted: task['status'] == 1,
                                  onEdit: () => _showEditTaskPopup(task),
                                  onDelete: () {
                                    _showDeleteTaskPopup(task);
                                  },
                                  onToggleComplete: () => _toggleTaskComplete(task),
                                  dueDate: selectedDate, // Se pasa el selectedDate formateado
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.orangeAccent,
                onPressed: _showAddTaskPopup,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}
