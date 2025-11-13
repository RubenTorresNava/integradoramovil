import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryEntry entry;
  final Color primaryColor;

  const HistoryListItem({
    super.key,
    required this.entry,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    // Escucha solo para el estado de selección, no para toda la lista
    final viewModel = Provider.of<HistoryViewModel>(context, listen: false);

    // Formatear la fecha como "dd/MM/yy"
    final formattedDate = DateFormat('dd/MM/yy, hh:mm a').format(entry.date);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(34, 34, 34, 1.0), // Fondo oscuro
      ),
      child: Row(
        children: <Widget>[
          // Checkbox (usa Consumer para escuchar el cambio de selección del elemento)
          Consumer<HistoryViewModel>(
            builder: (context, vm, child) {
              // Encuentra la entrada actualizada
              final currentEntry = vm.entries.firstWhere((e) => e.id == entry.id, orElse: () => entry);

              return Checkbox(
                value: currentEntry.isSelected,
                onChanged: (bool? newValue) {
                  viewModel.toggleSelection(entry.id);
                },
                checkColor: Colors.white,
                activeColor: primaryColor,
              );
            },
          ),

          const SizedBox(width: 10),

          // Contenido de la fila
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Resultado y Fecha
                Text(
                  '${entry.result.toStringAsFixed(2)} MPa | $formattedDate',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                // Tipo de Grieta y Tamaño
                Text(
                  '${entry.shape}, ${entry.size.toStringAsFixed(2)}mm',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}