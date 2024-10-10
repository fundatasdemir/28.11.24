/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class Ihracat extends StatefulWidget {
  const Ihracat({super.key});

  @override
  _IhracatState createState() => _IhracatState();
}

class _IhracatState extends State<Ihracat> {
  List<String> ihracatInfo = [];
  List<String> pdfLinks = [];

  @override
  void initState() {
    super.initState();
    fetchIhracatInfo();
  }

  Future<void> fetchIhracatInfo() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3699'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          ihracatInfo = parseHtmlString(data['content']['rendered']);
        });
      } else {
        throw Exception(
            'İhracat bilgileri yüklenemedi. HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  List<String> parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    List<String> lines =
        document.body?.text.split('\n').map((line) => line.trim()).toList() ??
            [];

    // PDF linklerini bulma
    pdfLinks = document
        .querySelectorAll('a[href]')
        .map((element) {
          final href = element.attributes['href'];
          if (href != null && href.endsWith('.pdf')) {
            return Uri.parse(href).isAbsolute
                ? href
                : 'https://www.kutso.org.tr/$href';
          }
          return '';
        })
        .where((link) => link.isNotEmpty)
        .toList();

    return lines
        .where((line) => line.isNotEmpty && !line.contains('reCAPTCHA'))
        .toList();
  }

  Future<void> openPdf(String url) async {
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
        title: const Text('İhracat Bilgileri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(ihracatInfo.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ihracatInfo[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (index < pdfLinks.length)
                      ElevatedButton(
                        onPressed: () => openPdf(pdfLinks[index]),
                        child: const Text('PDF Aç'),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
*/
