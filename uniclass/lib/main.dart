import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniclass/utils/themeNotifier.dart';
import 'telas/login_page/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ddxpwnaqhwtuurjarzgo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkeHB3bmFxaHd0dXVyamFyemdvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0MjY1OTA3NSwiZXhwIjoyMDU4MjM1MDc1fQ.e1QqD_i7r5ci4i4g-8WC3YQefhSGKIiEdev13kCVtsE', // substitua aqui
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(false), // Inicia com modo claro
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.theme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
