import 'package:flutter/material.dart';
import 'package:uniclass/telas/cadastro/cadastro_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Cadastro',
     home: CadastroPage());
  }
}
