import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa las traducciones
import 'package:focused_app/views/models/task_item_widget.dart';
import 'package:focused_app/views/models/timer_widget.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_pop_up.dart';
import 'package:focused_app/views/models/widget_pop_up_pomodoro_settings.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'dart:async';

enum PomodoroState { working, shortBreak, longBreak }

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController pomodoroController = TextEditingController();

  int workDuration = 25 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuration = 15 * 60;

  int minutes = 1;
  int seconds = 0;
  bool isWorking = true;
  double percent = 0;
  int totalSeconds = 60;
  Timer? _timer;
  bool isRunning = false;
  List<Map<String, dynamic>> tasks = [];
  int intervals = 2;

  void _showPomodoSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return WidgetPopUpPomodoroSettings(
          controller: pomodoroController,
          onSave: () {
            setState(() {});
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          onWorkDurationChanged: (value) {
            setState(() {
              workDuration = (value * 60).toInt();
            });
          },
          onShortBreakDurationChanged: (value) {
            setState(() {
              shortBreakDuration = (value * 60).toInt();
            });
          },
          onLongBreakDurationChanged: (value) {
            setState(() {
              longBreakDuration = (value * 60).toInt();
            });
          },
          onIntervalsChanged: (value) {
            setState(() {
              intervals = value;
            });
          },
        );
      },
    );
  }

  void _sortTasks() {
    tasks.sort((a, b) => a['isCompleted'] ? 1 : -1);
  }

  void _showAddTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          controller: taskController,
          onSave: () {
            if (taskController.text.isNotEmpty) {
              setState(() {
                tasks.add({
                  'id': DateTime.now().toString(),
                  'task': taskController.text,
                  'isCompleted': false
                });
                _sortTasks();
              });
              taskController.clear();
            }
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          title: S.current.addTask,
          buttonText: S.current.add,
          isPomodoroView: true, // Indica que es para PomodoroView
        );
      },
    );
  }


  void _showEditTaskPopup(int index) {
    taskController.text = tasks[index]['task'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          controller: taskController,
          onSave: () {
            setState(() {
              tasks[index]['task'] = taskController.text;
            });
            taskController.clear();
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
          title: S.current.editTask, // Texto traducible
          buttonText: S.current.save,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Stack(
          children: [
            Text(S.current.pomodoro), // Texto traducible
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _showPomodoSettings();
                  },
                  child: const Icon(Icons.settings),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: TimerWidget(
                  workDuration: workDuration,
                  shortBreakDuration: shortBreakDuration,
                  longBreakDuration: longBreakDuration,
                  intervals: intervals,
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return TaskItemWidget(
                            key: ValueKey(tasks[index]['id']),
                            taskText: tasks[index]['task'],
                            isCompleted: tasks[index]['isCompleted'],
                            onEdit: () {
                              _showEditTaskPopup(index);
                            },
                            onDelete: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                            onToggleComplete: () {
                              setState(() {
                                tasks[index]['isCompleted'] =
                                    !tasks[index]['isCompleted'];
                                _sortTasks();
                              });
                            },
                          );
                        },
                      ),
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
                backgroundColor: Colors.orangeAccent,
                onPressed: _showAddTaskPopup,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}
