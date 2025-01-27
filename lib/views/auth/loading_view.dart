import 'package:flutter/material.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/views/auth/login_view.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  final AuthStorage authStorage = AuthStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la imagen que ocupa toda la pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.jpeg', // Imagen de fondo
              fit: BoxFit.cover,
            ),
          ),
          // Capa de sombreado
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Capa oscura encima de la imagen
            ),
          ),
          // Contenido centralizado
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/icons/Focused_Icon.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  // Título
                  const Text(
                    'Focus Up!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92C7A3),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Subtítulo
                  const Text(
                    'Connect with your ADHD specialists and let them take care of you',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Botón
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF92C7A3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        },
                        child: Center(
                          child: const Text(
                            'Let’s start',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
