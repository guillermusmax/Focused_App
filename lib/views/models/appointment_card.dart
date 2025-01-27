import 'package:flutter/material.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para las traducciones

class AppointmentCard extends StatelessWidget {
  final String specialistType;
  final String doctorName;
  final String dateTime;

  const AppointmentCard({
    super.key,
    required this.specialistType,
    required this.doctorName,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            specialistType,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            doctorName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${S.current.dateTime}: $dateTime', // Traducción de 'DateTime'
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
