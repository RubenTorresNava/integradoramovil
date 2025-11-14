import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/sif_predictor_viewmodel.dart';

class HomeBottomNav extends StatelessWidget {
  final Color primaryColor;

  const HomeBottomNav({Key? key, required this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SifPredictorViewModel>(context);

    return BottomNavigationBar(
      currentIndex: viewModel.selectedTabIndex,
      onTap: (index) {
        if (index == 0) {
          viewModel.selectTab(index);
        } else {

          Navigator.of(context).pushNamed('/coming_soon');

          if (viewModel.selectedTabIndex != 0) {
            viewModel.selectTab(0);
          }
        }
      },
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