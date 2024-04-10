import 'dart:async';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

import '../../models/audio_status.dart';
import '../../models/song.dart';
import '../../services/audio_service.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  final AudioService audioService;

  StreamSubscription<AudioStatus>? _audioStatusSubscription;
  StreamSubscription<Duration>? _positionSubscription;

  AudioCubit(this.audioService) : super(AudioState.initial()) {
    _audioStatusSubscription =
        audioService.audioStatusStream.listen(_statusChanged);
    _positionSubscription =
        audioService.positionStream.listen(_positionChangedFromPlayer);
  }

  @override
  close() async {
    _audioStatusSubscription?.cancel();
    _positionSubscription?.cancel();
    await audioService.dispose();

    super.close();
  }

  void _positionChangedFromPlayer(Duration position) {
    if (state.changingPosition != null) return;

    if (state.currentPosition != null) {
      final differenceWithCurrent =
          (state.currentPosition!.inMilliseconds - position.inMilliseconds)
              .abs();

      if (differenceWithCurrent < 500) return;
    }

    emit(state.copyWith(currentPosition: position));
  }

  void _statusChanged(AudioStatus status) {
    if (state.currentPlaylist.isEmpty) return;

    if (status == AudioStatus.completed) {
      final nextIndex = (state.index + 1) % state.currentPlaylist.length;
      _play(state.currentPlaylist[nextIndex]);
    }

    emit(state.copyWith(status: status));
  }

  void userStartedChangingPosition(double start) {
    emit(state.copyWith(changingPosition: start));
  }

  Future<void> userEndedPositionChange() async {
    final changingPositionEnd = state.changingPosition ??
        state.currentPosition?.inSeconds.toDouble() ??
        0.0;
    final currentDuration = state.currentSongDuration?.inSeconds ?? 0;
    final currentPosition = Duration(
      seconds: (changingPositionEnd * currentDuration).toInt(),
    );

    await audioService.changePosition(currentPosition);

    emit(state.copyWith(
      changingPosition: null,
      currentPosition: currentPosition,
    ));
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

  void addSongs(List<Song> songs) {
    if (state.currentPlaylist.length > songs.length) return;
    emit(state.copyWith(
      currentPlaylist: songs,
      index: state.index == -1 ? 0 : state.index,
      currentSong: state.currentSong ?? songs.first,
    ));
  }

  Future<void> _play(Song song) async {
    final duration = await audioService.setSingleAudioFile(song.path);

    print("Called");

    emit(state.copyWith(
      index: state.currentPlaylist.indexWhere((element) => element == song),
      currentSongDuration: duration,
      currentSong: song,
      changingPosition: null,
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
