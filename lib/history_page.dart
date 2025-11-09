import 'package:flutter/material.dart';
import 'tts_manager.dart'; // <-- Import the global TTS Manager

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5),
        elevation: 0,
        foregroundColor: primaryColor,
        actions: [
          // Add a button to clear the history
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: "Clear History",
            onPressed: () {
              // Show a confirmation dialog before clearing
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Clear History?'),
                    content: const Text('Are you sure you want to delete all spoken phrases? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Clear All'),
                        onPressed: () {
                          ttsManager.clearHistory();
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      // Use ValueListenableBuilder to automatically update the UI
      // whenever a new item is added to the history list in the TTS Manager.
      body: ValueListenableBuilder<List<String>>(
        valueListenable: ttsManager.history,
        builder: (context, historyList, child) {
          
          if (historyList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No History Yet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Gestures you use will appear here.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final phrase = historyList[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(phrase, style: const TextStyle(fontWeight: FontWeight.w500)),
                  // Add a button to re-speak the phrase
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up_outlined),
                    color: primaryColor,
                    onPressed: () {
                      ttsManager.speak(phrase);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}