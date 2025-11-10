import 'package:flutter/material.dart';

class CrackInput {
  String id = UniqueKey().toString();
  String? shape;
  double? size;
  double? result;

  CrackInput({this.shape, this.size, this.result});
}

class SifPredictorViewModel extends ChangeNotifier {
  final List<CrackInput> _crackInputs = [CrackInput()];

  double? _sifResult;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedTabIndex = 0;

  // Getters
  List<CrackInput> get crackInputs => _crackInputs;
  double? get sifResult => _sifResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;


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

  void setCrackSize(String id, double size) {
    _crackInputs.firstWhere((input) => input.id == id).size = size;
    notifyListeners();
  }

  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // --- LÓGICA DE CÁLCULO MÚLTIPLE ---

  Future<void> calculateSIF() async {
    // 1. Validaciones
    if (_crackInputs.any((input) => input.size == null || input.size! <= 0 || input.shape == null)) {
      _errorMessage = 'Asegúrate de que todos los campos (Forma y Tamaño) estén llenos y sean válidos.';
      _sifResult = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _sifResult = null;
    notifyListeners();

    // Simulación de API call
    await Future.delayed(const Duration(seconds: 2));

    double totalSIF = 0;

    for (var input in _crackInputs) {
      // Simular cálculo individual por grieta
      double individualSIF = 800.0 + (input.size! * 5.0);
      input.result = individualSIF;
      totalSIF += individualSIF;
    }

    // El resultado principal muestra el total o el último, según el modelo físico
    // Aquí mostraremos el resultado del último input o el total si es un cálculo agregado.
    _sifResult = totalSIF;

    _isLoading = false;
    notifyListeners();
  }

  void clearInput() {
    _crackInputs.clear();
    _crackInputs.add(CrackInput());
    _sifResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}