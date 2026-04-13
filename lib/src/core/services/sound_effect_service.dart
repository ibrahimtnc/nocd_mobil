import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sound effect service for game interactions
/// Provides various sound effects for minigames
/// Uses haptic feedback as fallback when sound files are not available
class SoundEffectService {
  static final SoundEffectService _instance = SoundEffectService._internal();
  factory SoundEffectService() => _instance;
  SoundEffectService._internal();

  final AudioPlayer _soundPlayer = AudioPlayer();
  bool _soundsEnabled = true;

  /// Enable or disable sound effects
  void setSoundsEnabled(bool enabled) {
    _soundsEnabled = enabled;
  }

  bool get soundsEnabled => _soundsEnabled;

  /// Play a sound effect from assets
  /// Returns true if sound played successfully, false otherwise
  Future<bool> _playSound(String assetPath) async {
    if (!_soundsEnabled) return false;

    try {
      await _soundPlayer.play(AssetSource(assetPath), mode: PlayerMode.lowLatency);
      return true;
    } catch (e) {
      debugPrint('Sound effect not found: $assetPath - Using haptic feedback instead');
      return false;
    }
  }

  /// Play a soft pop sound (for bubble wrap, card flips, etc.)
  Future<void> playPop() async {
    final success = await _playSound('audio/sfx_pop.mp3');
    if (!success) {
      HapticFeedback.lightImpact();
    }
  }

  /// Play a match/success sound
  Future<void> playMatch() async {
    final success = await _playSound('audio/sfx_match.mp3');
    if (!success) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Play drawing haptic feedback (light vibration while drawing)
  /// Used for ZenFlowGame to provide tactile feedback during drawing
  Future<void> playDrawingHaptic() async {
    if (!_soundsEnabled) return;
    HapticFeedback.lightImpact();
  }

  /// Play a breath/inhale sound
  Future<void> playBreathIn() async {
    final success = await _playSound('audio/sfx_breath_in.mp3');
    if (!success) {
      HapticFeedback.selectionClick();
    }
  }

  /// Play a breath/exhale sound
  Future<void> playBreathOut() async {
    final success = await _playSound('audio/sfx_breath_out.mp3');
    if (!success) {
      HapticFeedback.selectionClick();
    }
  }

  /// Play a click/tap sound
  Future<void> playClick() async {
    final success = await _playSound('audio/sfx_click.mp3');
    if (!success) {
      HapticFeedback.selectionClick();
    }
  }

  /// Play a success/completion sound
  Future<void> playSuccess() async {
    final success = await _playSound('audio/sfx_success.mp3');
    if (!success) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Play a card flip sound
  Future<void> playCardFlip() async {
    final success = await _playSound('audio/sfx_card_flip.mp3');
    if (!success) {
      HapticFeedback.lightImpact();
    }
  }

  void dispose() {
    _soundPlayer.dispose();
  }
}

