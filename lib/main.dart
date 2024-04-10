import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/audio/audio_cubit.dart';
import 'bloc/file/file_cubit.dart';
import 'models/isar_database/song_isar.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/data_store.dart';
import 'services/file_service.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.mfqscode.the_perfect_player',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SongIsarSchema],
    directory: dir.path,
  );

  runApp(MyApp(
    isarInstance: isar,
  ));
}

class MyApp extends StatelessWidget {
  final Isar isarInstance;

  const MyApp({
    super.key,
    required this.isarInstance,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FileCubit>(
          create: (context) => FileCubit(
            // fileService: const FileServiceImpl(),
            fileService: const AssetFileServiceImpl(),
            store: IsarDataStore(isarInstance: isarInstance),
          ),
        ),
        BlocProvider(
          create: (context) => AudioCubit(
            AudioServiceImpl(AudioPlayer()),
          ),
        ),
      ],
      child: const MaterialApp(
        color: PpColors.white,
        title: 'Material App',
        home: HomeScreen(),
      ),
    );
  }
}
