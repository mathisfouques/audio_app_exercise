import 'package:flutter/material.dart';

import '../theme/theme.dart';

class DraggableProgressIndicator extends StatelessWidget {
  final void Function(double) onDrag;
  final void Function() onDragEnd;
  final double value;

  const DraggableProgressIndicator({
    super.key,
    required this.onDrag,
    required this.onDragEnd,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8,
        thumbColor: PpColors.dark,
        overlayColor: PpColors.dark.withOpacity(0.5),
        activeTrackColor: PpColors.gray,
        inactiveTrackColor: PpColors.grayBorders,
      ),
      child: Slider(
        value: value,
        onChanged: onDrag,
        onChangeEnd: (value) => onDragEnd(),
      ),
    );
  }
}
