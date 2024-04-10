part of 'audio_cubit.dart';

class AudioState extends Equatable {
  final List<Song> currentPlaylist;
  final Song? currentSong;
  final int index;
  final AudioStatus status;
  final Duration? currentPosition;
  final double? changingPosition;
  final Duration? currentSongDuration;

  const AudioState({
    required this.currentPlaylist,
    required this.index,
    required this.currentSong,
    required this.status,
    this.currentPosition,
    this.currentSongDuration,
    this.changingPosition,
  });

  factory AudioState.initial() {
    return const AudioState(
      currentPlaylist: [],
      currentSong: null,
      index: -1,
      status: AudioStatus.idle,
      currentPosition: null,
      currentSongDuration: null,
      changingPosition: null,
    );
  }

  @override
  List<Object?> get props => [
        index,
        currentPlaylist,
        currentSong,
        status,
        currentPosition,
        currentSongDuration,
        changingPosition
      ];

  AudioState copyWith({
    List<Song>? currentPlaylist,
    Song? currentSong,
    int? index,
    AudioStatus? status,
    Duration? currentPosition,
    Duration? currentSongDuration,
    double? changingPosition,
  }) {
    return AudioState(
      currentSong: currentSong ?? this.currentSong,
      currentPlaylist: currentPlaylist ?? this.currentPlaylist,
      index: index ?? this.index,
      status: status ?? this.status,
      currentPosition: currentPosition ?? this.currentPosition,
      currentSongDuration: currentSongDuration ?? this.currentSongDuration,
      changingPosition: changingPosition,

      /// Interesting
    );
  }

  @override
  String toString() {
    return 'AudioState(son: $currentSong, $index, playlist length: ${currentPlaylist.length}, status: $status, changingPosition: $changingPosition, currentPosition: $currentPosition, wholeDuration: $currentSongDuration)';
  }
}
