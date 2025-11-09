import 'package:flutter/material.dart';
import 'tts_manager.dart'; // <-- FIX: Import the global TTS Manager

class PhraseEditorPage extends StatelessWidget {
  const PhraseEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80); // Deep blue
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text(
          "Quick Phrase Editor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5),
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      // Listen directly to the list of phrases in the global manager
      body: ValueListenableBuilder<List<String>>(
        valueListenable: ttsManager.quickPhrases,
        builder: (context, phrases, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return PhraseEditCard(
                phrase: phrase,
                index: index,
                onSave: (newPhrase) {
                  ttsManager.updateQuickPhrase(index, newPhrase);
                  Navigator.pop(context); // Close editor after saving
                },
              ); // PhraseEditCard
            },
          ); // ListView.builder
        },
      ), // ValueListenableBuilder
    ); // Scaffold
  }
}

// --- A new widget to handle the editing logic ---
class PhraseEditCard extends StatefulWidget {
  final String phrase;
  final int index;
  final Function(String newPhrase) onSave;

  const PhraseEditCard({
    super.key,
    required this.phrase,
    required this.index,
    required this.onSave,
  });

  @override
  State<PhraseEditCard> createState() => _PhraseEditCardState();
}

class _PhraseEditCardState extends State<PhraseEditCard> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phrase);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Row for text or textfield
            Row(
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: _controller,
                          autofocus: true,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Enter new phrase",
                            isDense: true,
                          ),
                        )
                      : Text(
                          widget.phrase,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(_isEditing ? Icons.done : Icons.edit),
                  color: primaryColor,
                  onPressed: () {
                    if (_isEditing) {
                      // Save action
                      if (_controller.text.isNotEmpty) {
                        widget.onSave(_controller.text);
                        // No need to pop here, onSave handles it
                      } else {
                        // Show error if empty
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Phrase cannot be empty.')),
                        );
                      }
                    }
                    // Toggle editing state
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}