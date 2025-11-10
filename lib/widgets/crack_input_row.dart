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

    return Consumer<SifPredictorViewModel>(
      builder: (context, vm, child) {
        if (crackInput.size?.toString() != sizeController.text && !sizeController.text.contains('.')) {
          sizeController.text = crackInput.size?.toString() ?? '';
          sizeController.selection = TextSelection.fromPosition(TextPosition(offset: sizeController.text.length));
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Columna principal para Inputs y Resultado
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //  Botón 'Forma de grieta'
                        Expanded(child: _buildShapeSelectorButton(context, viewModel)),
                        const SizedBox(width: 8),

                        // Campo de entrada 'Tamaño (mm)'
                        Expanded(child: _buildCrackSizeInput(viewModel, sizeController)),
                      ],
                    ),

                    // Resultado de SIF
                    if (crackInput.result != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Resultado: ${crackInput.result}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              //Botón para eliminar la fila
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

  // Helper para el selector de forma (Modal Bottom Sheet)
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
          final options = ['Rectangular'];
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

  // Helper para el campo de texto de tamaño
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
          viewModel.setCrackSize(crackInput.id, size);
        },
      ),
    );
  }
}