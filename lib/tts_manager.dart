import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keys for storing data in SharedPreferences
const String _kPitchKey = 'tts_pitch';
const String _kSpeedKey = 'tts_speed';
const String _kHistoryKey = 'tts_history';

// Create a global instance of the manager that can be accessed anywhere
final ttsManager = TTSManager();

class TTSManager {
  final FlutterTts _flutterTts = FlutterTts();

  // ValueNotifiers to hold and notify listeners of state changes
  // Initial values are defaults, but they will be loaded from storage later
  final ValueNotifier<double> pitch = ValueNotifier(1.0);
  final ValueNotifier<double> speed = ValueNotifier(0.5);
  final ValueNotifier<List<String>> history = ValueNotifier([]);

  TTSManager() {
    _initializeTts();
    _loadSettings();
  }

  // --- Initialization and Persistence ---

  void _initializeTts() {
    _flutterTts.setLanguage("en-US");
    // Listen for changes in pitch and speed and update the TTS engine immediately
    pitch.addListener(() {
      _flutterTts.setPitch(pitch.value);
    });
    speed.addListener(() {
      _flutterTts.setSpeechRate(speed.value);
    });

    // Set initial values once
    _flutterTts.setPitch(pitch.value);
    _flutterTts.setSpeechRate(speed.value);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load pitch and speed, falling back to defaults if not found
    pitch.value = prefs.getDouble(_kPitchKey) ?? 1.0;
    speed.value = prefs.getDouble(_kSpeedKey) ?? 0.5;

    // Load history, falling back to an empty list
    history.value = prefs.getStringList(_kHistoryKey) ?? [];
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPitchKey, pitch.value);
    await prefs.setDouble(_kSpeedKey, speed.value);
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kHistoryKey, history.value);
  }

  // --- Public State Updaters ---

  void setPitch(double newPitch) {
    pitch.value = newPitch;
    _saveSettings();
  }

  void setSpeed(double newSpeed) {
    speed.value = newSpeed;
    _saveSettings();
  }

  // --- TTS Functionality ---

  Future<void> speak(String text) async {
    // 1. Speak the text using the current pitch/speed settings
    await _flutterTts.speak(text);

    // 2. Log the spoken text to history
    _logHistory(text);
  }

  void _logHistory(String text) {
    // Add the new text to the beginning of the list (newest first)
    final updatedHistory = List<String>.from(history.value);
    updatedHistory.insert(0, text);

    // Limit history to the last 20 items
    if (updatedHistory.length > 20) {
      updatedHistory.removeLast();
    }

    history.value = updatedHistory;
    _saveHistory(); // Persist the updated history list
  }
}