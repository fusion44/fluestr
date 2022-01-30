import 'package:flutter/material.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({Key? key}) : super(key: key);

  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Contact')),
      body: Center(child: Text('Search contacts')),
    );
  }
}
