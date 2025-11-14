import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart'; // Asegúrate de que esta ruta sea correcta

// 1. Convertido a StatefulWidget
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // 2. Estado local para la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // 3. Controladores de texto movidos al State
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const Color primaryColor = Color.fromRGBO(104, 36, 68, 1);

  @override
  void dispose() {
    // Liberar los controladores para evitar fugas de memoria
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escucha el ViewModel para reconstruir con el estado de carga/error
    final viewModel = context.watch<LoginViewModel>();

    return Column(
      children: <Widget>[
        // Campo de Correo (sin cambios)
        _buildTextField(
          controller: _emailController,
          hintText: 'Correo',
          icon: Icons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),

        // Campo de Contraseña (con alternancia de visibilidad)
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
                  // Usamos context.read (no escucha) para llamar a la función
                  context.read<LoginViewModel>().signIn(
                    _emailController.text,
                    _passwordController.text,
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
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            TextButton(
              onPressed: viewModel.isLoading ? null : () => viewModel.goToRegister(context),
              child: Text(
                'Registrarse',
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

  // --- WIDGETS AUXILIARES REUTILIZADOS ---

  Widget _buildTextField({
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
      obscureText: !isVisible, // Ocultar si isVisible es false
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.lock, color: Colors.black54),
        hintText: hintText,
        // Ícono de alternancia
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