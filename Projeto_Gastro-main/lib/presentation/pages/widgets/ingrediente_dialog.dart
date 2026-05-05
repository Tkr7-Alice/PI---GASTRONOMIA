import 'package:flutter/material.dart';
import '../../../models/ingrediente.dart';

class IngredienteDialog extends StatefulWidget {
  final Function(Ingrediente) onAdd;

  const IngredienteDialog({super.key, required this.onAdd});

  @override
  State<IngredienteDialog> createState() => _IngredienteDialogState();
}

class _IngredienteDialogState extends State<IngredienteDialog> {
  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();
  final _precoController = TextEditingController();
  final _fatorController = TextEditingController();
  final _fatorFocus = FocusNode();

  String _unidadeSelecionada = "g";

  @override
  void initState() {
    super.initState();

    _fatorFocus.addListener(() {
      // Quando clicar no campo
      if (_fatorFocus.hasFocus && _fatorController.text == "1.0") {
        _fatorController.clear();
      }

      // Quando sair do campo vazio
      if (!_fatorFocus.hasFocus && _fatorController.text.isEmpty) {
        _fatorController.text = "1.0";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFF4EC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 500;
          return Container(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 420,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu, color: Color(0xFFFF7A00)),
                      const SizedBox(width: 10),
                      const Text(
                        "Adicionar Ingrediente",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _input(_nomeController, "Nome"),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _input(_qtdController, "Quantidade", isNumber: true),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _unidadeSelecionada,
                          decoration: _decoration("Unid."),
                          items: ["g", "kg", "ml", "L", "un"]
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _unidadeSelecionada = v!),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _input(_precoController, "Preço Unitário (R\$)",
                      isNumber: true),
                  const SizedBox(height: 14),

                  _input(
                    _fatorController,
                    "Fator de Correção",
                    isNumber: true,
                    hint: "1.0",
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _handleAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A00),
                          elevation: 4,
                          shadowColor: Colors.orange.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                        ),
                        child: const Text(
                          "Adicionar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAdd() {
    double qtd =
        double.tryParse(_qtdController.text.replaceAll(',', '.')) ?? 0;
    double preco =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0;
    double fator =
        double.tryParse(_fatorController.text.replaceAll(',', '.')) ?? 1.0;

    if (_nomeController.text.isEmpty || qtd <= 0 || preco <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha os campos corretamente")),
      );
      return;
    }

    final novo = Ingrediente(
      nome: _nomeController.text.trim(),
      quantidade: qtd,
      unidade: _unidadeSelecionada,
      precoUnitario: preco,
      fatorCorrecao: fator,
    );

    widget.onAdd(novo);
    Navigator.pop(context);
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      decoration: _decoration(label, hint: hint),
    );
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFFF7A00), width: 1.5),
      ),
    );
  }
  @override
  void dispose() {
    _fatorFocus.dispose();
    super.dispose();
  }
}