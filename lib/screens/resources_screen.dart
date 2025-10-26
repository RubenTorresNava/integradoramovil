import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../viewmodels/resources_viewmodel.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  Widget build(BuildContext context) {
    // Solo escucha para obtener los datos.
    final viewModel = Provider.of<ResourcesViewModel>(context);

    // Contenido central que se adapta al scroll
    Widget _buildContent() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Sección 1: Scripts APDL de Ansys
            _buildSectionCard(
              title: 'Scripts APDL de Ansys:',
              content: Column(
                children: viewModel.ansysScripts.map((script) => _buildScriptTile(script)).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Sección 2: Instrucciones de Uso
            _buildSectionCard(
              title: 'Instrucciones de Uso:',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Muestra las instrucciones
                  Text(
                    viewModel.instructions,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  const Divider(height: 20),
                  // Muestra la nota
                  Text(
                    'Nota: ${viewModel.note}',
                    style: TextStyle(fontSize: 14, color: Colors.amber[800], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sección 3: Publicaciones Académicas
            _buildSectionCard(
              title: 'Publicaciones Académicas:',
              content: _buildPublicationCard(viewModel.publication, viewModel.launchUrl),
            ),
            const SizedBox(height: 50), // Espacio al final
          ],
        ),
      );
    }

    // Estructura general con App Bar y Drawer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: _buildContent(),
    );
  }

  // --- WIDGETS AUXILIARES PARA LIMPIAR LA UI ---

  // Tarjeta general para agrupar secciones
  Widget _buildSectionCard({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: content,
          ),
        ),
      ],
    );
  }

  // Elemento de lista para cada script
  Widget _buildScriptTile(ScriptModel script) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nombre del Script: ${script.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Descripción: ${script.description}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  // Tarjeta especial para la publicación académica
  Widget _buildPublicationCard(PublicationModel pub, Function(String) onLaunch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pub.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          '${pub.journal}, ${pub.year}',
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.visibility),
            label: const Text('Ver Artículo', style: TextStyle(color: Colors.white)),
            onPressed: () => onLaunch(pub.url),
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            ),
          ),
        ),
      ],
    );
  }
}