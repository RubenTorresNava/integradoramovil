// lib/config/api_config.dart (ACTUALIZADO)
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class ApiConfig {
  // --- 1. API DE FASTAPI (PRODUCCIÓN) ---
  // ¡Felicidades! Esta URL es ahora pública y siempre será la misma.
  // Ya no necesitamos lógica de localhost/emulador para esto.
  static const String fastApiBaseUrl = 'https://prefis-api.onrender.com';

  // --- 2. API DE MACHINE LEARNING (LOCAL) ---

  // Esta es la IP de tu PC en la red WiFi que nos diste.
  // Es la ÚNICA LÍNEA que debes cambiar si tu WiFi te da una IP nueva.
  static const String _localMlIp = '192.168.1.84';

  // IPs especiales para emuladores/simuladores
  static const String _androidEmulatorIp = '10.0.2.2';
  static const String _iosSimulatorIp = '127.0.0.1'; // o 'localhost'
  static const String _mlApiPort = '5000';

  // Constructor privado
  ApiConfig._();

  // --- 3. GETTER "INTELIGENTE" PARA LA API DE ML ---
  // Este getter decide qué IP usar basado en la plataforma.
  static String get mlApiBaseUrl {
    // Si estamos en un emulador de Android (solo en modo debug)
    if (kDebugMode && !kIsWeb && Platform.isAndroid) {
      // NOTA: Esto asume que estás en un EMULADOR.
      // Si pruebas en un TELÉFONO FÍSICO Android, DEBE estar en la misma
      // WiFi que la IP _localMlIp.
      return 'http://$_androidEmulatorIp:$_mlApiPort';
    }

    // Si estamos en un simulador de iOS (solo en modo debug)
    if (kDebugMode && !kIsWeb && Platform.isIOS) {
      return 'http://$_iosSimulatorIp:$_mlApiPort';
    }

    // Por defecto, para un teléfono físico (en la misma WiFi),
    // o para un build de release (que fallará si no está en la WiFi),
    // usamos la IP local.
    return 'http://$_localMlIp:$_mlApiPort';
  }
}
