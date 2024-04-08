import 'package:audio_app_exercise/bloc/file_cubit.dart';
import 'package:audio_app_exercise/services/file_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_file_service.dart';

void main() {
  // getApplicationsDocumentsdirectory calls Flutter
  // That means that we can't use it in a test environment
  // Must create a fake.
  group(
    "File cubit tests : ",
    () {
      const files = [
        "assets/Boris Brejcha - Dimension (Original).mp3",
        "assets/Boris Brejcha - Level One (Original).mp3",
        "assets/Boris Brejcha - Universe Of Love (Original).mp3",
        "assets/Herro.mp3",
      ];
      final FileService fileService = FakeFileService();

      blocTest<FileCubit, FileState>(
        'Given initial emits [MyState] when pickFiles is called.',
        build: () => FileCubit(fileService),
        act: (cubit) => cubit.pickFiles(),
        expect: () => <FileState>[
          const FileState(status: FileStatus.picking),
          const FileState(status: FileStatus.idle, songs: files),
        ],
      );
    },
  );
}
