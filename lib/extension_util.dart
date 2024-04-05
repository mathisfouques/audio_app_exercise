import 'dart:async';

typedef FutureVoidCallback = FutureOr<void> Function();

extension IterableExtension<T> on Iterable<T> {
  bool doesNotContain(T element) => !contains(element);

  List<E> mapToList<E>(E Function(T element) convert) =>
      map(convert).toList(); // Iterable : Map, Set, List.

  List<T> whereToList(bool Function(T element) test) => where(test).toList();
}

extension ListExtension<T> on List<T> {
  List<T> spaced(T element, {bool addLast = false, bool addFirst = false}) {
    final result = <T>[if (addFirst) element];
    for (T t in this) {
      result.add(t);
      result.add(element);
    }
    if (!addLast && isNotEmpty) result.removeLast();

    return result;
  }

  List<T> ifEmptyAdd(T element) => isEmpty ? [element] : this;
}

extension NullableListExtension<T> on List<T>? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  String removeLastCharacter() => substring(0, length - 1);
}

extension DurationExtension on Duration {
  String toTimeString() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');

    return '${inHours > 0 ? '$hours:' : ''}$minutes:$seconds';
  }
}
