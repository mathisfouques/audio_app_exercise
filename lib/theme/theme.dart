import 'package:flutter/material.dart';

import 'pp_colors.dart';

export 'pp_typo.dart';
export 'pp_colors.dart';

ThemeData get theme => ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PpColors.dark,
        selectionColor: PpColors.gray,
      ),
    );
