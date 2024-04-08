import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/audio_status.dart';
import '../models/song.dart';
import '../services/audio_service.dart';

class AudioState extends Equatable {
  final bool isPlaying;
  final Song? currentSong;
  final AudioStatus status;

  const AudioState({
    required this.isPlaying,
    this.currentSong,
    this.status = AudioStatus.idle,
  });

  factory AudioState.initial() => const AudioState(
      isPlaying: false, status: AudioStatus.idle, currentSong: null);

  @override
  List<Object?> get props => [isPlaying, currentSong, status];

  AudioState copyWith({
    bool? isPlaying,
    Song? currentSong,
    AudioStatus? status,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentSong: currentSong ?? this.currentSong,
      status: status ?? this.status,
    );
  }
}

class AudioCubit extends Cubit<AudioState> {
  final AudioService audioService;

  StreamSubscription<AudioStatus>? _statusSubscription;

  AudioCubit(this.audioService) : super(AudioState.initial()) {
    _statusSubscription = audioService.audioStatusStream.listen(_statusChanged);
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }

  // void addSongs(List<Song> songs) {
  //   if (state.currentPlaylist.length > songs.length) return;
  //   emit(state.copyWith(
  //     currentPlaylist: songs,
  //     index: state.index == -1 ? 0 : state.index,
  //     currentSong: state.currentSong ?? songs.first,
  //   ));
  // }

  void _statusChanged(AudioStatus status) {
    // if (state.currentPlaylist.isEmpty) return;

    // if (status == AudioStatus.completed) {
    //   final nextIndex = (state.index + 1) % state.currentPlaylist.length;
    //   _play(state.currentPlaylist[nextIndex]);
    // }

    emit(state.copyWith(status: status));
  }

  Future<void> tappedOnSong(Song song) async {
    if (state.currentSong == song && state.status != AudioStatus.idle) {
      if (state.status == AudioStatus.running) {
        await pause();
      } else {
        await resume();
      }
    } else {
      await _play(song);
    }
  }

  Future<void> _play(Song song) async {
    // final duration =
    await audioService.setSingleAudioFile(song.path);

    emit(state.copyWith(
        // index: state.currentPlaylist.indexWhere((element) => element == song),
        // currentSongDuration: duration,
        currentSong: song,
        isPlaying: true
        // changingPosition: null,
        ));

    audioService.play();
  }

  Future<void> pause() async {
    if (state.status != AudioStatus.running) return;
    audioService.pause();
  }

  Future<void> resume() async {
    if (state.status != AudioStatus.paused) return;
    audioService.resume();
  }
}