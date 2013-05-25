library tilebasedwordsearch;

import 'dart:math';
import 'dart:html';
import 'dart:async';
import 'package:game_loop/game_loop_html.dart';
import 'package:asset_pack/asset_pack.dart';
import 'package:web_ui/web_ui.dart';


import 'package:web_ui/observe/observable.dart' as __observe;
part '../../../packages/tilebasedwordsearch/src/board_view.dart';
part 'src/game.dart';
part 'src/game_clock.dart';
part '../../../packages/tilebasedwordsearch/src/dictionary.dart';
part '../../../packages/tilebasedwordsearch/src/rectangle_transform.dart';
part '../../../packages/tilebasedwordsearch/src/image_atlas.dart';
part '../../../packages/tilebasedwordsearch/src/game_score.dart';
part '../../../packages/tilebasedwordsearch/src/tile_set.dart';

AssetManager assetManager = new AssetManager();
Dictionary dictionary;
ImageAtlas letterAtlas;

final __changes = new __observe.Observable();

String __$currentPanel = 'main';
String get currentPanel {
  if (__observe.observeReads) {
    __observe.notifyRead(__changes, __observe.ChangeRecord.FIELD, 'currentPanel');
  }
  return __$currentPanel;
}
set currentPanel(String value) {
  if (__observe.hasObservers(__changes)) {
    __observe.notifyChange(__changes, __observe.ChangeRecord.FIELD, 'currentPanel',
        __$currentPanel, value);
  }
  __$currentPanel = value;
}

void parseAssets() {
  if (assetManager['game.dictionary'] == null) {
    throw new StateError("Can't play without a dictionary.");
  }
  dictionary = new Dictionary.fromFile(assetManager['game.dictionary']);

  var letterTileImage = assetManager['game.tile-letters'];
  if (letterTileImage == null) {
    throw(new StateError('Can\'t play without tile images.'));
  }

  letterAtlas = new ImageAtlas(letterTileImage);
  final int letterRow = 5;
  final int lettersPerRow = 6;
  final int letterWidth = 70;
  List<String> letters = [ 'A', 'B', 'C', 'D', 'E', 'F',
                           'G', 'H', 'I', 'J', 'K', 'L',
                           'M', 'N', '~N', 'O', 'P', 'Q',
                           'QU', 'R', 'rr', 'S', 'T', 'U',
                           'V', 'W', 'X', 'Y', 'Z', ' '];
  for (int i = 0; i < letterRow; i++) {
    for (int j = 0; j < lettersPerRow; j++) {
      int index = (i * lettersPerRow) + j;
      int x = j * letterWidth;
      int y = i * letterWidth;
      letterAtlas.addElement(letters[index], x, y, letterWidth, letterWidth);
    }
  }
}

Future initialize() {
  assetManager.loaders['image'] = new ImageLoader();
  assetManager.importers['image'] = new NoopImporter();

  print('Touch events supported? ${TouchEvent.supported}');

  return assetManager.loadPack('game', 'assets/_.pack')
      .then((_) => parseAssets());
}
//@ sourceMappingURL=tilebasedwordsearch.dart.map