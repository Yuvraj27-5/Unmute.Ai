import 'package:flutter/material.dart';
import 'tts_manager.dart'; // Import the global TTS Manager

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5),
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      // We use ValueListenableBuilder to automatically update the UI
      // whenever a new item is added to the history list in the TTS Manager.
      body: ValueListenableBuilder<List<String>>(
        valueListenable: ttsManager.history,
        builder: (context, historyList, child) {
          if (historyList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 10),
                  const Text(
                    "No recognized phrases yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Text(
                    "Start your camera and use a gesture!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              // History items are stored in reverse chronological order (newest first)
              final phrase = historyList[index];
              
              // Note: For simplicity, we are using the current time as the timestamp
              // since we are not storing history in SharedPreferences or a database.
              final now = DateTime.now();
              final timeString = '${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.volume_up, color: primaryColor),
                  title: Text(
                    phrase,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Spoken at: $timeString',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  // Tapping the history item replays the speech
                  onTap: () => ttsManager.speak(phrase),
                ),
              );
            },
          );
        },
      ),
    );
  }
}