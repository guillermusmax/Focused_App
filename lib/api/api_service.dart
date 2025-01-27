import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:focused_app/api/timezone_service.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../generated/l10n.dart'; // Necesario para manejar fechas

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? ''; // Carga la URL desde el archivo .env
  // final String baseUrl ='https://focusedapi.com';
  Future<String?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/token/'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      // Obtener detalles del usuario
      final userResponse = await http.get(
        Uri.parse('$baseUrl/usuarios/me/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        final int idRol = userData['id_rol'];
        print('ID Rol del usuario: $idRol'); // Imprime el id_rol en la consola

        if (idRol == 1) {
          return token; // Usuario es un paciente
        } else {
          print('Acceso denegado: el usuario no es un paciente.');
          return null;
        }
      } else {
        print('Error al obtener detalles del usuario: ${userResponse.statusCode}');
        return null;
      }
    } else {
      print('Error de autenticación: ${response.statusCode}');
      return null;
    }
  }



  Future<String?> getProtectedData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/users/'), // Usa la URL base del .env
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data.toString();
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
  Future<Map<String, dynamic>?> getPatientInfo(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/patient/me/info'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return data.first; // Devuelve el primer elemento de la lista
      }
      return null; // Si la lista está vacía, retorna null
    } else {
      print('Error al obtener información del paciente: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>?> getAppointments(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/appointment/patient/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      print('Error al obtener las citas: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>?> getMedications(String token, String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/medlog/patient/$date'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Devuelve la lista de medicaciones
    } else {
      print('Error al obtener medicaciones: ${response.statusCode}');
      print(dotenv.env['BASE_URL']); // Debe mostrar "https://focusedapi.com"das
      return null;
    }
  }

  Future<String?> changePassword(String token, Map<String, String> requestData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/usuarios/change_password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      return null; // Indica que el cambio fue exitoso
    } else {
      final responseData = jsonDecode(response.body);
      return responseData['error'] ?? S.current.unknownError; // Devuelve el error si la API falla
    }
  }



  Future<bool> updateMedicationTaken(String token, int medlogId, bool taken, String timeZone) async {
    try {
      // Validar token antes de la solicitud
      if (token.isEmpty || JwtDecoder.isExpired(token)) {
        print('Token inválido o expirado');
        return false;
      }
      final response = await http.put(
        Uri.parse('$baseUrl/medlog/patient/updated_taken/$medlogId?time_zone=$timeZone'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Medicación marcada como tomada exitosamente.');
        return true;
      } else {
        print('Error al marcar medicación como tomada: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return false;
    }

  }

  Future<List<dynamic>?> getMedicationsByDate(String token, String timeZone) async {
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final String url = '$baseUrl/medlog/patient/$todayDate?time_zone=$timeZone';

    try {
      print('URL solicitada: $url'); // Depuración
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        print('No se encontraron medicaciones para hoy.');
        return [];
      } else {
        print('Error al obtener medicaciones: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al obtener medicaciones: $e');
      return null;
    }
  }




  Future<Map<String, dynamic>?> signUp(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(userData), // Serialización correcta del JSON
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data; // Devuelve los datos de la respuesta
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        print('User Data: ${jsonEncode(userData)}');
        return null; // Devuelve null en caso de error
      }
    } catch (e) {
      print('Error en signUp: $e');
      return null; // Manejo de errores
    }
  }

  Future<bool> forgotPassword(String email) async {
    final Uri url = Uri.parse('$baseUrl/usuarios/forgot_password/');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Forgot password request successful.');
        return true;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<bool> resendLink(String email) async {
    final Uri url = Uri.parse('$baseUrl/usuarios/verification_mail/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('request successful.');
        return true;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<bool> updateMedicationStatus(String token, int medlogId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/medlog/patient/updated_taken/$medlogId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Medication status updated successfully.');
        return true;
      } else {
        print('Error updating medication status: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception occurred while updating medication status: $e');
      return false;
    }
  }

  Future<bool> updatePatientInfo(String token, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/patient/update'), // URL del endpoint
        headers: {
          'Authorization': 'Bearer $token', // Autenticación con el token
          'Content-Type': 'application/json', // Tipo de contenido JSON
        },
        body: jsonEncode(updatedData), // Cuerpo de la solicitud en formato JSON
      );

      if (response.statusCode == 200) {
        print('Información del paciente actualizada exitosamente.');
        return true; // Indica que la actualización fue exitosa
      } else {
        print('Error al actualizar la información del paciente: ${response.body}');
        return false; // Indica que hubo un error en la actualización
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return false; // Manejo de errores
    }
  }

  // Obtener categorías
  Future<List<dynamic>?> getCategoriesFlashcards(String token) async {
    final url = Uri.parse('$baseUrl/category/me/categories/flashcards');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener categorías: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al obtener categorías: $e');
      return null;
    }
  }

  // Crear una categoría
  Future<bool> createCategoryFlashcards(String token, String name, int type) async {
    final url = Uri.parse('$baseUrl/category/create');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name, "type": type}),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error al crear categoría: $e');
      return false;
    }
  }

  // Actualizar categoría
  Future<bool> updateCategory(String token, int categoryId, String newName) async {
    final url = Uri.parse('$baseUrl/category/update?category_id=$categoryId');

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token', // Token dinámico
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": newName}),
      );

      if (response.statusCode == 200) {
        print("Categoría actualizada correctamente");
        return true;
      } else {
        print("Error al actualizar categoría: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error de red al actualizar: $e");
      return false;
    }
  }

  // Eliminar categoría
  Future<bool> deleteCategory(String token, int categoryId) async {
    final url = Uri.parse('$baseUrl/category/delete/$categoryId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token', // Token dinámico
        },
      );

      if (response.statusCode == 200) {
        print("Categoría eliminada correctamente");
        return true;
      } else {
        print("Error al eliminar categoría: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error de red al eliminar: $e");
      return false;
    }
  }

  Future<List<dynamic>?> getFlashcardsByCategory(String token, int categoryId) async {
    final url = '$baseUrl/flashcards/category/$categoryId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Devuelve la lista de flashcards
      } else {
        print("Error al obtener flashcards: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de red al obtener flashcards: $e");
      return null;
    }
  }

  Future<bool> createFlashcard(String token, int categoryId, String question, String answer) async {
    final url = '$baseUrl/flashcards/create';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_category': categoryId,
          'question': question,
          'answer': answer,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Flashcard creada exitosamente');
        return true;
      } else {
        print('Error al crear flashcard: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error de red al crear flashcard: $e');
      return false;
    }
  }
// Actualizar una flashcard existente
  Future<bool> updateFlashcard(String token, int flashcardId, String question, String answer) async {
    final url = '$baseUrl/flashcards/update/$flashcardId';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question': question,
          'answer': answer,
        }),
      );
      if (response.statusCode == 200) {
        return true; // Flashcard actualizada exitosamente
      } else {
        print('Error al actualizar flashcard: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return false;
    }
  }

  // Eliminar una flashcard
  Future<bool> deleteFlashcard(String token, int flashcardId) async {
    final url = '$baseUrl/flashcards/delete/$flashcardId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return true; // Flashcard eliminada exitosamente
      } else {
        print('Error al eliminar flashcard: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return false;
    }
  }

  // Actualiza el nivel de una flashcard en función de la respuesta correcta o incorrecta
  // Actualiza el nivel del flashcard basado en la respuesta correcta o incorrecta
  Future<int?> updateFlashcardLevel(String token, int flashcardId, bool isCorrect) async {
    final url =
        '$baseUrl/flashcards/update/level/$flashcardId/${isCorrect ? 'true' : 'false'}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data.containsKey('new_level') && data['new_level'] != null) {
          print("Nivel actualizado correctamente: ${data['new_level']}");
          return data['new_level'];
        } else {
          print("Respuesta inválida: $data");
          return null;
        }
      } else {
        print('Error al actualizar nivel: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return null;
    }
  }

  Future<List<dynamic>?> getCategoriesTask(String token) async {
    final url = Uri.parse('$baseUrl/category/me/categories/task');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error al obtener categorías de tareas: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al obtener categorías de tareas: $e');
      return null;
    }
  }

  Future<bool> createCategoryTask(String token, String name) async {
    final url = Uri.parse('$baseUrl/category/create');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": name, "type": 1}),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error al crear categoría de tareas: $e');
      return false;
    }
  }


  Future<List<dynamic>?> getTasksByCategory(String token, int categoryId, String timeZone) async {
    final String url = '$baseUrl/task/category/$categoryId?time_zone=$timeZone';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      );

      print('Solicitando tareas desde: $url');
      if (response.statusCode == 200) {
        final List<dynamic> tasks = jsonDecode(response.body);
        return tasks;
      } else {
        print('Error al obtener tareas: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return null;
    }
  }

  // Crear tarea
  Future<bool> createTask(
      String token,
      int categoryId,
      String title, {
        String description = '',
        int priority = 0,
        required DateTime dueDate,
        required String timeZone,
      }) async {
    final String url = '$baseUrl/task/create?time_zone=$timeZone';

    final Map<String, dynamic> body = {
      "id_category": categoryId,
      "title": title,
      "description": description,
      "priority": priority,
      "due_date": dueDate.toIso8601String(),
    };

    try {
      // Imprime la URL y el cuerpo de la solicitud para verificar su contenido
      print('URL de la creando tarea: $url');
      print('Cuerpo de la solicitud: ${jsonEncode(body)}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Tarea creada exitosamente. Respuesta del servidor: ${response.body}');
        return true;
      } else {
        print('Error al crear la tarea. Código de estado: ${response.statusCode}. Respuesta del servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Excepción al enviar la solicitud: $e');
      return false;
    }
  }


  // Actualizar tarea
  Future<bool> updateTask(
      String token,
      int taskId, {
        required String title,
        String? description,
        int? priority,
        int? status,
        DateTime? dueDate,
        required String timeZone,
      }) async {
    final url = '$baseUrl/task/update?task_id=$taskId&time_zone=$timeZone';

    final body = {
      'title': title,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Tarea actualizada exitosamente');
        return true;
      } else {
        print('Error al actualizar tarea: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error en conexión al actualizar tarea: $e');
      return false;
    }
  }

  // Eliminar tarea
  Future<bool> deleteTask(String token, int taskId) async {
    final url = '$baseUrl/task/delete/$taskId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error al eliminar tarea: $e');
      return false;
    }
  }


  Future<bool> updateTaskStatus(String token, int taskId, String timeZone) async {
    final url = '$baseUrl/task/update/completed/$taskId?time_zone=$timeZone';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Estado de tarea actualizado exitosamente.');
        return true;
      } else {
        print('Error al actualizar estado: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al conectar con el servidor: $e');
      return false;
    }
  }

  Future<List<dynamic>?> getIncompleteMedications(String token, String timeZone) async  {
    final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Fecha actual
    final String url = '$baseUrl/medlog/patient/$todayDate?time_zone=$timeZone';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data
            .where((med) => !med['taken']) // Filtrar medicaciones incompletas
            .toList();
      } else {
        print('Error al obtener medicaciones incompletas: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en getIncompleteMedications: $e');
      print(dotenv.env['BASE_URL']); // Debe mostrar "https://focusedapi.com"
      return null;

    }
  }


}
