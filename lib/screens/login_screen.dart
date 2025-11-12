import 'package:flutter/material.dart';
import '../widgets/user_icon.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Widget del Icono de usuario
              const UserIcon(),
              const SizedBox(height: 48.0),

              // Texto de bienvenida
              Text(
                'Bienvenido a PREFIS',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 32.0),

              // Widget del Formulario de inicio de sesión
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}