import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String url;
  final String name;
  final double size;
  const ProfileAvatar({
    this.url = '',
    this.name = '',
    this.size = 25.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget c;
    if (url.isNotEmpty) {
      c = CircleAvatar(
        radius: size,
        foregroundImage: NetworkImage(url, scale: 0.5),
      );
    } else if (name.isNotEmpty) {
      c = CircleAvatar(
        radius: size,
        child: Text(name.substring(0, 2)),
      );
    } else {
      c = CircleAvatar(
        radius: size,
        child: Icon(Icons.person),
      );
    }

    return c;
  }
}
