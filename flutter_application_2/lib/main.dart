import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:io';

void main() {
  runApp(const ApplisevApp());
}

class ApplisevApp extends StatelessWidget {
  const ApplisevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Applisev',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedGender;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a Applisev',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.directions_car,
                  size: 80,
                  color: Color(0xFF1E88E5),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                }
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                isLogin = false;
              });
            },
            child: const Text(
              '¿No tienes cuenta? Regístrate',
              style: TextStyle(
                color: Color(0xFF1E88E5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Es rápido y fácil.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          _buildNameFields(),
          const SizedBox(height: 16),
          _buildBirthDateField(),
          const SizedBox(height: 16),
          _buildGenderField(),
          const SizedBox(height: 16),
          _buildContactField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          const Text(
            'Al hacer clic en "Registrarte", aceptas nuestras Condiciones, la Política de privacidad y la Política de cookies.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                }
              },
              child: const Text(
                'Registrarte',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isLogin = true;
                });
              },
              child: const Text(
                '¿Ya tienes una cuenta? Inicia sesión',
                style: TextStyle(
                  color: Color(0xFF1E88E5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Apellido',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu apellido';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha de nacimiento',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              setState(() {
                _birthDate = selectedDate;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _birthDate == null
                      ? 'Selecciona tu fecha'
                      : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                  style: TextStyle(
                    color: _birthDate == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Género',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _selectedGender == 'Mujer'
                        ? const Color(0xFF1E88E5)
                        : Colors.grey,
                  ),
                  backgroundColor: _selectedGender == 'Mujer'
                      ? const Color(0xFF1E88E5).withOpacity(0.1)
                      : null,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _selectedGender = 'Mujer';
                  });
                },
                child: Text(
                  'Mujer',
                  style: TextStyle(
                    color: _selectedGender == 'Mujer'
                        ? const Color(0xFF1E88E5)
                        : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _selectedGender == 'Hombre'
                        ? const Color(0xFF1E88E5)
                        : Colors.grey,
                  ),
                  backgroundColor: _selectedGender == 'Hombre'
                      ? const Color(0xFF1E88E5).withOpacity(0.1)
                      : null,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  setState(() {
                    _selectedGender = 'Hombre';
                  });
                },
                child: Text(
                  'Hombre',
                  style: TextStyle(
                    color: _selectedGender == 'Hombre'
                        ? const Color(0xFF1E88E5)
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Número de celular o correo electrónico',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu celular o correo';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Contraseña nueva',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu contraseña';
        }
        if (value.length < 6) {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
        return null;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final String _userEmail = 'usuario@applisev.com';
  ImageProvider? _profileImage;

  final List<Widget> _screens = [
    const ProfileScreen(),
    const TrafficRulesScreen(),
    const AIAssistantScreen(), // Reemplazado por el nuevo Asistente de IA
    const VideoTutorialsScreen(),
    const EmergencyPlacesScreen(),
    const SettingsScreen(),
  ];

  Future<void> _changeProfileImage() async {
    // Implementar lógica para cambiar imagen de perfil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applisev'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Usuario Applisev'),
              accountEmail: Text(_userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: _profileImage ?? const AssetImage('assets/default_profile.png'),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1E88E5),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.traffic),
              title: const Text('Reglas de Tránsito'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome), // Nuevo ícono para el asistente
              title: const Text('Asistente de IA (CyberPilot)'),
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video Tutoriales'),
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Lugares de Emergencia'),
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                setState(() => _currentIndex = 5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}




class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  bool loading = false;
  final controller = TextEditingController();
  final List<String> messages = [];
  final String apiKey = 'AIzaSyBiY4LztLO-DKCuk5HiakM8FGy5CrkhAM0'; // Reemplaza con tu clave real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CyberPilot - Gemini'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Escribe tu pregunta sobre seguridad vial...",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          if (loading) const LinearProgressIndicator(),
          ...messages.reversed.map((message) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                message,
                style: TextStyle(
                  color: message.startsWith("Tú") 
                     ? Colors.blue 
                     : Colors.green[800],
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (controller.text.isEmpty || loading) return;

    setState(() {
      messages.add("Tú: ${controller.text}");
      loading = true;
    });

    try {
      // Usamos el modelo correcto para la API v1beta
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey'
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': 'Eres CyberPilot, experto en seguridad vial. Responde en español de forma clara y concisa.'},
                {'text': controller.text}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 1000,
          }
        }),
      );

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final textResponse = responseData['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          messages.add("CyberPilot: $textResponse");
        });
      } else {
        setState(() {
          messages.add("Error ${response.statusCode}: ${responseData['error']?['message'] ?? 'Error desconocido'}");
        });
      }
    } catch (e) {
      setState(() {
        messages.add("Error: ${e.toString()}");
      });
    } finally {
      setState(() => loading = false);
      controller.clear();
    }
  }
}



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/default_profile.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Usuario Applisev',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'usuario@applisev.com',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person, 'Nombre completo', 'Usuario Applisev'),
                  const Divider(),
                  _buildProfileItem(Icons.phone, 'Teléfono', '+52 123 456 7890'),
                  const Divider(),
                  _buildProfileItem(Icons.cake, 'Fecha de nacimiento', '01/01/1990'),
                  const Divider(),
                  _buildProfileItem(Icons.transgender, 'Género', 'Masculino'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Editar perfil'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrafficRulesScreen extends StatefulWidget {
  const TrafficRulesScreen({super.key});

  @override
  State<TrafficRulesScreen> createState() => _TrafficRulesScreenState();
}

class _TrafficRulesScreenState extends State<TrafficRulesScreen> {
  late final WebViewController _controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al cargar la página: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://matamoros.gob.mx')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://matamoros.gob.mx/conoce-el-reglamento-de-transito-y-evita-multas/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reglamento de Tránsito'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              backgroundColor: Colors.transparent,
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class VehicleTrackingScreen extends StatelessWidget {
  const VehicleTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gps_fixed, size: 80, color: Colors.blue),
          const SizedBox(height: 20),
          const Text(
            'Rastreo Vehicular',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Esta función te permite rastrear la ubicación en tiempo real de tu vehículo conectado al sistema Applisev.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.directions_car),
            label: const Text('Conectar vehículo'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoTutorialsScreen extends StatelessWidget {
  const VideoTutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Tutoriales'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildVideoCard(
            'Señales de tránsito básicas',
            'Aprende a identificar las señales de tránsito más importantes',
            Icons.play_circle_fill,
            Colors.red,
          ),
          _buildVideoCard(
            'Cómo cambiar un neumático',
            'Guía paso a paso para cambiar una llanta ponchada',
            Icons.play_circle_fill,
            Colors.blue,
          ),
          _buildVideoCard(
            'Mantenimiento básico del auto',
            'Conoce los mantenimientos esenciales para tu vehículo',
            Icons.play_circle_fill,
            Colors.green,
          ),
          _buildVideoCard(
            'Conducción defensiva',
            'Técnicas para anticiparte a situaciones peligrosas',
            Icons.play_circle_fill,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyPlacesScreen extends StatefulWidget {
  const EmergencyPlacesScreen({super.key});

  @override
  State<EmergencyPlacesScreen> createState() => _EmergencyPlacesScreenState();
}

class _EmergencyPlacesScreenState extends State<EmergencyPlacesScreen> {
  late GoogleMapController _mapController;
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 12,
  );

  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  bool _loading = true;
  String _selectedCategory = 'hospital';
  bool _showCategories = true;
  List<dynamic> _places = [];
  dynamic _selectedPlace;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loading = false);
      _showLocationServiceDisabledAlert();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        _showLocationPermissionDeniedAlert();
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _initialCameraPosition = CameraPosition(
          target: _currentPosition!,
          zoom: 14,
        );
      });

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(_initialCameraPosition),
      );
      
      await _fetchNearbyPlaces();
    } catch (e) {
      print("Error obteniendo ubicación: $e");
      setState(() => _loading = false);
      _showLocationErrorAlert();
    }
  }

  Future<void> _fetchNearbyPlaces() async {
    if (_currentPosition == null) return;

    setState(() {
      _loading = true;
      _places = [];
      _markers.clear();
      _selectedPlace = null;
    });

    try {
      // Simulación de datos basados en la ubicación actual
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _places = _getMockPlaces();
        _loading = false;
      });
      _updateMarkers();
    } catch (e) {
      print("Error fetching places: $e");
      setState(() => _loading = false);
      _showPlacesFetchError();
    }
  }

  List<Map<String, dynamic>> _getMockPlaces() {
    if (_selectedCategory == 'hospital') {
      return [
        {
          'place_id': '1',
          'name': 'Hospital cercano',
          'vicinity': 'A ${(500 + _random.nextInt(1000)).toString()} metros de tu ubicación',
          'geometry': {
            'location': {
              'lat': _currentPosition!.latitude + (0.001 + _random.nextDouble() * 0.01),
              'lng': _currentPosition!.longitude + (0.001 + _random.nextDouble() * 0.01)
            }
          },
          'rating': 3.5 + _random.nextDouble() * 1.5,
          'user_ratings_total': 50 + _random.nextInt(200),
          'opening_hours': {'open_now': _random.nextBool()},
          'formatted_phone_number': '55 ${1000 + _random.nextInt(9000)} ${1000 + _random.nextInt(9000)}'
        },
        {
          'place_id': '2',
          'name': 'Clínica de emergencias',
          'vicinity': 'A ${(500 + _random.nextInt(1000)).toString()} metros de tu ubicación',
          'geometry': {
            'location': {
              'lat': _currentPosition!.latitude - (0.001 + _random.nextDouble() * 0.01),
              'lng': _currentPosition!.longitude + (0.001 + _random.nextDouble() * 0.01)
            }
          },
          'rating': 3.5 + _random.nextDouble() * 1.5,
          'user_ratings_total': 50 + _random.nextInt(200),
          'opening_hours': {'open_now': _random.nextBool()},
          'formatted_phone_number': '55 ${1000 + _random.nextInt(9000)} ${1000 + _random.nextInt(9000)}'
        }
      ];
    } else if (_selectedCategory == 'police') {
      return [
        {
          'place_id': '3',
          'name': 'Estación de policía',
          'vicinity': 'A ${(500 + _random.nextInt(1000)).toString()} metros de tu ubicación',
          'geometry': {
            'location': {
              'lat': _currentPosition!.latitude + (0.001 + _random.nextDouble() * 0.01),
              'lng': _currentPosition!.longitude - (0.001 + _random.nextDouble() * 0.01)
            }
          },
          'rating': 3.5 + _random.nextDouble() * 1.5,
          'user_ratings_total': 50 + _random.nextInt(200),
          'opening_hours': {'open_now': true},
          'formatted_phone_number': '55 ${1000 + _random.nextInt(9000)} ${1000 + _random.nextInt(9000)}'
        },
      ];
    } else if (_selectedCategory == 'fire_station') {
      return [
        {
          'place_id': '4',
          'name': 'Estación de bomberos',
          'vicinity': 'A ${(500 + _random.nextInt(1000)).toString()} metros de tu ubicación',
          'geometry': {
            'location': {
              'lat': _currentPosition!.latitude - (0.001 + _random.nextDouble() * 0.01),
              'lng': _currentPosition!.longitude + (0.001 + _random.nextDouble() * 0.01)
            }
          },
          'rating': 3.5 + _random.nextDouble() * 1.5,
          'user_ratings_total': 50 + _random.nextInt(200),
          'opening_hours': {'open_now': true},
          'formatted_phone_number': '55 ${1000 + _random.nextInt(9000)} ${1000 + _random.nextInt(9000)}'
        },
      ];
    } else {
      return [
        {
          'place_id': '5',
          'name': 'Gasolinera cercana',
          'vicinity': 'A ${(500 + _random.nextInt(1000)).toString()} metros de tu ubicación',
          'geometry': {
            'location': {
              'lat': _currentPosition!.latitude + (0.001 + _random.nextDouble() * 0.01),
              'lng': _currentPosition!.longitude - (0.001 + _random.nextDouble() * 0.01)
            }
          },
          'rating': 3.5 + _random.nextDouble() * 1.5,
          'user_ratings_total': 50 + _random.nextInt(200),
          'opening_hours': {'open_now': true},
          'formatted_phone_number': '55 ${1000 + _random.nextInt(9000)} ${1000 + _random.nextInt(9000)}'
        },
      ];
    }
  }

  void _updateMarkers() {
    final markers = <Marker>{};
    
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(title: 'Tu ubicación'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    for (var place in _places) {
      final lat = place['geometry']['location']['lat'];
      final lng = place['geometry']['location']['lng'];
      final position = LatLng(lat, lng);

      BitmapDescriptor icon;
      switch (_selectedCategory) {
        case 'hospital':
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        case 'police':
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
        case 'fire_station':
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
          break;
        case 'gas_station':
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
          break;
        default:
          icon = BitmapDescriptor.defaultMarker;
      }

      markers.add(
        Marker(
          markerId: MarkerId(place['place_id']),
          position: position,
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['vicinity'],
          ),
          icon: icon,
          onTap: () {
            setState(() {
              _selectedPlace = place;
            });
          },
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Widget _buildCategoryButton(String category, String displayName, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCategory == category ? color.withOpacity(0.2) : Colors.grey[200],
            foregroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: _selectedCategory == category ? color : Colors.grey[300]!,
                width: _selectedCategory == category ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            setState(() {
              _selectedCategory = category;
              _selectedPlace = null;
            });
            _fetchNearbyPlaces();
          },
          icon: Icon(icon),
          label: Text(displayName),
        ),
      ),
    );
  }

  Widget _buildPlaceCard() {
    if (_selectedPlace == null) return const SizedBox();

    final place = _selectedPlace;
    final rating = place['rating']?.toDouble() ?? 0.0;
    final ratingCount = place['user_ratings_total'] ?? 0;
    final isOpen = place['opening_hours']?['open_now'] ?? false;
    final phone = place['formatted_phone_number'] ?? 'No disponible';
    final address = place['vicinity'] ?? 'Dirección no disponible';

    // Calcular distancia
    double distance = 0.0;
    if (_currentPosition != null && place['geometry'] != null) {
      final lat = place['geometry']['location']['lat'];
      final lng = place['geometry']['location']['lng'];
      distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        lat,
        lng,
      ) / 1000; // Convertir a kilómetros
    }

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      place['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedPlace = null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(rating.toStringAsFixed(1)),
                  const SizedBox(width: 8),
                  Text('($ratingCount reseñas)'),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isOpen ? Colors.green : Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isOpen ? 'Abierto ahora' : 'Cerrado',
                      style: TextStyle(
                        color: isOpen ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              if (distance > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.directions_walk, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      '${distance.toStringAsFixed(1)} km de distancia',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.directions),
                      label: const Text('Cómo llegar'),
                      onPressed: () {
                        final lat = place['geometry']['location']['lat'];
                        final lng = place['geometry']['location']['lng'];
                        _launchMaps(lat, lng);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.phone),
                      label: const Text('Llamar'),
                      onPressed: () {
                        if (phone != 'No disponible') {
                          _launchPhone(phone);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchMaps(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir Google Maps';
    }
  }

  Future<void> _launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo realizar la llamada';
    }
  }

  void _showLocationServiceDisabledAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS desactivado'),
        content: const Text('Por favor activa el GPS para usar esta función'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDeniedAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso denegado'),
        content: const Text('Necesitamos acceso a tu ubicación para mostrar lugares cercanos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLocationErrorAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error de ubicación'),
        content: const Text('No pudimos obtener tu ubicación actual'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPlacesFetchError() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('No pudimos obtener los lugares cercanos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares de Emergencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _getCurrentLocation();
            },
          ),
          IconButton(
            icon: Icon(_showCategories ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () {
              setState(() {
                _showCategories = !_showCategories;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_showCategories)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildCategoryButton('hospital', 'Hospitales', Icons.local_hospital, Colors.red),
                      _buildCategoryButton('police', 'Policía', Icons.local_police, Colors.blue),
                    ],
                  ),
                ),
              if (_showCategories)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildCategoryButton('fire_station', 'Bomberos', Icons.fire_truck, Colors.orange),
                      _buildCategoryButton('gas_station', 'Gasolineras', Icons.local_gas_station, Colors.yellow),
                    ],
                  ),
                ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: (controller) => _mapController = controller,
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        mapToolbarEnabled: true,
                      ),
              ),
            ],
          ),
          _buildPlaceCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentPosition != null) {
            _mapController.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition!, 15),
            );
          }
        },
        child: const Icon(Icons.my_location),
        backgroundColor: const Color(0xFF1E88E5),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Configuración',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Notificaciones'),
                value: true,
                onChanged: (value) {},
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Modo Oscuro'),
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Idioma'),
                trailing: const Text('Español'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Tamaño de texto'),
                trailing: const Text('Mediano'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}