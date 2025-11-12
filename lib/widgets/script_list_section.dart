import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resources_viewmodel.dart';
import 'resource_section_card.dart';

class ScriptListSection extends StatelessWidget {
  const ScriptListSection({super.key});

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ResourcesViewModel>(context);

    return ResourceSectionCard(
      title: 'Scripts APDL de Ansys:',
      content: Column(
        children: viewModel.ansysScripts.map((script) => _buildScriptTile(script)).toList(),
      ),
    );
  }

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
          // Usamos un Separator para la lista, reemplazando el Divider si es el último.
          const Divider(height: 16),
        ],
      ),
    );
  }
}