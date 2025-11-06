import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class ResultOutputPanel extends StatelessWidget {
  const ResultOutputPanel({Key? key}) : super(key: key);

  static const Color secondaryColor = Color.fromARGB(255, 128, 55, 93);

  @override
  Widget build(BuildContext context) {
    // Escucha solo los cambios de resultado, error y carga
    final viewModel = Provider.of<SifPredictorViewModel>(context);

    // Solo muestra el panel si hay algo que mostrar (resultado, carga o error)
    if (viewModel.sifResult == null && !viewModel.isLoading && viewModel.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (viewModel.isLoading)
            const Center(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              ),
            )
          else if (viewModel.errorMessage != null)
            Text(
              'Error: ${viewModel.errorMessage!}',
              style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resultado Calculado:',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  '${viewModel.sifResult!.toString()} MPa',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    );
  }
}