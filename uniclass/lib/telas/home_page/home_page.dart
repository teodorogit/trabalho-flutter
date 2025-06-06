import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniclass/utils/themeNotifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nomeUsuario;
  String? selectedCurso;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    buscarNomeUsuario();
    buscarCursoSelecionado();
  }

  Future<void> buscarCursoSelecionado() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final userId = user.id;

    final response = await Supabase.instance.client
        .from('mobileUser')
        .select('curso')
        .eq('id', userId)
        .single();

    setState(() {
      selectedCurso = response['curso'] ?? 'Curso não encontrado';
    });

    print('Curso selecionado: $selectedCurso');
  }

  Future<void> buscarNomeUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final userId = user.id;

    final response = await Supabase.instance.client
        .from('mobileUser')
        .select('nome')
        .eq('id', userId)
        .single();

    setState(() {
      nomeUsuario = response['nome'] ?? 'Usuário';
    });

    print('Nome do usuário: $nomeUsuario');
  }

  Future<void> _tirarEShareScreenshot() async {
    try {
      final Uint8List? image = await _screenshotController.capture();

      if (image == null) return;

      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compartilhar não é suportado no navegador.')),
        );
        return;
      }

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/screenshot.png');
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Confira meus horários no app UniClass 📚',
      );
    } catch (e) {
      print('Erro ao compartilhar screenshot: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao compartilhar. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/fake_user_flutter.png',
                      width: 38,
                      height: 38,
                    ),
                    nomeUsuario == null
                        ? const CircularProgressIndicator()
                        : Text(
                            nomeUsuario!,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .changeTheme();
                      },
                      child: Image.asset(
                        'assets/images/moon_flutter.png',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Container(
                      child: selectedCurso == null
                          ? const CircularProgressIndicator()
                          : Text(
                              'Curso: $selectedCurso',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      width: MediaQuery.of(context).size.width * 0.75,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 20),
                    Screenshot(
                      controller: _screenshotController,
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Primeiro horário',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'LAB 01 -\nFlutter Avançado',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Segundo horário',
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                Divider(
                                  thickness: 1,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'LAB 01 -\nFlutter Avançado',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset('assets/images/fundo_celular.png',
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.height * 0.15),
                    SizedBox(height: 50),
                    ElevatedButton.icon(
                      onPressed: _tirarEShareScreenshot,
                      icon: Icon(Icons.share),
                      label: Text('Compartilhar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
