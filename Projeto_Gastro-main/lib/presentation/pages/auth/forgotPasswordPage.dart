import 'package:flutter/material.dart';
import '../../../config/routes/app_routes.dart';
import '../../../config/theme/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendRecovery() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = _emailController.text.trim();

    Navigator.pushReplacementNamed(context, AppRoutes.forgotPasswordSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Stack(
          children: [
            // FUNDO GLOBAL
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/imagens/fundo_icons.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // RODAPÉ
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/imagens/senac_fundo.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),

            // CONTEÚDO
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      _buildCard(),
                      const SizedBox(height: 24),
                      const Text(
                        "© 2026 Senac - Todos os direitos reservados",
                        style: TextStyle(
                          color: Color(0xFF004C94),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 25),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0EDED)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔙 BOTÃO VOLTAR
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // 🟦 LOGO
              Image.asset(
                'assets/imagens/senac.png',
                height: 110,
              ),

              const SizedBox(height: 20),

              const Text(
                "Esqueceu sua senha?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C94),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Digite seu e-mail para recuperar sua conta",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu e-mail';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, digite um e-mail válido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "exemplo@senac.com",
                  prefixIcon: const Icon(
                    Icons.alternate_email_rounded,
                    color: Color(0xFF004C94),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF004C94),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _sendRecovery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004C94),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Enviar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
