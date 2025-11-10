import 'package:flutter/material.dart';
import 'tts_manager.dart'; // Import the global manager

// This is the new page for editing profile info
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Load the current values from the manager
    _nameController = TextEditingController(text: ttsManager.username.value);
    _emailController = TextEditingController(text: ttsManager.email.value);
    _phoneController = TextEditingController(text: ttsManager.phoneNumber.value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Call the manager to update and save the new info
    ttsManager.updateProfile(
      newName: _nameController.text,
      newEmail: _emailController.text,
      newPhone: _phoneController.text,
    );
    
    // Show a confirmation and go back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5),
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- Form Fields ---
            _buildEditTextField(_nameController, "Name", Icons.person_outline),
            const SizedBox(height: 16),
            _buildEditTextField(_emailController, "Email", Icons.email_outlined),
            const SizedBox(height: 16),
            _buildEditTextField(_phoneController, "Phone Number", Icons.phone_outlined),
            
            const SizedBox(height: 30),
            
            // --- Save Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveProfile,
                child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for text fields
  Widget _buildEditTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1C2D80), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 10.0),
          child: Icon(icon, color: Colors.grey[600]),
        ),
      ),
    );
  }
}