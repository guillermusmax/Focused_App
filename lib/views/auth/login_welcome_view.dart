import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/nav_screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginWelcomeView extends StatefulWidget {
  const LoginWelcomeView({super.key});

  @override
  State<LoginWelcomeView> createState() => _LoginWelcomeViewState();
}

class _LoginWelcomeViewState extends State<LoginWelcomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controlador para la animación
  late Animation<double> _animation; // Animación de opacidad

  @override
  void initState() {
    super.initState();

    // Configurar el controlador y la animación de opacidad
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Duración total de la animación
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Iniciar la animación y navegar a HomeScreen después de 3 segundos
    _controller.forward();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos del controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/Focused_Icon.png',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: textSecondaryColor, // Indicador de carga animado
              ),
            ],
          ),
        ),
      ),
    );
  }
}
