import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'bloc/bloc.dart';

class SavedList extends StatefulWidget {
  @override
  State<SavedList> createState() => _SavedListState();
}

class _SavedListState extends State<SavedList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Saved"),
        ),
        body: _buildList());
  }

  Widget _buildList() {
    return StreamBuilder<Set<WordPair>>(
        stream: bloc.savedStream,
        builder: (context, snapshot) {
          var saved = Set<WordPair>();

          if (snapshot.hasData)
            saved.addAll(saved);
          else
            bloc.addCurrentSaved;

          return ListView.builder(
              itemCount: saved.length * 2,
              itemBuilder: (context, index) {
                if (index.isOdd) return Divider(); //1, 3, 5, 7

                var realIndex = index ~/ 2;

                return _buildRow(saved.toList()[realIndex]); //0, 2, 4, 6, 8
              });
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        textScaleFactor: 1.5,
      ),
      onTap: () {
        bloc.addToOrRemoveFromSavedList(pair);
      },
    );
  }
}
