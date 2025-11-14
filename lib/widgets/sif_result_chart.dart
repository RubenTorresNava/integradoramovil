// lib/widgets/sif_result_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class SifResultChart extends StatelessWidget {
  const SifResultChart({Key? key}) : super(key: key);

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  double? _safeParseResult(String? resultString) {
    if (resultString == null) return null;
    final cleanedString = resultString.replaceAll(' MPa', '').trim();
    return double.tryParse(cleanedString);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SifPredictorViewModel>(
      builder: (context, viewModel, child) {

        // 1. Obtener los datos de PUNTOS INDIVIDUALES (cálculos introducidos por el usuario)
        final List<FlSpot> individualSpots = viewModel.crackInputs
            .where((input) => input.size != null && input.result != null)
            .map((input) {
          final double? yValue = _safeParseResult(input.result);
          return (yValue != null && input.size != null) ? FlSpot(input.size!, yValue) : null;
        }).whereType<FlSpot>().toList();

        // 2. Obtener los datos de la CURVA
        final List<FlSpot> curveSpots = viewModel.sifCurveData.map((point) {
          // point[0] es X (Tamaño), point[1] es Y (SIF)
          return FlSpot(point[0], point[1]);
        }).toList();

        final bool hasData = curveSpots.isNotEmpty || individualSpots.isNotEmpty;

        if (!hasData) {
          return const Center(
            child: Text(
              'Introduce los parámetros de la grieta y presiona "✓" para generar la gráfica.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // 3. Determinar límites (Basado en la curva Y los puntos)
        double maxX = 0;
        double maxY = 0;

        final allX = [...curveSpots.map((s) => s.x), ...individualSpots.map((s) => s.x)];
        final allY = [...curveSpots.map((s) => s.y), ...individualSpots.map((s) => s.y)];

        if (allX.isNotEmpty) {
          maxX = allX.reduce((a, b) => a > b ? a : b) * 1.1;
          maxY = allY.reduce((a, b) => a > b ? a : b) * 1.1;
        }

        // 4. Configuración de la Gráfica
        return Padding(
          padding: const EdgeInsets.only(top: 24, right: 16, bottom: 8, left: 8),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX > 10 ? maxX : 10,
              minY: 0,
              maxY: maxY > 100 ? maxY : 100,

              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  axisNameWidget: const Text('SIF (MPa)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text('Tamaño de Grieta (mm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) =>  FlLine(color: Colors.grey, strokeWidth: 0.5),
                getDrawingVerticalLine: (value) =>  FlLine(color: Colors.grey, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey, width: 1),
              ),

              // 5. Capas de la Gráfica (Curva y Puntos)
              lineBarsData: [
                // A. LÍNEA PRINCIPAL (CURVA DE RELACIÓN)
                LineChartBarData(
                  spots: curveSpots,
                  isCurved: true,
                  color: primaryColor.withOpacity(0.7),
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),

                // B. PUNTOS INDIVIDUALES CALCULADOS POR EL USUARIO
                LineChartBarData(
                  spots: individualSpots,
                  isCurved: false,
                  color: primaryColor,
                  barWidth: 0, // Dibuja solo los puntos
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 8,
                      color: Colors.redAccent,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}