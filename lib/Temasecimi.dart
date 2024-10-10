import 'package:flutter/material.dart';
import 'ana_ekran.dart';

class Temasecimi extends StatefulWidget {
  const Temasecimi({super.key, required Function(ThemeMode p1) onThemeChanged});

  @override
  State<Temasecimi> createState() => _TemasecimiState();
}

class _TemasecimiState extends State<Temasecimi> {
  ThemeMode _themeMode = ThemeMode.light; //Varsayılan olarak açık tema

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tema Seçimi',
      theme: ThemeData.light(), //Açık Tema
      darkTheme: ThemeData.dark(), // Karanlık tema
      themeMode: _themeMode, //Dinamik olarak tema değişikliği
      home: AnaEkran(
        onThemeChanged: (newThemeMode) {
          setState(() {
            _themeMode = newThemeMode;
          });
        },
      ),
    );
  }
}
