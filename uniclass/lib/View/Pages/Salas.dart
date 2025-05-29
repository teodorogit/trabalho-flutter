import 'package:flutter/material.dart';
import '../layout.dart';

class SalasPage extends StatelessWidget {
  const SalasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Salas',
      child: Center(
        child: Text(
          'Cadastrar e Editar Salas',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
