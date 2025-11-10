import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A global manager to handle Text-to-Speech, settings persistence, and history.
final TTSManager ttsManager = TTSManager();

class TTSManager {
  late FlutterTts _flutterTts;
  late SharedPreferences _prefs;

  // --- State Notifiers ---
  ValueNotifier<double> speed = ValueNotifier(0.5);
  ValueNotifier<double> pitch = ValueNotifier(1.0);
  ValueNotifier<List<String>> history = ValueNotifier([]);
  ValueNotifier<List<String>> quickPhrases = ValueNotifier([]);
  ValueNotifier<String> username = ValueNotifier("Yuvraj");
  ValueNotifier<String> email = ValueNotifier("yuvraj@email.com");
  ValueNotifier<String> phoneNumber = ValueNotifier("+91 12345 67890");
  ValueNotifier<String> currentOutputText = ValueNotifier("Your recognized text will appear here");

  // --- Initialization ---
  // --- FIX: Made initialize() a separate, await-able function ---
  Future<void> initialize() async {
    _flutterTts = FlutterTts();
    _setTtsProperties();
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

    // Load Profile Info
    username.value = _prefs.getString('profile_name') ?? "Yuvraj";
    email.value = _prefs.getString('profile_email') ?? "yuvraj@email.com";
    phoneNumber.value = _prefs.getString('profile_phone') ?? "+91 12345 67890";

    // Add listeners to save settings whenever they change
    speed.addListener(_saveSettings);
    pitch.addListener(_saveSettings);
  }

  // --- Public Methods ---

  void speak(String text) {
    if (text.isEmpty || text == "Your recognized text will appear here") return;
    
    _flutterTts.speak(text);
    final currentHistory = List<String>.from(history.value);
    currentHistory.insert(0, text);
    history.value = currentHistory;
    _prefs.setStringList('tts_history', history.value);
  }

  void clearHistory() {
    history.value = [];
    _prefs.setStringList('tts_history', []);
  }

  void setOutputText(String text) {
    currentOutputText.value = text;
  }

  void addQuickPhrase(String newPhrase) {
    final currentPhrases = List<String>.from(quickPhrases.value);
    currentPhrases.add(newPhrase);
    quickPhrases.value = currentPhrases;
    _prefs.setStringList('tts_quick_phrases', quickPhrases.value);
  }

  void updateQuickPhrase(int index, String newPhrase) {
    final currentPhrases = List<String>.from(quickPhrases.value);
    if (index >= 0 && index < currentPhrases.length) {
      currentPhrases[index] = newPhrase;
      quickPhrases.value = currentPhrases;
      _prefs.setStringList('tts_quick_phrases', quickPhrases.value);
    }
  }
  
  void deleteQuickPhrase(int index) {
    final currentPhrases = List<String>.from(quickPhrases.value);
    if (index >= 0 && index < currentPhrases.length) {
      currentPhrases.removeAt(index);
      quickPhrases.value = currentPhrases;
      _prefs.setStringList('tts_quick_phrases', quickPhrases.value);
    }
  }

  Future<void> updateProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
  }) async {
    username.value = newName;
    email.value = newEmail;
    phoneNumber.value = newPhone;
    
    await _prefs.setString('profile_name', newName);
    await _prefs.setString('profile_email', newEmail);
    await _prefs.setString('profile_phone', newPhone);
  }


  // --- Setters for Settings ---
  void setSpeed(double newSpeed) {
    speed.value = newSpeed;
  }

  void setPitch(double newPitch) {
    pitch.value = newPitch;
  }

  // --- Private Helper Methods ---
  Future<void> _saveSettings() async {
    await _prefs.setDouble('tts_speed', speed.value);
    await _prefs.setDouble('tts_pitch', pitch.value);
    _setTtsProperties();
  }

  void _setTtsProperties() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(speed.value);
    _flutterTts.setPitch(pitch.value);
  }
}