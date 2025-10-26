
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resources_viewmodel.dart';
import 'resource_section_card.dart';

class PublicationSection extends StatelessWidget {
  const PublicationSection({Key? key}) : super(key: key);

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ResourcesViewModel>(context, listen: false);
    final pub = viewModel.publication;

    return ResourceSectionCard(
      title: 'Publicaciones Académicas:',
      content: Column(
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
              onPressed: () => viewModel.launchUrl(pub.url),
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ),
          ),
        ],
      ),
    );
  }
}