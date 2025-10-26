import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // El color morado oscuro del diseño
    const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

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
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('A', style: TextStyle(color: primaryColor)),
            ),
            title: const Text('Usuario A', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Lógica para cerrar sesión/perfil
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}