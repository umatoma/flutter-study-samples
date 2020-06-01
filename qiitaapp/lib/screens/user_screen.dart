import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/item.dart';
import '../models/user.dart';
import '../qiita_repository.dart';
import 'item_screen.dart';

class UserScreen extends StatelessWidget {
  final User user;

  const UserScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = QiitaItemsQuery().userIdEquals(user.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(user.id),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _UserProfile(user: user),
            Divider(height: 32),
            FutureBuilder(
              future: QiitaRepository().getItemList(query: query),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  return _UserItems(itemList: snapshot.data);
                }

                return Container(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final User user;

  const _UserProfile({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        ClipOval(
          child: Container(
            width: 64,
            height: 64,
            child: Image.network(user.profileImageUrl),
          ),
        ),
        SizedBox(height: 8),
        Text('@${user.id}'),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            user.description ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  '${user.itemsCount}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '投稿',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${user.followersCount}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'フォロワー',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _UserItems extends StatelessWidget {
  final List<Item> itemList;

  const _UserItems({
    Key key,
    @required this.itemList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Icon(Icons.view_list, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text('最新の記事', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ...itemList.map((item) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ItemScreen(item: item)),
              );
            },
            child: ListTile(
              title: Text(item.title),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LGTM ${item.likesCount}'),
                  Text(DateFormat.Md().add_jm().format(item.createdAt)),
                ],
              ),
            ),
          );
        }).toList()
      ],
    );
  }
}
