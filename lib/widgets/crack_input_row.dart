// lib/widgets/crack_input_row.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class CrackInputRow extends StatelessWidget {
  final CrackInput crackInput;
  final Color primaryColor;

  const CrackInputRow({
    Key? key,
    required this.crackInput,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SifPredictorViewModel>(context, listen: false);

    final TextEditingController sizeController = TextEditingController(
        text: crackInput.size?.toString() ?? '');

    // Se usa Consumer para reconstruir solo la fila cuando la forma cambia (por el modal)
    return Consumer<SifPredictorViewModel>(
      builder: (context, vm, child) {
        // Asegura que el controlador esté actualizado si la data cambia externamente
        if (crackInput.size?.toString() != sizeController.text && !sizeController.text.contains('.')) {
          sizeController.text = crackInput.size?.toString() ?? '';
          sizeController.selection = TextSelection.fromPosition(TextPosition(offset: sizeController.text.length));
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: <Widget>[
              // 1. Botón 'Forma de grieta'
              Expanded(
                flex: 3,
                child: _buildShapeSelectorButton(context, viewModel),
              ),
              const SizedBox(width: 8),

              // 2. Campo de entrada 'Tamaño (mm)'
              Expanded(
                flex: 2,
                child: _buildCrackSizeInput(viewModel, sizeController),
              ),
              const SizedBox(width: 8),

              // 3. Botón para eliminar la fila
              SizedBox(
                height: 48,
                width: 48,
                child: ElevatedButton(
                  onPressed: () => viewModel.removeCrackInput(crackInput.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor.withOpacity(0.8),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShapeSelectorButton(BuildContext context, SifPredictorViewModel viewModel) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.apps, size: 20),
        label: Text(
          crackInput.shape ?? 'Forma de grieta',
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: () {
          final options = ['Recta', 'Curva', 'Mixta'];
          showModalBottomSheet(
            context: context,
            builder: (ctx) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: options.map((option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      viewModel.setCrackShape(crackInput.id, option);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildCrackSizeInput(SifPredictorViewModel viewModel, TextEditingController controller) {
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
        ),
        onChanged: (value) {
          double? size = double.tryParse(value);
          viewModel.setCrackSize(crackInput.id, size ?? 0.0);
        },
      ),
    );
  }
}