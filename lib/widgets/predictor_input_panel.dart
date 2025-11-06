import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';
import 'crack_size_input.dart';
import 'input_action_button.dart';
import 'result_output_panel.dart';

class PredictorInputPanel extends StatelessWidget {
  final Color primaryColor;

  const PredictorInputPanel({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SifPredictorViewModel>(context);

    // El controlador local ahora se mantiene aquí
    final TextEditingController crackSizeController = TextEditingController(
        text: viewModel.crackSize > 0 ? viewModel.crackSize.toString() : '');

    // Sincronizar el controlador después de un 'clearInput' o actualización
    if (viewModel.crackSize.toString() != crackSizeController.text && !viewModel.isLoading) {
      crackSizeController.text = viewModel.crackSize > 0 ? viewModel.crackSize.toString() : '';
      // Mueve el cursor al final
      crackSizeController.selection = TextSelection.fromPosition(TextPosition(offset: crackSizeController.text.length));
    }


    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Título
            const Text(
              'Predictor de SIF',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87),
            ),
            const Divider(height: 30),

            // Controles de Input
            Row(
              children: <Widget>[
                // Botón '+'
                InputActionButton(
                  icon: Icons.add,
                  color: primaryColor,
                  onPressed: viewModel.addEntry,
                ),
                const SizedBox(width: 8),

                // Botón 'Forma de grieta' (Mantenido aquí para la lógica de modal)
                Expanded(
                  child: _buildShapeSelectorButton(context, viewModel),
                ),
                const SizedBox(width: 8),

                // Campo de entrada 'Tamaño (mm)'
                Expanded(
                  child: CrackSizeInput(controller: crackSizeController),
                ),
                const SizedBox(width: 8),

                // Botón de Check (Calcular)
                InputActionButton(
                  icon: Icons.check,
                  color: primaryColor,
                  onPressed: viewModel.calculateSIF,
                ),
              ],
            ),
            
            // Widget para mostrar las entradas agregadas
            if (viewModel.inputs.isNotEmpty) ...[
              const Divider(height: 30),
              _buildEntriesList(viewModel),
            ],

            const SizedBox(height: 20),

            // Resultado
            const ResultOutputPanel(),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar la lista de entradas como Chips
  Widget _buildEntriesList(SifPredictorViewModel viewModel) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: viewModel.inputs.map((input) {
        return Chip(
          label: Text('${input.shape} - ${input.size} mm'),
          backgroundColor: Colors.grey.shade200,
          onDeleted: () => viewModel.removeEntry(input.id),
          deleteIconColor: Colors.red.shade400,
        );
      }).toList(),
    );
  }

  // Helper para el botón de selector de forma (se mantiene aquí por el showModalBottomSheet)
  Widget _buildShapeSelectorButton(BuildContext context, SifPredictorViewModel viewModel) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.apps, size: 20),
        label: Text(
          viewModel.crackShape ?? 'Forma de grieta',
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
                      viewModel.setCrackShape(option);
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
}