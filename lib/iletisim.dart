import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as parser;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class Iletisim extends StatefulWidget {
  const Iletisim({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IletisimState createState() => _IletisimState();
}

class _IletisimState extends State<Iletisim> {
  List<String> contactInfo = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContactInfo();
  }

  Future<void> fetchContactInfo() async {
    final response = await http
        .get(Uri.parse('https://www.kutso.org.tr/wp-json/wp/v2/pages/1167'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        contactInfo = parseHtmlString(data['content']['rendered']);
      });
    } else {
      throw Exception('Failed to load contact info');
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  Future<void> sendEmail() async {
    final Email email = Email(
      body:
          'Name: ${_nameController.text}\nEmail: ${_emailController.text}\nSubject: ${_subjectController.text}\nMessage: ${_messageController.text}',
      subject: _subjectController.text,
      recipients: [
        'far.durak@hotmail.com'
      ], // Gönderilmesini istediğiniz mail adresi
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sent successfully!')),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send email: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İletişim'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (contactInfo.isNotEmpty)
                ...contactInfo.map(
                  (info) {
                    List<String> splitLine = info.split(':');
                    if (splitLine.length > 1) {
                      final contactDetail =
                          splitLine.sublist(1).join(':').trim();
                      final isEmail = contactDetail.contains('@');
                      final isPhone =
                          RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(contactDetail);
                      final isAddress = !isEmail && !isPhone;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '${splitLine[0]}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: contactDetail,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    if (isEmail) {
                                      _launchUrl('mailto:$contactDetail');
                                    } else if (isPhone) {
                                      _launchUrl('tel:$contactDetail');
                                    } else if (isAddress) {
                                      _launchUrl(
                                          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(contactDetail)}');
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          info,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }
                  },
                ),
              const SizedBox(height: 20),
              const Text(
                'Bize Ulaşın',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Adınız *'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-Mail *'),
              ),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Konu *'),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: 'Mesajınız *'),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: sendEmail,
                child: const Text('Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
