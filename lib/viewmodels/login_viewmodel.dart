// lib/viewmodels/login_viewmodel.dart

import 'package:flutter/material.dart';

// 1. Un ChangeNotifier es lo que 'Provider' observa para notificar cambios.
class LoginViewModel extends ChangeNotifier {
  // Estados para simular carga y errores
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 2. La lógica de negocio
  Future<void> signIn(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a la UI que muestre el spinner de carga

    // **AQUÍ VA LA LÓGICA PESADA (LLAMADAS A LA API)**
    await Future.delayed(const Duration(seconds: 2)); // Simula una llamada a la red

    if (email == 'test@prefis.com' && password == '12345') {
      // 3. Lógica de éxito: Navegación, etc.
      print("Login exitoso!");

      // Puedes navegar a otra pantalla aquí.
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));

    } else {
      // 4. Lógica de error
      _errorMessage = 'Correo o contraseña incorrectos.';
      print("Error de Login: $_errorMessage");
    }

    _isLoading = false;
    notifyListeners(); // Notifica a la UI que actualice el estado final
  }

  // Lógica de registro
  void goToRegister() {
    print("Navegando a la pantalla de Registro...");
    // Lógica de navegación para ir a la pantalla de registro
  }
}