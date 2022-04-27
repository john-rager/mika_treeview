import 'package:flutter/material.dart';

class ToggleText extends StatelessWidget {
  const ToggleText({
    Key? key,
    required this.text,
    this.value = false,
    required this.onChanged,
    this.style,
  }) : super(key: key);

  final String text;
  final bool value;
  final TextStyle? style;
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
