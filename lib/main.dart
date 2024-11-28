import 'package:flutter/material.dart';
import 'ana_ekran.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_register_page.dart';

void main() async {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KUTSO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnaEkran(
        onThemeChanged: (newThemeMode) {},
      ), //Anaekranı burada çağırıyoruz
    );
  }
}
