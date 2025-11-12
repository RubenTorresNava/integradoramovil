import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    return Column(
      children: <Widget>[
        // Campo de Nombre
        TextField(
          controller: nameController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.person, color: Colors.black54),
            hintText: 'Nombre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color.fromRGBO(104, 36, 68, 1), width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 16.0),

        // Campo de Correo
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.mail, color: Colors.black54),
            hintText: 'Correo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color.fromRGBO(104, 36, 68, 1), width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 16.0),

        // Campo de Contraseña
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.lock, color: Colors.black54),
            hintText: 'Contraseña',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color.fromRGBO(104, 36, 68, 1), width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 16.0),

        // Campo de Confirmar Contraseña
        TextField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.lock, color: Colors.black54),
            hintText: 'Confirmar Contraseña',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color.fromRGBO(104, 36, 68, 1), width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          style: const TextStyle(color: Colors.black87),
        ),

        // Mensaje de Error
        if (viewModel.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              viewModel.errorMessage!,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),

        const SizedBox(height: 24.0),

        // Botones de acción
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () {
                  viewModel.register(
                    nameController.text,
                    emailController.text,
                    passwordController.text,
                    confirmPasswordController.text,
                    context,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(104, 36, 68, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            TextButton(
              onPressed: viewModel.isLoading ? null : () => viewModel.goToLogin(context),
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}