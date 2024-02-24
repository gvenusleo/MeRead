import 'package:flutter/material.dart';
import 'package:meread/ui/widgets/item_card.dart';

class SlideItemCard extends StatefulWidget {
  final String title;
  final String? description;
  final double value;
  final double minValue;
  final double maxValue;
  final int divisions;
  final Function(double) afterChange;
  final int stringFixed;

  const SlideItemCard({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.divisions,
    required this.afterChange,
    this.stringFixed = 2,
  });

  @override
  State<SlideItemCard> createState() => _SlideItemCardState();
}

class _SlideItemCardState extends State<SlideItemCard> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      title: widget.title,
      description: widget.description,
      item: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 64,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _value.toStringAsFixed(widget.stringFixed).padLeft(2, '0'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: Slider(
                value: _value,
                min: widget.minValue,
                max: widget.maxValue,
                divisions: widget.divisions,
                label: _value.toStringAsFixed(widget.stringFixed),
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                  widget.afterChange(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
