import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utlis/text_style.dart';

class AyasList extends StatefulWidget {
  final int surahNumber;

  const AyasList({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _AyasListState createState() => _AyasListState();
}

class _AyasListState extends State<AyasList> {
  dynamic surah;

  Future<dynamic> fetchSurah() async {
    final response = await http.get(
        Uri.parse('http://api.alquran.cloud/v1/surah/${widget.surahNumber}'));
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      final jsonResponse = json.decode(response.body);
      setState(() {
        surah = jsonResponse['data'];
      });
    } else {
      throw Exception('Failed to load surah');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSurah();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          surah != null ? surah['name'] : '',
          style: Styles.textStyle25,
        ),
        centerTitle: true,
      ),
      body: surah != null
          ? ListView.builder(
              itemCount: surah['ayahs'].length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surah['ayahs'][index]['numberInSurah']}',
                        style: Styles.textStyle18,
                        textAlign: TextAlign.right,
                      ),
                      Expanded(
                        child: Text(
                          surah['ayahs'][index]['text'],
                          style: Styles.textStyle28,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
