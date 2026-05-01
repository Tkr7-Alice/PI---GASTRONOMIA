import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/routes/app_routes.dart';
import '../../../providers/auth_provider.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isButtonPressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.vibrate(); 
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim().toLowerCase(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicial);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Credenciais inválidas'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
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
           // IMAGEM DE FUNDO GLOBAL
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  'assets/imagens/fundo_icons.png',
                  fit: BoxFit.cover,                       
                ),
              ),
            ),
            

            //  🔵 Ondas do rodapé \\ Imagem alinhada na base com largura total 
            Opacity(
              opacity: 0.7,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/imagens/senac_fundo.png',
                  fit: BoxFit.fitWidth, // Garante que as ondas ocupem toda a largura
                  width: double.infinity,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLoginCard(authProvider),
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

  Widget _buildLoginCard(AuthProvider authProvider) {
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/imagens/senac.png',
                    height: 125, 
                    fit: BoxFit.contain, 
                  ), 
                  const SizedBox(height: 30),
                  const Text(
                    "Acesse sua conta",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Informe suas credenciais para entrar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildInput(
                    label: "E-mail",
                    controller: _emailController,
                    icon: Icons.alternate_email_rounded,
                    hint: "exemplo@senac.com",
                    keyboardType: TextInputType.emailAddress,
                    isEmail: true,
                  ),
                  const SizedBox(height: 24),
                  _buildInput(
                    label: "Senha",
                    controller: _passwordController,
                    icon: Icons.lock_outline_rounded,
                    hint: "Sua senha",
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 18, width: 18,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (v) => setState(() => _rememberMe = v!),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text("Lembrar", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {Navigator.pushNamed(context, AppRoutes.forgotPassword);},
                          child: const Text(
                            "Esqueceu a senha?",
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(authProvider),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Não tem uma conta? ", style: TextStyle(color: Color(0xFF6B6B6B))),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cadastro),
                  child: const Text(
                    "Cadastre-se",
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AuthProvider authProvider) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) => setState(() => _isButtonPressed = false),
      onTapCancel: () => setState(() => _isButtonPressed = false),
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004C94),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: authProvider.isLoading
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("ENTRAR", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isEmail = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: keyboardType,
          inputFormatters: isEmail ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] : null,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obrigatório';
            if (isEmail && !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'E-mail inválido';
            if (isPassword && value.length < 6) return 'Mínimo 6 caracteres';
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textTertiary, size: 18),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}