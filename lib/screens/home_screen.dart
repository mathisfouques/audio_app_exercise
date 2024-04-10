import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart';

import '../bloc/audio/audio_cubit.dart';
import '../bloc/file/file_cubit.dart';
import '../extension_util.dart';
import '../models/audio_status.dart';
import '../models/song.dart';
import '../theme/theme.dart';
import 'player_view.dart';
import 'song_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: PpColors.white,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Audio player'),
              actions: [
                IconButton(
                  onPressed: () =>
                      context.read<FileCubit>().selectFilesAndPersist(),
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => context.read<FileCubit>().clearStore(),
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<FileCubit, FileState>(
                    listenWhen: (previous, current) =>
                        current.status == FileStatus.idle,
                    listener: (context, fileState) =>
                        context.read<AudioCubit>().addSongs(fileState.songs),
                    builder: (context, state) {
                      if (state.status == FileStatus.failure) {
                        return Center(child: Text('Error: ${state.exception}'));
                      }
                      if (state.status == FileStatus.idle) {
                        return SongListView(
                          songs: state.songs,
                          onRefresh: () =>
                              context.read<FileCubit>().retrieveSongs(),
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                const PlayerView(),
              ],
            )),
      ),
    );
  }
}
