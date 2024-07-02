import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meread/models/category.dart';
import 'package:meread/models/feed.dart';

class FeedPanel extends StatefulWidget {
  final Category category;
  final Function() categoryOnTap;
  final Function(Feed feed) feedOnTap;

  const FeedPanel({
    super.key,
    required this.category,
    required this.categoryOnTap,
    required this.feedOnTap,
  });

  @override
  State<FeedPanel> createState() => _FeedPanelState();
}

class _FeedPanelState extends State<FeedPanel> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
            title: Text(
              widget.category.name,
              style: const TextStyle(fontSize: 16),
            ),
            contentPadding: const EdgeInsets.all(0),
            onTap: () => widget.categoryOnTap(),
            dense: true,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (child, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: child,
              );
            },
            child: _expanded
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Get.theme.colorScheme.secondaryContainer
                          .withAlpha(100),
                    ),
                    child: Column(
                      children: widget.category.feeds
                          .map((feed) => ListTile(
                                title: Text(feed.title),
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                onTap: () => widget.feedOnTap(feed),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
