import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart'; // Importado para usar la API
import 'package:focused_app/api/models/auth_storage.dart'; // Importado para manejar el token
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/faq_view.dart';
import 'package:focused_app/views/auth/forgot_code_view.dart';
import 'package:focused_app/views/auth/resend_email_code_view.dart';
import 'package:focused_app/views/auth/signup_view.dart';
// import 'package:focused_app/views/nav_screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
import 'login_welcome_view.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final ApiService apiService = ApiService(); // Instancia de ApiService para manejar solicitudes
  final AuthStorage authStorage = AuthStorage(); // Instancia de AuthStorage para manejar el token

  // Controladores para capturar el texto de los campos de usuario y contraseña
  final TextEditingController usernameController = TextEditingController(); // Controlador para el nombre de usuario
  final TextEditingController passwordController = TextEditingController(); // Controlador para la contraseña
  bool isLoading = false; // Variable para manejar el estado de carga

  // Función que maneja el inicio de sesión
  Future<void> handleLogin() async {
    setState(() {
      isLoading = true; // Activa el indicador de carga
    });

    try {
      final token = await apiService.login(
        usernameController.text, // Captura el texto del nombre de usuario
        passwordController.text, // Captura el texto de la contraseña
      );

      if (token != null) {
        // Guarda el token en el almacenamiento seguro
        await authStorage.saveToken(token);

        setState(() {
          isLoading = false; // Desactiva el indicador de carga
        });

        // Navega a la pantalla de bienvenida
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginWelcomeView()),
        );
      } else {
        // Si la autenticación falla, espera 5 segundos antes de ocultar el indicador
        await Future.delayed(Duration(milliseconds: 10));

        setState(() {
          isLoading = false; // Desactiva el indicador de carga
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de autenticación o acceso denegado')),
        );
      }
    } catch (e) {
      // Si hay un error (por ejemplo, no hay internet), espera 5 segundos y luego muestra el mensaje
      await Future.delayed(Duration(milliseconds: 10));

      setState(() {
        isLoading = false; // Desactiva el indicador de carga
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.teal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQScreen()),
              );
            },
          ),
        ],
      ),
      body: Form(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Image.asset(
                          'assets/icons/Focused_Icon.png',
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(height: 60),
                        TextFormField(
                          controller: usernameController, // Enlaza el controlador para capturar el texto
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              color: textSecondaryColor,
                            ),
                            labelText: 'Your Username',
                            hintText: 'your username',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController, // Enlaza el controlador para capturar el texto
                          obscureText: true, // Oculta el texto para la contraseña
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: textSecondaryColor,
                            ),
                            labelText: 'Your Password',
                            hintText: 'your password',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          child: Container(
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: isLoading ? null : handleLogin, // Lógica del botón
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white, // Indicador de carga
                                )
                                    : Text(
                                  'Log In',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.roboto(
                                  color: textTertiaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // Navega a la vista de registro
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupView(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.roboto(
                                  color: textSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                // Navega a la vista de recuperación de contraseña
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotCodeView(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        InkWell(
                          child: Text(
                            'Resend Email Link?',
                            style: GoogleFonts.roboto(
                              color: textSecondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // Navega a la vista de recuperación de contraseña
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResendEmailCodeView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
