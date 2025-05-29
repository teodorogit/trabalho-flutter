import 'package:flutter/material.dart';
import '../layout.dart';

class TurmasPage extends StatelessWidget {
  const TurmasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Turmas',
      child: Center(
        child: Text(
          'Cadastrar e Editar Turmas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
