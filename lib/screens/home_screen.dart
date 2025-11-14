import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/predictor_input_panel.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/sif_result_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

// Widget del área de la gráfica (contenedor gris)
  Widget _buildGraphArea() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300)
      ),
      alignment: Alignment.center,
      // ** CAMBIO CLAVE: Usamos el widget de la gráfica **
      child: const SifResultChart(),
    );
  }
  // Widget de la barra de navegación inferior
  Widget _buildBottomNavigation() {
    return const HomeBottomNav(primaryColor: primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    // Cuerpo principal de la pantalla
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: <Widget>[
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
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const PredictorInputPanel(primaryColor: primaryColor),

                  // Área de Gráfica
                  SizedBox(
                    height: 350,
                    child: _buildGraphArea(),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}