import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class CrackSizeInput extends StatelessWidget {
  final TextEditingController controller;

  const CrackSizeInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          suffixIcon: viewModel.crackSize > 0
              ? IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 18),
            onPressed: () => viewModel.clearInput(),
          )
              : null,
        ),
        onChanged: (value) {
          double? size = double.tryParse(value);
          if (size != null) {
            // Usa listen: false aquí porque solo necesitas llamar a la función, no reconstruir.
            Provider.of<SifPredictorViewModel>(context, listen: false).setCrackSize(size);
          }
        },
      ),
    );
  }
}