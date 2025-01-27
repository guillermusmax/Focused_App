import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/login_view.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupVerificationView extends StatefulWidget {
  const SignupVerificationView({super.key});

  @override
  State<SignupVerificationView> createState() => _SignupVerificationViewState();
}

class _SignupVerificationViewState extends State<SignupVerificationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controlador para la animación
  late Animation<double> _animation; // Animación de opacidad

  @override
  void initState() {
    super.initState();

    // Configuración del controlador y la animación
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Duración de 1.5 segundos
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Inicia la animación y navega a LoginView después de 1.5 segundos
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
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
          opacity: _animation, // Aplica la animación de opacidad
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
                'Signup \n Completed',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 25,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
