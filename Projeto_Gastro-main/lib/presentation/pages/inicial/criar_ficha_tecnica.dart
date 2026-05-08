import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../models/ingrediente.dart';
import '../widgets/ingrediente_dialog.dart';
import '../../../services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

  String nivelSelecionado = "";
  bool isLoading = false;
  File? imagemReceita;

  final ImagePicker _picker = ImagePicker();
  final _lucroController = TextEditingController(text: "300");

  List<Ingrediente> ingredientes = [];

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

  double get custoTotal => ingredientes.fold(0.0, (sum, item) => sum + item.custoTotal);

  double get custoPorPorcao {
    
    final p = parseInt(_porcoesController.text);
    if (p == 0) return 0;
    return custoTotal / p;
  }

  double get margemLucro {
    return parseDouble(_lucroController.text);
  }

  double get precoSugerido {
    return custoTotal * (1 + (margemLucro / 100));
  }

  double get foodCost {
    if (precoSugerido == 0) return 0;

    return (custoTotal / precoSugerido) * 100;
  }

  void _addIngrediente() {
    showDialog(
      context: context,
      builder: (_) => IngredienteDialog(
        onAdd: (novoIngrediente) {
          setState(() {
            ingredientes.add(novoIngrediente);
          });
        },
      ),
    );
  }

  Future<void> _selecionarImagem() async {
    final XFile? imagem =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imagem == null) return;

    setState(() {
      imagemReceita = File(imagem.path);
    });
  }

  Future<void> _submit() async {
    if (isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    if (nivelSelecionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione o nível de dificuldade"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final payload = {
      "nome": sanitize(_nomeController.text),
      "categoria": sanitize(_categoriaController.text),
      "tempo_preparo_min": parseInt(_tempoController.text),
      "porcoes": parseInt(_porcoesController.text),
      "modo_preparo": sanitize(_modoPreparoController.text),
      "nivel_dificuldade": nivelSelecionado,

      "ingredientes": ingredientes.map((i) => i.toJson()).toList(),

      "custo_total": double.parse(custoTotal.toStringAsFixed(2)),
      "custo_por_porcao":
          double.parse(custoPorPorcao.toStringAsFixed(2)),
    };

    try {

      await ApiService.post(
        "/api/v1/fichas-tecnicas",
        body: payload,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salvo com sucesso 🚀"),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao salvar"),
        ),
      );

    } finally {

      // desativa loading SEMPRE
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                    Color(0xFF005CA9),   
                    Color(0xFF007BFF),   
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

                          child: isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
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

            _nivelDificuldade(),

            _input(
              "Margem de lucro (%)",
              _lucroController,
              isNumber: true,
            ),

            _resumoFinanceiro(),

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
    return GestureDetector(
      onTap: _selecionarImagem,

      child: Container(
        height: 220,
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: AppColors.border,
          ),

          image: imagemReceita != null
              ? DecorationImage(
                  image: FileImage(imagemReceita!),
                  fit: BoxFit.cover,
                )
              : null,
        ),

        child: imagemReceita == null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(
                      Icons.add_a_photo,
                      size: 42,
                      color: AppColors.primary,
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Adicionar foto da receita",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Clique para selecionar uma imagem",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )

            : Stack(
                children: [

                  Positioned(
                    right: 12,
                    top: 12,

                    child: Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
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
          label: const Text("Adicionar Ingrediente"),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
        ),
        const SizedBox(height: 10),
        
        // Listagem atualizada com detalhes técnicos
        ...ingredientes.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("${item.quantidade} ${item.unidade} | FC: ${item.fatorCorrecao}", 
                             style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text("R\$ ${item.custoTotal.toStringAsFixed(2)}"),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: () => setState(() => ingredientes.remove(item)),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _nivelDificuldade() {
    final niveis = ["Fácil", "Médio", "Difícil"];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nível de dificuldade",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: niveis.map((nivel) {
              final selected = nivelSelecionado == nivel;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      nivelSelecionado = nivel;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),

                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFFF4F6F8),

                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),

                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.20),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),

                    child: Center(
                      child: Text(
                        nivel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (nivelSelecionado.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 4),
              child: Text(
                "Selecione um nível",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor:
              AppColors.primary.withValues(alpha: 0.7),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Text(
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

  Widget _resumoFinanceiro() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Resumo Financeiro",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [

            Expanded(
              child: _financeCard(
                "Custo Total",
                "R\$ ${custoTotal.toStringAsFixed(2)}",
                Icons.attach_money,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _financeCard(
                "Por Porção",
                "R\$ ${custoPorPorcao.toStringAsFixed(2)}",
                Icons.pie_chart,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Expanded(
              child: _financeCard(
                "Preço Sugerido",
                "R\$ ${precoSugerido.toStringAsFixed(2)}",
                Icons.sell_outlined,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _financeCard(
                "Food Cost",
                "${foodCost.toStringAsFixed(1)}%",
                Icons.bar_chart,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Expanded(
              child: _financeCard(
                "Ingredientes",
                "${ingredientes.length}",
                Icons.inventory_2_outlined,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _financeCard(
                "Nível",
                nivelSelecionado.isEmpty
                    ? "--"
                    : nivelSelecionado,
                Icons.local_fire_department_outlined,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _financeCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: AppColors.borderLight,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
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