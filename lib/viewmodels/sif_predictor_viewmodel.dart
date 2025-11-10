import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CrackInput {
  String id = UniqueKey().toString();
  String? shape;
  double? size;
  String? result; // Resultado SIF individual (String formateado con ' MPa')

  CrackInput({this.shape, this.size, this.result});
}

class SifPredictorViewModel extends ChangeNotifier {
  // --- CONSTANTE: URL DE TU API ---
  final String _apiUrl = 'http://192.168.1.6:5000/predict';

  // --- ESTADO ---
  final List<CrackInput> _crackInputs = [CrackInput()];

  double? _sifResult;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTabIndex = 0;

  // --- GETTERS ---
  List<CrackInput> get crackInputs => _crackInputs;
  double? get sifResult => _sifResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;

  // --- MÉTODOS DE MANEJO DE INPUTS ---

  void addCrackInput() {
    _crackInputs.add(CrackInput());
    _errorMessage = null;
    notifyListeners();
  }

  void removeCrackInput(String id) {
    if (_crackInputs.length > 1) {
      _crackInputs.removeWhere((input) => input.id == id);
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setCrackShape(String id, String shape) {
    _crackInputs.firstWhere((input) => input.id == id).shape = shape;
    notifyListeners();
  }

  void setCrackSize(String id, double? size) {
    _crackInputs.firstWhere((input) => input.id == id).size = size;
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void clearInput() {
    _crackInputs.clear();
    _crackInputs.add(CrackInput());
    _sifResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  // --- LÓGICA DE CONEXIÓN A LA API ---

  Future<void> calculateSIF() async {
    // Validaciones
    if (_crackInputs.any((input) => input.size == null || input.size! <= 0 || input.shape == null)) {
      _errorMessage = 'Asegúrate de que todos los campos (Forma y Tamaño) estén llenos y sean válidos.';
      _sifResult = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;

    // Limpiar resultados anteriores en la lista
    for (var input in _crackInputs) {
      input.result = null;
    }
    notifyListeners();

    try {
      // Preparar los datos
      final features = _crackInputs.map((input) => input.size).toList();
      final body = jsonEncode({'features': features});
      final url = Uri.parse(_apiUrl);

      // Petición HTTP POST
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10));

      // 4. Procesar la Respuesta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> predictions = data['predictions'];

        // Asignar resultados individuales
        for (int i = 0; i < predictions.length; i++) {
          if (i < _crackInputs.length) {
            // Se asume que predictions[i] contiene el valor numérico
            final double sifValue = (predictions[i][0] as num).toDouble();

            // Almacenar el resultado formateado con ' MPa' en el input individual
            _crackInputs[i].result = sifValue.toStringAsFixed(2) + ' MPa';
          }
        }

        _errorMessage = null;

      } else {
        // Manejar errores del servidor
        try {
          final errorData = jsonDecode(response.body);
          _errorMessage = errorData['error'] ?? errorData['message'] ?? 'Error del servidor: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Error del servidor: Código ${response.statusCode}.';
        }
      }

    } catch (e) {
      // Manejar errores de red o Timeout
      _errorMessage = 'No se pudo conectar con el servidor (Timeout o Red).';
      print("Error al realizar la predicción: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}