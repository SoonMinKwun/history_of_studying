// ignore: file_names, import_of_legacy_library_into_null_safe
// ignore_for_file: file_names

import 'package:english_words/english_words.dart';
import 'dart:async';

class Bloc {
  final Set<WordPair> saved = <WordPair>{};

  final _savedController = StreamController<Set<WordPair>>.broadcast();

  get savedStream => _savedController.stream;

  get addCurrentSaved => _savedController.sink.add(saved);

  addToOrRemoveFromSavedList(WordPair item) {
    if (saved.contains(item)) {
      saved.remove(item);
    } else {
      saved.add(item);
    }

    _savedController.sink.add(saved);
  }

  dispose() {
    _savedController.close();
  }
}

var bloc = Bloc();
