import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../extension_util.dart';

abstract class FileService {
  Future<List<String>> pickAudioFiles({bool allowMultiple = true});
}

class AssetFileServiceImpl implements FileService {
  const AssetFileServiceImpl();

  Future<String> _getAppFileDuplicate(String assetPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile =
        File("${appDir.absolute.path}/${assetPath.split("/").last}");
    await newFile.writeAsBytes(
      (await rootBundle.load(assetPath)).buffer.asUint8List(),
    );
    return newFile.path;
  }

  @override
  Future<List<String>> pickAudioFiles({bool allowMultiple = true}) =>
      Future.wait(
        [
          "assets/Boris Brejcha - Dimension (Original).mp3",
          "assets/Boris Brejcha - Level One (Original).mp3",
          "assets/Boris Brejcha - Universe Of Love (Original).mp3",
          "assets/Herro.mp3",
        ].mapToList(_getAppFileDuplicate),
      );
}

class FileServiceImpl implements FileService {
  const FileServiceImpl();

  static const allowedExtensions = ['mp3', 'wav'];

  /// This function duplicates the file picked from the file picker
  /// to the app's documents directory. It's mandatory on ios because
  /// the file picker returns a temporary file path. And because
  /// we store this path for later use with isar, we need to duplicate.
  /// It's mandatory on iOS, so we copy the behavior for android as well,
  /// to keep the code consistent, and more for convenience.
  Future<String> _getAppFileDuplicate(String pickedFilePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile =
        File("${appDir.absolute.path}/${pickedFilePath.split("/").last}");
    await newFile.writeAsBytes(
      await File(pickedFilePath).readAsBytes(),
    );
    return newFile.path;
  }

  /// Uses the file_picker package to pick audio files.
  /// Duplicates it and returns the path of the duplicated file.
  @override
  Future<List<String>> pickAudioFiles({bool allowMultiple = true}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );
    if (result != null) {
      final files = result.files.where((element) => element.path != null);
      if (files.isNotEmpty) {
        return Future.wait(
          files.map(
            (file) => _getAppFileDuplicate(file.path ?? ""),
          ),
        );
      }
    }
    return [];
  }
}
