import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class CriarFichaTecnica extends StatefulWidget {
  const CriarFichaTecnica({super.key});

  @override
  State<CriarFichaTecnica> createState() => _CriarFichaTecnicaState();
}

class _CriarFichaTecnicaState extends State<CriarFichaTecnica> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _tempoController = TextEditingController();
  final _porcoesController = TextEditingController();
  final _modoPreparoController = TextEditingController();

  List<Map<String, dynamic>> ingredientes = [];

  // 🔒 SANITIZAÇÃO
  String sanitize(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s@.,\-]'), '');
  }

  double parseDouble(String input) {
    return double.tryParse(input.replaceAll(',', '.')) ?? 0;
  }

  int parseInt(String input) {
    return int.tryParse(input) ?? 0;
  }

  double get custoTotal =>
      ingredientes.fold(0.0, (sum, item) => sum + item['preco']);

  double get custoPorPorcao {
    final p = parseInt(_porcoesController.text);
    if (p == 0) return 0;
    return custoTotal / p;
  }

  void _addIngrediente() {
    final nome = TextEditingController();
    final qtd = TextEditingController();
    final preco = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Adicionar Ingrediente"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input("Nome", nome),
            _input("Quantidade", qtd),
            _input("Preço (R\$)", preco, isNumber: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nome.text.isNotEmpty &&
                  qtd.text.isNotEmpty &&
                  preco.text.isNotEmpty) {
                setState(() {
                  ingredientes.add({
                    "nome": sanitize(nome.text),
                    "quantidade": sanitize(qtd.text),
                    "preco": parseDouble(preco.text),
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text("Adicionar"),
          )
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "nome": sanitize(_nomeController.text),
      "categoria": sanitize(_categoriaController.text),
      "tempo": parseInt(_tempoController.text),
      "porcoes": parseInt(_porcoesController.text),
      "modo_preparo": sanitize(_modoPreparoController.text),
      "ingredientes": ingredientes,
      "custo_total": custoTotal,
      "custo_por_porcao": custoPorPorcao,
    };

    debugPrint(payload.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pronto para API 🚀")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isTablet = width >= 600 && width < 1024;
    final isDesktop = width >= 1024;
    return Scaffold(
      backgroundColor: AppColors.background,

      // 🔥 HEADER PROFISSIONAL
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF005CA9),   // 🔵 azul forte
                    Color(0xFF007BFF),   // 🔵 azul médio
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    // 🔙 BOTÃO VOLTAR
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),

                    
                    const Center(
                      child: Text(
                        "Nova Receita",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    // ✅ BOTÃO CONFIRMAR
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: _submit,
                        icon: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      // 🔥 BODY PROFISSIONAL
      body: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.65,
              child: Image.asset(
                'assets/imagens/senac_fundo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 1000
                      : isTablet
                          ? 800
                          : double.infinity,
                ),
                child: _card(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _foto(),
            const SizedBox(height: 20),

            _input("Nome", _nomeController),
            _input("Categoria", _categoriaController),
            _input("Tempo (min)", _tempoController, isNumber: true),
            _input("Porções", _porcoesController, isNumber: true),

            _section("Ingredientes"),
            _ingredientes(),

            _section("Modo de preparo"),
            _input("Descreva...", _modoPreparoController, maxLines: 4),

            const SizedBox(height: 20),

            _button(),
          ],
        ),
      ),
    );
  }

  Widget _foto() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 40),
            SizedBox(height: 8),
            Text("Adicionar foto da receita"),
          ],
        ),
      ),
    );
  }

  Widget _ingredientes() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _addIngrediente,
          icon: const Icon(Icons.add),
          label: const Text("Adicionar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 10),

        ...ingredientes.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(e['nome'])),
                  Text("R\$ ${e['preco'].toStringAsFixed(2)}"),
                ],
              ),
            )),
      ],
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Salvar Receita",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary)),
        const Divider(),
      ],
    );
  }

  Widget _input(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? "Obrigatório" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF9FAFB),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),     
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}