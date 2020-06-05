import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup Name Generator",
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[]; // random word collection
  final Set<WordPair> _saved = Set<WordPair>(); // favorite collection
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0); // universal text style for this app

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white); // set status bar color to white
    FlutterStatusbarcolor.setNavigationBarColor(Colors.white); // set navigation bar color to white

    return Scaffold(
      appBar: AppBar(
        title: Text("Random Text Generator"), // app bar title
        elevation: 0.0, // remove shadow from app bar
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved), // set app bar icon and added action
        ],
      ),
      body: _buildSuggestions(), // body full using list view (like recycler view in android native layout)
    );
  }

  // this widget like recycler view adapter, item view xml in android native
  // add data in this widget
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); // show divider lines

        final index = i;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Suggestions"),
            ),
            body: ListView(
              children: divided,
            ),
          );
        },
      ),
    );
  }
}
