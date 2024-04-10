import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../bloc/audio/audio_cubit.dart';
import '../extension_util.dart';
import '../models/song.dart';
import '../widgets/song_card.dart';

class SongListView extends StatelessWidget {
  final List<Song> songs;
  final FutureVoidCallback onRefresh;

  const SongListView({
    super.key,
    required this.songs,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator.adaptive(
        onRefresh: () async => await onRefresh(),
        child: ListView(
          children: songs
              .mapToList<Widget>(
                (song) => SongCard(
                  song: song,
                  isSelected: context.select<AudioCubit, bool>(
                      (value) => value.state.currentSong == song),
                  onPressed: () =>
                      context.read<AudioCubit>().tappedOnSong(song),
                ),
              )
              .spaced(const Gap(8)),
        ),
      ),
    );
  }
}
