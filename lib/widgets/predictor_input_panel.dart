import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';
import 'crack_input_row.dart';

class PredictorInputPanel extends StatelessWidget {
  final Color primaryColor;

  const PredictorInputPanel({super.key, required this.primaryColor});

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

            // ---  LISTA DINÁMICA DE INPUTS Y SUS RESULTADOS ---
            Column(
              children: viewModel.crackInputs.map((input) {
                return CrackInputRow(
                  key: ValueKey(input.id),
                  crackInput: input,
                  primaryColor: primaryColor,
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // --- BOTÓN DE AGREGAR (+) ---
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

            // ---  BOTÓN DE CÁLCULO (✓) ---
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

            // --- MENSAJE DE ERROR ---
            if (viewModel.errorMessage != null)
              Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}