import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class SayisalTak extends StatefulWidget {
  const SayisalTak({super.key});

  @override
  _SayisalTakState createState() => _SayisalTakState();
}

class _SayisalTakState extends State<SayisalTak> {
  List<Widget> sayisalTakWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchSayisalTakInfo();
  }

  Future<void> fetchSayisalTakInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3553'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        sayisalTakWidgets = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Sayısal Tak info');
    }
  }

  List<Widget> parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    List<Widget> widgets = [];
    document
        .querySelectorAll('h1, h2, h3, h4, h5, h6, p, a')
        .forEach((element) {
      widgets.add(_buildWidgetForElement(element));
    });

    return widgets;
  }

  Widget _buildWidgetForElement(dom.Element element) {
    final fontSize = _getFontSizeForElement(element.localName);

    if (element.localName == 'a') {
      final href = element.attributes['href'];
      if (href != null && href.startsWith('http')) {
        // Bağlantı için widget oluştur
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
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
        );
      }
    } else if (fontSize != null) {
      // Başlık için widget oluştur
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          element.text.trim(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
    } else if (element.localName == 'p') {
      // Paragraf için widget oluştur
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          element.text.trim(),
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return SizedBox
        .shrink(); // Tanımlanmamış bir element türü için boş bir widget döner
  }

  double? _getFontSizeForElement(String? localName) {
    switch (localName) {
      case 'h1':
        return 24.0;
      case 'h2':
        return 20.0;
      case 'h3':
        return 18.0;
      case 'h4':
        return 16.0;
      case 'h5':
        return 14.0;
      case 'h6':
        return 12.0;
      default:
        return null; // Bilinmeyen veya desteklenmeyen başlık türleri için null döner
    }
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
        title: const Text('Sayısal Takograf İşlemleri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sayisalTakWidgets,
          ),
        ),
      ),
    );
  }
}
