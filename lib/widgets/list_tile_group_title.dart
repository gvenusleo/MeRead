import 'package:flutter/material.dart';

class ListTileGroupTitle extends StatelessWidget {
  final String title;
  const ListTileGroupTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
