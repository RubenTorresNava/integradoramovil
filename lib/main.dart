// lib/main.dart (MODIFICADO)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- 1. IMPORTAR EL AUTH_PROVIDER ---
import 'providers/auth_provider.dart';

// --- Tus imports (sin cambios) ---
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // --- 2. AÑADIR EL AUTH_PROVIDER (EL CEREBRO) ---
        // Lo ponemos primero para que esté disponible globalmente.
        ChangeNotifierProvider(create: (context) => AuthProvider()),

        // --- Tus ViewModels (los músculos) ---
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel()),

        // --- ¡CAMBIO AQUÍ! ---
        // Usamos un ProxyProvider para que SifPredictorViewModel
        // "reciba" el AuthProvider y pueda reaccionar a sus cambios.
        ChangeNotifierProxyProvider<AuthProvider, SifPredictorViewModel>(
          // 'auth' es el AuthProvider que definimos arriba
          // 'previousViewModel' es la instancia anterior (si existe)
          update: (context, auth, previousViewModel) => SifPredictorViewModel(
            authProvider: auth, // Le pasamos el AuthProvider
          ),
          // 'create' solo se usa para la instanciación inicial
          create: (context) => SifPredictorViewModel(
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        // --- FIN DEL CAMBIO ---

        ChangeNotifierProvider(create: (context) => ResourcesViewModel()),
        ChangeNotifierProxyProvider<AuthProvider, HistoryViewModel>(
          update: (context, auth, previous) => HistoryViewModel(
            authProvider: auth, // Le pasamos el AuthProvider
          ),
          create: (context) => HistoryViewModel(
            authProvider: Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],

      // --- 3. ENVOLVER MATERIALAPP EN UN CONSUMER ---
      // Esto hace que MaterialApp se reconstruya cuando el estado de 'auth' cambie
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          title: 'PREFIS SIF Predictor',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),

          // --- 4. LÓGICA DE NAVEGACIÓN DINÁMICA ---
          // Usamos 'home' para decidir la página de inicio.
          home: auth.isLoading
              ? const Scaffold(
                  body: Center(
                      child:
                          CircularProgressIndicator())) // 1. Pantalla de carga
              : auth.isAuthenticated
                  ? const HomeScreen() // 2. Si está logueado, va a Home
                  : const LoginPage(), // 3. Si no, va a Login

          // --- 5. RUTAS CON NOMBRE ---
          // Mantenemos tus rutas, pero '/ ' ya no es necesario
          // porque 'home' se encarga de la raíz.
          routes: {
            // '/': (context) => const LoginPage(), // <-- Ya no se necesita
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/resources': (context) => const ResourcesScreen(),
            '/history': (context) => const HistoryScreen(),
            // ... (Deberías añadir '/user' aquí si tienes una página de perfil)
          },
        ),
      ),
    );
  }
}
