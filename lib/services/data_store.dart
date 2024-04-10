import 'package:isar/isar.dart';

import '../extension_util.dart';
import '../models/song.dart';
import '../models/isar_database/song_isar.dart';

abstract class DataStore {
  Future<bool> saveSongs(List<Song> songs);
  Future<List<Song>> getAllSongs();
  Future<int> clearStore();
}

class WebFakeDataStore implements DataStore {
  @override
  Future<bool> saveSongs(List<Song> songs) async {
    return true;
  }

  @override
  Future<List<Song>> getAllSongs() async {
    return [];
  }

  @override
  Future<int> clearStore() async {
    return 0;
  }
}
