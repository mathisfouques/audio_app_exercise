import 'package:audio_app_exercise/models/isar_database/song_isar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:audio_app_exercise/services/file_service.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/file_cubit.dart';
import 'screens/home_screen.dart';
import 'services/data_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SongIsarSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  const MyApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileCubit(
          const AssetFileServiceImpl(), IsarDataStore(isarInstance: isar)),
      child: const MaterialApp(
        title: 'Material App',
        home: HomeScreen(),
      ),
    );
  }
}
