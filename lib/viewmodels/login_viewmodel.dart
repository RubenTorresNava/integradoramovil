import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Importar http
import 'package:provider/provider.dart'; // Importar provider
import './../providers/auth_provider.dart'; // Importar nuestro "cerebro"

// 1. Un ChangeNotifier es lo que 'Provider' observa para notificar cambios.
class LoginViewModel extends ChangeNotifier {
  // Estados para simular carga y errores
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String _apiUrl = 'http://10.0.2.2:8000';

  // 2. La lógica de negocio
  Future<void> signIn(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a la UI que muestre el spinner de carga

    // --- LÓGICA DE API REAL ---
    try {
      final url = Uri.parse('$_apiUrl/token');

      // FastAPI espera un formulario (x-www-form-urlencoded),
      // que 'http.post' hace por defecto si le pasas un Map al 'body'.
      final response = await http.post(
        url,
        body: {
          'username': email, // Recuerda que FastAPI espera 'username'
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // ¡Éxito!
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];

        // 3. ¡Le decimos al "Cerebro" que guarde el token!
        // Usamos 'listen: false' porque estamos en una función, no en 'build'.
        Provider.of<AuthProvider>(context, listen: false).login(token);

        // 4. Navegamos a Home
        // (Asegúrate de que 'context' sigue siendo válido)
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else if (response.statusCode == 401) {
        // Error de credenciales (email o pass incorrectos)
        final errorData = json.decode(response.body);
        _errorMessage =
            errorData['detail'] ?? 'Email o contraseña incorrectos.';
      } else {
        // Otro error del servidor (500, etc.)
        _errorMessage = 'Error del servidor: ${response.statusCode}';
      }
    } catch (e) {
      // Error de red (sin conexión, DNS, etc.)
      _errorMessage = 'Error de conexión. Revisa tu red.';
      print("Error de Login (catch): $e");
    }

    _isLoading = false;
    notifyListeners(); // Notifica a la UI que actualice el estado final
  }

  // Lógica de registro
  void goToRegister(BuildContext context) {
    print("Navegando a la pantalla de Registro...");
    Navigator.of(context).pushNamed('/register'); // Navega usando la ruta definida en main.dart
  }
}