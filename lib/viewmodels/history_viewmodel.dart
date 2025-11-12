import 'package:flutter/material.dart';
import 'dart:convert'; // <-- 1. Importar
import 'package:http/http.dart' as http; // <-- 2. Importar
import '../providers/auth_provider.dart'; // <-- 3. Importar AuthProvider

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

  // --- 4. Factory constructor para parsear el JSON de la API ---
  // Esto "traduce" la respuesta de la API a nuestro modelo de UI
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['registro_id'].toString(), // Convertimos el int a String
      result: double.parse(json['valor_salida_esfuerzo']),
      date:
          DateTime.parse(json['fecha_calculo']), // Parseamos el string de fecha
      shape: json['modelo']['nombre'], // Obtenemos el nombre del modelo anidado
      size: double.parse(json['valor_entrada_grieta']),
      isSelected: false,
    );
  }
}

class HistoryViewModel extends ChangeNotifier {
  final AuthProvider _authProvider;
  final String _apiUrl = 'http://10.0.2.2:8000';
  
  List<HistoryEntry> _entries = [];
  bool _isLoading = false;

  List<HistoryEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  int get selectedCount => _entries.where((e) => e.isSelected).length;

  HistoryViewModel({required AuthProvider authProvider})
      : _authProvider = authProvider {
    // Si ya estamos autenticados al crear el ViewModel, cargamos el historial
    if (_authProvider.isAuthenticated) {
      fetchHistory();
    }
  }

  // Simulación de llamada a la API para cargar el historial
  Future<void> fetchHistory() async {
    final token = _authProvider.token;
    if (token == null) {
      print("HistoryVM: No hay token, no se puede cargar el historial.");
      return; // Salir si no hay token
    }

    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$_apiUrl/calculos/me/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Usamos nuestro factory constructor para parsear la lista
        _entries = data.map((json) => HistoryEntry.fromJson(json)).toList();

        // Opcional: ordenar por fecha, más reciente primero
        _entries.sort((a, b) => b.date.compareTo(a.date));
      } else if (response.statusCode == 401) {
        // Token expirado, deslogueamos
        _authProvider.logout();
      } else {
        print("HistoryVM: Error del servidor ${response.statusCode}");
      }
    } catch (e) {
      print("HistoryVM: Error de red al cargar historial: $e");
    }

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

  Future<void> deleteSelected() async {
    final token = _authProvider.token;
    final itemsToDelete = _entries.where((e) => e.isSelected).toList();

    if (itemsToDelete.isEmpty || token == null) return;

    print(
        'Eliminando ${itemsToDelete.length} elementos seleccionados de la BD...');
    _isLoading = true; // Opcional: mostrar un estado de carga
    notifyListeners();

    try {
      // Creamos una lista de futuros de borrado
      final deletePromises = itemsToDelete.map((entry) {
        final url = Uri.parse('$_apiUrl/calculos/${entry.id}');
        return http.delete(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }).toList();

      // Esperamos a que todas las peticiones de borrado terminen
      final responses = await Future.wait(deletePromises);

      // Verificamos si alguna falló (puedes hacer un manejo de error más granular)
      if (responses.any((res) => res.statusCode != 204)) {
        print("HistoryVM: Alguna eliminación falló.");
        // Podrías recargar el historial para re-sincronizar
      }

      // Si todo salió bien, actualizamos la UI local
      _entries.removeWhere((e) => e.isSelected);
    } catch (e) {
      print("HistoryVM: Error al eliminar: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void shareSelected() {
    final selectedItems = _entries.where((e) => e.isSelected).toList();
    if (selectedItems.isEmpty) return;

    // Aquí iría la lógica para construir el texto y compartir
    String shareText = 'Resultados de SIF:\n';
    for (var item in selectedItems) {
      shareText +=
          'Resultado: ${item.result.toStringAsFixed(2)} MPa, Grieta: ${item.shape}, ${item.size.toStringAsFixed(0)}mm\n';
    }

    print('Compartiendo: $shareText');
    // Se usará el paquete 'share_plus'
  }
}
