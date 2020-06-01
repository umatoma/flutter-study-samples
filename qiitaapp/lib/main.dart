import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'qiita_repository.dart';
import 'screens/item_list_screen.dart';
import 'screens/sign_in_screen.dart';

void main() async {
  Intl.defaultLocale = 'ja_JP';
  await initializeDateFormatting('ja_JP');
  runApp(QiitaApp());
}

class QiitaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _LoadAccessToken(),
    );
  }
}

class _LoadAccessToken extends StatefulWidget {
  @override
  __LoadAccessTokenState createState() => __LoadAccessTokenState();
}

class __LoadAccessTokenState extends State<_LoadAccessToken> {
  Error _error;

  @override
  void initState() {
    super.initState();

    QiitaRepository().accessTokenIsSaved().then((isSaved) {
      if (isSaved) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ItemListScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SignInScreen()),
        );
      }
    }).catchError((e) {
      setState(() {
        _error = e;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: (_error == null)
            ? CircularProgressIndicator()
            : Text(_error.toString()),
      ),
    );
  }
}
