import 'package:isar/isar.dart';

import '../extension_util.dart';
import '../models/song.dart';
import '../models/isar_database/song_isar.dart';
import 'data_store.dart';

class IsarDataStore implements DataStore {
  final Isar isarInstance;

  const IsarDataStore({
    required this.isarInstance,
  });

  @override
  Future<List<Song>> getAllSongs() async {
    final songs = await isarInstance.songIsars.where().findAll();
    return songs.mapToList((e) => Song.fromPath(e.path));
  }

  @override
  Future<bool> saveSongs(List<Song> songs) async {
    final isarSongs = (await _filterAllreadyStoredSongs(songs)).mapToList(
      (song) => SongIsar()
        ..path = song.path
        ..title = song.title,
    );

    await isarInstance.writeTxn(() => isarInstance.songIsars.putAll(isarSongs));

    return true;
  }

  Future<List<Song>> _filterAllreadyStoredSongs(List<Song> songs) async {
    final allSongs = await getAllSongs();
    return songs.whereToList((element) => allSongs.doesNotContain(element));
  }

  @override
  Future<int> clearStore() =>
      isarInstance.writeTxn(() => isarInstance.songIsars.where().deleteAll());
}
