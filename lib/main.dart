import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ContratoData/ContratoData.dart';
import '../InicioView/InicioView.dart';
import '../config.dart';

class GrandTabView extends StatelessWidget {
  const GrandTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('GrandTabView')));
  }
}

// Servicio API
class APILogin {
  Future<List<ContratoData>> validarContrato(
    String contrato,
    String password,
  ) async {
    final url = Uri.parse('$API_BASE_URL/api/sp_Sel_Valida_Contrato'); 

    final body = jsonEncode({"Contrato": contrato, "Password": password});

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

// Pantalla Login
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
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      contratoController.text = prefs.getString('contrato') ?? '';
      passwordController.text = prefs.getString('password') ?? '';

      if (contratoController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        final datos = await apiLogin.validarContrato(
          contratoController.text,
          passwordController.text,
        );
        if (datos.isNotEmpty && datos.first.error == 'Ok') {
          setState(() {
            isAuthenticated = true;
          });
          _navigateToMembresia(datos.first);
        }
      }
    }
  }

  Future<void> _login() async {
    setState(() {
      errorMessage = null;
    });

    final datos = await apiLogin.validarContrato(
      contratoController.text,
      passwordController.text,
    );

    if (datos.isNotEmpty) {
      if (datos.first.error == 'Ok') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('contrato', contratoController.text);
        await prefs.setString('password', passwordController.text);
        await prefs.setBool('isLoggedIn', true);

        setState(() {
          isAuthenticated = true;
        });

        _navigateToMembresia(datos.first);
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

  void _navigateToMembresia(ContratoData datosContrato) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InicioView(datosContrato: datosContrato),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  size: 100,
                  color: const Color.fromRGBO(14, 30, 197, 1),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      contratoController.text.isEmpty ||
                          passwordController.text.isEmpty
                      ? null
                      : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(14, 30, 197, 1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

/*
// Pantalla Membresia (placeholder)
class MembresiaView extends StatelessWidget {
  final ContratoData datosContrato;

  const MembresiaView({super.key, required this.datosContrato});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membresía')),
      body: Center(
        child: Text('Bienvenido, ${datosContrato.nombre1 ?? ''}'),
      ),
    );
  }
}*/

void main() {
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
