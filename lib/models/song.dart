import 'package:equatable/equatable.dart';

import '../extension_util.dart';
import '../services/file_service_io_implementation.dart';

class Song extends Equatable {
  final String path;
  final String title;

  const Song({
    required this.path,
    required this.title,
  });

  @override
  List<Object?> get props => [title];

  @override
  String toString() => 'Song { path: ${path.split('/').last}, title: $title }';

  // TODO : This function should throw if the title is null
  // Or  at least handle this differently
  factory Song.fromPath(String path) {
    String? title;
    final titleWithExtension = path.split('/').last;
    for (final extension in FileServiceImpl.allowedExtensions) {
      if (titleWithExtension.contains(extension)) {
        title = titleWithExtension.split(extension).first.removeLastCharacter();
      }
    }

    return Song(
      path: path,
      title: title ?? "Unknown title",
    );
  }
}
