import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/audio/audio_cubit.dart';
import '../models/audio_status.dart';
import '../theme/theme.dart';
import '../widgets/draggable_progress_indicator.dart';
import '../extension_util.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioCubit, AudioState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) {
        if (state.status == AudioStatus.idle || state.currentPlaylist.isEmpty) {
          return const SizedBox();
        }

        final double progress = (state.currentPosition?.inSeconds ?? 0) /
            (state.currentSongDuration?.inSeconds ?? 180);

        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          color: PpColors.grayBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: SafeArea(
            top: false,
            bottom: true,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.currentPlaylist[state.index].title,
                          style: PpTypo.tileHeader,
                          overflow: TextOverflow.ellipsis,
                        ),
                        DraggableProgressIndicator(
                          value: state.changingPosition ?? progress,
                          onDrag: (value) => context
                              .read<AudioCubit>()
                              .userStartedChangingPosition(value),
                          onDragEnd: () => context
                              .read<AudioCubit>()
                              .userEndedPositionChange(),
                        ),
                        Text(
                          state.currentPosition?.toTimeString() ?? '',
                          style: PpTypo.bodySemibold,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (state.status == AudioStatus.idle) {
                        context
                            .read<AudioCubit>()
                            .tappedOnSong(state.currentPlaylist[state.index]);
                      }
                      if (state.status == AudioStatus.paused) {
                        context.read<AudioCubit>().resume();
                      }
                      if (state.status == AudioStatus.running) {
                        context.read<AudioCubit>().pause();
                      }
                    },
                    icon: Icon(
                      state.status == AudioStatus.paused
                          ? Icons.play_arrow
                          : Icons.pause,
                      size: 32,
                      color: PpColors.dark,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
