import 'package:audio_app_exercise/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../bloc/audio_cubit.dart';
import '../bloc/file_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio app'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<FileCubit>().pickFiles();
            },
          ),
        ],
      ),
      body: BlocBuilder<FileCubit, FileState>(
        builder: (context, state) {
          if (state.status == FileStatus.initial) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<FileCubit>().pickFiles();
                },
                child: const Text('Pick files'),
              ),
            );
          }

          if (state.status.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == FileStatus.idle) {
            return RefreshIndicator(
              onRefresh: () => context.read<FileCubit>().retrieveSongs(),
              child: ListView.builder(
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.songs[index].title),
                    onTap: () {
                      context
                          .read<AudioCubit>()
                          .tappedOnSong(state.songs[index]);
                    },
                  );
                },
              ),
            );
          }

          return Center(
            child: Text('An error occurred : ${state.error}'),
          );
        },
      ),
    );
  }
}
