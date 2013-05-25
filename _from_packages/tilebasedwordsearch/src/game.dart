part of tilebasedwordsearch;

@observable
class Game extends Observable  {
  final TileSet tileSet = new TileSet();

  static const DIMENSIONS = 4;
  static const Map<String, num> LETTERS =  const {
    'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1,
    'F': 4, 'G': 2, 'H': 4, 'I': 1, 'J': 8,
    'K': 5, 'L': 1, 'M': 3, 'N': 1, 'O': 1,
    'P': 3, 'QU': 10, 'R': 1, 'S': 1, 'T': 1,
    'U': 1, 'V': 4,'W': 4, 'X': 8, 'Y': 4, 'Z': 10};

  dynamic __$grid = new List.generate(4, (_) => new List<String>(4));
  dynamic get grid {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'grid');
    }
    return __$grid;
  }
  set grid(dynamic value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'grid',
          __$grid, value);
    }
    __$grid = value;
  }
  List __$selectedPositions = [];
  List get selectedPositions {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'selectedPositions');
    }
    return __$selectedPositions;
  }
  set selectedPositions(List value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'selectedPositions',
          __$selectedPositions, value);
    }
    __$selectedPositions = value;
  }
  int __$score = 0;
  int get score {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'score');
    }
    return __$score;
  }
  set score(int value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'score',
          __$score, value);
    }
    __$score = value;
  }
  final Dictionary dictionary;
  Set<String> __$words = new Set<String>();
  Set<String> get words {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'words');
    }
    return __$words;
  }
  set words(Set<String> value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'words',
          __$words, value);
    }
    __$words = value;
  }

  final CanvasElement canvas;
  final ImageAtlas letterAtlas;

  GameClock __$gameClock;
  GameClock get gameClock {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'gameClock');
    }
    return __$gameClock;
  }
  set gameClock(GameClock value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'gameClock',
          __$gameClock, value);
    }
    __$gameClock = value;
  }
  BoardView __$board;
  BoardView get board {
    if (__observe.observeReads) {
      __observe.notifyRead(this, __observe.ChangeRecord.FIELD, 'board');
    }
    return __$board;
  }
  set board(BoardView value) {
    if (__observe.hasObservers(this)) {
      __observe.notifyChange(this, __observe.ChangeRecord.FIELD, 'board',
          __$board, value);
    }
    __$board = value;
  }

  String get currentWord {
    return selectedPositions.join('');
 }

  void clearSelectedPositions() {
    selectedPositions = [];
  }

  bool addToSelectedPositions(position) {
    if (selectedPositions.isEmpty || this.validMove(selectedPositions.last, position)) {
      selectedPositions.add(position);
      return true;
    }
    return false;
  }

  bool isPositionSelected(position) {
    bool selected = false;
    for (var i = 0; i < selectedPositions.length; i++) {
      if (selectedPositions[i].first == position.first &&
          selectedPositions[i].last == position.last) {
        selected = true;
        break;
      }
    }
    return selected;
  }
  
  Game(this.dictionary, this.canvas, gameLoop, this.letterAtlas) {
    _assignCharsToPositions();
    board = new BoardView(this, canvas);
    gameClock = new GameClock(gameLoop);
  }
  
  void stop() {
    gameClock.stop();
  }

  void _assignCharsToPositions() {
    int gameId = new Random().nextInt(1000000);
    List<String> selectedLetters = tileSet.getTilesForGame(gameId);
    for (var i = 0; i < DIMENSIONS; i++) {
      for (var j = 0; j < DIMENSIONS; j++) {
        this.grid[i][j] = selectedLetters[i*DIMENSIONS+j];
      }
    }
  }

  // There is no checking that the word has been previously picked or not.
  // All this does is check if every move in a path is legal.
  bool completePathIsValid(path) {
    if (path.length != path.toSet().length) return false;

    var valid = true;
    for (var i = 0; i < path.length - 1; i++) {
      if (!validMove(path[i], path[i + 1])) {
        valid = false;
      }
    }
    return valid;
  }

  // Checks if move from position1 or position2 is legal.
  bool validMove(position1, position2) {
    bool valid = true;

    if (!_vertical(position1, position2) &&
        !_horizontal(position1, position2) &&
        !_diagonal(position1, position2)) {
      valid = false;
    }
    return valid;
  }

  // Args are GameLoopTouchPosition(s).
  bool _vertical(position1, position2) => position1.x == position2.x;

  bool _horizontal(position1, position2) => position1.y == position2.y;

  bool _diagonal(position1, position2) {
    return ((position1.x - position2.y).abs() == 1 &&
        (position1.y - position2.x).abs()) &&
        !(position1.x == position2.x && position1.x == position2.x);
  }

  bool attemptWord(String word) {
    if (words.contains(word)) {
      return false;
    }
    if (_wordIsValid(word)) {
      score += scoreForWord(word);
      print('score = $score');
      words.add(word);
      return true;
    }
    return false;
  }

  int scoreForWord(String word) {
    List<int> scores = word.split('').map(
        (char) => Game.LETTERS[char]).toList();
    return scores.reduce((value, element) => value + element);
  }

  Future get done {
    return gameClock.allDone.future;
  }

  bool _wordIsValid(String word) => dictionary.hasWord(word);
}

//@ sourceMappingURL=game.dart.map