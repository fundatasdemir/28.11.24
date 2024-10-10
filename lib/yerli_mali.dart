import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class YerliMali extends StatefulWidget {
  const YerliMali({super.key});

  @override
  _YerliMaliState createState() => _YerliMaliState();
}

class _YerliMaliState extends State<YerliMali> {
  List<String> yerliMaliInfo = [];

  @override
  void initState() {
    super.initState();
    fetchYerliMaliInfo();
  }

  Future<void> fetchYerliMaliInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3734'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        yerliMaliInfo = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Yerli Mali info');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yerli Malı'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (yerliMaliInfo.isNotEmpty)
                ...yerliMaliInfo.map(
                  (info) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        info,
                        style: const TextStyle(fontSize: 16),
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
