import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HibeTesvik(),
    );
  }
}

class HibeTesvik extends StatefulWidget {
  const HibeTesvik({super.key});

  @override
  _HibeTesvikState createState() => _HibeTesvikState();
}

class _HibeTesvikState extends State<HibeTesvik> {
  List<Map<String, String>> links = [];

  @override
  void initState() {
    super.initState();
    fetchHibeTesvikInfo();
  }

  Future<void> fetchHibeTesvikInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/6030'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        links = extractLinks(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Hibe ve Teşvik info');
    }
  }

  List<Map<String, String>> extractLinks(String htmlString) {
    final document = parser.parse(htmlString);
    List<Map<String, String>> extractedLinks = [];
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
        title: const Text('Hibe & Teşvik Destek'),
      ),
      body: SafeArea(
        child: links.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: links.map((link) {
                  return ListTile(
                    title: Text(
                      link['text'] ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.blue, // Mavi renk
                        decoration: TextDecoration.underline, // Altı çizili
                        fontSize: 16, // Yazı boyutu
                      ),
                    ),
                    onTap: () async {
                      final url = link['url'] ?? '';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // If the URL cannot be launched, show an error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch $url')),
                        );
                      }
                    },
                  );
                }).toList(),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
