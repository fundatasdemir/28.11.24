import 'package:flutter/material.dart';

class AdminSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Paneli'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // Etkinlik ekleme ekranına yönlendirme
                Navigator.pushNamed(context, '/etkinlikEkle');
              },
              child: Text('Etkinlik Ekle'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kullanıcı yönetim ekranına yönlendirme
                Navigator.pushNamed(context, '/kullaniciYonetimi');
              },
              child: Text('Kullanıcı Yönetimi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ayarlar sayfasına yönlendirme
                Navigator.pushNamed(context, '/ayarlar');
              },
              child: Text('Ayarlar'),
            ),
          ],
        ),
      ),
    );
  }
}
