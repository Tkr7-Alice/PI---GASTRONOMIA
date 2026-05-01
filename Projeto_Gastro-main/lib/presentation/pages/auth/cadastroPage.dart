import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/config/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../config/routes/app_routes.dart';
import '../../../providers/auth_provider.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.register(
      email: _emailController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicial);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(
        child: Stack(
          children: [
            // 🌅 FUNDO
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/imagens/fundo_icons.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 🌊 ONDAS
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

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    children: [
                      _buildCard(authProvider),
                      const SizedBox(height: 20),
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

  Widget _buildCard(AuthProvider authProvider) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
               // BOTÃO VOLTAR
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Image.asset('assets/imagens/senac.png', height: 110),

              const SizedBox(height: 20),

              const Text(
                "Crie sua conta",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004C94),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Preencha os dados abaixo",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 24),

              _input(
                label: "Nome Completo",
                controller: _nameController,
                icon: Icons.person_outline,
                hint: "Digite seu nome",
              ),

              _input(
                label: "Usuário",
                controller: _usernameController,
                icon: Icons.person_2_outlined,
                hint: "Digite um nome de usuário",
              ),

              _input(
                label: "E-mail",
                controller: _emailController,
                icon: Icons.alternate_email_rounded,
                hint: "exemplo@senac.com",
              ),

              _input(
                label: "Senha",
                controller: _passwordController,
                icon: Icons.lock_outline_rounded,
                hint: "Sua senha",
                isPassword: true,
              ),

              _input(
                label: "Confirmar Senha",
                controller: _confirmPasswordController,
                icon: Icons.lock_outline_rounded,
                hint: "Confirme sua senha",
                isPassword: true,
                isConfirm: true,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004C94),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Cadastrar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),


             Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Já tem conta? ", style: TextStyle(color: Color(0xFF6B6B6B))),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: isPassword
              ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
              : false,

          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),

            prefixIcon: Icon(
              icon,
              color: const Color(0xFF004C94),
              size: 18,
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

            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      (isConfirm
                              ? _obscureConfirmPassword
                              : _obscurePassword)
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isConfirm) {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        } else {
                          _obscurePassword =
                              !_obscurePassword;
                        }
                      });
                    },
                  )
                : null,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

