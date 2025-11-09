import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A global manager to handle Text-to-Speech, settings persistence, and history.
///
/// By defining it globally, all pages (Home, Settings, History, Editor)
/// can access the same instance and stay in sync.
final TTSManager ttsManager = TTSManager();

class TTSManager {
  late FlutterTts _flutterTts;
  late SharedPreferences _prefs;

  // --- State Notifiers ---
  // Any widget that listens to these will automatically rebuild when they change.
  
  // Settings
  ValueNotifier<double> speed = ValueNotifier(0.5);
  ValueNotifier<double> pitch = ValueNotifier(1.0);
  
  // History
  ValueNotifier<List<String>> history = ValueNotifier([]);
  
  // Quick Phrases
  ValueNotifier<List<String>> quickPhrases = ValueNotifier([
    "Hello",
    "I need help",
    "Thank you",
    "Goodbye"
  ]);

  // --- Initialization ---
  // This is called one time when the app starts.
  TTSManager() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize TTS engine
    _flutterTts = FlutterTts();
    _setTtsProperties();

    // Load saved data from the phone's storage
    _prefs = await SharedPreferences.getInstance();
    
    // Load settings
    speed.value = _prefs.getDouble('tts_speed') ?? 0.5;
    pitch.value = _prefs.getDouble('tts_pitch') ?? 1.0;

    // Load history
    history.value = _prefs.getStringList('tts_history') ?? [];
    
    // Load quick phrases
    quickPhrases.value = _prefs.getStringList('tts_quick_phrases') ?? [
      "Hello",
      "I need help",
      "Thank you",
      "Goodbye"
    ];

    // Add listeners to save settings whenever they change
    speed.addListener(_saveSettings);
    pitch.addListener(_saveSettings);
  }

  // --- Public Methods ---

  /// Speaks the given text and adds it to the history.
  void speak(String text) {
    // 1. Speak the text
    _flutterTts.speak(text);

    // 2. Add to history
    // We insert at the beginning (index 0) to show the newest item first
    final currentHistory = List<String>.from(history.value);
    currentHistory.insert(0, text);
    history.value = currentHistory; // This notifies all listeners
    
    // 3. Save the updated history list
    _prefs.setStringList('tts_history', history.value);
  }

  /// Clears all saved history.
  void clearHistory() {
    history.value = [];
    _prefs.setStringList('tts_history', []);
  }

  /// Updates a quick phrase at a specific index and saves the list.
  void updateQuickPhrase(int index, String newPhrase) {
    final currentPhrases = List<String>.from(quickPhrases.value);
    if (index >= 0 && index < currentPhrases.length) {
      currentPhrases[index] = newPhrase;
      quickPhrases.value = currentPhrases; // Notifies listeners (like the Home Page)
      
      // Save the updated list
      _prefs.setStringList('tts_quick_phrases', quickPhrases.value);
    }
  }

  // --- Setters for Settings ---
  // These are called by the sliders on the SettingsPage.

  void setSpeed(double newSpeed) {
    speed.value = newSpeed;
  }

  void setPitch(double newPitch) {
    pitch.value = newPitch;
  }

  // --- Private Helper Methods ---

  /// Saves the current speed and pitch values to the phone's storage.
  Future<void> _saveSettings() async {
    await _prefs.setDouble('tts_speed', speed.value);
    await _prefs.setDouble('tts_pitch', pitch.value);
    _setTtsProperties();
  }

  /// Applies the current properties (speed/pitch) to the TTS engine.
  void _setTtsProperties() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(speed.value);
    _flutterTts.setPitch(pitch.value);
  }
}