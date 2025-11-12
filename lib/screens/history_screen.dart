import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/history_list_item.dart';
import '../widgets/history_selection_header.dart';
import '../widgets/history_action_buttons.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  Widget build(BuildContext context) {
    // El widget escucha el ViewModel para reconstruir la lista (carga y datos)
    final viewModel = Provider.of<HistoryViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Historial',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
      body: Column(
        children: <Widget>[
          // Encabezado de Selección (Widget externo)
          const HistorySelectionHeader(primaryColor: primaryColor),

          // Lista de Historial
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 214, 209, 209), // Fondo muy oscuro para la lista
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : ListView.builder(
                itemCount: viewModel.entries.length,
                itemBuilder: (context, index) {
                  final entry = viewModel.entries[index];
                  return HistoryListItem(
                      entry: entry, primaryColor: primaryColor);
                },
              ),
            ),
          ),
        ],
      ),
      // Botones de Acción Flotantes (Widget externo)
      floatingActionButton: const HistoryActionButtons(primaryColor: primaryColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}