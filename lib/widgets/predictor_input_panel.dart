// lib/widgets/predictor_input_panel.dart (MODIFICADO)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';
import 'input_action_button.dart';
import 'result_output_panel.dart';
import 'crack_input_row.dart'; // Importa el nuevo widget de fila

class PredictorInputPanel extends StatelessWidget {
  final Color primaryColor;

  const PredictorInputPanel({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SifPredictorViewModel>(context);

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

            // --- 1. LISTA DINÁMICA DE INPUTS ---
            Flexible( // Permite que el Column dentro de la Card sepa cómo expandirse
              child: SingleChildScrollView(
                child: Column(
                  children: viewModel.crackInputs.map((input) {
                    return CrackInputRow(
                      key: ValueKey(input.id), // Clave para manejo de lista
                      crackInput: input,
                      primaryColor: primaryColor,
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- 2. BOTÓN DE AGREGAR (+) ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Agregar Grieta'),
                onPressed: viewModel.addCrackInput,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. BOTÓN DE CÁLCULO (MOVIDO ABAJO) ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: viewModel.isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.check, color: Colors.white),
                label: Text(
                  viewModel.isLoading ? 'Calculando...' : 'Calcular SIF',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: viewModel.isLoading ? null : viewModel.calculateSIF,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Resultado (ResultOutputPanel)
            const ResultOutputPanel(),
          ],
        ),
      ),
    );
  }
}