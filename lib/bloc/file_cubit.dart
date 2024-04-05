import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/file_service.dart';

enum FileStatus { initial, picking, idle, error }

class FileState extends Equatable {
  final FileStatus status;
  final Exception? error;
  final List<String> files;

  const FileState({
    required this.status,
    this.error,
    this.files = const [],
  });

  factory FileState.initial() => const FileState(status: FileStatus.initial);

  @override
  List<Object?> get props => [status, error, files];

  //copyWith method
  FileState copyWith({
    FileStatus? status,
    Exception? error,
    List<String>? files,
  }) {
    return FileState(
      status: status ?? this.status,
      error: error ?? this.error,
      files: files ?? this.files,
    );
  }
}

class FileCubit extends Cubit<FileState> {
  final FileService fileService;

  FileCubit(this.fileService) : super(FileState.initial());

  pickFiles() async {
    if (state.status == FileStatus.picking) return;

    emit(state.copyWith(status: FileStatus.picking));

    final files = await fileService.pickAudioFiles();

    emit(state.copyWith(status: FileStatus.idle, files: files));
  }
}
