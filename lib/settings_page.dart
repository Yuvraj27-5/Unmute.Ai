import 'package:flutter/material.dart';
import 'tts_manager.dart'; // <-- FIX: Import the global TTS Manager

// --- FIX: FUNCTION IS MOVED OUTSIDE THE CLASS ---
// This helper widget builds the styled cards for each setting
Widget _buildSettingCard({
  required String title,
  required String subtitle,
  required Widget settingWidget,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.only(top: 10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          settingWidget,
        ],
      ),
    ),
  );
}
// --- END OF MOVED FUNCTION ---

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80); // Deep blue
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5), // Light bluish bg
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Voice Settings Section ---
            const Text(
              "Text-to-Speech (TTS) Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(),
            
            // --- 1. Speech Rate (Speed) Slider ---
            _buildSettingCard(
              title: "Speech Rate (Speed)",
              subtitle: "Adjusts how fast the recognized text is spoken.",
              settingWidget: ValueListenableBuilder<double>(
                valueListenable: ttsManager.speed,
                builder: (context, currentSpeed, child) {
                  return Column(
                    children: [
                      Slider(
                        value: currentSpeed,
                        min: 0.1, // Slower speed
                        max: 1.0, // Faster speed
                        divisions: 9,
                        label: currentSpeed.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          ttsManager.setSpeed(newValue);
                        },
                      ),
                      Text('Current Speed: ${currentSpeed.toStringAsFixed(1)}', style: TextStyle(color: Colors.grey[700])),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // --- 2. Voice Pitch Slider ---
            _buildSettingCard(
              title: "Voice Pitch",
              subtitle: "Controls the tone of the voice (higher/lower).",
              settingWidget: ValueListenableBuilder<double>(
                valueListenable: ttsManager.pitch,
                builder: (context, currentPitch, child) {
                  return Column(
                    children: [
                      Slider(
                        value: currentPitch,
                        min: 0.5, // Lower pitch
                        max: 2.0, // Higher pitch
                        divisions: 15,
                        label: currentPitch.toStringAsFixed(1),
                        onChanged: (double newValue) {
                          ttsManager.setPitch(newValue);
                        },
                      ),
                      Text('Current Pitch: ${currentPitch.toStringAsFixed(1)}', style: TextStyle(color: Colors.grey[700])),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // --- Gesture Settings Section ---
            const Text(
              "Gesture & Phrase Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(),

            // --- 3. Edit Quick Phrases Button ---
            _buildSettingCard(
              title: "Custom Phrases",
              subtitle: "Edit the quick phrases used on the Phrases tab.",
              settingWidget: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/phrase_editor');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Edit Phrases"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}