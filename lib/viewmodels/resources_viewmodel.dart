import 'package:flutter/material.dart';

class ScriptModel {
  final String name;
  final String description;

  ScriptModel({required this.name, required this.description});
}

class PublicationModel {
  final String title;
  final String journal;
  final String year;
  final String url;

  PublicationModel({required this.title, required this.journal, required this.year, required this.url});
}

class ResourcesViewModel extends ChangeNotifier {
  // Datos simulados (lo que se resiviria de la API)

  final List<ScriptModel> _ansysScripts = [
    ScriptModel(
      name: 'edge_crack_analysis.apdl',
      description: 'Script APDL para cálculo de factor de intensidad de tensión de grieta de borde',
    ),
    ScriptModel(
      name: 'center_crack_2d.txt',
      description: 'Análisis de grieta central con refinamiento de malla en punta de grieta',
    ),
    ScriptModel(
      name: 'random_crack_distribution.apdl',
      description: 'Análisis de interacción multigrieta para patrones de grietas aleatorias',
    ),
  ];

  final String _instructions = '''
1. Descargue el archivo de script .apdl o .txt deseado.
2. Abra Ansys Mechanical APDL (versión 2021 R1 o posterior recomendada).
3. File → Read Input From... → Seleccione el script descargado.
4. Ejecute el script usando el comando /INPUT o la GUI.
5. Los resultados se mostrarán en el post-procesador.
''';

  final String _note = 'Modifique las propiedades del material y parámetros geométricos según sea necesario para su caso específico.';

  final PublicationModel _publication = PublicationModel(
    title: 'Al-Enhanced Fracture Mechanics: A CNN-LSTM Approach for Stress Intensity Prediction',
    journal: 'International Journal of Fracture',
    year: '2024',
    url: 'https://ejemplo.com/publicacion-teorica', // URL de ejemplo
  );

  // Getters para acceder a los datos
  List<ScriptModel> get ansysScripts => _ansysScripts;
  String get instructions => _instructions;
  String get note => _note;
  PublicationModel get publication => _publication;

  // Función para abrir el enlace (simulada)
  void launchUrl(String url) {
    print('Abriendo URL: $url');
    // En Flutter, se usaría el paquete 'url_launcher' aquí:
    // launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}