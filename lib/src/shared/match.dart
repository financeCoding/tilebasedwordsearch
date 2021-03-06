part of shared;

class TwoPlayerMatch extends Object with Persistable {
  String board;
  int word_bonus_tile;
  String letter_bonus_tile_indexes;
  
  DateTime created_on;
  String p1_id;
  String p2_id;
  String p1_name;
  String p2_name;
  String p1_words;
  String p2_words;
  int p1_score;
  int p2_score;
  DateTime p1_played;
  DateTime p2_played;
  
  TwoPlayerMatch();
  
  TwoPlayerMatch.fromBoardConfig(BoardConfig boardConfig, this.p1_id, this.p2_id,
      this.p1_name, this.p2_name) {
    board = boardConfig.board;
    word_bonus_tile = boardConfig.wordBonusTileIndex;
    letter_bonus_tile_indexes = boardConfig.letterBonusTileIndexes.join(',');
    created_on = new DateTime.now();
  }
  
  TwoPlayerMatch.fromPersistence(String id, Map data) {
    this.id = id;
    if (data['created_on'] != null) {
      created_on = new DateTime.fromMillisecondsSinceEpoch(data['created_on']);
    }
    board = data['board'];
    p1_id = data['p1_id'];
    p2_id = data['p2_id'];
    p1_name = data['p1_name'];
    p2_name = data['p2_name'];
    p1_words = data['p1_words'];
    p2_words = data['p2_words'];
    p1_score = data['p1_score'];
    p2_score = data['p2_score'];
    
    if (data['p1_played'] != null) {
      p1_played = new DateTime.fromMillisecondsSinceEpoch(data['p1_played']);
    }
    
    if (data['p2_played'] != null) {
      p2_played = new DateTime.fromMillisecondsSinceEpoch(data['p2_played']);
    }
    
    if (data['letter_bonus_tile_indexes'] != null) {
      letter_bonus_tile_indexes = data['letter_bonus_tile_indexes'].join(',');
    }
    
    word_bonus_tile = data['word_bonus_tile'];
  }
  
  List get letterBonusTiles {
    if (letter_bonus_tile_indexes == null) {
      return [];
    } else {
      return letter_bonus_tile_indexes.split(',');
    }
  }
  
  // TODO once mirrors generate small JS, use mirrors here
  Map toJson() {
    return {
      'id': id,
      'board': board,
      'created_on': created_on == null ? null : created_on.millisecondsSinceEpoch,
      'p1_id': p1_id,
      'p2_id': p2_id,
      'p1_name': p1_name,
      'p2_name': p2_name,
      'p1_words': p1_words,
      'p2_words': p2_words,
      'p1_score': p1_score,
      'p2_score': p2_score,
      'p1_played': p1_played == null ? null : p1_played.millisecondsSinceEpoch,
      'p2_played': p2_played == null ? null : p2_played.millisecondsSinceEpoch,
      'word_bonus_tile': word_bonus_tile,
      'letter_bonus_tile_indexes': letter_bonus_tile_indexes == null ? [] : letter_bonus_tile_indexes.split(',')
    };
  }
  
  String toString() => toJson().toString();
}
