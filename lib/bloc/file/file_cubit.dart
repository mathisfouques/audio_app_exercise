import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../extension_util.dart';
import '../../models/song.dart';
import '../../services/data_store.dart';
import '../../services/file_service.dart';

enum FileStatus {
  idle,
  pickingFiles,
  persistSongs,
  retrievingSongs,
  deletingSongs,
  failure;
}

class FileState extends Equatable {
  final FileStatus status;
  final List<Song> songs;
  final Exception? exception;

  const FileState(
    this.songs,
    this.status, {
    this.exception,
  });

  @override
  List<Object> get props => [songs, status];

  FileState copyWith({
    List<Song>? songs,
    FileStatus? status,
    Exception? exception,
  }) {
    return FileState(
      songs ?? this.songs,
      status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}

class FileCubit extends Cubit<FileState> {
  final DataStore store;
  final FileService fileService;

  FileCubit({
    required this.fileService,
    required this.store,
  }) : super(const FileState([], FileStatus.idle));

  @override
  close() async {
    await clearStore();

    super.close();
  }

  Future<void> selectFilesAndPersist() async {
    if (state.status != FileStatus.idle) return;

    emit(state.copyWith(status: FileStatus.pickingFiles));

    final paths = await fileService.pickAudioFiles();

    final songs = paths.mapToList(Song.fromPath);
    final addedAndExistingSongs = <Song>{...state.songs, ...songs}.toList();

    emit(FileState(
      addedAndExistingSongs,
      FileStatus.persistSongs,
    ));

    await store.saveSongs(songs);

    emit(state.copyWith(status: FileStatus.idle));
  }

  Future<void> retrieveSongs() async {
    if (state.status != FileStatus.idle) return;

    emit(state.copyWith(status: FileStatus.retrievingSongs));

    final songs = await store.getAllSongs();

    emit(FileState(songs, FileStatus.idle));
  }

  //TODO : Remove, and implemet the feature only for specific ids.
  Future<void> clearStore() async {
    if (state.status != FileStatus.idle) return;

    emit(state.copyWith(status: FileStatus.deletingSongs));

    await store.clearStore();

    emit(state.copyWith(songs: [], status: FileStatus.idle));
  }
}
