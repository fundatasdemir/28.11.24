import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class IsMakina extends StatefulWidget {
  const IsMakina({super.key});

  @override
  _IsMakinaState createState() => _IsMakinaState();
}

class _IsMakinaState extends State<IsMakina> {
  List<Widget> isMakinaWidgets = [];

  @override
  void initState() {
    super.initState();
    fetchIsMakinaInfo();
  }

  Future<void> fetchIsMakinaInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3732'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        isMakinaWidgets = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load İş Makina info');
    }
  }

  List<Widget> parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    List<Widget> widgets = [];

    // Başlıkları (strong etiketleri) kırmızı renkli yapma
    document.querySelectorAll('strong').forEach((element) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          element.text.trim(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.red, // Kırmızı renk
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    });

    // Diğer metinleri standart renk ve stil ile yapma
    document.querySelectorAll('p').forEach((element) {
      String text = element.text.trim();
      if (text.isNotEmpty &&
          !element.querySelector('strong')!.innerHtml.isNotEmpty) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black, // Siyah renk
            ),
          ),
        ));
      }
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İş Makinası Tescili'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isMakinaWidgets,
          ),
        ),
      ),
    );
  }
}
