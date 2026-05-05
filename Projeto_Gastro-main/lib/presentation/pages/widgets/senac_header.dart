import 'package:flutter/material.dart';
import 'package:projeto_gastronomia_ficha/config/theme/app_colors.dart';

class SaasHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onAdd;
  final VoidCallback? onProfile;
  final VoidCallback? onBack;
  final bool showBack;

  const SaasHeader({
    super.key,
    required this.title,
    this.onAdd,
    this.onProfile,
    this.onBack,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFFF7941D)], // Azul + Laranja SENAC
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 🔙 VOLTAR
            if (showBack)
              IconButton(
                onPressed: onBack ?? () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),

            // 🧾 TÍTULO
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // ➕ BOTÃO AÇÃO
            if (onAdd != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text("Novo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            // 👤 PERFIL
            GestureDetector(
              onTap: onProfile,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}