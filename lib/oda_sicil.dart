import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class OdaSicil extends StatefulWidget {
  const OdaSicil({super.key});

  @override
  _OdaSicilState createState() => _OdaSicilState();
}

class _OdaSicilState extends State<OdaSicil> {
  List<String> odaSicilInfo = [];

  @override
  void initState() {
    super.initState();
    fetchOdaSicilInfo();
  }

  Future<void> fetchOdaSicilInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3556'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        odaSicilInfo = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Oda Sicil info');
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
    return lines
        .where((line) => line.isNotEmpty && !line.contains('reCAPTCHA'))
        .toList();
  }

  bool isHeading(String line) {
    // Başlıkların genellikle tamamen büyük harflerden oluştuğunu varsayıyoruz
    return line == line.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Sicili İşlemleri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (odaSicilInfo.isNotEmpty)
                ...odaSicilInfo.map(
                  (info) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        info,
                        style: TextStyle(
                          fontSize: 16,
                          color: isHeading(info) ? Colors.red : Colors.black,
                          fontWeight: isHeading(info)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
