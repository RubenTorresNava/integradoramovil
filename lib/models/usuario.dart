// lib/models/usuario.dart

class Usuario {
  final int usuarioId;
  final String nombre;
  final String email;
  final String rol;
  // (Puedes añadir más campos aquí si los necesitas,
  // como 'fecha_registro', 'esta_activo', etc.)

  Usuario({
    required this.usuarioId,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  // Un 'factory constructor' para crear un Usuario desde un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuario_id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
    );
  }
}
