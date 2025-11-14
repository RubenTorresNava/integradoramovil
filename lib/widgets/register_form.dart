import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart'; // Asegúrate de que esta ruta sea correcta

// 1. Convertido a StatefulWidget
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // 2. Estado local para la visibilidad de las contraseñas
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 3. Controladores de texto movidos al State
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegisterViewModel>();

    return Column(
      children: <Widget>[
        // --- Campo de Nombre ---
        _buildStandardTextField(
          controller: _nameController,
          hintText: 'Nombre',
          icon: Icons.person,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16.0),

        // --- Campo de Correo ---
        _buildStandardTextField(
          controller: _emailController,
          hintText: 'Correo',
          icon: Icons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),

        // --- Campo de Contraseña (con alternancia) ---
        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Contraseña',
          isVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        const SizedBox(height: 16.0),

        // --- Campo de Confirmar Contraseña (con alternancia) ---
        _buildPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Confirmar Contraseña',
          isVisible: _isConfirmPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
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

        // --- Botón de Registrarse ---
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () {
              // Usamos context.read (no escucha) para llamar a la función de registro
              context.read<RegisterViewModel>().register(
                _nameController.text,
                _emailController.text,
                _passwordController.text,
                _confirmPasswordController.text,
                context,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
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

        const SizedBox(height: 10.0),

        // --- Enlace de texto (Iniciar Sesión) ---
        TextButton(
          onPressed: viewModel.isLoading
              ? null
              : () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Si ya se ha registrado, iniciar sesión',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[700],
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: Icon(icon, color: Colors.black54),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.lock, color: Colors.black54),
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }
}