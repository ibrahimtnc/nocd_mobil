import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Relaxing music player for mini-games
/// Plays calming background music during the wait time
class RelaxingMusicPlayer {
  static final RelaxingMusicPlayer _instance = RelaxingMusicPlayer._internal();
  factory RelaxingMusicPlayer() => _instance;
  RelaxingMusicPlayer._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  /// Start playing relaxing music
  Future<void> play() async {
    if (_isPlaying) return;

    try {
      // Play the relaxing music from assets
      await _audioPlayer.play(AssetSource('audio/relaxing_music.mp3'));
      // Set to loop mode for continuous playback
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing music: $e');
      _isPlaying = false;
    }
  }

  /// Stop playing music
  Future<void> stop() async {
    if (!_isPlaying) return;

    try {
      await _audioPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  /// Pause music
  Future<void> pause() async {
    if (!_isPlaying) return;

    try {
      await _audioPlayer.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing music: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _audioPlayer.dispose();
  }
}

