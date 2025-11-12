import 'package:flutter/material.dart';
import 'dart:convert'; // <-- 1. Importar dart:convert para json.encode
import 'package:http/http.dart' as http; // <-- 2. Importar http

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String _apiUrl = 'http://10.0.2.2:8000';

  Future<void> register(String name, String email, String password, String confirmPassword, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // --- Validaciones básicas ---
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'Todos los campos son obligatorios.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Las contraseñas no coinciden.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Puedes agregar más validaciones aquí (ej. formato de email)

    try {
      final url = Uri.parse('$_apiUrl/usuarios/');

      // ¡Importante! La API espera 'nombre' y un body JSON
      final body = json.encode({
        'nombre': name, // Usamos 'nombre' como espera la API
        'email': email,
        'password': password,
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', // Le decimos a la API que enviamos JSON
        },
        body: body,
      );

      // 201 Creado (Respuesta de éxito de FastAPI para este endpoint)
      if (response.statusCode == 201) {
        print("Usuario registrado: $name, $email");

        // Lógica de éxito (sin cambios)
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('¡Registro exitoso! Por favor, inicie sesión.')),
          );
          Navigator.of(context).pop(); // Vuelve a la pantalla anterior (Login)
        }
      }
      // 400 Bad Request (Lo que la API devuelve si el email ya existe)
      else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        _errorMessage = errorData['detail'] ?? 'El email ya está registrado.';
      }
      // 422 Unprocessable Entity (Si la contraseña es muy corta, etc.)
      else if (response.statusCode == 422) {
        _errorMessage = 'Los datos no son válidos (ej. contraseña muy corta).';
      } else {
        // Otros errores del servidor
        _errorMessage = 'Error en el registro. Código: ${response.statusCode}';
      }
    } catch (e) {
      // Error de red o conexión
      _errorMessage = 'Error de conexión. Revisa tu red o la IP del servidor.';
      print("Error en el registro (catch): $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void goToLogin(BuildContext context) {
    print("Navegando de vuelta a la pantalla de Login...");
    Navigator.of(context).pop(); // Cierra la pantalla de registro y vuelve a la anterior
  }
}