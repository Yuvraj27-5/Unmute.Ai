import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_unmute/main.dart'; // <-- Using standard package reference
import 'package:camera/camera.dart'; 
import 'package:flutter/material.dart'; // <-- Re-added the material import

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
    await tester.pumpWidget(const UnmuteApp(camera: mockCamera));

    // Verify that the WelcomePage is shown (initialRoute: '/')
    // Check for the title text from the WelcomePage.
    expect(find.text('UNMUTE.AI'), findsOneWidget);
    
    // Check for one of the buttons
    expect(find.text('Sign Up'), findsOneWidget);

    // Ensure the main entry screen's slogan is present
    expect(find.text('Your Voice, Through Gestures'), findsOneWidget);
  });
  
  // --- Test for Login Page Navigation ---
  testWidgets('Navigate to LoginPage and verify content', (WidgetTester tester) async {
    // 1. Build the app at the starting screen
    await tester.pumpWidget(const UnmuteApp(camera: mockCamera));

    // 2. Tap the Login button
    await tester.tap(find.text('Login →'));
    
    // Wait for the navigation transition to complete
    await tester.pumpAndSettle(); 

    // 3. Verify that the new LoginPage content is visible
    expect(find.text('Log In'), findsOneWidget); // The title in the blue card
    expect(find.text('Log in to continue'), findsOneWidget); // The subtitle
    expect(find.widgetWithText(OutlinedButton, 'Login'), findsOneWidget); // The login button
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  // --- NEW TEST: Test successful login navigation ---
  testWidgets('Login success navigates to MainLayout (Bottom Nav Bar)', (WidgetTester tester) async {
    // 1. Build the app and navigate to the Login page
    await tester.pumpWidget(const UnmuteApp(camera: mockCamera));
    await tester.tap(find.text('Login →'));
    await tester.pumpAndSettle();

    // 2. Enter valid text into the fields
    // We can use any text because the login is simulated
    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '123456');

    // 3. Tap the "Login" button
    await tester.tap(find.widgetWithText(OutlinedButton, 'Login'));

    // 4. Wait for the simulated login (Future.delayed) and navigation
    await tester.pumpAndSettle();

    // 5. Verify that we are on the MainLayout page by looking for the
    //    text labels in the new Bottom Navigation Bar.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Phrases'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 6. Verify that the GestureHomePage (the default tab) is visible
    expect(find.text('Camera is off'), findsOneWidget);
  });
}