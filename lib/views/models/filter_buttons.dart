import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para las traducciones

class FilterButtons extends StatelessWidget {
  final Function(String) onFilterSelected;

  const FilterButtons({
    super.key,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () => onFilterSelected('Pending'),
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            S.current.pending, // Texto traducido
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => onFilterSelected('Scheduled'),
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            S.current.scheduled, // Texto traducido
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () => onFilterSelected('Completed'),
          style: OutlinedButton.styleFrom(
            backgroundColor: primaryColor,
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            S.current.completed, // Texto traducido
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
