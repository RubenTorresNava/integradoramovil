import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/resources_screen.dart';
import 'screens/history_screen.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/sif_predictor_viewmodel.dart';
import 'viewmodels/resources_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),
        ChangeNotifierProvider(create: (context) => SifPredictorViewModel()),
        ChangeNotifierProvider(create: (context) => ResourcesViewModel()),
        ChangeNotifierProvider(create: (context) => HistoryViewModel()),
      ],
      child: MaterialApp(
        title: 'PREFIS SIF Predictor',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/resources': (context) => const ResourcesScreen(),
          '/history': (context) => const HistoryScreen(),
        },
      ),
    );
  }
}