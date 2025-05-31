import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'telas/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ddxpwnaqhwtuurjarzgo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkeHB3bmFxaHd0dXVyamFyemdvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI2NTkwNzUsImV4cCI6MjA1ODIzNTA3NX0.IZGrzstRfBY7Zh6WuoysKwxGJZvFEGbFxdEOPlu4X6M',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(), // Altere para AppHomePage() se quiser ir direto pra home
    );
  }
}
