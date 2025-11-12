// lib/providers/auth_provider.dart (MUY MODIFICADO)

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; // <-- 1. Importar http
import 'dart:convert'; // <-- 2. Importar convert
import '../models/usuario.dart'; // <-- 3. Importar nuestro nuevo modelo

class AuthProvider with ChangeNotifier {
  String? _token;
  Usuario? _user; // <-- 4. Añadir estado para el usuario
  bool _isLoading = true;
  final _storage = const FlutterSecureStorage();

  // --- 5. Definir la URL de la API (¡RECUERDA EL TEMA DE LOCALHOST!) ---
  // Android Emu: 'http://10.0.2.2:8000'
  // iOS Sim o Teléfono Físico: IP de tu PC (ej. 'http://192.168.1.100:8000')
  final String _apiUrl = 'http://10.0.2.2:8000'; // <-- CAMBIA ESTO

  // --- Getters públicos ---
  String? get token => _token;
  Usuario? get user => _user; // <-- 6. Getter para el usuario
  bool get isAuthenticated => _token != null && _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    tryAutoLogin();
  }

  // Al iniciar la app, intenta loguearse con el token guardado
  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: 'authToken');
    if (storedToken != null) {
      // Encontramos un token, ahora validémoslo buscando al usuario
      await _fetchUserData(storedToken);
    } else {
      // No hay token, terminamos de cargar
      _isLoading = false;
      notifyListeners();
    }
  }

  // Esta es la nueva función que busca los datos del usuario
  Future<void> _fetchUserData(String token) async {
    try {
      final url = Uri.parse('$_apiUrl/usuarios/me/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // ¡Éxito! Token válido.
        final responseData = json.decode(response.body);
        _user = Usuario.fromJson(responseData); // Guardamos el usuario
        _token = token; // Guardamos el token
        _isLoading = false;
        notifyListeners();
      } else {
        // El token es inválido o expiró
        await logout(); // Limpiamos todo
      }
    } catch (e) {
      // Error de red
      print("Error en _fetchUserData: $e");
      await logout(); // Limpiamos todo
    }
  }

  // --- Funciones públicas ---

  // setToken ahora solo se usa INTERNAMENTE por 'login'
  // El ViewModel de Login ya no necesita llamar a esto
  Future<void> login(String token) async {
    // Cuando iniciamos sesión, guardamos el token Y buscamos al usuario
    await _storage.write(key: 'authToken', value: token);
    await _fetchUserData(token); // Esto notificará a los listeners
  }

  Future<void> logout() async {
    _token = null;
    _user = null; // <-- 7. Limpiar el usuario al salir
    _isLoading = false;
    await _storage.delete(key: 'authToken');
    notifyListeners();
  }
}
