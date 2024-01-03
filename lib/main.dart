import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:softtask/screens/login_screen.dart';
import 'package:softtask/utility/AppColors.dart';
import 'package:softtask/utility/PreferenceUtils.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PreferenceUtils.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.greenColor),
        useMaterial3: true,
      ),
      home: LogInScreen(),
    );
  }
}

