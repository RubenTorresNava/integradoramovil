import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Clase para modelar cada entrada de grieta
class CrackInput {
  final double size;
  final String shape;
  final String id = UniqueKey().toString(); // ID único para poder borrarla

  CrackInput({required this.size, required this.shape});
}

class SifPredictorViewModel extends ChangeNotifier {
  double _crackSize = 0.0; // Tamaño de la grieta en mm (input)
  String? _sifResult;     // Resultado SIF en MPa (output) - CAMBIADO A STRING
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTabIndex = 0; // 0: Estándar, 1: Aleatorias, 2: Residuales
  String? _crackShape;
  final List<CrackInput> _inputs = []; // Lista para almacenar las entradas

  // Getters
  double get crackSize => _crackSize;
  String? get sifResult => _sifResult; // CAMBIADO A STRING
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;
  String? get crackShape => _crackShape;
  List<CrackInput> get inputs => _inputs; // Getter para la lista

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

  // Nueva función para agregar una entrada a la lista
  void addEntry() {
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

    // Agrega la entrada actual a la lista
    _inputs.add(CrackInput(size: _crackSize, shape: _crackShape!));

    // Limpia los campos para la siguiente entrada
    _crackSize = 0.0;
    //_crackShape = null;
    _errorMessage = null;
    _sifResult = null;
    notifyListeners();
  }

  // Función para remover una entrada de la lista
  void removeEntry(String id) {
    _inputs.removeWhere((input) => input.id == id);
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
    if (_inputs.isEmpty) {
      _errorMessage = 'Agrega al menos una entrada para calcular.';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;
    notifyListeners();

    try {
      // 1. Preparar los datos para la API
      final features = _inputs.map((input) => input.size).toList();
      final body = jsonEncode({'features': features});
      final url = Uri.parse('http://192.168.1.84:5000/predict');

      print("Enviando a API: $body");

      // 2. Realizar la solicitud POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

      // 3. Procesar la respuesta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Extraer la lista de predicciones [[val1], [val2], ...]
        final List<dynamic> predictions = data['predictions'];
        
        // Formatear los resultados a 2 decimales y unirlos en un string
        final results = predictions.map((p) => (p[0] as num).toStringAsFixed(2)).toList();
        _sifResult = results.join(' MPa, ') + ' MPa';

        print("Resultado de la API: $_sifResult");

      } else {
        // Intentar decodificar un mensaje de error del servidor
        try {
          final errorData = jsonDecode(response.body);
          _errorMessage = errorData['error'] ?? 'Error del servidor: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Error del servidor: ${response.statusCode}';
        }
      }

    } catch (e) {
      _errorMessage = 'No se pudo conectar con el servidor.';
      _sifResult = null;
      print("Error al realizar la predicción: $e");
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
    _inputs.clear(); // También limpia la lista de entradas
    notifyListeners();
  }
}