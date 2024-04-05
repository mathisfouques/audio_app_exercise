import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:audio_app_exercise/services/file_service.dart';

import 'bloc/file_cubit.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileCubit(const FileServiceImpl()),
      child: const MaterialApp(
        title: 'Material App',
        home: HomeScreen(),
      ),
    );
  }
}
