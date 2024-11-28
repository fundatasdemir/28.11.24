import 'package:pz26082024/birlestirme.dart';
import 'package:pz26082024/bolunme.dart';
import 'package:pz26082024/projelerimiz.dart';
import 'package:pz26082024/iletisim.dart';
import 'meclis_uyeleri.dart';
import 'oda_hizmetleri.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'online_islemler.dart';
import 'pages/login_register_page.dart';

class AnaEkran extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  const AnaEkran({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KUTSO"),
        backgroundColor: Colors.grey,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Birlestirme()),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Bolunme()),
                );
              } else if (value == 3) {}
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("seçim"),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text("Seçim2"),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 320,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/kutso.1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    backgroundColor: Colors.black45,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    title: const Text('Giriş Yap'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginRegisterPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('İletişim'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Iletisim()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("Seçenek 1"),
                    onTap: () {
                      // İşlemler burada yapılacak
                    },
                  ),
                  ListTile(
                    title: const Text("Seçenek 2"),
                    onTap: () {
                      //İşlemler burada yapılacak
                    },
                  ),
                  ListTile(
                    title: const Text("Seçenek 3"),
                    onTap: () {
                      //İşlemler burada yapılacak
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.4, // %40 olarak ayarlandı
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/arka_plan.png'),
                fit: BoxFit.contain, // Resmin tam olarak görünmesi için
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16.0),
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: <Widget>[
                buildMenuItem(
                    context, 'Giriş yap', Icons.login, LoginRegisterPage()),
                buildMenuItem(context, 'Online İşlemler',
                    Icons.online_prediction, const OnlineIslemlerEkrani()),
                buildMenuItem(context, 'Oda Hizmetleri', Icons.business_center,
                    const Hizmetlerimiz()),
                buildMenuItem(
                    context, 'Uyeler', Icons.group, const MeclisUyeleri()),
                buildMenuItem(context, 'Projelerimiz', Icons.assignment,
                    const Projelerimiz()),
                buildMenuItem(
                    context, 'İletişim', Icons.contact_mail, const Iletisim()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(
      BuildContext context, String title, IconData icon, Widget? screen,
      {bool isUrl = false, String? url}) {
    return Card(
      color: const Color.fromRGBO(
          248, 244, 202, 1), // Background color: C:8 M:11 Y:64 K:0
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: InkWell(
        onTap: () {
          if (isUrl && url != null) {
            _launchURL(url);
          } else if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon,
                size: 40.0,
                color: const Color.fromRGBO(
                    81, 67, 55, 1)), // Icon color: C:81 M:67 Y:55 K:83
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: Color.fromRGBO(
                    81, 67, 55, 1), // Text color: C:81 M:67 Y:55 K:83
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
