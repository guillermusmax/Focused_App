import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/api/timezone_service.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
//import 'package:timezone/data/latest.dart' as tzData;
//import 'package:timezone/timezone.dart' as tz;
import 'dart:async';


/// Estado para manejar flashcards
class FlashcardProvider with ChangeNotifier {
  List<List<Map<String, dynamic>>> _flashcardsByLevel = [
    [], // Nivel 1
    [], // Nivel 2
    [], // Nivel 3
    []  // Nivel 4
  ];

  List<List<Map<String, dynamic>>> get flashcardsByLevel => _flashcardsByLevel;

  void setFlashcardsByLevel(List<List<Map<String, dynamic>>> newFlashcards) {
    _flashcardsByLevel = newFlashcards;
    notifyListeners(); // Notifica a los widgets que escuchan este estado
  }

  void updateFlashcardLevel(Map<String, dynamic> flashcard, int newLevel) {
    final currentLevel = int.tryParse(flashcard['level']?.toString() ?? '1') ?? 1;

    // Eliminar del nivel actual
    if (currentLevel >= 1 && currentLevel <= _flashcardsByLevel.length) {
      _flashcardsByLevel[currentLevel - 1].remove(flashcard);
    }

    // Agregar al nuevo nivel
    if (newLevel >= 1 && newLevel <= _flashcardsByLevel.length) {
      flashcard['level'] = newLevel.toString();
      _flashcardsByLevel[newLevel - 1].add(flashcard);
    }

    notifyListeners(); // Actualiza la UI
  }
}

/// Estado para manejar la sesión de usuario
class UserProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _userInfo;

  String? get token => _token;
  Map<String, dynamic>? get userInfo => _userInfo;

  void setToken(String token) {
    _token = token;
    notifyListeners(); // Actualiza cualquier parte que dependa del token
  }

  void setUserInfo(Map<String, dynamic> userInfo) {
    _userInfo = userInfo;
    notifyListeners(); // Actualiza cualquier parte que dependa de la info de usuario
  }
}

/// Estado para manejar configuraciones globales
class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notifica a los widgets que escuchan
  }
}

class FlashcardState extends ChangeNotifier {
  List<Map<String, dynamic>> flashcards = [];

  void updateFlashcardLevel(int flashcardId, int newLevel) {
    final index = flashcards.indexWhere((flashcard) => flashcard['id'] == flashcardId);
    if (index != -1) {
      flashcards[index]['level'] = newLevel;
      notifyListeners(); // Notifica a los widgets que dependen de este estado
    }
  }

  void setFlashcards(List<Map<String, dynamic>> newFlashcards) {
    flashcards = newFlashcards;
    notifyListeners(); // Notifica a los widgets que dependen de este estado
  }
}


class MedicationState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  final TimezoneService _timezoneService = TimezoneService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _logs = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get logs => _logs;

  Future<void> fetchMedications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? token = await _authStorage.getToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        // Inicializar la base de datos de zonas horarias
        final TimezoneService _timezoneService = TimezoneService();
        // final String timeZone = tz.local.name;
        final String localTimeZone = await _timezoneService.getDeviceTimeZone();

        //print('Zona horaria utilizada: $localTimeZone'); // Depuración
        final medications = await _apiService.getMedicationsByDate(token, localTimeZone);

        if (medications != null) {
          _logs = _groupMedicationsByTime(medications);
        } else {
          _logs = [];
        }
      } else {
        _logs = [];
      }
    } catch (e) {
      //print('Error al obtener medicaciones: $e');
      _logs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  List<Map<String, dynamic>> _groupMedicationsByTime(List<dynamic> medications) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var med in medications) {
      // Convertir la hora programada a la hora local
      final time = DateFormat('HH:mm').format(DateTime.parse(med['scheduled_time']).toLocal());

      grouped[time] ??= [];
      grouped[time]?.add({
        'medlog_id': med['medlog_id'],
        'name': med['med_name'],
        'taken': med['taken'],
      });
    }

    return grouped.entries
        .map((entry) => {'time': entry.key, 'medications': entry.value})
        .toList();
  }

  Future<void> toggleMedication(int medlogId, bool taken) async {
    try {
      final String? token = await _authStorage.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        //print('Token inválido o expirado');
        return;
      }

      final String localTimeZone = await _timezoneService.getDeviceTimeZone();

      final bool success = await _apiService.updateMedicationTaken(token, medlogId, !taken, localTimeZone);
      if (success) {
        for (var log in _logs) {
          final medications = log['medications'] as List<Map<String, dynamic>>;
          for (var med in medications) {
            if (med['medlog_id'] == medlogId) {
              med['taken'] = !taken; // Cambiar el estado
              break;
            }
          }
        }
        notifyListeners();

        // Imprimir todas las medicaciones después de actualizar el estado
        //print('Lista de medicaciones actualizada:');
        for (var log in _logs) {
          //print('Hora: ${log['time']}');
          for (var med in log['medications']) {
            //print('  ID: ${med['medlog_id']}, Nombre: ${med['name']}, Tomada: ${med['taken']}');
          }
        }
      }
    } catch (e) {
      //print('Error al actualizar el estado de la medicación: $e');
    }
  }

}

class FlashcardCategoryState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  List<Map<String, dynamic>> _categories = [];
  String? _token;
  bool _isLoading = true;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? token = await _authStorage.getToken();
      if (token != null) {
        _token = token;
        final categoriesData = await _apiService.getCategoriesFlashcards(token);
        if (categoriesData != null) {
          _categories = List<Map<String, dynamic>>.from(categoriesData);
        }
      }
    } catch (e) {
      //('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCategory(String name) async {
    if (_token == null) return;

    try {
      final success = await _apiService.createCategoryFlashcards(_token!, name, 2);
      if (success) {
        fetchCategories(); // Refresca las categorías después de crear una
      }
    } catch (e) {
      //('Error creating category: $e');
    }
  }

  Future<bool> updateCategory(String token, int categoryId, String newName) async {
    try {
      final success = await _apiService.updateCategory(token, categoryId, newName);
      if (success) {
        final index = _categories.indexWhere((category) => category['id'] == categoryId);
        if (index != -1) {
          _categories[index]['name'] = newName;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      //('Error updating category: $e');
    }
    return false;
  }

  Future<bool> deleteCategory(String token, int categoryId) async {
    try {
      final success = await _apiService.deleteCategory(token, categoryId);
      if (success) {
        _categories.removeWhere((category) => category['id'] == categoryId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      //('Error deleting category: $e');
    }
    return false;
  }
}

class TaskCategoryState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  List<Map<String, dynamic>> _categories = [];
  String? _token;
  bool _isLoading = true;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get token => _token;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? token = await _authStorage.getToken();
      if (token != null) {
        _token = token;
        final categoriesData = await _apiService.getCategoriesTask(token);
        if (categoriesData != null) {
          _categories = List<Map<String, dynamic>>.from(categoriesData);
        }
      }
    } catch (e) {
      //('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCategory(String name) async {
    if (_token == null) return;

    try {
      final success = await _apiService.createCategoryTask(_token!, name);
      if (success) {
        fetchCategories(); // Refresca las categorías después de crear una
      }
    } catch (e) {
      //('Error creating category: $e');
    }
  }

  Future<bool> updateCategory(String token, int categoryId, String newName) async {
    try {
      final success = await _apiService.updateCategory(token, categoryId, newName);
      if (success) {
        final index = _categories.indexWhere((category) => category['id'] == categoryId);
        if (index != -1) {
          _categories[index]['name'] = newName;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      //('Error updating category: $e');
    }
    return false;
  }

  Future<bool> deleteCategory(String token, int categoryId) async {
    try {
      final success = await _apiService.deleteCategory(token, categoryId);
      if (success) {
        _categories.removeWhere((category) => category['id'] == categoryId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      //('Error deleting category: $e');
    }
    return false;
  }
}

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  DateTime? selectedDate;

  bool _isLoading = false;
  List<Map<String, dynamic>> _tasks = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get tasks => _tasks;

  Future<void> fetchTasks(int categoryId) async {
    _isLoading = true;
    notifyListeners(); // Notifica que el estado de carga ha iniciado.

    try {
      final String? token = await _authStorage.getToken();
      if (token == null) {
        throw Exception("Token no encontrado o inválido.");
      }

      // Inicializa las zonas horarias


      // Obtiene la zona horaria local
      final TimezoneService _timezoneService = TimezoneService();
      // final String timeZone = tz.local.name;
      final String localTimeZone = await _timezoneService.getDeviceTimeZone();

      //('Obteniendo tareas con timeZone: $timeZone');

      // Llama al servicio de API para obtener los datos
      final tasksData = await _apiService.getTasksByCategory(token, categoryId, localTimeZone);

      if (tasksData != null) {
        _tasks = List<Map<String, dynamic>>.from(tasksData); // Actualiza las tareas
      } else {
        _tasks = []; // Asegura que no haya datos residuales en caso de respuesta nula
      }
    } catch (e) {
      //('Error al obtener tareas: $e');
      _tasks = []; // Limpia la lista de tareas en caso de error
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica que la carga ha finalizado
    }
  }


  Future<void> addTask(int categoryId, String title, DateTime dueDate) async {
    try {
      final String? token = await _authStorage.getToken();
      if (token != null) {

        final TimezoneService _timezoneService = TimezoneService();
        // final String timeZone = tz.local.name;
        final String localTimeZone = await _timezoneService.getDeviceTimeZone();

        //('Creando tarea: $title en categoría $categoryId');

        final success = await _apiService.createTask(
          token,
          categoryId,
          title,
          description: 'Default description',
          priority: 0,
          dueDate: dueDate,
          timeZone: localTimeZone,
        );

        if (success) {
          //('Tarea creada exitosamente.');
          await fetchTasks(categoryId); // Refresca la lista de tareas
        }
      }
    } catch (e) {
      //('Error al agregar tarea: $e');
    }
  }

  Future<void> updateTask(
      int taskId,
      String title,
      int categoryId, {
        String? description,
        int? priority,
        DateTime? dueDate,
        int? status,
      }) async {
    try {
      final token = await _authStorage.getToken();
      if (token == null) return;


      // Obtiene la zona horaria local
      final TimezoneService _timezoneService = TimezoneService();
      // final String timeZone = tz.local.name;
      final String localTimeZone = await _timezoneService.getDeviceTimeZone();

      final success = await _apiService.updateTask(
        token,
        taskId,
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        status: status,
        timeZone: localTimeZone,
      );

      if (success) {
        await fetchTasks(categoryId);
      }
    } catch (e) {
      //('Error al actualizar tarea: $e');
    }
  }


  Future<bool> deleteTask(int taskId, int categoryId) async {
    try {
      final String? token = await _authStorage.getToken();
      if (token != null) {
        final success = await _apiService.deleteTask(token, taskId);
        if (success) {
          _tasks.removeWhere((task) => task['id'] == taskId);

          //("Tarea eliminada exitosamente.");

          notifyListeners(); // Notifica el cambio localmente

          // Refresca la lista de tareas de la categoría correspondiente
          fetchTasks(categoryId);

          notifyListeners(); // Notifica el cambio localmente

          return true;
        } else {
          //("Error: No se pudo eliminar la tarea en el servidor.");
        }
      } else {
        //("Error: Token no válido o no disponible.");
      }
    } catch (e) {
      //('Error al eliminar tarea: $e');
    }
    await fetchTasks(categoryId);

    return false;
  }


  Future<void> updateTaskStatus(int taskId, int categoryId) async {
    try {
      final token = await _authStorage.getToken();
      if (token == null) return;


      // Obtiene la zona horaria local
      final TimezoneService _timezoneService = TimezoneService();
      // final String timeZone = tz.local.name;
      final String localTimeZone = await _timezoneService.getDeviceTimeZone();

      final success = await _apiService.updateTaskStatus(token, taskId, localTimeZone);
      if (success) {
        await fetchTasks(categoryId);
      }
    } catch (e) {
      //('Error al actualizar estado de tarea: $e');
    }
  }
}

class NotificationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    Future.microtask(() {
      notifyListeners();
    });

    try {
      final String? token = await _authStorage.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final TimezoneService _timezoneService = TimezoneService();
      final String localTimeZone = await _timezoneService.getDeviceTimeZone();

      final DateTime now = DateTime.now();
     // final String todayDate = DateFormat('yyyy-MM-dd').format(now);

      final medications = await _apiService.getIncompleteMedications(token, localTimeZone) ?? [];
      final appointments = await _apiService.getAppointments(token) ?? [];

      final medicationNotifications = medications
          .where((med) {
        final DateTime scheduledTime = DateTime.parse(med['scheduled_time']).toLocal();
        return !med['taken'] && scheduledTime.isBefore(now);
      })
          .map((med) {
        final DateTime scheduledTime = DateTime.parse(med['scheduled_time']).toLocal();
        final formattedTime = DateFormat('hh:mm a').format(scheduledTime);
        return {
          'type': 'medication',
          'title': 'Pending Medication',
          'details': '${med['med_name']} at $formattedTime',
          'id': med['medlog_id'],
          'navigation': '/medications',
        };
      })
          .toList();

      final appointmentNotifications = appointments
          .where((appointment) {
        final DateTime appointmentDate = DateTime.parse(appointment['appointment_date']);
        final TimeOfDay startTime = TimeOfDay(
          hour: int.parse(appointment['start_time'].split(':')[0]),
          minute: int.parse(appointment['start_time'].split(':')[1]),
        );
        final DateTime fullStartDate = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          startTime.hour,
          startTime.minute,
        );
        return fullStartDate.isAfter(now);
      })
          .map((appointment) {
        final DateTime appointmentDate = DateTime.parse(appointment['appointment_date']);
        final TimeOfDay startTime = TimeOfDay(
          hour: int.parse(appointment['start_time'].split(':')[0]),
          minute: int.parse(appointment['start_time'].split(':')[1]),
        );
        final DateTime fullStartDate = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          startTime.hour,
          startTime.minute,
        );
        final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(fullStartDate);
        return {
          'type': 'appointment',
          'title': 'Pending Appointment',
          'details': 'With Dr. ${appointment['professional_name']} ${appointment['professional_lastname']} on $formattedDate',
          'id': appointment['id'],
          'navigation': '/appointments',
        };
      })
          .toList();

      _notifications = [...medicationNotifications, ...appointmentNotifications];
    } catch (e) {
      _notifications = [];
      //print('Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


