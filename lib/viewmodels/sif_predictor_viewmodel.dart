import 'package:flutter/material.dart';

class SifPredictorViewModel extends ChangeNotifier {
  double _crackSize = 0.0; // Tamaño de la grieta en mm (input)
  double? _sifResult;     // Resultado SIF en MPa (output)
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTabIndex = 0; // 0: Estándar, 1: Aleatorias, 2: Residuales
  String? _crackShape;

  // Getters
  double get crackSize => _crackSize;
  double? get sifResult => _sifResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;
  String? get crackShape => _crackShape;

  // Setter para la forma de la grieta
  void setCrackShape(String shape) {
    _crackShape = shape;
    notifyListeners();
  }

  // Setter para el input
  void setCrackSize(double value) {
    _crackSize = value;
    notifyListeners();
  }

  // Lógica para cambiar de pestaña (simulando la navegación inferior)
  void selectTab(int index) {
    _selectedTabIndex = index;
    // Opcionalmente, resetear el resultado al cambiar de pestaña
    _sifResult = null;
    notifyListeners();
  }

  // Función simulada de llamada a la API
  Future<void> calculateSIF() async {
    // 1. Validaciones
    if (_crackSize <= 0) {
      _errorMessage = 'Ingresa un tamaño de grieta válido.';
      notifyListeners();
      return;
    }
    if (_crackShape == null) {
      _errorMessage = 'Por favor, selecciona la forma de la grieta.';
      notifyListeners();
      return;
    }

    // 2. Preparar la llamada a la API
    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;
    notifyListeners();

    print("Enviando a API: Tamaño de grieta = $_crackSize mm");

    // Simulación de API call
    await Future.delayed(const Duration(seconds: 2));

    try {
      // En una aplicación real, aquí usarías un paquete como 'http' o 'dio'
      // para enviar los datos y recibir la respuesta.
      // Ejemplo de cálculo simulado:
      double simulatedResult = 800.0 + (_crackSize * 5.0);

      _sifResult = simulatedResult;
      print("Resultado de la API (simulado): $_sifResult MPa");

    } catch (e) {
      _errorMessage = 'Error al conectar con el servidor.';
      _sifResult = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Lógica para limpiar el input
  void clearInput() {
    _crackSize = 0.0;
    _sifResult = null;
    _errorMessage = null;
    _crackShape = null;
    notifyListeners();
  }
}