import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unmute/main.dart'; // <-- Using standard package reference
import 'package:camera/camera.dart'; 
import 'package:flutter/material.dart'; // <-- Re-added the material import needed for the mock

// A mock camera description for testing
const mockCamera = CameraDescription(
  name: 'mock',
  lensDirection: CameraLensDirection.front,
  sensorOrientation: 90,
);

void main() {
  testWidgets('App builds and shows WelcomePage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We must provide the mockCamera that UnmuteApp now requires.
    await tester.pumpWidget(const UnmuteApp(camera: mockCamera)); // Added 'const' to satisfy linting

    // Verify that the WelcomePage is shown (initialRoute: '/')
    // Check for the title text from the WelcomePage.
    expect(find.text('UNMUTE.AI'), findsOneWidget);
    
    // Check for one of the buttons
    expect(find.text('Sign Up'), findsOneWidget);

    // Ensure the main entry screen's slogan is present
    expect(find.text('Your Voice, Through Gestures'), findsOneWidget);

  });
  
  // --- NEW TEST FOR LOGIN NAVIGATION ---
  testWidgets('Navigate to LoginPage and verify content', (WidgetTester tester) async {
    // 1. Build the app at the starting screen
    await tester.pumpWidget(const UnmuteApp(camera: mockCamera));

    // 2. Tap the Login button
    // Find the button with the text "Login →"
    await tester.tap(find.text('Login →'));
    
    // The navigation happens instantly, but screen transitions may need a second pump.
    await tester.pumpAndSettle(); 

    // 3. Verify that the LoginPage content is visible
    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Log in to continue'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
  });
}
