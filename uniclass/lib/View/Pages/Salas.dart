import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../layout.dart';

class SalasPage extends StatefulWidget {
  const SalasPage({super.key});

  @override
  State<SalasPage> createState() => _SalasPageState();
}

class _SalasPageState extends State<SalasPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> salas = [];
  bool carregando = true;
  final TextEditingController buscaController = TextEditingController();
  String termoBusca = '';

  @override
  void initState() {
    super.initState();
    fetchSalas();
  }

  Future<void> fetchSalas() async {
    try {
      final data = await supabase
          .from('salas')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        salas = data as List<dynamic>;
        carregando = false;
      });
    } catch (error) {
      print('Erro ao buscar salas: $error');
      setState(() {
        carregando = false;
      });
    }
  }

  List get salasFiltradas {
    if (termoBusca.isEmpty) return salas;
    return salas.where((sala) {
      final nome = (sala['name'] ?? '').toString().toLowerCase();
      return nome.contains(termoBusca);
    }).toList();
  }

  void showAddSalaDialog(BuildContext context) {
  final nomeController = TextEditingController();
  final cadeirasComunsController = TextEditingController();
  final cadeirasEspeciaisController = TextEditingController();
  final tvsController = TextEditingController();
  final arCondicionadoController = TextEditingController();
  final projetoresController = TextEditingController();
  final caixasSomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Adicionar nova sala'),
      content: SizedBox(
        width: screenWidth * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da sala'),
                  validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cadeirasComunsController,
                  decoration: const InputDecoration(labelText: 'Cadeiras comuns'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Informe as cadeiras comuns' : null,
                ),
                TextFormField(
                  controller: cadeirasEspeciaisController,
                  decoration: const InputDecoration(labelText: 'Cadeiras especiais'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: tvsController,
                  decoration: const InputDecoration(labelText: 'TVs'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: arCondicionadoController,
                  decoration: const InputDecoration(labelText: 'Ar-condicionado'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: projetoresController,
                  decoration: const InputDecoration(labelText: 'Projetores'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: caixasSomController,
                  decoration: const InputDecoration(labelText: 'Caixas de som'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              try {
                await supabase.from('salas').insert({
                  'name': nomeController.text.trim(),
                  'qnt_chair': int.tryParse(cadeirasComunsController.text) ?? 0,
                  'qnt_especial_chair': int.tryParse(cadeirasEspeciaisController.text) ?? 0,
                  'qnt_tv': int.tryParse(tvsController.text) ?? 0,
                  'qnd_ar_condicionado': int.tryParse(arCondicionadoController.text) ?? 0,
                  'qnd_projetor': int.tryParse(projetoresController.text) ?? 0,
                  'qnd_caixa_som': int.tryParse(caixasSomController.text) ?? 0,
                });
                Navigator.pop(context);
                fetchSalas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sala adicionada com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao adicionar sala: $e')),
                );
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    ),
  );
}

  void showEditSalaDialog(BuildContext context, Map<String, dynamic> sala) {
  final nomeController = TextEditingController(text: sala['nome'] ?? '');
  final cadeirasComunsController = TextEditingController(text: sala['qnt_chair']?.toString() ?? '0');
  final cadeirasEspeciaisController = TextEditingController(text: sala['qnt_especial_chair']?.toString() ?? '0');
  final tvsController = TextEditingController(text: sala['qnt_tv']?.toString() ?? '0');
  final arCondicionadoController = TextEditingController(text: sala['qnd_ar_condicionado']?.toString() ?? '0');
  final projetoresController = TextEditingController(text: sala['qnd_projetor']?.toString() ?? '0');
  final caixasSomController = TextEditingController(text: sala['qnd_caixa_som']?.toString() ?? '0');
  final _formKey = GlobalKey<FormState>();
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Editar sala'),
      content: SizedBox(
        width: screenWidth * 0.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da sala'),
                  validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cadeirasComunsController,
                  decoration: const InputDecoration(labelText: 'Cadeiras comuns'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: cadeirasEspeciaisController,
                  decoration: const InputDecoration(labelText: 'Cadeiras especiais'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: tvsController,
                  decoration: const InputDecoration(labelText: 'TVs'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: arCondicionadoController,
                  decoration: const InputDecoration(labelText: 'Ar-condicionado'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: projetoresController,
                  decoration: const InputDecoration(labelText: 'Projetores'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: caixasSomController,
                  decoration: const InputDecoration(labelText: 'Caixas de som'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              try {
                await supabase.from('salas').update({
                  'name': nomeController.text.trim(),
                  'qnt_chair': int.tryParse(cadeirasComunsController.text) ?? 0,
                  'qnt_especial_chair': int.tryParse(cadeirasEspeciaisController.text) ?? 0,
                  'qnt_tv': int.tryParse(tvsController.text) ?? 0,
                  'qnd_ar_condicionado': int.tryParse(arCondicionadoController.text) ?? 0,
                  'qnd_projetor': int.tryParse(projetoresController.text) ?? 0,
                  'qnd_caixa_som': int.tryParse(caixasSomController.text) ?? 0,
                }).eq('sala_id', sala['sala_id']);
                Navigator.pop(context);
                fetchSalas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sala atualizada com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar sala: $e')),
                );
              }
            }
          },
          child: const Text('Salvar alterações'),
        ),
      ],
    ),
  );
}

  void showDeleteSalaDialog(BuildContext context, Map<String, dynamic> sala) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir sala'),
        content: Text('Deseja excluir a sala "${sala['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await supabase.from('salas').delete().eq('sala_id', sala['sala_id']);
                Navigator.pop(context);
                fetchSalas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sala excluída com sucesso')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao excluir sala: $e')),
                );
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Salas',
      child: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 50),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: buscaController,
                          decoration: InputDecoration(
                            hintText: 'Buscar por nome...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              termoBusca = value.toLowerCase();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => showAddSalaDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar sala'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: salasFiltradas.isEmpty
                      ? const Center(child: Text('Nenhuma sala cadastrada.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: salasFiltradas.length,
                          itemBuilder: (context, index) {
                            final sala = salasFiltradas[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: const Color(0xFFF8F3FA),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Coluna com o nome e as informações
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sala['name'] ?? 'Sem nome',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 18,
                                            runSpacing: 4,
                                            children: [
                                              Text('Cadeiras comuns: ${sala['qnt_chair'] ?? 0}'),
                                              Text('Cadeiras especiais: ${sala['qnt_especial_chair'] ?? 0}'),
                                              Text('TVs: ${sala['qnt_tv'] ?? 0}'),
                                              Text('Ar-condicionado: ${sala['qnd_ar_condicionado'] ?? 0}'),
                                              Text('Projetores: ${sala['qnd_projetor'] ?? 0}'),
                                              Text('Caixas de som: ${sala['qnd_caixa_som'] ?? 0}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Ícones de ação
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.green),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () => showEditSalaDialog(context, sala),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () => showDeleteSalaDialog(context, sala),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
