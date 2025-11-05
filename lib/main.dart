import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
// --- ML KIT IMPORTS ---
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; 

// --- NEW PAGE IMPORTS ---
import 'settings_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'tts_manager.dart'; // Global TTS Manager import

// This global variable is needed for the app initialization
late CameraDescription firstCamera;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

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
        '/home': (context) => HomePage(camera: camera),
        // --- ADDED NEW PAGE ROUTES ---
        '/settings': (context) => const SettingsPage(),
        '/history': (context) => const HistoryPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    minimumSize:
                        const Size(200, 50),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    minimumSize:
                        const Size(200, 50),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text("Login →"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _successMessage = 'Registration successful! Proceeding to login.';
      });
    }

    // Go back to login after success message
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
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
        title: const Text("Sign Up"),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_usernameController, "Name", false),
                    const SizedBox(height: 20),
                    _buildTextField(_emailController, "Email", false),
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, "Password", true),
                    const SizedBox(height: 12),
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
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                side: const BorderSide(color: Colors.white),
                                foregroundColor: Colors.white,
                                minimumSize:
                                    const Size(150, 50),
                              ),
                              onPressed: _registerUser,
                              child: const Text("Sign Up"),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(
                                context, '/login');
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
                                    decoration:
                                        TextDecoration.underline
                                    ),
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

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87),
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
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        prefixIcon: Icon(
          isPassword
              ? Icons.lock_outline
              : (label == "Email"
                  ? Icons.email_outlined
                  : Icons.person_outline),
          color: Colors.grey[600],
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
} 

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

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Simulate network delay and successful login
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Navigate immediately to the home page
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
            const SizedBox(height: 20),
            Text(
              "UNMUTE.AI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Log in to continue",
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.indigo[900],
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Log In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(_emailController, "Email", false), 
                    const SizedBox(height: 20),
                    _buildTextField(_passwordController, "Password", true), 
                    const SizedBox(height: 12),
                      if (_errorMessage.isNotEmpty)
                        Center(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red[300], fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    const SizedBox(height: 18),
                    Center(
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white,) : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          side: const BorderSide(color: Colors.white),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(150, 50),
                        ),
                        onPressed: _loginUser,
                        child: const Text("Login"),
                      ),
                    ),
                    const SizedBox(height: 15),
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
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/signup'); 
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

  Widget _buildTextField(
      TextEditingController controller, String label, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black87),
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
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        prefixIcon: Icon(
          isPassword
              ? Icons.lock_outline
              : (label == "Email"
                  ? Icons.email_outlined
                  : Icons.person_outline),
          color: Colors.grey[600],
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
} 


class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({
    super.key,
    required this.camera,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _outputText = "Your recognized text will appear here";
  bool _isCameraOn = false;
  
  // We use the global ttsManager instead of managing FlutterTts locally
  // late FlutterTts _flutterTts;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  late PoseDetector _poseDetector;
  bool _isDetectingPoses = false;

  Timer? _gestureCooldownTimer;
  bool _isGestureOnCooldown = false;


  @override
  void initState() {
    super.initState.call();
    // TTS initialization is now handled globally by ttsManager
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

    setState(() {
      _isDetectingPoses = true;
    });

    try {
      final InputImage inputImage = _createInputImageFromCameraImage(image);
      
      final List<Pose> poses = await _poseDetector.processImage(inputImage);
      
      if (mounted) {
        _analyzePoses(poses);
      }

    } catch (e) {
      print("Error processing image: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isDetectingPoses = false;
        });
      }
    }
  }

  void _analyzePoses(List<Pose> poses) {
    if (poses.isEmpty) {
      return;
    }
    final Pose firstPose = poses.first;

    if (isThumbsUp(firstPose)) {
      _triggerGesture("Hello, Thumbs Up!");
    }
    else if (isHandsUp(firstPose)) {
      _triggerGesture("Hello, you are waving!");
    }
    else if (isHandsOnHead(firstPose)) {
      _triggerGesture("Why are your hands on your head?");
    }
    else if (isStopGesture(firstPose)) {
      _triggerGesture("Stop. I need a moment.");
    }
    else if (isClapping(firstPose)) {
      _triggerGesture("Attention, please!");
    }
    else if (isPointing(firstPose)) {
      _triggerGesture("Look over there!");
    }
  }


  void _triggerGesture(String text) {
    if (_isGestureOnCooldown) return;

    setState(() {
      _outputText = text;
      _isGestureOnCooldown = true;
    });
    // Use the global manager for speaking
    ttsManager.speak(text);

    _gestureCooldownTimer?.cancel();
    _gestureCooldownTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isGestureOnCooldown = false;
        });
      }
    });
  }


  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector.close();
    _gestureCooldownTimer?.cancel();
    // We do NOT dispose FlutterTts here, as it's globally managed by ttsManager
    super.dispose();
  }

  void _toggleCamera() async {
    if (_isCameraOn) {
      await _cameraController?.stopImageStream();
      await _cameraController?.dispose();
      setState(() {
        _isCameraOn = false;
        _isCameraInitialized = false;
        _cameraController = null;
        _outputText = "Camera is off";
      });
      print("Camera stopping...");
    } else {
      setState(() {
        _isCameraOn = true;
        _outputText = "Initializing camera...";
      });
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
      // Use the global manager for speaking
      ttsManager.speak(_outputText);
    }
  }

  void _onQuickPhraseTapped(String phrase) {
    setState(() {
      _outputText = phrase;
    });
    // Use the global manager for speaking
    ttsManager.speak(phrase);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1C2D80); // Deep blue
    const Color backgroundColor = Color(0xFFF4F8FA); // Light blue/white
    const Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      // --- ADDED NAVIGATION DRAWER ---
      endDrawer: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[900],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('UNMUTE.AI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Welcome, User!', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            _buildDrawerTile(Icons.person, "Profile", primaryColor, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            }),
            _buildDrawerTile(Icons.settings, "Settings", primaryColor, () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/settings'); // Navigate to Settings Page
            }),
            _buildDrawerTile(Icons.history, "History", primaryColor, () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/history');
            }),
            const Divider(color: Colors.white54, indent: 16, endIndent: 16),
            _buildDrawerTile(Icons.logout, "Log Out", primaryColor, () {
              // Clear navigation stack and go to the Welcome Page
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            }),
          ],
        ),
      ),
      // --- END OF NAVIGATION DRAWER ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, User!",
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
        actions: [
          // --- MODIFIED TO OPEN DRAWER ---
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: primaryColor, size: 30),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCameraCard(primaryColor, cardColor),
            const SizedBox(height: 20),
            _buildOutputCard(primaryColor, cardColor),
            const SizedBox(height: 20),
            _buildQuickPhrasesCard(primaryColor, cardColor),
          ],
        ),
      ),
    );
  }
  
  // --- HELPER WIDGET FOR DRAWER TILES ---
  Widget _buildDrawerTile(IconData icon, String title, Color primaryColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: onTap,
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
              child: ClipRRect( // Clip the preview to the container's border radius
                borderRadius: BorderRadius.circular(15),
                child: Center(
                  child: (_isCameraOn && _isCameraInitialized && _cameraController != null && _cameraController!.value.isInitialized)
                      ? AspectRatio(
                          // Use a built-in aspect ratio to prevent distortion
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

  Widget _buildQuickPhrasesCard(Color primaryColor, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quick Phrases",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _buildPhraseButton("Hello"),
                _buildPhraseButton("I need help"),
                _buildPhraseButton("Thank you"),
                _buildPhraseButton("Goodbye"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseButton(String phrase) {
    return FilledButton.tonal(
      onPressed: () => _onQuickPhraseTapped(phrase),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        phrase,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  InputImage _createInputImageFromCameraImage(CameraImage image) {
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

  // --- START GESTURE LOGIC ---

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
    // Check if arms are spread out horizontally (wrists are far apart on the X-axis)
    bool armsSpread = (rightWrist.x - leftWrist.x).abs() > (rightElbow.x - leftElbow.x).abs();

    return handsExtended && armsSpread;
  }

  // --- NEW GESTURE: CLAP ---
  bool isClapping(Pose pose) {
    final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftWrist == null || rightWrist == null) {
      return false;
    }

    // Check if wrists are close horizontally (X-axis) and roughly aligned vertically (Y-axis)
    final double horizontalDistance = (leftWrist.x - rightWrist.x).abs();
    final double verticalAlignment = (leftWrist.y - rightWrist.y).abs();
    final double alignmentThreshold = 0.05; // 5% of screen width (approx)

    return horizontalDistance < alignmentThreshold && verticalAlignment < alignmentThreshold;
  }

  // --- NEW GESTURE: POINT ---
  bool isPointing(Pose pose) {
    final PoseLandmark? leftIndex = pose.landmarks[PoseLandmarkType.leftIndex];
    final PoseLandmark? rightIndex = pose.landmarks[PoseLandmarkType.rightIndex];
    final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final PoseLandmark? rightWrist = pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftIndex == null || rightIndex == null || leftWrist == null || rightWrist == null) {
      return false;
    }

    // Simple check: Is the index finger significantly far from the wrist on the X-axis?
    bool isLeftPointingOut = (leftIndex.x - leftWrist.x).abs() > 0.1;
    bool isRightPointingOut = (rightIndex.x - rightWrist.x).abs() > 0.1;

    // Check if index finger is the highest (Y is smallest) point in the hand region
    bool leftFingerIsHigh = leftIndex.y < leftWrist.y;
    bool rightFingerIsHigh = rightIndex.y < rightWrist.y;


    return (isLeftPointingOut && leftFingerIsHigh) || (isRightPointingOut && rightFingerIsHigh);
  }
}