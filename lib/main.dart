import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:camera/camera.dart';
// --- ML KIT IMPORTS ---
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; 

// --- ALL PAGE IMPORTS ---
import 'settings_page.dart';
import 'history_page.dart';
import 'profile_page.dart'; 
import 'tts_manager.dart'; 
import 'phrase_editor_page.dart'; 

// This global variable is needed for the app initialization
late CameraDescription firstCamera;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize TTS manager (loads settings, sets up engine)
  ttsManager; 

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  // We'll try to get the front camera first.
  firstCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first, // Fallback to the first camera
  );

  runApp(UnmuteApp(camera: firstCamera));
}

class UnmuteApp extends StatelessWidget {
  final CameraDescription camera;

  const UnmuteApp({
    super.key,
    required this.camera,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UNMUTE.AI",
      theme: ThemeData(
        fontFamily: "Roboto",
        scaffoldBackgroundColor: const Color(0xFFEAF3F5), // light bluish bg
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        // --- ROUTE TO NEW MAIN LAYOUT ---
        '/home': (context) => MainLayout(camera: camera), 
        '/settings': (context) => const SettingsPage(),
        '/history': (context) => const HistoryPage(),
        '/profile': (context) => const NewProfilePage(), 
        '/phrase_editor': (context) => const PhraseEditorPage(), 
      },
    );
  }
}

// --- WELCOME PAGE (Matches new design) ---
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder
                Image.asset(
                  "assets/logo.png",
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.mic,
                        size: 100,
                        color: Color(0xFF1C2D80)); 
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "UNMUTE.AI",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Your Voice, Through Gestures",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                // --- Sign Up Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("Sign Up", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 15),
                // --- Login Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text("Login →", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SIGNUP PAGE (Rebuilt to match image_8b0db0.png) ---
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  // --- SIMULATED REGISTER FUNCTION ---
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() { _isLoading = true; _errorMessage = ''; _successMessage = ''; });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() { _isLoading = false; _successMessage = 'Registration successful!'; });
    }
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) { Navigator.pop(context); }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Content ---
            Text(
              "Welcome to",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "UNMUTE.AI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.mic, size: 80, color: Colors.indigo[900]),
            const SizedBox(height: 30),

            // --- Form Container ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_usernameController, "Name", false),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, "Email", false),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, "Password", true),
                    const SizedBox(height: 12),
                    
                    // --- Error/Success Messages ---
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[300], fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_successMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _successMessage,
                          style: TextStyle(color: Colors.green[300], fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 18),

                    // --- Next Button ---
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _registerUser,
                              child: const Text("Next"),
                            ),
                    ),
                    const SizedBox(height: 30),

                    // --- Sign In Link ---
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            style: const TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- LOGIN PAGE (Rebuilt to match image_8b6028.png) ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // --- SIMULATED LOGIN FUNCTION ---
  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }
    setState(() { _isLoading = true; _errorMessage = ''; });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Content ---
            const SizedBox(height: 10),
            Text(
              "Log in to continue",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              "UNMUTE.AI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
            const SizedBox(height: 20),
            Icon(Icons.mic, size: 80, color: Colors.indigo[900]),
            const SizedBox(height: 30),
            
            // --- Form Container ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Log In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_emailController, "Email", false), 
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, "Password", true), 
                    const SizedBox(height: 12),
                    
                    // --- Error Message ---
                    if (_errorMessage.isNotEmpty)
                      Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[300], fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 18),

                    // --- Login Button ---
                    Center(
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _loginUser,
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // --- Forgot Password ---
                    Center(
                        child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Forgot Password Tapped (Not Implemented)')),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
                    const SizedBox(height: 20),

                    // --- Sign Up Link ---
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup'); 
                        },
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Helper for Login/Signup TextFields ---
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
          const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0), // Increased padding
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10.0), // Adjust icon padding
        child: Icon(
          isPassword
              ? Icons.lock_outline
              : (label == "Email"
                  ? Icons.email_outlined
                  : Icons.person_outline),
          color: Colors.grey[600],
        ),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label';
      }
      if (label == "Email" && !value.contains('@')) {
        return 'Please enter a valid email';
      }
      if (label == "Password" && value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      return null;
    },
  );
} 


// --- NEW: MAIN LAYOUT WIDGET ---
// This widget manages the Bottom Navigation Bar and switches pages
class MainLayout extends StatefulWidget {
  final CameraDescription camera;
  const MainLayout({super.key, required this.camera});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Define the pages for the bottom nav bar
    _pages = [
      GestureHomePage(camera: widget.camera), // Tab 0
      const PhraseEditorPage(), // Tab 1
      const NewProfilePage(), // Tab 2 (Using the new profile page)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Phrases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo[900],
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- GESTURE HOME PAGE (Formerly HomePage) ---
class GestureHomePage extends StatefulWidget {
  final CameraDescription camera;

  const GestureHomePage({
    super.key,
    required this.camera,
  });

  @override
  State<GestureHomePage> createState() => _GestureHomePageState();
}

class _GestureHomePageState extends State<GestureHomePage> {
  String _outputText = "Your recognized text will appear here";
  bool _isCameraOn = false;
  
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  late PoseDetector _poseDetector;
  bool _isDetectingPoses = false;

  Timer? _gestureCooldownTimer;
  bool _isGestureOnCooldown = false;


  @override
  void initState() {
    super.initState.call();
    _initializePoseDetector();
  }

  void _initializePoseDetector() {
    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    );
    _poseDetector = PoseDetector(options: options);
  }


  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    try {
      await _cameraController!.initialize();
      
      await _cameraController!.startImageStream((CameraImage image) {
        _processCameraImage(image);
      });

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
      setState(() {
         _isCameraOn = false; 
         _outputText = "Could not initialize camera. Please check permissions.";
      });
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetectingPoses || _isGestureOnCooldown) return;
    if (!mounted) return;
    setState(() { _isDetectingPoses = true; });

    try {
      // --- FIX: Call the function *without* the underscore ---
      final InputImage inputImage = createInputImageFromCameraImage(image);
      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      if (mounted) { _analyzePoses(poses); }
    } catch (e) {
      print("Error processing image: $e");
    } finally {
      if (mounted) { setState(() { _isDetectingPoses = false; }); }
    }
  }

  void _analyzePoses(List<Pose> poses) {
    if (poses.isEmpty || !mounted) return;
    final Pose firstPose = poses.first;

    if (isThumbsUp(firstPose)) { _triggerGesture("Hello, Thumbs Up!"); }
    else if (isHandsUp(firstPose)) { _triggerGesture("Hello, you are waving!"); }
    else if (isHandsOnHead(firstPose)) { _triggerGesture("Why are your hands on your head?"); }
    else if (isStopGesture(firstPose)) { _triggerGesture("Stop. I need a moment."); }
    else if (isClapping(firstPose)) { _triggerGesture("Attention, please!"); }
    else if (isPointing(firstPose)) { _triggerGesture("Look over there!"); }
  }


  void _triggerGesture(String text) {
    if (_isGestureOnCooldown || !mounted) return;

    setState(() {
      _outputText = text;
      _isGestureOnCooldown = true;
    });
    ttsManager.speak(text);

    _gestureCooldownTimer?.cancel();
    _gestureCooldownTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() { _isGestureOnCooldown = false; });
      }
    });
  }


  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector.close();
    _gestureCooldownTimer?.cancel();
    super.dispose();
  }

  void _toggleCamera() async {
    if (_isCameraOn) {
      await _cameraController?.stopImageStream();
      await _cameraController?.dispose();
       if (mounted) {
        setState(() {
          _isCameraOn = false;
          _isCameraInitialized = false;
          _cameraController = null;
          _outputText = "Camera is off";
        });
      }
      print("Camera stopping...");
    } else {
      if (mounted) {
        setState(() {
          _isCameraOn = true;
          _outputText = "Initializing camera...";
        });
      }
      print("Camera starting...");
      await _initializeCamera();
      
      if(mounted && _isCameraInitialized) {
        setState(() {
           _outputText = "Camera is on. Show me a gesture!";
        });
      }
    }
  }

  void _speakText() {
    if (_outputText.isNotEmpty) {
      print("Speaking: $_outputText");
      ttsManager.speak(_outputText);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80); // Deep blue
    const Color backgroundColor = Color(0xFFF4F8FA); // Light blue/white
    const Color cardColor = Colors.white;

    // This Scaffold is now the BODY of the MainLayout
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Remove the back arrow
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, User!", // Placeholder
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              "Express Yourself Freely",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCameraCard(primaryColor, cardColor),
            const SizedBox(height: 20),
            _buildOutputCard(primaryColor, cardColor),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCameraCard(Color primaryColor, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.camera_alt_rounded, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Camera",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _toggleCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCameraOn ? Colors.red : primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(_isCameraOn ? "Stop Camera" : "Start Camera"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect( 
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: (_isCameraOn && _isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized)
                      ? AspectRatio(
                          aspectRatio: _cameraController!.value.aspectRatio,
                          child: CameraPreview(_cameraController!),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.no_photography_rounded,
                                color: Colors.grey[400], size: 50),
                            const SizedBox(height: 8),
                            Text(
                              _isCameraOn ? "Initializing..." : "Camera is off",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputCard(Color primaryColor, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.volume_up_rounded, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Output",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _speakText,
                  icon: Icon(Icons.mic_rounded, color: primaryColor, size: 30),
                  tooltip: "Speak text",
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView( 
                child: Text(
                  _outputText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- GESTURE LOGIC MOVED OUTSIDE THE CLASS ---

// --- FIX: This function is now *outside* the class ---
InputImage createInputImageFromCameraImage(CameraImage image) {
  final cameraRotation = InputImageRotation.rotation270deg;

  final InputImageFormat inputImageFormat =
      InputImageFormatValue.fromRawValue(image.format.raw) ??
          InputImageFormat.nv21;
  
  final metadata = InputImageMetadata(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: cameraRotation,
    format: inputImageFormat,
    bytesPerRow: image.planes.first.bytesPerRow,
  );

  final bytes = image.planes.first.bytes;

  return InputImage.fromBytes(
    bytes: bytes,
    metadata: metadata,
  );
}

bool isThumbsUp(Pose pose) {
  final PoseLandmark? leftThumb = pose.landmarks[PoseLandmarkType.leftThumb];
  final PoseLandmark? leftPinky = pose.landmarks[PoseLandmarkType.leftPinky];
  final PoseLandmark? rightThumb = pose.landmarks[PoseLandmarkType.rightThumb];
  final PoseLandmark? rightPinky = pose.landmarks[PoseLandmarkType.rightPinky];

  if (leftThumb == null || leftPinky == null || rightThumb == null || rightPinky == null) {
    return false;
  }
  bool rightThumbsUp = (rightThumb.y < rightPinky.y);
  bool leftThumbsUp = (leftThumb.y < leftPinky.y);
  return leftThumbsUp || rightThumbsUp;
}

bool isHandsUp(Pose pose) {
  final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  final PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  final PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if (leftWrist == null || leftShoulder == null || rightWrist == null || rightShoulder == null) {
    return false;
  }
  bool leftHandUp = leftWrist.y < leftShoulder.y;
  bool rightHandUp = rightWrist.y < rightShoulder.y;
  return leftHandUp || rightHandUp;
}

bool isHandsOnHead(Pose pose) {
  final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  final PoseLandmark? nose = pose.landmarks[PoseLandmarkType.nose];

  if (leftWrist == null || rightWrist == null || nose == null) {
    return false;
  }
  bool bothHandsUp = (leftWrist.y < nose.y && rightWrist.y < nose.y);
  return bothHandsUp;
}

bool isStopGesture(Pose pose) {
  final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];
  final PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
  final PoseLandmark? rightElbow = pose.landmarks[PoseLandmarkType.rightElbow];
  
  if (leftWrist == null || rightWrist == null || leftElbow == null || rightElbow == null) {
    return false;
  }
  bool handsExtended = (leftWrist.y < leftElbow.y) && (rightWrist.y < rightElbow.y);
  bool armsSpread = (rightWrist.x - leftWrist.x).abs() > (rightElbow.x - leftElbow.x).abs();
  return handsExtended && armsSpread;
}

bool isClapping(Pose pose) {
  final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

  if (leftWrist == null || rightWrist == null) {
    return false;
  }
  final double horizontalDistance = (leftWrist.x - rightWrist.x).abs();
  final double verticalAlignment = (leftWrist.y - rightWrist.y).abs();
  final double alignmentThreshold = 0.1; 

  return horizontalDistance < alignmentThreshold && verticalAlignment < alignmentThreshold;
}

bool isPointing(Pose pose) {
  final PoseLandmark? leftIndex = pose.landmarks[PoseLandmarkType.leftIndex];
  final PoseLandmark? rightIndex = pose.landmarks[PoseLandmarkType.rightIndex];
  final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
  final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

  if (leftIndex == null || rightIndex == null || leftWrist == null || rightWrist == null) {
    return false;
  }
  bool isLeftPointingOut = (leftIndex.x - leftWrist.x).abs() > 0.1;
  bool isRightPointingOut = (rightIndex.x - rightWrist.x).abs() > 0.1;
  bool leftFingerIsHigh = leftIndex.y < leftWrist.y;
  bool rightFingerIsHigh = rightIndex.y < rightWrist.y;
  return (isLeftPointingOut && leftFingerIsHigh) || (isRightPointingOut && rightFingerIsHigh);
}  