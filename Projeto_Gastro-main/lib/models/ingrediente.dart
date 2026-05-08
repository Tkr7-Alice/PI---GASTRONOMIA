class Ingrediente {
  final String nome;
  final double quantidade;
  final String unidade;
  final double precoUnitario;
  final double fatorCorrecao;

  Ingrediente({
    required this.nome,
    required this.quantidade,
    required this.unidade,
    required this.precoUnitario,
    this.fatorCorrecao = 1.0,
  });

  // 🔥 JSON PARA API
  Map<String, dynamic> toJson() {
    return {
      "nome": nome,
      "quantidade": quantidade,
      "unidade": unidade,
      "preco_unitario": precoUnitario,
      "fator_correcao": fatorCorrecao,
    };
  }

  // 🔥 (IMPORTANTE) CASO VENHA DO BACKEND
  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    return Ingrediente(
      nome: json["nome"] ?? "",
      quantidade: (json["quantidade"] ?? 0).toDouble(),
      unidade: json["unidade"] ?? "g",
      precoUnitario: (json["preco_unitario"] ?? 0).toDouble(),
      fatorCorrecao: (json["fator_correcao"] ?? 1.0).toDouble(),
    );
  }

  // 🔥 REGRA DE NEGÓCIO (GASTRONOMIA)
  double get quantidadeCorrigida => quantidade * fatorCorrecao;

  double get custoTotal => quantidadeCorrigida * precoUnitario;
}