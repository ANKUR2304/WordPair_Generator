import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _likedWordPairs = Set<WordPair>();
  // One Row
  Widget _buildRow(WordPair pair) {
    final alreadyLiked = _likedWordPairs.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(alreadyLiked ? Icons.favorite : Icons.favorite_border,
          color: alreadyLiked ? Colors.red : null),
      onTap: () {
        setState(() {
          if (alreadyLiked) {
            _likedWordPairs.remove(pair);
          } else {
            _likedWordPairs.add(pair);
          }
        });
      },
    );
  }

  void _pushLiked() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _likedWordPairs.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: TextStyle(fontSize: 16.0),
          ),
        );
      });

      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
          appBar: AppBar(title: Text('Liked WordPairs')),
          body: ListView(
            children: divided,
          ));
    }));
  }

  // One List
  Widget build(BuildContext context) {
    Widget _buildList() {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          if (item.isOdd) return Divider();

          final index = item ~/ 2;
          if (index >= _randomWordPairs.length) {
            _randomWordPairs.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPairs[index]);
        },
      );
    }

    // Final UI, which has an AppBar and a ListView
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPair Generator'),
          actions: <Widget>[
            IconButton(onPressed: _pushLiked, icon: Icon(Icons.list))
          ],
        ),
        body: _buildList());
  }
}
