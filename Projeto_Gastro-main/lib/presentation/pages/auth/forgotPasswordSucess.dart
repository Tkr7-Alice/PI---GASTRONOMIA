import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/routes/app_routes.dart';

class ForgotPasswordSuccessPage extends StatelessWidget {
  const ForgotPasswordSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Stack(
          children: [
            // 🔥 FUNDO GLOBAL
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/imagens/fundo_icons.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🌊 RODAPÉ
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

            // 📦 CONTEÚDO
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard(context),
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

  Widget _buildCard(BuildContext context) {
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
        child: Column(
          children: [
            // 🔙 VOLTAR (opcional)
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

            // ✅ ÍCONE DE SUCESSO
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              "E-mail enviado!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004C94),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Verifique sua caixa de entrada para redefinir sua senha.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004C94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Voltar para login",
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
    );
  }
}