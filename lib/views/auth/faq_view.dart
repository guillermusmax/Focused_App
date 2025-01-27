import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textSecondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          Center(
            child: Image.asset(
              'assets/icons/Focused_Icon.png',
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'FAQs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const FAQItem(
            question: '¿Cómo me vinculo con mi psicólogo/psiquiatra?',
            answer:
            'El profesional debe inicializar la vinculación mandando un correo al paciente que desea vincularse. Luego, el paciente presiona el hipervínculo encontrado dentro del correo para finalizar la vinculación.',
          ),
          const Divider(),
          const FAQItem(
            question: '¿Cómo visualizo la información de mi profesional?',
            answer:
            'El paciente no puede visualizar la información de su profesional, ya que FOCUSED no busca hacer que los pacientes conozcan nuevos profesionales, sino ayudar a los profesionales con el seguimiento de sus pacientes y ofrecerle al paciente herramientas para manejar su TDAH.',
          ),
          const Divider(),
          const FAQItem(
            question: '¿Cómo realizo un cambio de profesional?',
            answer:
            'El paciente debe mandar un correo al administrador (focused389@gmail.com) pidiendo la desvinculación del profesional. El administrador luego procede a desvincular dicho profesional y le notifica al paciente.',
          ),
          const Divider(),
          const FAQItem(
            question:
            '¿Por qué no puedo visualizar medicamentos de días anteriores?',
            answer:
            'El paciente solamente puede marcar como tomados los medicamentos del día actual y los de días anteriores ya están vencidos, por lo que no puede visualizarlos.',
          ),
          const Divider(),
          const FAQItem(
            question: '¿Cómo me ayuda esta aplicación?',
            answer:
            'Además de brindarle mayor transparencia al profesional para saber cómo tratar al paciente, FOCUSED le brinda al paciente con TDAH herramientas para manejo de tiempo, aprendizaje de contenido, organización y concentración.',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
