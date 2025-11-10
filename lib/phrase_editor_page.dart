import 'package:flutter/material.dart';
import 'tts_manager.dart'; // Import the global TTS Manager

// This is the helper function for text fields
Widget _buildTextField(
    TextEditingController controller, String label, bool isPassword) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(color: Colors.black87), // Input text color
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFEAF3F5),
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10.0),
        child: Icon(
          isPassword
              ? Icons.lock_outline
              : (label == "Email"
                  ? Icons.email_outlined
                  : Icons.chat_bubble_outline_rounded), // Use a chat icon
          color: Colors.grey[600],
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label';
      }
      return null;
    },
  );
}


class PhraseEditorPage extends StatelessWidget {
  const PhraseEditorPage({super.key});

  // Function to show the "Add Phrase" dialog
  void _showAddPhraseDialog(BuildContext context) {
    final TextEditingController newPhraseController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>(); // For validation
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Phrase"),
          content: Form(
            key: formKey,
            child: _buildTextField(newPhraseController, "New phrase", false),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ttsManager.addQuickPhrase(newPhraseController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

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
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Add new phrase",
            onPressed: () => _showAddPhraseDialog(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: ttsManager.quickPhrases,
        builder: (context, phrases, child) {
          if (phrases.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No Quick Phrases",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the '+' icon to add your first phrase.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
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
                },
                onDelete: () {
                  ttsManager.deleteQuickPhrase(index);
                },
                // --- NEW: Set output text on tap ---
                onTap: () {
                  ttsManager.setOutputText(phrase);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[600],
                      content: Text('Set output to: "$phrase"'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ); 
            },
          ); 
        },
      ), 
    ); 
  }
}

// --- A new widget to handle the editing logic ---
class PhraseEditCard extends StatefulWidget {
  final String phrase;
  final int index;
  final Function(String newPhrase) onSave;
  final VoidCallback onDelete;
  final VoidCallback onTap; // <-- NEW: Tap callback

  const PhraseEditCard({
    super.key,
    required this.phrase,
    required this.index,
    required this.onSave,
    required this.onDelete,
    required this.onTap, // <-- NEW
  });

  @override
  State<PhraseEditCard> createState() => _PhraseEditCardState();
}

class _PhraseEditCardState extends State<PhraseEditCard> {
  late TextEditingController _controller;
  bool _isEditing = false;
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>(); // For validation

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phrase);
  }

  // Ensures the text in the edit box updates if the phrase is changed elsewhere
  @override
  void didUpdateWidget(covariant PhraseEditCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.phrase != oldWidget.phrase) {
      _controller.text = widget.phrase;
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleSave() {
    if (_editFormKey.currentState!.validate()) {
      widget.onSave(_controller.text);
      setState(() { _isEditing = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      // --- NEW: Make the card tappable ---
      child: InkWell(
        onTap: _isEditing ? null : widget.onTap, // Only tappable when not editing
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: _isEditing 
              ? const EdgeInsets.fromLTRB(16, 12, 16, 16)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _isEditing
                      ? 
                        Form(
                          key: _editFormKey,
                          child: _buildTextField(_controller, "Phrase ${widget.index + 1}", false)
                        )
                      : Text(
                          widget.phrase,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  ),
                  // --- NEW: Delete Button (only show when not editing) ---
                  if (!_isEditing)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: "Delete phrase",
                      onPressed: widget.onDelete,
                    ),
                  
                  // --- Edit / Save Button ---
                  IconButton(
                    icon: Icon(_isEditing ? Icons.done : Icons.edit_outlined),
                    tooltip: _isEditing ? "Save" : "Edit",
                    color: primaryColor,
                    onPressed: () {
                      if (_isEditing) {
                        _handleSave();
                      } else {
                        setState(() { _isEditing = true; });
                      }
                    },
                  ),
                ],
              ),
              if (_isEditing)
                const SizedBox(height: 12),
              if (_isEditing)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _controller.text = widget.phrase; // Reset text
                        setState(() { _isEditing = false; });
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _handleSave,
                      child: const Text("Save"),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}