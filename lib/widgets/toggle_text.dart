import 'package:flutter/material.dart';

/// A text widget that can be toggled "on" or "off" to indicate selection.
///
/// Provide your text, an initial toggle value (optional), and an [onChanged]
/// handler, to render a text widget that responds to a tap to indicate
/// whether it has been selected. This widget honors the theme of the context.
class ToggleText extends StatelessWidget {
  const ToggleText({
    Key? key,
    required this.text,
    this.value = false,
    required this.onChanged,
    this.style,
  }) : super(key: key);

  /// The text to display in the widget.
  final String text;

  /// Initial toggle value (optional, defaults to false).
  final bool value;

  /// If non-null, the style to use for this text.
  final TextStyle? style;

  /// A handler function that is passed the toggle value when the widget
  /// is tapped.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: (value)
          ? Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                border: Border.all(
                  color: theme.primaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Text(
                text,
                style: style?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            )
          : Text(text, style: style),
    );
  }
}
