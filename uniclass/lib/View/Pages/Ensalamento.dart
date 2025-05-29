import 'package:flutter/material.dart';
import '../layout.dart';

class EnsalamentoPage extends StatelessWidget {
  const EnsalamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Ensalamento',
      child: Center(
        child: Text(
          'Ensalar Turmas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
