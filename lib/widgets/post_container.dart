import 'package:flutter/material.dart';
import 'package:meread/models/post.dart';

/// 用于展示 [Post]
class PostContainer extends StatelessWidget {
  const PostContainer({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (!post.read)
                  Icon(
                    Icons.circle,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                if (post.favorite)
                  Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                Text(
                  post.feedName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  post.pubDate.substring(0, 16),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
