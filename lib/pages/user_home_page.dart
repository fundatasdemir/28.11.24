import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth üzerinden mevcut kullanıcı bilgilerini al
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: const Color.fromRGBO(178, 136, 0, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Kullanıcı çıkış yapma işlemi
              FirebaseAuth.instance.signOut();
              Navigator.pop(context); // Giriş sayfasına geri dön
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hoş Geldin!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Merhaba, ${user?.email ?? 'kullanıcı'}',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Uygulamanın diğer bölümlerine yönlendirme yap
                },
                child: const Text('Ayarlar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
