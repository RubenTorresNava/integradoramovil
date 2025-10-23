import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Obtener acceso al ViewModel (la lógica)
    // El widget se reconstruirá cada vez que el ViewModel llame a notifyListeners()
    final viewModel = Provider.of<LoginViewModel>(context);

    // Controladores de texto. Se definen aquí ya que son necesarios solo para este widget.
    // El estado de lo que escriben queda en el TextField, pero el valor se pasa al ViewModel al presionar el botón.
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      children: <Widget>[
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
                // 2. Lógica del botón: Si está cargando, es null (deshabilitado)
                onPressed: viewModel.isLoading
                    ? null
                    : () {
                  // Llama a la función signIn del ViewModel, pasando los datos del formulario
                  viewModel.signIn(
                    emailController.text,
                    passwordController.text,
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
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                ) // Muestra el spinner de carga
                    : const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            TextButton(
              // 3. Lógica del botón Registrarse
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
}