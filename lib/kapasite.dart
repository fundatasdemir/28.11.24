import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class Kapasite extends StatefulWidget {
  const Kapasite({super.key});

  @override
  _KapasiteState createState() => _KapasiteState();
}

class _KapasiteState extends State<Kapasite> {
  List<Widget> kapasiteWidgets = [];
  Map<String, String> pdfLinks = {};

  @override
  void initState() {
    super.initState();
    fetchKapasiteInfo();
  }

  Future<void> fetchKapasiteInfo() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3730'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          kapasiteWidgets = parseHtmlString(data['content']['rendered']);
        });
      } else {
        throw Exception('Failed to load Kapasite info');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        kapasiteWidgets = [Text('Failed to load data.')];
      });
    }
  }

  List<Widget> parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    // PDF links
    pdfLinks = {};
    final links = document.querySelectorAll('a[href]');
    for (var element in links) {
      final href = element.attributes['href'];
      final text = element.text.toLowerCase();
      if (href != null &&
          (href.endsWith('.pdf') ||
              text.contains('dilekçe') ||
              text.contains('genel kurul') ||
              text.contains('şirket genel kurul'))) {
        final fullUrl = Uri.parse(href).isAbsolute
            ? href
            : 'https://www.kutso.org.tr/$href';
        pdfLinks[text] = fullUrl;
      }
    }

    // Convert HTML content to widgets
    List<Widget> widgets = [];
    for (var element in document.body!.children) {
      if (element.localName == 'h1') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              element.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Başlıkları kırmızı yap
              ),
            ),
          ),
        );
      } else if (element.localName == 'h2') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              element.text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Başlıkları kırmızı yap
              ),
            ),
          ),
        );
      } else if (element.localName == 'p') {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                final url = pdfLinks.entries
                    .firstWhere(
                      (entry) => element.text.toLowerCase().contains(entry.key),
                      orElse: () => const MapEntry('', ''),
                    )
                    .value;
                if (url.isNotEmpty) {
                  _openPDF(url);
                }
              },
              child: Text(
                element.text,
                style: TextStyle(
                  fontSize: 16,
                  color: pdfLinks.keys.any(
                          (key) => element.text.toLowerCase().contains(key))
                      ? Colors.blue
                      : Colors.black,
                  decoration: pdfLinks.keys.any(
                          (key) => element.text.toLowerCase().contains(key))
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Future<void> _openPDF(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kapasite, Bilirkişi, Ekspertiz Raporları'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: kapasiteWidgets,
          ),
        ),
      ),
    );
  }
}
