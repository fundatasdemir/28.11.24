import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class TurkMali extends StatefulWidget {
  const TurkMali({super.key});

  @override
  _TurkMaliState createState() => _TurkMaliState();
}

class _TurkMaliState extends State<TurkMali> {
  List<Widget> turkMaliWidgets = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchTurkMaliInfo();
  }

  Future<void> fetchTurkMaliInfo() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/3736'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          turkMaliWidgets = parseHtmlString(data['content']['rendered']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Veriler yüklenirken bir sorun oluştu. Lütfen daha sonra tekrar deneyin.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage =
            'Bir hata oluştu: $e. Lütfen internet bağlantınızı kontrol edin.';
        isLoading = false;
      });
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
    final color = _getColorForElement(element.localName);

    if (fontSize != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          element.text.trim(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      );
    }

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

    return SizedBox.shrink();
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

  Color _getColorForElement(String? localName) {
    if (localName != null && localName.startsWith('h')) {
      return Colors.red;
    }
    return Colors.black;
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu bağlantıyı açmak mümkün olmadı: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Türk Malı Belgesi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isLoading
                ? [const Center(child: CircularProgressIndicator())]
                : errorMessage.isNotEmpty
                    ? [
                        Text(errorMessage,
                            style: const TextStyle(color: Colors.red))
                      ]
                    : turkMaliWidgets,
          ),
        ),
      ),
    );
  }
}
