import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_bottom_navbar.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones

class MeditationAudioPlayerScreen extends StatefulWidget {
  final String audioTitle;
  final String audioAsset;
  final IconData meditationIcon;

  const MeditationAudioPlayerScreen({
    super.key,
    required this.audioTitle,
    required this.audioAsset,
    required this.meditationIcon,
  });

  @override
  State<MeditationAudioPlayerScreen> createState() =>
      _MeditationAudioPlayerScreenState();
}

class _MeditationAudioPlayerScreenState
    extends State<MeditationAudioPlayerScreen> {
  late AudioPlayer _audioPlayer;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _audioPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(widget.audioAsset));
      }
      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.audioPlayError)),
      );
      print("Error al reproducir audio: $e");
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          widget.audioTitle,
          style: const TextStyle(
            color: textTertiaryColor,
          ),
        ),
      ),
      drawer: const WidgetSideBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.meditationIcon,
                size: 120.0,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.audioTitle,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Column(
              children: [
                Slider(
                  value: _audioPosition.inSeconds.toDouble(),
                  max: _audioDuration.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                    setState(() {
                      _audioPosition = position;
                    });
                  },
                  activeColor: primaryColor,
                  inactiveColor: textTertiaryColor.withOpacity(0.3),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_audioPosition),
                        style: const TextStyle(color: textTertiaryColor)),
                    Text(_formatDuration(_audioDuration),
                        style: const TextStyle(color: textTertiaryColor)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textTertiaryColor,
                  ),
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const WidgetBottomNavBar(),
    );
  }
}
