import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/item.dart';
import '../models/tag.dart';
import '../models/user.dart';

class ItemScreen extends StatelessWidget {
  final Item item;

  const ItemScreen({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _UserProfileIcon(
                    size: 32,
                    profileImageUrl: item.user.profileImageUrl,
                  ),
                  SizedBox(width: 8),
                  Text('@${item.user.id}'),
                  SizedBox(width: 8),
                  Text(
                    DateFormat.yMd().add_jm().format(item.createdAt),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16, left: 8, right: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 16),
              child: _TagList(tags: item.tags),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
              child: _LgtmBox(likesCount: item.likesCount),
            ),
            Html(
              data: item.renderedBody,
              onLinkTap: (String url) {
                launch(url);
              },
              style: {
                'h2': Style(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                ),
                'code': Style(
                  backgroundColor: Colors.blueGrey[100],
                ),
                '.code-frame': Style(
                  color: Colors.white,
                  backgroundColor: Colors.blueGrey[900],
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                '.code-lang span': Style(
                  backgroundColor: Colors.blueGrey[300],
                  display: Display.INLINE_BLOCK,
                ),
                'pre': Style(
                  padding: EdgeInsets.only(top: 16),
                ),
              },
            ),
            Divider(
              height: 64,
              color: Colors.blueGrey,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 32),
              child: ListTile(
                leading: _UserProfileIcon(
                  size: 48,
                  profileImageUrl: item.user.profileImageUrl,
                ),
                title: Text('@${item.user.id}'),
                subtitle: Text(item.user.description ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileIcon extends StatelessWidget {
  final double size;
  final String profileImageUrl;

  const _UserProfileIcon({
    Key key,
    @required this.size,
    @required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        profileImageUrl,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

class _TagList extends StatelessWidget {
  final List<Tag> tags;

  const _TagList({
    Key key,
    @required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: tags.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                label: Text(tag.name),
                labelStyle: TextStyle(color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LgtmBox extends StatelessWidget {
  final int likesCount;

  const _LgtmBox({
    Key key,
    @required this.likesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          'LGTM $likesCount',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
