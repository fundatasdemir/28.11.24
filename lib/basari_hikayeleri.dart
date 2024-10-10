import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class BasariHikayeleri extends StatefulWidget {
  const BasariHikayeleri({super.key});

  @override
  _BasariHikayeleriState createState() => _BasariHikayeleriState();
}

class _BasariHikayeleriState extends State<BasariHikayeleri> {
  List<String> basariHikayeleriInfo = [];
  List<String> pdfLinks = [];

  @override
  void initState() {
    super.initState();
    fetchBasariHikayeleriInfo();
  }

  Future<void> fetchBasariHikayeleriInfo() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3701'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          basariHikayeleriInfo = parseHtmlString(data['content']['rendered']);
        });
      } else {
        throw Exception(
            'Başarı Hikayeleri bilgileri yüklenemedi. HTTP ${response.statusCode}');
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
        title: const Text('Başarı Hikayeleri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(basariHikayeleriInfo.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        basariHikayeleriInfo[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
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
