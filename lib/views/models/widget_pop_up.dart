import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa el paquete de traducción
import 'package:intl/intl.dart';

class CustomPopup extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final VoidCallback? onDelete;
  final String title;
  final String buttonText;
  final bool isEditing;
  final bool isPomodoroView; // Indica si es usado en PomodoroView
  final Function(DateTime)? onDateSelected; // Solo se usará en TaskView
  final Color? dialogBackgroundColor;
  final Color? buttonBackgroundColor;
  final Color? buttonTextColor;

  const CustomPopup({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.onDelete,
    this.title = '',
    this.buttonText = '',
    this.isEditing = false,
    this.isPomodoroView = false, // Valor predeterminado
    this.onDateSelected, // Solo en TaskView
    this.dialogBackgroundColor,
    this.buttonBackgroundColor,
    this.buttonTextColor,
  }) : super(key: key);

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
      if (selectedDate != null && widget.onDateSelected != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );
        widget.onDateSelected!(finalDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: widget.dialogBackgroundColor ?? backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textTertiaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: textTertiaryColor),
                  onPressed: widget.onCancel,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Campo de texto
            TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                labelText: 'Nombre de la tarea',
                labelStyle: TextStyle(color: textTertiaryColor),
              ),
            ),
            const SizedBox(height: 20),
            // Botón para seleccionar fecha y hora (solo si onDateSelected no es null)
            if (widget.onDateSelected != null)
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.buttonBackgroundColor ?? secondaryColor,
                  foregroundColor: widget.buttonTextColor ?? textPrimaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  selectedDate != null && selectedTime != null
                      ? DateFormat('yyyy-MM-dd – kk:mm').format(
                    DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    ),
                  )
                      : 'Fecha y Hora',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            const SizedBox(height: 20),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: textTertiaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.buttonBackgroundColor ?? secondaryColor,
                    foregroundColor: widget.buttonTextColor ?? textPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
