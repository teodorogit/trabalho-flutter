import 'package:flutter/material.dart';
import 'package:uniclass/View/Pages/home.dart';
import 'package:uniclass/View/Pages/Ensalamento.dart';
import 'package:uniclass/View/Pages/Turmas.dart';
import 'package:uniclass/View/Pages/Salas.dart';
import 'package:uniclass/View/Pages/Cursos.dart';
import 'package:uniclass/View/Pages/Cadastros.dart';
import 'package:uniclass/View/login_page/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ddxpwnaqhwtuurjarzgo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkeHB3bmFxaHd0dXVyamFyemdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI2NTkwNzUsImV4cCI6MjA1ODIzNTA3NX0.IZGrzstRfBY7Zh6WuoysKwxGJZvFEGbFxdEOPlu4X6M',
  );

  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uniclass',
      initialRoute: '/login_page',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => const HomePage(),
        '/Ensalamento': (context) => const EnsalamentoPage(),
        '/Salas': (context) => const SalasPage(),
        '/Turmas': (context) => const TurmasPage(),
        '/Cursos': (context) => const CursosPage(),
        '/Perfil': (context) => const CadastrosPage(),
      },
    );
  }
}
