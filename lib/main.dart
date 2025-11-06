import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ContratoData/ContratoData.dart';
import '../InicioView/InicioView.dart';
import '../config.dart';

class APILogin {
  Future<List<ContratoData>> validarContrato(
    String usuario,
    String password,
  ) async {
    final url = Uri.parse('$API_BASE_URL/api/sp_Sel_Valida_Usuario');
    final body = jsonEncode({"user": usuario, "password": password});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((e) => ContratoData.fromJson(e)).toList();
      } else {
        print('Error en la API: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return [];
    }
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final contratoController = TextEditingController();
  final passwordController = TextEditingController();
  final apiLogin = APILogin();
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession(); // Verificar sesión activa
  }

  /// ✅ Verifica si hay sesión guardada
  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final user = prefs.getString('user');
    final password = prefs.getString('password');

    if (user != null) contratoController.text = user;
    if (password != null) passwordController.text = password;

    if (isLoggedIn && user != null && password != null) {
      final datos = await apiLogin.validarContrato(user, password);

      if (datos.isNotEmpty && datos.first.nombre.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioView(datosContrato: datos.first),
          ),
        );
        return;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
    });

    final usuario = contratoController.text.trim();
    final password = passwordController.text.trim();

    final datos = await apiLogin.validarContrato(usuario, password);

    if (datos.isNotEmpty) {
      final contrato = datos.first;

      if (contrato.nombre.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', usuario);
        await prefs.setString('password', password);
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InicioView(datosContrato: contrato),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Contrato o contraseña incorrectos.';
        });
      }
    } else {
      setState(() {
        errorMessage = 'No se recibió respuesta del servidor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(14, 30, 197, 1),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(14, 30, 197, 1),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logoBlanco.png', width: 35, height: 35),
            const SizedBox(width: 8),
            const Text(
              "Pacífica Resorts",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person,
                  size: 90,
                  color: Color.fromRGBO(14, 30, 197, 1),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: contratoController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_snippet),
                      labelText: 'Usuario',
                      border: OutlineInputBorder(),
                    ),
                    autocorrect: false,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(14, 30, 197, 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 🔹 Redondeado estilo “pill”
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
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



void main() {
  print('🌐 API_BASE_URL: $API_BASE_URL');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pacífica Resorts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(14, 30, 197, 1),
        ),
        useMaterial3: true,
      ),
      home: const LoginView(),
    );
  }
}
