import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class CrackSizeInput extends StatelessWidget {
  final TextEditingController controller;
  // AÑADIDO: Necesitas el ID o el objeto CrackInput para saber qué fila actualizar
  final CrackInput crackInput;

  const CrackSizeInput({
    super.key,
    required this.controller,
    required this.crackInput, // Incluye el objeto CrackInput
  });

  @override
  Widget build(BuildContext context) {
    // Escuchar el ViewModel con listen: false para llamar a la función
    final viewModel = Provider.of<SifPredictorViewModel>(context, listen: false);

    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          hintText: 'Tamaño (mm)',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          // MODIFICACIÓN: Usar el tamaño del input individual para mostrar el botón X
          suffixIcon: (crackInput.size != null && crackInput.size! > 0)
              ? IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 18),
            // MODIFICACIÓN: Llamar a removeCrackInput para borrar la fila
            onPressed: () => viewModel.removeCrackInput(crackInput.id),
          )
              : null,
        ),
        onChanged: (value) {
          double? size = double.tryParse(value);
          // MODIFICACIÓN: Usar la nueva función setCrackSize con el ID de la grieta
          // Si size es null (entrada no válida), pasamos null o 0.0, según cómo lo maneje el ViewModel
          viewModel.setCrackSize(crackInput.id, size!);
        },
      ),
    );
  }
}