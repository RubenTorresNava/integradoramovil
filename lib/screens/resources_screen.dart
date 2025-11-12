
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/resource_section_card.dart';
import '../widgets/script_list_section.dart';
import '../widgets/publication_section.dart';
import '../viewmodels/resources_viewmodel.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  Widget _buildInstructionSection(BuildContext context, ResourcesViewModel viewModel) {
    return ResourceSectionCard(
      title: 'Instrucciones de Uso:',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            viewModel.instructions,
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
          const Divider(height: 20),
          Text(
            'Nota: ${viewModel.note}',
            style: TextStyle(fontSize: 14, color: Colors.amber[800], fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ResourcesViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recursos',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: Text('A', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ScriptListSection(),
            const SizedBox(height: 24),

            _buildInstructionSection(context, viewModel),
            const SizedBox(height: 24),

            const PublicationSection(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}