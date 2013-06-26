library persistable_html;

import 'dart:async';
import 'package:lawndart/lawndart.dart';
import 'package:logging/logging.dart';

final Logger log = new Logger("persistence");

// TODO: one store per type
Store _store;

Future init(String dbName, String storeName) {
  _store = new Store(dbName, storeName);
  return _store.open();
}

int _counter = 0;
final String _idOffset = new DateTime.now().millisecondsSinceEpoch.toString();

typedef Persistable Constructor(String id, Map data);

/**
 * See also the mirror-based implementation at persistable_html_mirrors.dart
 */
abstract class Persistable {
  
  String _dbId;
  
  /**
   * 
   */
  static Future load(String id, Constructor constructor) {
    return _store.getByKey(id).then((Map data) {
      if (data == null) {
        return null;
      } else {
        return _createAndPopulate(constructor, id, data);
      }
    });
  }
  
  static Stream all(Constructor constructor) {
    return _store.all().map((Map data) {
      return _createAndPopulate(constructor, data['dbId'], data);
    });
  }
  
  Future store() {
    return _store.save(toJson(), dbId);
  }
  
  Future delete() {
    return _store.removeByKey(dbId);
  }
  
  static Future clear() {
    return _store.nuke();
  }
  
  static _createAndPopulate(Constructor constructor, String id, Map data) {
    Persistable object = constructor(id, data);
    return object;
  }
  
  // This assumes there's no reason for code to change an ID.
  String get dbId {
    if (_dbId == null) {
      _dbId = _idOffset + '-' + (_counter++).toString();
    }
    return _dbId;
  }
  
  void set dbId(String id) { _dbId = id; }
  
  Map toJson();
}
