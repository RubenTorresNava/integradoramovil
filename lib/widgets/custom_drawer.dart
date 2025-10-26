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
            title: const Text('Inicio', style: TextStyle(color: Colors.white)),
            tileColor: const Color.fromRGBO(104, 36, 68, 1), // Fondo morado para el elemento activo
            onTap: () {
              // Lógica de navegación a Inicio (ya estamos aquí, se puede cerrar el drawer)
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white70),
            title: const Text('Historial', style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Lógica de navegación a Historial
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_stories, color: Colors.white70),
            title: const Text('Recursos', style: TextStyle(color: Colors.white70)),
            tileColor: ModalRoute.of(context)?.settings.name == '/resources' ? Colors.purple[800] : null, // Opcional: Resaltar si está activo
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