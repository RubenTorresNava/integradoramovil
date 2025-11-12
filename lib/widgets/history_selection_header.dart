import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';

class HistorySelectionHeader extends StatelessWidget {
  final Color primaryColor;

  const HistorySelectionHeader({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel para saber el estado de la selección
    final viewModel = Provider.of<HistoryViewModel>(context);

    // Determina si todos están seleccionados
    final allSelected = viewModel.entries.isNotEmpty && viewModel.selectedCount == viewModel.entries.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: (bool? newValue) {
              viewModel.selectAll(newValue ?? false);
            },
            checkColor: Colors.white,
            activeColor: primaryColor,
          ),
          Text(
            viewModel.selectedCount > 0
                ? '${viewModel.selectedCount} seleccionados'
                : 'Seleccionar todos',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}