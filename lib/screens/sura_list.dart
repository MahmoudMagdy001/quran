import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/utlis/text_style.dart';
import 'ayas_list.dart';

class SurahList extends StatefulWidget {
  const SurahList({super.key});

  @override
  _SurahListState createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  List<dynamic> surahs = [];

  Future<dynamic> fetchSurahs() async {
    final response =
        await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final jsonResponse = json.decode(response.body);
      setState(() {
        surahs = jsonResponse['data'];
      });
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'القرأن الكريم',
          style: Styles.textStyle25,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: surahs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    '${surahs[index]['number']} -',
                    style: Styles.textStyle25,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    surahs[index]['englishName'],
                    style: Styles.textStyle23,
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Text(
                      surahs[index]['name'],
                      style: Styles.textStyle25,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AyasList(surahNumber: surahs[index]['number'])),
              );
            },
          );
        },
      ),
    );
  }
}
