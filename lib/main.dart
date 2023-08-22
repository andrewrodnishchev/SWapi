import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Character {
  final String name;
  final String gender;
  final String birthYear;

  Character({
    required this.name,
    required this.gender,
    required this.birthYear,
  });
}

Future<List<Character>> fetchCharacters() async {
  final response = await http.get(Uri.parse('https://swapi.dev/api/people/'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final characters = (data['results'] as List)
        .map((characterData) => Character(
      name: characterData['name'],
      gender: characterData['gender'],
      birthYear: characterData['birth_year'],
    ))
        .toList();

    return characters;
  } else {
    throw Exception('Failed to load characters');
  }
}

void fetchData(BuildContext context) async {
  final characters = await fetchCharacters();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Star Wars Characters'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: characters.map((character) {
              return ListTile(
                title: Text(character.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: ${character.gender}'),
                    Text('Birth Year: ${character.birthYear}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
        backgroundColor: Colors.black,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Color(0xFF000000),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<Character> characters = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final fetchedCharacters = await fetchCharacters();
    setState(() {
      characters = fetchedCharacters;
    });
  }

  void search(String query) {
    final filteredCharacters = characters.where((character) {
      return character.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Results'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: filteredCharacters.map((character) {
                return ListTile(
                  title: Text(character.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender: ${character.gender}'),
                      Text('Birth Year: ${character.birthYear}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Star Wars Wiki',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'STARWARSTTF',
              fontSize: 30,// Укажите имя вашего шрифта здесь
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/169627-joda-grogu-mandalorec_2_sezon-zvezdnye_vojny-voda-1080x1920.jpg'),
            // Путь к вашему ресурсу
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to the Star Wars Wiki App!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'STARWARSTTF',
                  ),
                ),
              ),
              SizedBox(height: 20),
          Container(
            width: 300, // Установите желаемую ширину
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0), // Установите нужные значения отступов

                ),style: TextStyle(fontSize: 10.0),
                maxLines: 1, // Устанавливаем максимальную высоту в 1 строку

              ),
          ),
              ElevatedButton(
                onPressed: () {
                  final query = searchController.text.trim();
                  if (query.length >= 2) {
                    search(query);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Search Error'),
                          content: Text(
                              'Search query must be at least 2 characters long.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                          backgroundColor: Colors.black,
                        );
                      },
                    );
                  }
                },
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}