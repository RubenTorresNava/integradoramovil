import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  static const Color accentColor = Color.fromRGBO(240, 240, 240, 1);

  // Helper para obtener iniciales (mejorado para manejar nombres completos)
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);
    final authProvider = Provider.of<AuthProvider>(context);

    // --- Extracción de datos (sin cambios) ---
    final String nombreCompleto = authProvider.user?.nombre ?? 'Cargando Usuario';
    final String emailUsuario = authProvider.user?.email ?? '...';
    // Usamos el helper mejorado
    final String iniciales = _getInitials(nombreCompleto);

    return Drawer(
      // Ya tiene width: 70%
      width: MediaQuery.of(context).size.width * 0.57,
      backgroundColor: primaryColor,
      child: Column(
        children: <Widget>[
          // --- 1. Encabezado COMPACTO ---
          SafeArea(
            child: Container(
              color: primaryColor,
              // Reducir la altura a 80 o menos
              height: 80,
              alignment: Alignment.centerLeft,
              child: const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8.0), // Ajustar padding superior
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 22, // Ligeramente más pequeño
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // --- Opciones de Navegación (Compactadas) ---
          ListTile(
            // ** CLAVE: Reducir el contentPadding **
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: const Icon(Icons.add, color: Colors.white, size: 24), // Icono más pequeño
            title: Text(
              'Inicio',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/home' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/home' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            visualDensity: VisualDensity.compact, // Opcional: Aún más compacto
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/home');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: const Icon(Icons.history, color: Colors.white70, size: 24),
            title: Text(
              'Historial',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/history' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/history' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            visualDensity: VisualDensity.compact,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/history');
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            leading: const Icon(Icons.auto_stories, color: Colors.white70, size: 24),
            title: Text(
              'Recursos',
              style: TextStyle(
                color: ModalRoute.of(context)?.settings.name == '/resources' ? Colors.white : Colors.white70,
                fontWeight: ModalRoute.of(context)?.settings.name == '/resources' ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            visualDensity: VisualDensity.compact,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/resources');
            },
          ),

          const Spacer(), // Empuja el contenido restante (usuario) al final

          // --- Información del Usuario (Parte inferior) ---
          InkWell(
            onTap: () {
              // Lógica de Logout
              Navigator.pop(context); // Cierra el Drawer
              authProvider.logout(); // Llama a la función de Logout del Provider

              // Navega a la ruta inicial ('/') y elimina todas las rutas anteriores
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0, top: 10.0), // Agregué un padding superior para hacer el área de tap más grande
              child: Row(
                children: <Widget>[
                  // Avatar con Iniciales
                  CircleAvatar(
                    backgroundColor: accentColor,
                    child: Text(
                      iniciales,
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Columna de texto (Expandida para truncar nombres largos)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          nombreCompleto,
                          style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          emailUsuario,
                          style: const TextStyle(color: accentColor, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}