import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa las traducciones

class WidgetPopUpPomodoroSettings extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final ValueChanged<double> onWorkDurationChanged;
  final ValueChanged<double> onShortBreakDurationChanged;
  final ValueChanged<double> onLongBreakDurationChanged;
  final ValueChanged<int> onIntervalsChanged; // Nuevo para intervalos

  const WidgetPopUpPomodoroSettings({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.onWorkDurationChanged,
    required this.onShortBreakDurationChanged,
    required this.onLongBreakDurationChanged,
    required this.onIntervalsChanged, // Nuevo
  });

  @override
  State<WidgetPopUpPomodoroSettings> createState() =>
      _WidgetPopUpPomodoroSettingsState();
}

class _WidgetPopUpPomodoroSettingsState
    extends State<WidgetPopUpPomodoroSettings> {
  final TextEditingController workController =
      TextEditingController(text: "25");
  final TextEditingController shortBreakController =
      TextEditingController(text: "5");
  final TextEditingController longBreakController =
      TextEditingController(text: "15");
  final TextEditingController intervalsController =
      TextEditingController(text: "4"); // Default de 4 intervalos

  @override
  void dispose() {
    workController.dispose();
    shortBreakController.dispose();
    longBreakController.dispose();
    intervalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                S.current.pomodoroSettings, // Texto traducido
                maxLines: 1,
                style: GoogleFonts.inter(
                  color: textTertiaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(S.current.workMinutes, workController, (value) {
              final duration = double.tryParse(value) ?? 25;
              widget.onWorkDurationChanged(duration);
            }),
            _buildSection(S.current.shortBreakMinutes, shortBreakController,
                (value) {
              final duration = double.tryParse(value) ?? 5;
              widget.onShortBreakDurationChanged(duration);
            }),
            _buildSection(S.current.longBreakMinutes, longBreakController,
                (value) {
              final duration = double.tryParse(value) ?? 15;
              widget.onLongBreakDurationChanged(duration);
            }),
            _buildSection(S.current.intervals, intervalsController, (value) {
              final intervals = int.tryParse(value) ?? 4;
              widget.onIntervalsChanged(intervals);
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: widget.onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                S.current.apply, // Texto traducido
                style: const TextStyle(
                  color: textPrimaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String label, TextEditingController controller,
      ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.inter(
              color: textTertiaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        _buildInputField(
          controller: controller,
          hintText: S.current.enterValue(label), // Texto traducido
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, color: Colors.black),
              onPressed: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                if (currentValue > 0) {
                  currentValue--;
                  controller.text = currentValue.toString();
                  onChanged(controller.text);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              readOnly: true,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              onChanged: onChanged,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                int currentValue = int.tryParse(controller.text) ?? 0;
                currentValue++;
                controller.text = currentValue.toString();
                onChanged(controller.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}
