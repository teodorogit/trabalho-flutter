import 'package:flutter/material.dart';
import '../layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Home',
      child: Center(
        child: Text(
          'Bem-vindo à página inicial!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
