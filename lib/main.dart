import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DogApp());
}

class DogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informacion Perruna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DogPage(),
    );
  }
}

class DogPage extends StatefulWidget {
  @override
  _DogPageState createState() => _DogPageState();
}

class _DogPageState extends State<DogPage> {
  late Future<Map<String, dynamic>> _dogInfo;

  @override
  void initState() {
    super.initState();
    _dogInfo = _fetchDogInfo();
  }

  Future<Map<String, dynamic>> _fetchDogInfo() async {
    final response = await http.get(
      Uri.parse('https://api.thedogapi.com/v1/breeds/5'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dog info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion Perruna'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Informacion Perruna',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _dogInfo,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DogInfoWidget(dogInfo: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DogInfoWidget extends StatelessWidget {
  final Map<String, dynamic> dogInfo;

  DogInfoWidget({required this.dogInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          child: Image.network(
            'https://i.ibb.co/2FRHjBB/perro-Blanco.jpg',
            fit: BoxFit.contain,
          ),
        ),
        Text('Nombre: ${dogInfo['name']}'),
        Text('Altura: ${dogInfo['height']['imperial']}'),
        Text('Masa: ${dogInfo['weight']['imperial']}'),
        Text('Temperamento: ${dogInfo['temperament']}'),
      ],
    );
  }
}


