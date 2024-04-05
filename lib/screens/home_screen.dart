import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/file_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio app'),
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

          if (state.status == FileStatus.picking) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == FileStatus.idle) {
            return ListView.builder(
              itemCount: state.files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.files[index].split('/').last),
                );
              },
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
