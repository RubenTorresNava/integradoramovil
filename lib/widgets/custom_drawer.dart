import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- 1. IMPORTAR PROVIDER
import '../providers/auth_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El color morado oscuro del diseño
    const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

    final authProvider = Provider.of<AuthProvider>(context);

    // --- 2. Extraer los datos del usuario de forma segura ---
    // Usamos '??' para poner valores por defecto mientras carga
    final String nombreUsuario = authProvider.user?.nombre ?? 'Cargando...';
    final String emailUsuario = authProvider.user?.email ?? '...';
    final String inicialUsuario = authProvider.user?.nombre.isNotEmpty == true
        ? authProvider.user!.nombre[0].toUpperCase()
        : '?';

    return Drawer(
      width: 250, // Ancho fijo para el drawer
      backgroundColor: primaryColor,
      child: Column(
        children: <Widget>[
          // Header de la app (oculta el icono de menú)
          const DrawerHeader(
            padding: EdgeInsets.zero,
            child: SizedBox(height: 50.0), // Espacio para la parte superior
          ),

          // Lista de elementos de navegación
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white, size: 30),
            title: Text(
              'Inicio',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/home' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/home' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              // Lógica de navegación a Inicio (ya estamos aquí, se puede cerrar el drawer)
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white70),
            title: Text(
              'Historial',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/history' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/history' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.of(context).pushNamed('/history'); // Navega a la pantalla
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_stories, color: Colors.white70),
            title: Text(
              'Recursos',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/resources' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/resources' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              // Lógica para navegar a Recursos
              Navigator.pop(context); // Cierra el drawer
              Navigator.of(context).pushNamed('/resources'); // Navega a la pantalla
            },
          ),

          const Spacer(), // Empuja el siguiente elemento al final

          // Icono de usuario (Adaptado de la esquina superior derecha)
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              // Muestra la inicial del usuario
              child: Text(inicialUsuario,
                  style: const TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
            ),
            // Muestra el nombre real
            title: Text(nombreUsuario,
                style: const TextStyle(color: Colors.white)),
            // Muestra el email real
            subtitle: Text(emailUsuario,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),

            onTap: () {
              // La lógica de Logout (no cambia)
              Navigator.pop(context);
              authProvider.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}