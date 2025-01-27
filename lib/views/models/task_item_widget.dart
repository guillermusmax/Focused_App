import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importamos para traducciones
import 'package:intl/intl.dart';

class TaskItemWidget extends StatefulWidget {
  final String taskText;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete; // Callback obligatorio
  final bool isCompleted;
  final DateTime? dueDate; // Parámetro opcional cambiado a String

  const TaskItemWidget({
    Key? key,
    required this.taskText,
    required this.onEdit,
    required this.onDelete,
    this.dueDate, // Parámetro opcional
    required this.onToggleComplete,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    // Verificar si dueDate es válido y formatear la fecha correctamente
    String formattedDate = S.current.noDueTime;
    if (widget.dueDate != null) {
      try {
        formattedDate = DateFormat('dd/MM/yyyy – HH:mm').format(widget.dueDate!);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            shape: const CircleBorder(),
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
              widget.onToggleComplete(); // Llama al callback para manejar cambios externos
            },
            activeColor: highlightColor,
          ),
          const SizedBox(width: 12),
          // Task text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.taskText,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textTertiaryColor,
                    decoration: _isChecked
                        ? TextDecoration.lineThrough
                        : null, // Línea tachada si está completado
                  ),
                  overflow: TextOverflow.ellipsis, // Maneja textos largos
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit, color: textTertiaryColor),
            tooltip: S.current.edit, // Traducción para "Editar"
            onPressed: widget.onEdit,
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: highlightColor),
            tooltip: S.current.delete, // Traducción para "Eliminar"
            onPressed: widget.onDelete,
          ),
        ],
      ),
    );
  }
}
