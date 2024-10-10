import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

class HukukMusavir extends StatefulWidget {
  const HukukMusavir({super.key});

  @override
  _HukukMusavirState createState() => _HukukMusavirState();
}

class _HukukMusavirState extends State<HukukMusavir> {
  List<List<String>> hukukMusavirInfo = [];
  List<String> pdfLinks = [];

  @override
  void initState() {
    super.initState();
    fetchHukukMusavirInfo();
  }

  Future<void> fetchHukukMusavirInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/5144'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        hukukMusavirInfo = parseHtmlTable(data['content']['rendered']);
        pdfLinks = extractPdfLinks(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load Hukuk Müşavirlik info');
    }
  }

  List<List<String>> parseHtmlTable(String htmlString) {
    final document = parser.parse(htmlString);
    document.querySelectorAll('style, script, link').forEach((element) {
      element.remove();
    });

    List<List<String>> tableData = [];
    var rows = document.querySelectorAll('tr');

    for (var row in rows) {
      List<String> rowData = [];
      var cells = row.querySelectorAll('td, th');

      for (var cell in cells) {
        rowData.add(cell.text.trim());
      }
      if (rowData.isNotEmpty) {
        tableData.add(rowData);
      }
    }

    return tableData;
  }

  List<String> extractPdfLinks(String htmlString) {
    final document = parser.parse(htmlString);
    List<String> pdfUrls = [];

    document.querySelectorAll('a[href]').forEach((element) {
      final href = element.attributes['href'];
      if (href != null && href.endsWith('.pdf')) {
        pdfUrls.add(href);
      }
    });

    return pdfUrls;
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hukuk Müşavirliği Notları'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: hukukMusavirInfo.isNotEmpty
              ? DataTable(
                  columnSpacing: 20.0,
                  dataRowHeight: 60.0,
                  columns: hukukMusavirInfo.isNotEmpty
                      ? hukukMusavirInfo.first.map((header) {
                          return DataColumn(
                            label: Text(
                              header,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          );
                        }).toList()
                      : [],
                  rows: hukukMusavirInfo.skip(1).map((row) {
                    return DataRow(
                      cells: row.map((cell) {
                        int index = hukukMusavirInfo.indexOf(row) - 1;
                        return DataCell(
                          Row(
                            children: [
                              Expanded(
                                child: Text(cell),
                              ),
                              if (index < pdfLinks.length && cell.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.picture_as_pdf),
                                  onPressed: () {
                                    _launchURL(pdfLinks[index]);
                                  },
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
