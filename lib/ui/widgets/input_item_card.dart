import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meread/ui/widgets/item_card.dart';

class InputItemCard extends StatelessWidget {
  final String title;
  final String? description;
  final TextEditingController controller;
  final bool inputEnabled;
  final Function()? inputOnTap;
  final TextInputType? keyboardType;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChanged;

  const InputItemCard({
    super.key,
    required this.title,
    this.description,
    required this.controller,
    this.inputEnabled = true,
    this.inputOnTap,
    this.keyboardType,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      title: title,
      description: description,
      item: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: onChanged,
        enabled: inputEnabled,
        onTap: inputOnTap,
      ),
    );
  }
}
