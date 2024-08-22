import 'package:flutter/material.dart';

class SwitchItemCard extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final bool value;
  final Function(bool) onChanged;

  const SwitchItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: title,
      subtitle: subtitle,
      tileColor: Theme.of(context).colorScheme.secondaryContainer.withAlpha(60),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
