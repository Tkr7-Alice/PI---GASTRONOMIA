import 'package:flutter/material.dart';
import '../../presentation/pages/home/homePage.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/cadastroPage.dart';
import '../../presentation/pages/inicial/inicialPage.dart';
import '../../presentation/pages/inicial/favoritos_page.dart';
import '../../presentation/pages/perfil/perfilPage.dart';
import '../../presentation/pages/configuracoes/configuracoesPage.dart';
import '../../presentation/pages/auth/forgotPasswordPage.dart';
import '../../presentation/pages/auth/forgotPasswordSucess.dart';
import '../../presentation/pages/inicial/criar_ficha_tecnica.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String inicial = '/inicial';
  static const String favoritos = '/favoritos';
  static const String perfil = '/perfil';
  static const String configuracoes = '/configuracoes';
  static const String forgotPassword = '/forgot-password'; 
  static const String forgotPasswordSuccess = '/forgot-password-success';
  static const String criarFichaTecnica = '/criar-ficha';
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const Homepage(),
      login: (context) => const LoginPage(),
      cadastro: (context) => const CadastroPage(),
      inicial: (context) => const InicialPage(),
      favoritos: (context) => const FavoritosPage(),
      perfil: (context) => const PerfilPage(),
      configuracoes: (context) => const ConfiguracoesPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
      forgotPasswordSuccess: (context) => const ForgotPasswordSuccessPage(),
      criarFichaTecnica: (context) => const CriarFichaTecnica(),
    };
  }
}
