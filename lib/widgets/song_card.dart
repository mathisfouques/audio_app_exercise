import 'package:flutter/material.dart';

import '../models/song.dart';
import '../theme/theme.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onPressed;
  final bool isSelected;

  const SongCard({
    super.key,
    required this.song,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        tileColor: isSelected ? PpColors.grayBorders : null,
        title: Text(
          song.title,
          style: PpTypo.cardButtonText,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onPressed,
      );
}
