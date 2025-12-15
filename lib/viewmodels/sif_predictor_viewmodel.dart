import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../config/api_config.dart';

// --- MODELOS DE DATOS ---

class CrackInput {
  String id = UniqueKey().toString();
  String? shape;
  double? size;
  String? result; // Resultado SIF individual (String formateado con ' MPa')

  CrackInput({this.shape, this.size, this.result});
}

class SifPredictorViewModel extends ChangeNotifier {
  // --- CONSTANTE: URL DE TU API ---
  final String _predUrl = '${ApiConfig.predApiBaseUrl}/predict';
  final String _apiUrl = ApiConfig.fastApiBaseUrl;

  final AuthProvider _authProvider;

  // --- CONSTRUCTOR MODIFICADO ---
  SifPredictorViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider;

  // --- ESTADO ---
  final List<CrackInput> _crackInputs = [CrackInput()];
  List<List<double>> _sifCurveData = []; // NUEVO: Datos para dibujar la curva [Tamaño, SIF]

  double? _sifResult;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTabIndex = 0;

  // --- GETTERS ---
  List<CrackInput> get crackInputs => _crackInputs;
  List<List<double>> get sifCurveData => _sifCurveData; // Getter de la curva
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
    _sifCurveData = []; // Limpiar la curva
    _sifResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  // --- LÓGICA DE CONEXIÓN A LA API ---

  Future<void> calculateSIF() async {
    // 1. Validaciones
    if (_crackInputs.any((input) => input.size == null || input.size! <= 0 || input.shape == null)) {
      _errorMessage = 'Asegúrate de que todos los campos (Forma y Tamaño) estén llenos y sean válidos.';
      _sifResult = null;
      notifyListeners();
      return;
    }

    final token = _authProvider.token;
    if (token == null) {
      _errorMessage = 'Error de autenticación. Por favor, inicia sesión de nuevo.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;
    _sifCurveData = []; // Limpiar antes de la petición

    for (var input in _crackInputs) {
      input.result = null;
    }
    notifyListeners();

    try {
      // 2. Preparar los datos
      final primaryInput = _crackInputs.first;

      final Map<String, dynamic> requestBody = {
        'features': _crackInputs.map((input) => input.size).toList(),
        'crack_shape': primaryInput.shape,
        'generate_curve': true,
      };

      // Petición HTTP POST a la API de Predicción (que devuelve la curva y los puntos)
      final response = await http.post(
        Uri.parse(_predUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 10));

      // 4. Procesar la Respuesta
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> predictions = data['predictions'];
        final List<dynamic> curveData = data['curve_points'] ?? [];

        final List<double> sifValues = [];

        // A. Asignar resultados individuales (Puntos)
        for (int i = 0; i < predictions.length; i++) {
          if (i < _crackInputs.length) {
            final double sifValue = (predictions[i][0] as num).toDouble();
            _crackInputs[i].result = '${sifValue.toStringAsFixed(2)} MPa';
            sifValues.add(sifValue);
          }
        }

        // B. Almacenar los datos de la curva (Línea)
        if (curveData.isNotEmpty) {
          _sifCurveData = curveData.map((point) =>
          [ (point[0] as num).toDouble(), (point[1] as num).toDouble() ]
          ).toList();
        }

        // --- LLAMADA A LA API DE FASTAPI para guardar los datos ---
        print("LOG API-FASTAPI: Guardando ${sifValues.length} resultados...");

        const int modeloId = 1;
        const int geometriaId = 1;

        final calculoBody = jsonEncode(List.generate(sifValues.length, (index) {
          final double sifValor = sifValues[index];
          final double? entradaGrieta = _crackInputs[index].size;

          return {
            'modelo_id': modeloId,
            'geometria_id': geometriaId,
            'valor_entrada_grieta': entradaGrieta,
            'valor_salida_esfuerzo': sifValor,
            'plataforma': "movil"
          };
        }));

        final fastApiUrl = Uri.parse('$_apiUrl/calculos/batch');
        final responseFastAPI = await http
            .post(
          fastApiUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: calculoBody,
        )
            .timeout(const Duration(seconds: 10));

        if (responseFastAPI.statusCode == 201) {
          print("LOG API-FASTAPI: Lote de cálculos guardado exitosamente.");
        } else if (responseFastAPI.statusCode == 401) {
          _errorMessage = "Tu sesión ha expirado. Por favor, inicia sesión de nuevo.";
          _authProvider.logout();
        } else {
          print("LOG API-FASTAPI: Error al guardar ${responseFastAPI.body}");
          _errorMessage = "No se pudieron guardar los resultados (Código ${responseFastAPI.statusCode})";
        }

        _errorMessage = null;
        notifyListeners();

      } else {
        // Manejar errores de la API de Predicción
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