import 'package:flutter/material.dart';
import '../layout.dart';

class CursosPage extends StatelessWidget {
  const CursosPage({super.key});

  Widget build(BuildContext) {
    return AppLayout(
        title: 'Cursos',
        child: Center(
          child: Text(
            'Cadastrar e Editar Cursos',
            style: TextStyle(fontSize: 20),
          ),
        ));
  }
}
