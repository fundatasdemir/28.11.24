import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class KutsoKart extends StatefulWidget {
  const KutsoKart({super.key});

  @override
  _KutsoKartState createState() => _KutsoKartState();
}

class _KutsoKartState extends State<KutsoKart> {
  List<Widget> contentWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchKutsoKartInfo();
  }

  Future<void> fetchKutsoKartInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/16673'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        final htmlString = data['content']['rendered'];
        final document = parser.parse(htmlString);
        contentWidgets = parseContent(document);
      });
    } else {
      throw Exception('Failed to load Kutso Kart info');
    }
  }

  List<Widget> parseContent(document) {
    List<Widget> widgets = [];
    var sections = document.querySelectorAll('h1, h2, h3, p, a, img');

    for (var element in sections) {
      switch (element.localName) {
        case 'h1':
        case 'h2':
        case 'h3':
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                element.text.trim(),
                style: TextStyle(
                  fontSize: element.localName == 'h1'
                      ? 24
                      : element.localName == 'h2'
                          ? 20
                          : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Başlıkları kırmızı yapmak için
                ),
              ),
            ),
          );
          break;
        case 'p':
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                element.text.trim(),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          );
          break;
        case 'a':
          final href = element.attributes['href'];
          if (href != null) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: InkWell(
                  onTap: () => _launchURL(href),
                  child: Text(
                    element.text.trim(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            );
          }
          break;
        case 'img':
          final src = element.attributes['src'];
          if (src != null) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.network(src),
              ),
            );
          }
          break;
      }
    }

    return widgets;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
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
        title: const Text('KUTSO Avantaj Kart'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: contentWidgets,
          ),
        ),
      ),
    );
  }
}
