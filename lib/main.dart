// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'viewmodels/login_viewmodel.dart'; // Importa el ViewModel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 5. Envuelve la aplicación en el Provider
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(), // Crea una instancia del ViewModel
      child: MaterialApp(
        title: 'PREFIS Login',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginPage(),
      ),
    );
  }
}