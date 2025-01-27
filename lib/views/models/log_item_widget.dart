import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:focused_app/api/state_models.dart';
import 'package:intl/intl.dart';

class LogItemWidget extends StatelessWidget {
  final String time;
  final List<Map<String, dynamic>> medications;

  const LogItemWidget({
    super.key,
    required this.time,
    required this.medications,
  });


  bool _isPastOrCurrentTime(String scheduledTime) {
    try {
      final now = DateTime.now();
      final nowTimeOnly = DateTime(0, 0, 0, now.hour, now.minute);

      final scheduled = DateFormat('HH:mm').parse(scheduledTime);
      final scheduledTimeOnly = DateTime(0, 0, 0, scheduled.hour, scheduled.minute);

      return scheduledTimeOnly.isBefore(nowTimeOnly) ||
          scheduledTimeOnly.isAtSameMomentAs(nowTimeOnly);
    } catch (e) {
      print('Error en formato de hora: $scheduledTime');
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (medications.isNotEmpty)
            Column(
              children: medications.map((medication) {
                final bool canBeMarked = _isPastOrCurrentTime(time);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medication['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: Consumer<MedicationState>(
                        builder: (context, state, _) {
                          return Checkbox(
                            shape: const CircleBorder(),
                            fillColor: WidgetStateProperty.resolveWith(
                                  (states) {
                                if (states.contains(WidgetState.selected)) {
                                  return canBeMarked
                                      ? const Color(0xFF215A6D)
                                      : Colors.grey; // Bloqueado
                                }
                                return Colors.white;
                              },
                            ),
                            checkColor: Colors.white,
                            value: medication['taken'],
                            onChanged: canBeMarked
                                ? (bool? value) {
                              state.toggleMedication(
                                medication['medlog_id'],
                                medication['taken'],
                              );
                            }
                                : null, // Deshabilitar cambio si no es la hora correcta
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            )
          else
            Center(
              child: Text(
                S.current.noMedications,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
