import 'package:flutter/material.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

    // --- Simulación de llamada a API ---
    await Future.delayed(const Duration(seconds: 2)); // Simula un retraso de red

    // Simular un registro exitoso o fallido
    if (email.contains('@') && password.length >= 6) { // Validación simple
      print("Usuario registrado: $name, $email");

      // Lógica para navegar de vuelta al login o a una pantalla de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso!')),
      );
      Navigator.of(context).pop(); // Vuelve a la pantalla anterior (Login)

    } else {
      _errorMessage = 'Error en el registro. Verifica tus datos.';
      print("Error en el registro para $email");
    }

    _isLoading = false;
    notifyListeners();
  }

  void goToLogin(BuildContext context) {
    print("Navegando de vuelta a la pantalla de Login...");
    Navigator.of(context).pop(); // Cierra la pantalla de registro y vuelve a la anterior
  }
}