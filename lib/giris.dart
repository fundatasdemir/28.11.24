import 'package:flutter/material.dart';
import 'admin_sayfasi.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  bool isAdmin = false; // Admin girişi için durum değişkeni
  final TextEditingController adminUsernameController = TextEditingController();
  final TextEditingController adminPasswordController = TextEditingController();
  final TextEditingController uyeTcController = TextEditingController();
  final TextEditingController uyePasswordController = TextEditingController();

  final String AdminUsername = 'admin';
  final String AdminPassword = 'admin123';

  void girisYap() {
    String girilenuserName = adminUsernameController.text;
    String girilenSifre = adminPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        backgroundColor:
            const Color.fromRGBO(178, 136, 0, 1), // C:0 M:26 Y:100 K:31
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(40, 35, 27, 1), // C:81 M:67 Y:55 K:83
                  ),
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
                    color: const Color.fromRGBO(
                        248, 244, 202, 1), // C:8 M:11 Y:64 K:0
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'KUTSO Üye Girişi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(40, 35, 27, 1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'TC Kimlik Numarası',
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(40, 35, 27, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color.fromRGBO(40, 35, 27, 1)),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(40, 35, 27, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromRGBO(40, 35, 27, 1)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromRGBO(40, 35, 27, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible =
                                        !isPasswordVisible; //şifre görünürlüğünü değiştir
                                  });
                                },
                              ),
                            ),
                            obscureText:
                                !isPasswordVisible, //şifrenin görünürlüğünü ayarla
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Üye Giriş işlemi burada gerçekleştirilebilir
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  178, 136, 0, 1), // C:0 M:26 Y:100 K:31
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: const Text(
                              'Üye Girişi Yap',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(
                                    217, 217, 214, 1), // C:14 M:10 Y:8 K:0
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/resetPassword');
                              // Şifremi unuttum işlemi
                            },
                            child: const Text(
                              'Şifremi Unuttum?',
                              style: TextStyle(
                                color: Color.fromRGBO(
                                    40, 35, 27, 1), // C:81 M:67 Y:55 K:83
                              ),
                            ),
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
                    color: const Color.fromRGBO(
                        248, 244, 202, 1), // C:8 M:11 Y:64 K:0
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Admin Girişi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(40, 35, 27, 1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Kullanıcı Adı',
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(40, 35, 27, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color.fromRGBO(40, 35, 27, 1)),
                            ),
                            keyboardType: TextInputType.text,
                            controller: adminUsernameController,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              labelStyle: const TextStyle(
                                color: Color.fromRGBO(40, 35, 27, 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock,
                                  color: Color.fromRGBO(40, 35, 27, 1)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color.fromRGBO(40, 35, 27, 1),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !isPasswordVisible,
                            controller: adminPasswordController,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Admin Giriş işlemi burada gerçekleştirilebilir
                              String enteredUsername =
                                  adminUsernameController.text;
                              String enteredPassword =
                                  adminPasswordController.text;

                              if (enteredUsername == AdminUsername &&
                                  enteredPassword == AdminPassword) {
                                //Admin girişi başarılı, yönlendirme yapalım
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AdminSayfasi()));
                              } else {
                                //Hatalı Giriş Uyarısı
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Geçersiz kullanıcı adı veya şifre!!'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(
                                  178, 136, 0, 1), // C:0 M:26 Y:100 K:31
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            child: const Text(
                              'Admin Girişi Yap',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(
                                    217, 217, 214, 1), // C:14 M:10 Y:8 K:0
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              // Şifremi unuttum işlemi
                              Navigator.pushNamed(context, '/resetPassword');
                            },
                            child: const Text(
                              'Şifremi Unuttum?',
                              style: TextStyle(
                                color: Color.fromRGBO(
                                    40, 35, 27, 1), // C:81 M:67 Y:55 K:83
                              ),
                            ),
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
