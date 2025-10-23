import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos MultiProvider para manejar múltiples ViewModels/Providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
      ],
      child: MaterialApp(
        title: 'PREFIS App',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/', // Define la ruta inicial
        routes: {
          '/': (context) => const LoginPage(), // Ruta para la pantalla de Login
          '/register': (context) => const RegisterScreen(), // Ruta para la pantalla de Registro
        },
      ),
    );
  }
}