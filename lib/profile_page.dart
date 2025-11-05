import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Placeholder data - replace with actual user data from backend
  final String userName = "King Yuvraj";
  final String userEmail = "user.email@example.com";
  final String memberSince = "Joined: October 2025";
  final int totalGestures = 42;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80); // Deep blue

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFEAF3F5),
        elevation: 0,
        foregroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Profile Icon/Avatar ---
            CircleAvatar(
              radius: 60,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // --- User Name ---
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),

            // --- User Email ---
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // --- Stats Card ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatRow(Icons.calendar_today, "Member Since", memberSince, primaryColor),
                    const Divider(height: 30),
                    _buildStatRow(Icons.waving_hand, "Total Gestures Recognized", totalGestures.toString(), primaryColor),
                    const Divider(height: 30),
                    _buildStatRow(Icons.mic, "TTS Status", "Functional", primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Placeholder for future actions like changing password
            TextButton.icon(
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feature coming soon!')),
                 );
              },
              icon: Icon(Icons.edit, color: primaryColor),
              label: Text("Edit Profile", style: TextStyle(color: primaryColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}