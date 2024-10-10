import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class Tercume extends StatefulWidget {
  const Tercume({super.key});

  @override
  _TercumeState createState() => _TercumeState();
}

class _TercumeState extends State<Tercume> {
  List<Widget> tercumeInfo = [];

  @override
  void initState() {
    super.initState();
    fetchTercumeInfo();
  }

  Future<void> fetchTercumeInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/4697'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        tercumeInfo = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Tercüme info');
    }
  }

  List<Widget> parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    List<Widget> widgets = [];
    final lines = document.body!.text.split('\n');
    for (var line in lines) {
      // Başlıkları tespit edip kırmızı renkte ve kalın yap
      if (isHeading(line.trim())) {
        widgets.add(Text(
          line.trim(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red, // Kırmızı rengi burada kullanıyoruz
            fontWeight: FontWeight.bold,
          ),
        ));
      }
      // Numaralı cümleleri tespit et ve kırmızı yap
      else if (RegExp(r'^\d+\.').hasMatch(line.trim())) {
        widgets.add(Text(
          line.trim(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red, // Burada da kırmızı rengi kullanıyoruz
          ),
        ));
      } else {
        widgets.add(Text(
          line.trim(),
          style: const TextStyle(fontSize: 16),
        ));
      }
    }
    return widgets;
  }

  bool isHeading(String line) {
    // Başlıkların genellikle tamamen büyük harflerden oluştuğunu varsayıyoruz
    return line == line.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tercüme Hizmeti'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tercumeInfo,
          ),
        ),
      ),
    );
  }
}
