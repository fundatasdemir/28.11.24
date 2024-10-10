import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: unused_import
//import 'ihracat.dart';
import 'basari_hikayeleri.dart';

class MeclisUyeleri extends StatelessWidget {
  const MeclisUyeleri({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üyelerimiz'),
        backgroundColor: const Color.fromRGBO(178, 136, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Daha fazla boşluk eklendi
        child: Column(
          children: [
            _buildRow(context, 0, 3),
            _buildRow(context, 3, 6),
            _buildRow(context, 6, 9),
            _buildRow(context, 9, 12),
            _buildRow(context, 12, _items.length),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int startIndex, int endIndex) {
    if (startIndex >= _items.length) return const SizedBox.shrink();

    final itemCount = endIndex - startIndex;
    final adjustedEndIndex =
        endIndex > _items.length ? _items.length : endIndex;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Kutular arası boşluk eklendi
      children: List.generate(itemCount, (index) {
        final itemIndex = startIndex + index;
        if (itemIndex < adjustedEndIndex) {
          final item = _items[itemIndex];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                  8.0), // Kutuların etrafında daha fazla boşluk
              child: _buildButton(
                context: context, // context parametresi eklendi
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                url: item['url'] as String,
                navigateToPage: item[
                    'navigateToPage'], // navigateToPage parametresi eklendi
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String url,
    Widget? navigateToPage, // navigateToPage parametresi eklendi
  }) {
    return InkWell(
      onTap: () {
        if (navigateToPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => navigateToPage),
          );
        } else {
          _launchUrl(url);
        }
      },
      child: Container(
        height: 130, // Kutu yüksekliği artırıldı
        decoration: BoxDecoration(
          color: const Color.fromRGBO(200, 200, 200, 1),
          borderRadius: BorderRadius.circular(12.0), // Köşe yuvarlama
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 48.0,
                color: const Color.fromRGBO(178, 136, 0, 1),
              ), // İkon boyutu büyütüldü
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0, // Yazı boyutu artırıldı
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

const List<Map<String, dynamic>> _items = [
  {
    'icon': Icons.person,
    'title': 'Üye Arama',
    'url': 'https://ub.tobb.org.tr/firmasorgula',
  },
  {
    'icon': Icons.analytics,
    'title': 'Bilgi Güncelleme',
    'url':
        'https://docs.google.com/forms/d/e/1FAIpQLSfaCntmESxcZFqH2bt3CnnBE86p1aGLNKL8S8J-KzYyGP01rA/viewform?usp=sf_link',
  },
  {
    'icon': Icons.public,
    'title': 'Online Üye Şikayet Formu',
    'url':
        'https://docs.google.com/forms/d/e/1FAIpQLSdRYvEBcNW02nsgs0edPePtirNjHdvRB8kw-l3S5w2otm4fpg/viewform',
  },
  {
    'icon': Icons.insert_chart,
    'title': 'Üye Görüş Öneri Formu',
    'url':
        'https://docs.google.com/forms/d/e/1FAIpQLSfDrOiu4T5omd9auPD_toQWDdvMLORqXqjpLJhF176vVC3wcA/viewform?usp=sf_link',
  },
  /*{
    'icon': Icons.flag,
    'title': 'İhracat Yapan Üyelerimiz',
    'url': '', // URL boş bırakıldı
    'navigateToPage': Ihracat(), // IhracatPage'e yönlendirme eklendi
  },*/
  {
    'icon': Icons.monetization_on,
    'title': 'Başarı Hikayeleri',
    'url': '',
    'navigateToPage': BasariHikayeleri(),
  },
];
