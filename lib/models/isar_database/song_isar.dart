import 'package:isar/isar.dart';

part 'song_isar.g.dart';

@collection
class SongIsar {
  final id = Isar.autoIncrement;
  late String path;
  String? title;
  String? artist;
}
