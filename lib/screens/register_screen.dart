// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_icon.dart'; // Reutilizamos el mismo icono
import '../widgets/register_form.dart'; // Importa el formulario de registro
import '../viewmodels/register_viewmodel.dart'; // Importa el ViewModel de registro

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
              const UserIcon(), // Reutilizamos el UserIcon
              const SizedBox(height: 48.0),

              Text(
                'Registrar Usuario',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 32.0),

              // Usa el formulario de registro
              const RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}