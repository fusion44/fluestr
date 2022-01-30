import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String url;
  final String name;

  const ProfileAvatar({
    this.url = '',
    this.name = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url.isNotEmpty) {
      return CircleAvatar(child: Image.network(url));
    } else if (name.isNotEmpty) {
      return CircleAvatar(child: Text(name.substring(0, 2)));
    }
    return CircleAvatar(child: Icon(Icons.person));
  }
}
