import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';

import '../models/audio_status.dart';

abstract class AudioService {
  Future<void> play();
  Future<Duration?> setSingleAudioFile(String path);
  Future<void> pause();
  Future<void> resume();
  Stream<AudioStatus> get audioStatusStream;
  Stream<Duration> get positionStream;
  Future<void> changePosition(Duration position);
  Future<void> dispose();
}

class AudioServiceImpl implements AudioService {
  final AudioPlayer player;

  const AudioServiceImpl(this.player);

  @override
  Future<void> dispose() async {
    await player.dispose();
  }

  @override
  Future<Duration?> setSingleAudioFile(String path) async {
    final itExists = await File(path).exists();

    Logger().i(itExists
        ? "File exists ✅ Setting audio source to: $path, and playing..."
        : "File does not exists...");

    if (itExists) {
      final duration = await player.setAudioSource(AudioSource.file(
        path,
        tag: MediaItem(
          id: path,
          title: path.split('/').last,
        ),
      ));
      // await player.setFilePath(path);

      return duration;
    } else {
      throw Exception("File does not exists...");
    }
  }

  @override
  Future<void> play() async {
    player.play();
  }

  @override
  pause() async {
    await player.pause();
  }

  @override
  resume() async {
    await player.play();
  }

  @override
  Stream<Duration> get positionStream => player.positionStream;

  @override
  Stream<AudioStatus> get audioStatusStream =>
      player.playerStateStream.map((state) {
        if (state.processingState == ProcessingState.completed) {
          return AudioStatus.completed;
        }
        if (state.processingState == ProcessingState.idle) {
          return AudioStatus.idle;
        }

        if (state.playing) {
          return AudioStatus.running;
        } else {
          return AudioStatus.paused;
        }
      });

  @override
  Future<void> changePosition(Duration position) async {
    await player.seek(position);
  }
}
