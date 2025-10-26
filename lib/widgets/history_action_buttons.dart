import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryActionButtons extends StatelessWidget {
  final Color primaryColor;

  const HistoryActionButtons({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel solo para el contador de selección
    final viewModel = Provider.of<HistoryViewModel>(context);

    if (viewModel.selectedCount == 0) {
      return const SizedBox.shrink(); // Oculta si no hay nada seleccionado
    }

    // El estilo de dos botones flotantes del diseño
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Botón de Eliminar
        FloatingActionButton(
          heroTag: 'deleteBtn',
          onPressed: viewModel.deleteSelected,
          backgroundColor: primaryColor,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        const SizedBox(width: 10),
        // Botón de Compartir
        FloatingActionButton(
          heroTag: 'shareBtn',
          onPressed: viewModel.shareSelected,
          backgroundColor: primaryColor,
          child: const Icon(Icons.share, color: Colors.white),
        ),
      ],
    );
  }
}