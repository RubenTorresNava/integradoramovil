import 'package:flutter/material.dart';

// Definición del modelo de datos
class HistoryEntry {
  final String id;
  final double result;
  final DateTime date;
  final String shape;
  final double size;
  bool isSelected;

  HistoryEntry({
    required this.id,
    required this.result,
    required this.date,
    required this.shape,
    required this.size,
    this.isSelected = false,
  });
}

class HistoryViewModel extends ChangeNotifier {
  List<HistoryEntry> _entries = [];
  bool _isLoading = false;

  List<HistoryEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  int get selectedCount => _entries.where((e) => e.isSelected).length;

  HistoryViewModel() {
    fetchHistory(); // Carga inicial
  }

  // Simulación de llamada a la API para cargar el historial
  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    // Simulación de API call
    await Future.delayed(const Duration(seconds: 1));

    // Datos simulados (lo que recibirías del backend)
    _entries = List.generate(
      10,
          (index) => HistoryEntry(
        id: 'H${100 + index}',
        result: 825.92 + (index * 0.5),
        date: DateTime(2025, 9, 28, 10, index * 5),
        shape: index % 2 == 0 ? 'Rectangular' : 'Curva',
        size: 50.0 + index,
      ),
    );

    _isLoading = false;
    notifyListeners();
  }

  // --- Lógica de Selección ---

  void toggleSelection(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      _entries[index].isSelected = !_entries[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll(bool select) {
    for (var entry in _entries) {
      entry.isSelected = select;
    }
    notifyListeners();
  }

  // --- Lógica de Acciones ---

  void deleteSelected() {
    final count = selectedCount;
    if (count == 0) return;

    // Aquí iría la llamada a la API de eliminación
    print('Eliminando $count elementos seleccionados...');

    _entries.removeWhere((e) => e.isSelected);
    notifyListeners();
  }

  void shareSelected() {
    final selectedItems = _entries.where((e) => e.isSelected).toList();
    if (selectedItems.isEmpty) return;

    // Aquí iría la lógica para construir el texto y compartir
    String shareText = 'Resultados de SIF:\n';
    for (var item in selectedItems) {
      shareText += 'Resultado: ${item.result.toStringAsFixed(2)} MPa, Grieta: ${item.shape}, ${item.size.toStringAsFixed(0)}mm\n';
    }

    print('Compartiendo: $shareText');
    // Se usará el paquete 'share_plus'
  }
}