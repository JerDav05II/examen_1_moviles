import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/': (_) => const InicioScreen(),
      '/registro': (_) => const RegistroScreen(),
      '/resumen': (_) => const ResumenScreen(),
    },
  ),
);

// 1. INICIO
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            const Text(
              'Registro de Capacitaciones',
              style: TextStyle(fontSize: 20),
            ),
            const Text('Completa tus datos para participar.'),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/registro'),
              child: const Text('Registrar participante'),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. REGISTRO
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _edad = TextEditingController();
  final _institucion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
                  (v == null || v.length < 5) ? 'Mínimo 5 caracteres' : null,
            ),
            TextFormField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (v) =>
                  (v == null || !v.contains('@') || !v.contains('.'))
                  ? 'Correo no válido'
                  : null,
            ),
            TextFormField(
              controller: _edad,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Edad'),
              validator: (v) {
                int? e = int.tryParse(v ?? '');
                return (e == null || e < 15 || e > 80)
                    ? 'Edad entre 15 y 80'
                    : null;
              },
            ),
            TextFormField(
              controller: _institucion,
              decoration: const InputDecoration(labelText: 'Institución'),
              validator: (v) =>
                  (v == null || v.length < 5) ? 'Mínimo 5 caracteres' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Datos registrados correctamente'),
                    ),
                  );
                  Navigator.pushNamed(
                    context,
                    '/resumen',
                    arguments: {
                      'nombre': _nombre.text,
                      'correo': _correo.text,
                      'edad': _edad.text,
                      'institucion': _institucion.text,
                    },
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. RESUMEN
class ResumenScreen extends StatelessWidget {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final datos =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'INSCRIPCIÓN COMPLETADA',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Nombre: ${datos['nombre']}'),
            Text('Correo: ${datos['correo']}'),
            Text('Edad: ${datos['edad']}'),
            Text('Institución: ${datos['institucion']}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              ),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
