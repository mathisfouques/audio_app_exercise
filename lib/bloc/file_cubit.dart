import 'package:audio_app_exercise/services/data_store.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/song.dart';
import '../services/file_service.dart';
import '../extension_util.dart';

enum FileStatus {
  initial(false),
  pickingFromDevice(true),
  persistingInStore(true),
  retrievingFromStore(true),
  idle(false),
  error(false);

  const FileStatus(this.isLoading);

  final bool isLoading;
}

class FileState extends Equatable {
  final FileStatus status;
  final Exception? error;
  final List<Song> songs;

  const FileState({
    required this.status,
    this.error,
    this.songs = const [],
  });

  factory FileState.initial() => const FileState(status: FileStatus.initial);

  @override
  List<Object?> get props => [status, error, songs];

  //copyWith method
  FileState copyWith({
    FileStatus? status,
    Exception? error,
    List<Song>? songs,
  }) {
    return FileState(
      status: status ?? this.status,
      error: error ?? this.error,
      songs: songs ?? this.songs,
    );
  }
}

class FileCubit extends Cubit<FileState> {
  final FileService fileService;
  final DataStore store;

  FileCubit(this.fileService, this.store) : super(FileState.initial());

  pickFiles() async {
    if (state.status == FileStatus.pickingFromDevice) return;

    emit(state.copyWith(status: FileStatus.pickingFromDevice));

    final filePaths = await fileService.pickAudioFiles();
    final songs = filePaths.mapToList(Song.fromPath);

    emit(state.copyWith(status: FileStatus.persistingInStore));

    final successSaving = await store.saveSongs(songs);
    if (successSaving) {
      emit(state.copyWith(
        status: FileStatus.idle,
        songs: songs,
      ));
    }
  }

  retrieveSongs() async {
    emit(state.copyWith(status: FileStatus.retrievingFromStore));

    final songs = await store.getAllSongs();

    emit(state.copyWith(
      status: FileStatus.idle,
      songs: songs,
    ));
  }
}
