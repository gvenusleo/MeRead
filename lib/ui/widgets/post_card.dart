import 'package:flutter/material.dart';
import 'package:meread/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            post.title,
            style: TextStyle(
              fontSize: 16,
              color: post.read
                  ? Theme.of(context).colorScheme.outline.withAlpha(150)
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.outline.withAlpha(
                    post.read ? 120 : 255,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                post.feed.value?.title ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary.withAlpha(
                        post.read ? 120 : 255,
                      ),
                ),
              ),
              const Spacer(),
              if (post.favorite)
                Container(
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.bookmark_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary.withAlpha(
                          post.read ? 120 : 255,
                        ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                post.pubDate.toLocal().toString().substring(0, 16),
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary.withAlpha(
                        post.read ? 120 : 255,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
