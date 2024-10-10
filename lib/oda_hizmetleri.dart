import 'package:flutter/material.dart';
import 'package:pz26082024/birlestirme.dart';
import 'package:pz26082024/degisiklikler.dart';
import 'package:pz26082024/yeni_kay%C4%B1t.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bolunme.dart';
import 'dis_ticaret.dart';
import 'fatura.dart';
import 'fiyat_tarife.dart';
import 'hizmet_standartı.dart';
import 'is_makina.dart';
import 'k_belgesi.dart';
import 'kutso_kart.dart';
import 'oda_sicil.dart';
import 'sayisal_tak.dart';
import 'tercume.dart';
import 'hibe_tesvik.dart';
import 'hukuk_musavir.dart';
import 'tur.dart';
import 'turk_mali.dart';
import 'yerli_mali.dart';
import 'kapasite.dart';

class Hizmetlerimiz extends StatelessWidget {
  const Hizmetlerimiz({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hizmetlerimiz'),
        backgroundColor: const Color.fromRGBO(178, 136, 0, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    'Ticaret Sicil',
                    [
                      _buildNavigationButton(
                          context, 'Yeni Kayıt', YeniKayit()),
                      _buildNavigationButton(
                          context, 'Değişiklikler', const Degisiklikler()),
                      _buildNavigationButton(
                          context, 'Birleşme', Birlestirme()),
                      _buildNavigationButton(context, 'Bölünme', Bolunme()),
                      _buildNavigationButton(context, 'Tür Değişikliği', Tur()),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildCard(
                    context,
                    'Oda Sicilleri',
                    [
                      _buildNavigationButton(
                          context, 'Oda Sicili İşlemleri', OdaSicil()),
                      _buildNavigationButton(
                          context, 'Hizmet Standartı', HizmetStandarti()),
                      _buildNavigationButton(
                          context, 'Fiyat Tarifeleri', FiyatTarife()),
                      _buildNavigationButton(
                          context, 'KUTSO Avantaj Kart', KutsoKart()),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    context,
                    'Sanayi ve Ticaret İşlemleri',
                    [
                      _buildNavigationButton(context,
                          'Kapasite,Bilirkişi,Ekspertiz Raporları', Kapasite()),
                      _buildNavigationButton(
                          context, 'İş Makinası Tescili', IsMakina()),
                      _buildNavigationButton(
                          context, 'Yerli Malı', YerliMali()),
                      _buildNavigationButton(
                          context, 'Türk Malı Belgesi', TurkMali()),
                      _buildNavigationButton(
                          context, 'Fatura Tasdiki', Fatura()),
                      _buildNavigationButton(
                          context, 'Dış Ticaret İşlemleri', DisTicaret()),
                      _buildNavigationButton(
                          context, 'K-Belgesi İşlemleri', KBelgesi()),
                      _buildNavigationButton(
                          context, 'Sayısal Takograf İşlemleri', SayisalTak()),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _buildCard(
                    context,
                    'Eğitim & Danışmanlık',
                    [
                      _buildURLButton(context, 'Bilgi Danışmanlık Destek',
                          'https://docs.google.com/forms/d/e/1FAIpQLSfcpXb285Q_Bvh9u5C4pRsYX1k3HgApXcZpP8-XjoALEDkcYQ/viewform?usp=sf_link'),
                      _buildNavigationButton(
                          context, 'Tercüme Hizmeti', Tercume()),
                      _buildNavigationButton(
                          context, 'Hibe & Teşvik Destek', HibeTesvik()),
                      _buildNavigationButton(
                          context, 'Hukuk Müşavirliği Notları', HukukMusavir()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, List<Widget> buttons) {
    return Card(
      color: const Color.fromARGB(255, 216, 218, 221),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.article,
                    color: Color.fromRGBO(178, 136, 0, 1),
                    size: 48.0,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: buttons.map((button) {
                return SizedBox(
                  width: double.infinity,
                  child: button,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(178, 136, 0, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color.fromRGBO(217, 217, 214, 1),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildURLButton(BuildContext context, String title, String url) {
    return GestureDetector(
      onTap: () {
        _launchURL(url);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(178, 136, 0, 1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color.fromRGBO(217, 217, 214, 1),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
