// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:cineroye/theme/palette.dart';

@immutable
class ProjectionDay {
  final bool selected;
  final Color currentColor;

  const ProjectionDay({
    required this.selected,
    required this.currentColor,
  });

  ProjectionDay.initial()
      : selected = false,
        currentColor = greyColor.withOpacity(0.62);

  @override
  String toString() =>
      'ProjectionTime(selected: $selected, currentColor: $currentColor)';

  @override
  int get hashCode => selected.hashCode ^ currentColor.hashCode;

  @override
  bool operator ==(covariant ProjectionDay other) {
    if (identical(this, other)) return true;

    return other.selected == selected && other.currentColor == currentColor;
  }

  ProjectionDay copyWith({
    bool? selected,
    Color? currentColor,
  }) {
    return ProjectionDay(
      selected: selected ?? this.selected,
      currentColor: currentColor ?? this.currentColor,
    );
  }
}
