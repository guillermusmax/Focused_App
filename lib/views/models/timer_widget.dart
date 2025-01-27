import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones
import 'dart:async';

enum PomodoroState { working, shortBreak, longBreak, stopped }

class TimerWidget extends StatefulWidget {
  final int workDuration; // Duración de trabajo en segundos
  final int shortBreakDuration; // Duración de descanso corto en segundos
  final int longBreakDuration; // Duración de descanso largo en segundos
  final int intervals; // Número de intervalos antes de un descanso largo

  const TimerWidget({
    super.key,
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.intervals,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int minutes;
  late int seconds;
  double percent = 0;
  Timer? _timer;
  bool isRunning = false;
  PomodoroState currentState = PomodoroState.working;
  late int totalSeconds;
  int currentInterval = 0; // Ciclo actual

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    setState(() {
      currentState = PomodoroState.working;
      totalSeconds = widget.workDuration;
      minutes = totalSeconds ~/ 60;
      seconds = totalSeconds % 60;
      percent = 0;
    });
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workDuration != oldWidget.workDuration ||
        widget.shortBreakDuration != oldWidget.shortBreakDuration ||
        widget.longBreakDuration != oldWidget.longBreakDuration ||
        widget.intervals != oldWidget.intervals) {
      _stopTimer();
      _initializeTimer();
    }
  }

  void _startTimer() {
    if (!isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (minutes == 0 && seconds == 0) {
          _stopTimer();
          _switchState();
        } else {
          setState(() {
            if (seconds > 0) {
              seconds--;
            } else {
              minutes--;
              seconds = 59;
            }
            percent = (totalSeconds - (minutes * 60 + seconds)) / totalSeconds;
          });
        }
      });
      setState(() {
        isRunning = true;
      });
    }
  }

  void _pauseTimer() {
    if (isRunning) {
      _timer?.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      minutes = totalSeconds ~/ 60;
      seconds = totalSeconds % 60;
      percent = 0;
      isRunning = false;
    });
  }

  void _switchState() {
    setState(() {
      if (currentState == PomodoroState.working) {
        currentInterval++;
        if (currentInterval >= widget.intervals) {
          currentState = PomodoroState.longBreak;
          totalSeconds = widget.longBreakDuration;
          currentInterval = 0;
        } else {
          currentState = PomodoroState.shortBreak;
          totalSeconds = widget.shortBreakDuration;
        }
      } else if (currentState == PomodoroState.shortBreak) {
        currentState = PomodoroState.working;
        totalSeconds = widget.workDuration;
      } else if (currentState == PomodoroState.longBreak) {
        currentState = PomodoroState.stopped;
        _stopTimer();
        return;
      }

      minutes = totalSeconds ~/ 60;
      seconds = totalSeconds % 60;
      percent = 0;
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                radius: 150,
                lineWidth: 10,
                percent: percent,
                animation: true,
                progressColor: currentState == PomodoroState.working
                    ? Colors.orangeAccent
                    : Colors.lightBlueAccent,
                backgroundColor: textSecondaryColor,
                animateFromLastPercent: true,
                animationDuration: 500,
                center: Text(
                  '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
                  style: GoogleFonts.inter(
                    color: textSecondaryColor,
                    fontSize: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          currentState == PomodoroState.working
              ? S.current.focusOnTask
              : currentState == PomodoroState.shortBreak
              ? S.current.shortBreak
              : currentState == PomodoroState.longBreak
              ? S.current.longBreak
              : S.current.sessionCompleted,
          style: GoogleFonts.inter(
            color: textSecondaryColor,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.pause_circle_outline,
                color: textTertiaryColor,
                size: 70,
              ),
              onPressed: _pauseTimer,
            ),
            const SizedBox(width: 30),
            IconButton(
              icon: const Icon(
                Icons.play_arrow,
                color: textTertiaryColor,
                size: 70,
              ),
              onPressed: _startTimer,
            ),
            const SizedBox(width: 30),
            IconButton(
              icon: const Icon(
                Icons.stop,
                color: textTertiaryColor,
                size: 70,
              ),
              onPressed: _stopTimer,
            ),
          ],
        ),
      ],
    );
  }
}
