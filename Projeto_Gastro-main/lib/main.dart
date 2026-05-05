import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes/app_routes.dart';
import 'config/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'services/favoritos_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthProvider(); // Initialize auth state

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritosService.instance),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Projeto Gastronomia',
            theme: AppTheme.lightTheme,
            initialRoute: AppRoutes.criarFichaTecnica,
            routes: AppRoutes.getRoutes(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
