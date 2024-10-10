import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class DisTicaret extends StatefulWidget {
  const DisTicaret({super.key});

  @override
  _DisTicaretState createState() => _DisTicaretState();
}

class _DisTicaretState extends State<DisTicaret> {
  List<Widget> disTicaretWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchDisTicaretInfo();
  }

  Future<void> fetchDisTicaretInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3522'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        disTicaretWidgets = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Dış Ticaret info');
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

    if (fontSize == null) {
      if (element.localName == 'a') {
        final href = element.attributes['href'];
        if (href != null && href.startsWith('http')) {
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
      }
      // For elements without a specific style, return them as plain text
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          element.text.trim(),
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    switch (element.localName) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
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
      case 'p':
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            element.text.trim(),
            style: const TextStyle(fontSize: 16),
          ),
        );
      default:
        return SizedBox
            .shrink(); // For undefined elements, return an empty widget
    }
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
        return null;
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
        title: const Text('Dış Ticaret İşlemleri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: disTicaretWidgets.isEmpty
                ? [
                    const Center(
                        child: Text('Yükleniyor...',
                            style: TextStyle(fontSize: 16)))
                  ]
                : disTicaretWidgets,
          ),
        ),
      ),
    );
  }
}
