class Ingrediente {
  final String nome;
  final double quantidade;
  final String unidade; // ex: 'g', 'kg', 'ml', 'un'
  final double precoUnitario; // Preço do kg/litro/unidade
  final double fatorCorrecao; // FC (ex: 1.0 para sem perda, 1.25 para limpeza)

  Ingrediente({
    required this.nome,
    required this.quantidade,
    required this.unidade,
    required this.precoUnitario,
    this.fatorCorrecao = 1.0,
  });

  // Cálculo: (Quantidade * Fator) * Preço Unitário
  double get custoTotal => (quantidade * fatorCorrecao) * precoUnitario;
}