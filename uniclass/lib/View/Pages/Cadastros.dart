import 'package:flutter/material.dart';
import '../layout.dart';

class CadastrosPage extends StatelessWidget {
  const CadastrosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Cadastros de Funcionários',
      child: Center(
        child: Text(
          'Cadastrar Funcionários',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
