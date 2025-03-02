import 'package:budget_bee/di/di_container.dart' as di;
import 'package:budget_bee/view-model/auth_provider.dart';
import 'package:budget_bee/view/screens/authentication/register_screen.dart';
import 'package:budget_bee/view/screens/authentication/welcome_screen.dart';
import 'package:budget_bee/view/screens/business%20logic/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => di.getIt<AuthProvider>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Provider.of<AuthProvider>(context, listen: false).isLoggedIn()
          ? Provider.of<AuthProvider>(context, listen: false).isVerified()
              ? const MainScreen()
              : const RegisterScreen()
          : const WelcomeScreen(),
      debugShowCheckedModeBanner: true,
    );
  }
}
