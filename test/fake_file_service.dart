import 'package:audio_app_exercise/services/file_service.dart';

class FakeFileService implements FileService {
  bool pickFilesWasCalled = false;

  FakeFileService({
    this.pickFilesWasCalled = false,
  });

  @override
  Future<List<String>> pickAudioFiles({bool allowMultiple = true}) async {
    pickFilesWasCalled = true;

    return [
      "assets/Boris Brejcha - Dimension (Original).mp3",
      "assets/Boris Brejcha - Level One (Original).mp3",
      "assets/Boris Brejcha - Universe Of Love (Original).mp3",
      "assets/Herro.mp3",
    ];
  }
}
