import 'package:app2m/themes/themes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'provider/my_provider.dart';
import 'screens/splash/splash_screen.dart';



void main() async {

  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyPro(),
      child: Consumer<MyPro>(
        builder: (ctx, val, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TCA',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: val.isDark? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        }
      ),
    );
  }
}