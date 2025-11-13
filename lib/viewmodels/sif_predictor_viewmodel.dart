import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // <-- 1. Importar Provider
import '../providers/auth_provider.dart'; // <-- 2. Importar AuthProvider
import '../config/api_config.dart'; // Importar la configuración

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

  // --- 5. CONSTRUCTOR MODIFICADO ---
  // Ahora "recibe" el AuthProvider que 'main.dart' le inyecta
  SifPredictorViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider;

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

    // --- 6. Obtener el token ANTES de empezar ---
    final token = _authProvider.token;
    if (token == null) {
      _errorMessage =
          'Error de autenticación. Por favor, inicia sesión de nuevo.';
      notifyListeners();
      // (El Consumer en main.dart probablemente ya te habría redirigido)
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;
    notifyListeners();

    // Limpiar resultados anteriores en la lista
    for (var input in _crackInputs) {
      input.result = null;
    }
    notifyListeners();

    try {
      // Preparar los datos
      final features = _crackInputs.map((input) => input.size).toList();
      final body = jsonEncode({'features': features});
      final url = Uri.parse(_predUrl);

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
        final List<double> sifValues = []; // Guardamos los valores numéricos

        // Asignar resultados individuales
        for (int i = 0; i < predictions.length; i++) {
          if (i < _crackInputs.length) {
            // Se asume que predictions[i] contiene el valor numérico
            final double sifValue = (predictions[i][0] as num).toDouble();

            // Almacenar el resultado formateado con ' MPa' en el input individual
            _crackInputs[i].result = '${sifValue.toStringAsFixed(2)} MPa';

            sifValues.add(sifValue);
            
          }
        }

        _errorMessage = null;
        notifyListeners();

        // --- PASO 3: LLAMADA A LA API DE FASTAPI (:8000) ---
        print("LOG API-FASTAPI: Guardando ${sifValues.length} resultados...");

        // TODO: Estos IDs (1 y 1) son fijos.
        // Deberías tener una lógica para que el usuario seleccione
        // el 'modelo' y 'geometria' y obtener sus IDs reales.
        const int modeloId = 1;
        const int geometriaId = 1;

        // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
        // Usamos List.generate para iterar de forma segura con un índice
        final calculoBody = jsonEncode(List.generate(sifValues.length, (index) {
          // Obtenemos los valores de cada lista usando el mismo índice
          final double sifValor = sifValues[index];
          final double? entradaGrieta = _crackInputs[index].size;

          return {
            'modelo_id': modeloId,
            'geometria_id': geometriaId,
            'valor_entrada_grieta': entradaGrieta,
            'valor_salida_esfuerzo': sifValor,
            'plataforma': "movil"
          };
        }) // .toList() no es necesario, List.generate ya devuelve una lista
            );
        // --- FIN DE LA CORRECCIÓN ---

        final fastApiUrl = Uri.parse('$_apiUrl/calculos/batch');
        final responseFastAPI = await http
            .post(
              fastApiUrl,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token' // ¡Usamos el token!
              },
              body: calculoBody,
            )
            .timeout(const Duration(seconds: 10));

            if (responseFastAPI.statusCode == 201) {
          // ¡Guardado con éxito!
          print("LOG API-FASTAPI: Lote de cálculos guardado exitosamente.");
        } else if (responseFastAPI.statusCode == 401) {
          // Token expirado
          _errorMessage =
              "Tu sesión ha expirado. Por favor, inicia sesión de nuevo.";
          _authProvider.logout(); // Limpiamos la sesión
        } else {
          // Otro error de guardado
          print("LOG API-FASTAPI: Error al guardar ${responseFastAPI.body}");
          _errorMessage =
              "No se pudieron guardar los resultados (Código ${responseFastAPI.statusCode})";
        }

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