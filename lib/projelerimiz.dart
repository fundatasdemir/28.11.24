import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;

class Projelerimiz extends StatefulWidget {
  const Projelerimiz({super.key});

  @override
  _ProjelerimizState createState() => _ProjelerimizState();
}

class _ProjelerimizState extends State<Projelerimiz> {
  List<List<String>> projectInfo = [];

  @override
  void initState() {
    super.initState();
    fetchProjectInfo();
  }

  Future<void> fetchProjectInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/4417'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        projectInfo = parseHtmlTable(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load project info');
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
      tableData.add(rowData);
    }

    return tableData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projelerimiz'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: projectInfo.isNotEmpty
              ? DataTable(
                  columnSpacing: 20.0, // Sütunlar arası boşluk
                  dataRowHeight: 60.0, // Satır yüksekliği
                  columns: projectInfo.first.map((header) {
                    return DataColumn(
                      label: Text(
                        header,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }).toList(),
                  rows: projectInfo.skip(1).map((row) {
                    return DataRow(
                      cells: row.map((cell) {
                        return DataCell(Text(cell));
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
