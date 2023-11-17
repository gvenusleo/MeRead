import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:meread/models/feed.dart';
import 'package:meread/utils/notification_util.dart';
import 'package:meread/widgets/list_tile_group_title.dart';

class EditFeedPage extends StatefulWidget {
  const EditFeedPage({
    super.key,
    required this.feed,
    this.needLeading = true,
    this.fromAddPage = false,
  });

  final Feed feed;
  final bool needLeading;
  final bool fromAddPage;

  @override
  EditFeedPageState createState() => EditFeedPageState();
}

class EditFeedPageState extends State<EditFeedPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.feed.url;
    _nameController.text = widget.feed.name;
    _categoryController.text = widget.feed.category;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return buildScaffold();
    } else {
      if (widget.fromAddPage) {
        return buildScaffold();
      } else {
        if (MediaQuery.of(context).size.width < 600) {
          return buildScaffold();
        } else {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 600,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: buildScaffold(),
                )
              ],
            ),
          );
        }
      }
    }
  }

  Widget buildScaffold() {
    final List<String> openTypeList = [
      AppLocalizations.of(context)!.openInApp,
      AppLocalizations.of(context)!.openInBuiltInTab,
      AppLocalizations.of(context)!.openInSystemBrowser,
    ];
    return Scaffold(
      appBar: AppBar(
        leading: widget.needLeading ? null : const SizedBox.shrink(),
        leadingWidth: widget.needLeading ? null : 0,
        title: Text(AppLocalizations.of(context)!.editFeed),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            /* 订阅源地址 */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: GestureDetector(
                onTap: () {
                  /* 复制订阅源地址 */
                  Clipboard.setData(
                    ClipboardData(text: widget.feed.url),
                  );
                  showToastOrSnackBar(
                    context,
                    AppLocalizations.of(context)!.copyFeedUrlSuccess,
                  );
                },
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.feedUrl,
                    enabled: false,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            /* 订阅源名称 */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.feedName,
                ),
              ),
            ),
            const SizedBox(height: 24),
            /* 订阅源分类 */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.feedCategory,
                ),
              ),
            ),
            const SizedBox(height: 18),
            /* 是否获取全文 */
            SwitchListTile(
              value: widget.feed.fullText,
              title: Text(AppLocalizations.of(context)!.fullText),
              onChanged: (bool value) {
                setState(() {
                  widget.feed.fullText = value;
                });
              },
            ),
            /* 文章打开方式 */
            ListTileGroupTitle(
              title: AppLocalizations.of(context)!.postOpenWith,
            ),
            ...openTypeList.map(
              (e) {
                return RadioListTile(
                  value: openTypeList.indexOf(e),
                  groupValue: widget.feed.openType,
                  title: Text(e),
                  onChanged: (int? value) {
                    setState(() {
                      widget.feed.openType = value!;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                const SizedBox(width: 24),
                /* 保存按钮 */
                TextButton(
                  onPressed: () async {
                    widget.feed.name = _nameController.text;
                    widget.feed.category = _categoryController.text;
                    await widget.feed.insertOrUpdateToDb();
                    /* 如果 feed 已存在，否则更新 feed 下的 Post */
                    if (await Feed.isExist(widget.feed.url)) {
                      await widget.feed
                          .updatePostsFeedNameAndOpenTypeAndFullText();
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
                const SizedBox(width: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
