import 'package:flutter/material.dart';
import 'package:uniclass/View/home_page/app_homepage.dart';
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
