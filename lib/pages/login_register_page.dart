import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pz26082024/admin_sayfasi.dart';
import 'package:pz26082024/service/auth.dart';
import 'user_home_page.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isPasswordVisible = false;
  bool isAdmin = false;
  final TextEditingController adminUsernameController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final String adminUsername = 'admin';
  final String adminPassword = 'admin123';

  bool isLogin = true;
  String? errorMessage;

  Future<void> createUser() async {
    try {
      await Auth().createUser(
        email: emailController.text,
        password: passwordController.text,
      );

      // Kayıt başarılı olduğunda giriş yap
      await signIn();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await Auth().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Giriş başarılı, kullanıcıyı yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserHomePage(), //Kullanıcı ana sayfası
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Giriş başarısız!'; //Hata mesajını göster
      });
      print('Hata: ${e.code} - ${e.message}'); // Hata kodunu konsola yaz
    } catch (e) {
      setState(() {
        errorMessage = 'Bir hata oluştu!'; //genel hata mesajı
      });
      print('Beklenmeyen hata: $e'); //beklenmeyen hatayı konsola yaz
    }
  }

  void handleAdminLogin() {
    String enteredUsername = adminUsernameController.text;
    String enteredPassword = adminPasswordController.text;

    if (enteredUsername == adminUsername && enteredPassword == adminPassword) {
      // Admin girişi başarılı, yönlendirme yapalım
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminSayfasi()),
      );
    } else {
      // Hatalı Giriş Uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçersiz kullanıcı adı veya şifre!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş / Kayıt'),
        backgroundColor: const Color.fromRGBO(178, 136, 0, 1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Giriş Seçenekleri',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Seçim butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAdmin = false; // Üye girişi seçildi
                        });
                      },
                      child: const Text('Üye Girişi'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAdmin = true; // Admin girişi seçildi
                        });
                      },
                      child: const Text('Admin Girişi'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Üye Girişi Formu
                if (!isAdmin)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'KUTSO Üye Girişi',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          if (errorMessage != null) ...[
                            const SizedBox(height: 10),
                            Text(errorMessage!,
                                style: TextStyle(color: Colors.red)),
                          ],
                          ElevatedButton(
                            onPressed: () {
                              signIn();
                            },
                            child: const Text('Üye Girişi Yap'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Admin Girişi Formu
                if (isAdmin)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Admin Girişi',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: adminUsernameController,
                            decoration: InputDecoration(
                              labelText: 'Kullanıcı Adı',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          TextField(
                            controller: adminPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Şifre',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              handleAdminLogin();
                            },
                            child: const Text('Admin Girişi Yap'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
