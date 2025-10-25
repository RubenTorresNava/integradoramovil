// lib/screens/home_screen.dart (MUCHO MÁS LIMPIO)

import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/predictor_input_panel.dart';
import '../widgets/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  Widget build(BuildContext context) {

    // El área de la gráfica
    Widget _buildGraphArea() {
      return Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300)
        ),
        alignment: Alignment.center,
        child: const Text(
          'Gráfica de Esfuerzos / Resultados aquí',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      // Usamos el Consumer/Provider a nivel del widget de input, no aquí
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Diseño para Tablet/Web
          if (constraints.maxWidth > 800) {
            return Row(
              children: <Widget>[
                // Widget que contiene TODO el input y resultado
                const SizedBox(
                  width: 420,
                  child: PredictorInputPanel(primaryColor: primaryColor),
                ),
                Expanded(
                  child: _buildGraphArea(),
                ),
              ],
            );
          } else {
            // Diseño para Móvil
            return Column(
              children: <Widget>[
                // Widget que contiene TODO el input y resultado
                PredictorInputPanel(primaryColor: primaryColor),
                Expanded(
                  child: _buildGraphArea(),
                ),
              ],
            );
          }
        },
      ),
      // Widget para la navegación inferior
      bottomNavigationBar: HomeBottomNav(primaryColor: primaryColor),
    );
  }
}