import 'package:flutter/material.dart';
import 'ana_ekran.dart';
import 'giris.dart';
import 'admin_sayfasi.dart';

void main() {
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
