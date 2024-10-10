import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class FiyatTarife extends StatefulWidget {
  const FiyatTarife({super.key});

  @override
  _FiyatTarifeState createState() => _FiyatTarifeState();
}

class _FiyatTarifeState extends State<FiyatTarife> {
  List<Map<String, String>> fiyatTarifeInfo = [];

  @override
  void initState() {
    super.initState();
    fetchFiyatTarifeInfo();
  }

  Future<void> fetchFiyatTarifeInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3820'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        fiyatTarifeInfo = extractLinks(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Fiyat Tarife info');
    }
  }

  List<Map<String, String>> extractLinks(String htmlString) {
    final document = parser.parse(htmlString);
    List<Map<String, String>> extractedLinks = [];

    // Extract text and links
    document.querySelectorAll('a').forEach((element) {
      final url = element.attributes['href'];
      final text = element.text.trim();

      if (url != null && Uri.tryParse(url)?.hasAbsolutePath == true) {
        extractedLinks.add({'url': url, 'text': text.isNotEmpty ? text : url});
      }
    });

    return extractedLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiyat Tarifeleri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fiyatTarifeInfo.isNotEmpty)
                ...fiyatTarifeInfo.map((link) {
                  final url = link['url'] ?? '';
                  final text = link['text'] ?? 'No Title';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                      },
                      child: Text(
                        text,
                        style: TextStyle(
                          color: const Color.fromARGB(
                              255, 162, 16, 16), // Metin rengini kırmızı yap
                          decoration: TextDecoration.underline, // Altı çizili
                          fontSize: 16, // Yazı boyutu
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
