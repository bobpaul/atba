import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String readableTime(int seconds) {
  if (seconds <= 0) return "∞";
  final int days = seconds ~/ 86400;
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int secs = seconds % 60;
  if (seconds == 8640000) {
    return "∞"; // 100 days
  } else if (days > 0) {
    return '${days}d ${hours % 24}h';
  } else if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else if (minutes > 0) {
    return '${minutes}m ${secs}s';
  } else {
    return '${secs}s';
  }
}

String formatTimeDifference(Duration duration) {
  if (duration.inDays > 0) {
    return '${duration.inDays}d';
  } else if (duration.inHours > 0) {
    return '${duration.inHours}h';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m';
  } else {
    return '${duration.inSeconds}s';
  }
}

String getReadableSize(int size) {
  if (size < 1000) {
    return '$size B';
  } else if (size < 1000 * 1000) {
    return '${(size / 1000).toStringAsPrecision(3)} KB';
  } else if (size < 1000 * 1000 * 1000) {
    return '${(size / (1000 * 1000)).toStringAsPrecision(3)} MB';
  } else {
    return '${(size / (1000 * 1000 * 1000)).toStringAsPrecision(3)} GB';
  }
}

// configure a FocusNode for keyboard navigation for text fields (eg: TV D-pad)
void configureTVInputNavigation({
  required BuildContext context,
  required FocusNode focusNode,
  required TextEditingController controller,
}) {
  focusNode.onKeyEvent = (FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Up/Down Arrow keys exit text box focus
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      bool moved = FocusScope.of(
        context,
      ).focusInDirection(TraversalDirection.up);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      bool moved = FocusScope.of(
        context,
      ).focusInDirection(TraversalDirection.down);
      return KeyEventResult.handled;
    }

    // Right Arrow key moves cursor, then exits text field
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final String text = controller.text;
      final int cursorPosition = controller.selection.baseOffset;

      if (cursorPosition >= text.length) {
        bool moved = FocusScope.of(
          context,
        ).focusInDirection(TraversalDirection.right);
        if (!moved) {
          FocusScope.of(context).focusInDirection(TraversalDirection.down);
        }
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  };
}
