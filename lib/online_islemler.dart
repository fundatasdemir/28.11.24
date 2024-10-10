import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineIslemlerEkrani extends StatelessWidget {
  const OnlineIslemlerEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online İşlemler'),
        backgroundColor:
            const Color.fromRGBO(178, 136, 0, 1), // C:0 M:26 Y:100 K:31
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildCard(
                    icon: Icons.cloud_download,
                    title: 'E-BELGE',
                    description:
                        'Elektronik Belge Dağıtım Sistemi, Odamızda hayata geçirilmiş olup, Üyelerimiz diledikleri yerden 7/24 e-imzalı belge talep ederek dakikalar içinde sistem üzerinden e-imzalı belgelerini almakla beraber aidat sorgulaması ve ödemesi yapabileceklerdir.',
                    url: 'https://uye.tobb.org.tr/organizasyon/firma-index.jsp',
                    backgroundColor: const Color.fromRGBO(
                        220, 220, 220, 1), // C:8 M:11 Y:64 K:0
                  ),
                  const SizedBox(
                      width: 16), // Kartlar arasındaki boşluğu artırdık
                  _buildCard(
                    icon: Icons.attach_money,
                    title: 'HIZLI ONLINE TAHSİLAT',
                    description:
                        'Aidat borçlarınızı üyelik gerektirmeden Oda Sicil Numaranız ve Vergi Numaranız ile sorgulamanızı aynı zamanda Kredi Kartı ile ödeme imkanı sunan hızlı ödeme ekranlarımız.',
                    url: 'https://uye.tobb.org.tr/hizliaidatodeme.jsp',
                    backgroundColor: const Color.fromRGBO(
                        220, 220, 220, 1), // C:81 M:67 Y:55 K:83
                  ),
                  const SizedBox(width: 16),
                  _buildCard(
                    icon: Icons.account_circle,
                    title: 'E-ODA',
                    description:
                        'Organ üyelerimizin kullanıcı adı ve şifre ile girebildikleri alandır.',
                    url:
                        'https://eoda.kutso.org.tr/out/out.Login.php?referuri=%2Fout%2Fout.ViewFolder.php',
                    backgroundColor: const Color.fromRGBO(
                        220, 220, 220, 1), // C:14 M:10 Y:8 K:0
                  ),
                ],
              ),
              const SizedBox(
                  height: 32), // Kartların altındaki boşluğu artırdık
              const Text(
                'Sayın Üyemiz,\n\nAidatlarınızı odamızda kredi kartı ile tahsil edilebilmekte olup, banka hesaplarımıza da yatırılabilmektedir.\nBanka hesaplarımıza isimsiz yatırılan tutarlardan kaynaklanan hak kayıplarından, odamız sorumlu değildir.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Table(
                border: TableBorder.all(),
                children: [
                  _buildTableRow(['SIRA NO', 'BANKA ŞUBESİ', 'IBAN NO'],
                      isHeader: true),
                  _buildTableRow([
                    '1',
                    'T.C. ZİRAAT BANKASI KÜTAHYA ŞUBESİ',
                    'TR53 0001 0001 7935 0645 1050 01'
                  ]),
                  _buildTableRow([
                    '2',
                    'T. GARANTİ BANKASI A.Ş. KÜTAHYA ŞUBESİ',
                    'TR79 0006 2000 4880 0006 2997 25'
                  ]),
                  _buildTableRow([
                    '3',
                    'YAPI VE KREDİ BANKASI A.Ş. KÜTAHYA ŞUBESİ',
                    'TR75 0006 7010 0000 0072 5232 23'
                  ]),
                  _buildTableRow([
                    '4',
                    'T. HALK BANKASI A.Ş. KÜTAHYA ŞUBESİ',
                    'TR70 0001 2009 5270 0016 0001 45'
                  ]),
                  _buildTableRow([
                    '5',
                    'T. İŞ BANKASI A.Ş. KÜTAHYA ŞUBESİ',
                    'TR51 0006 4000 0014 6000 0003 89'
                  ]),
                  _buildTableRow([
                    '6',
                    'T. VAKIFLAR BANKASI A.O. KÜTAHYA ŞUBESİ',
                    'TR86 0001 5001 5800 7287 8157 80'
                  ]),
                  _buildTableRow([
                    '7',
                    'DENİZBANK A.Ş. KÜTAHYA ŞUBESİ',
                    'TR19 0013 4000 0036 2094 5000 01'
                  ]),
                  _buildTableRow([
                    '8',
                    'ZİRAAT KATILIM A.Ş. KÜT.ŞUB.',
                    'TR36 0020 9000 0114 1863 0000 01'
                  ]),
                  _buildTableRow([
                    '9',
                    'VAKIF KATILIM BANKASI A.Ş. KÜT.ŞUB.',
                    'TR67 0021 0000 0010 2217 2000 01'
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: isHeader ? Colors.black : Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required String url,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: 300, // Kartların genişliği
      height: 400, // Kartların yüksekliği
      child: Card(
        color: backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundColor:
                    const Color.fromRGBO(178, 136, 0, 1), // C:0 M:26 Y:100 K:31
                radius: 30,
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _launchURL(url);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(
                      178, 136, 0, 1), // C:0 M:26 Y:100 K:31
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'BELGE OLUŞTUR',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(217, 217, 214, 1),
                  ),
                ),
              ),
            ],
          ),
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
