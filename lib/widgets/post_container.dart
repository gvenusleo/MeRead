import 'package:flutter/material.dart';

import '../models/models.dart';

// 定义用于展示 Post 的 Widget
class PostContainer extends StatelessWidget {
  const PostContainer({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 下面一行在 UI 上是多余的，但不加会导致右侧无文字部分点击后无法跳转
      // 原因未知，或为 Flutter 的 bug
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              if (post.read == 0)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              Text(
                post.feedName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                post.pubDate.substring(0, 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}
