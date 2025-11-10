import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class HomeBottomNav extends StatelessWidget {
  final Color primaryColor;

  const HomeBottomNav({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel
    final viewModel = Provider.of<SifPredictorViewModel>(context);

    // Estas propiedades fueron conservadas en el ViewModel y funcionan
    return BottomNavigationBar(
      currentIndex: viewModel.selectedTabIndex,
      onTap: viewModel.selectTab,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_on),
          label: 'Estándar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shuffle),
          label: 'Aleatorias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.blur_on),
          label: 'Residuales',
        ),
      ],
    );
  }
}