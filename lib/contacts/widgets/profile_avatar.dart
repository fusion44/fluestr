import 'dart:convert';

import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageData;
  final String name;
  final double size;
  const ProfileAvatar({
    this.imageData = '',
    this.name = '',
    this.size = 25.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageData.isNotEmpty && imageData.startsWith('http')) {
      return CircleAvatar(
        radius: size,
        foregroundImage: NetworkImage(imageData, scale: 0.5),
      );
    }

    if (imageData.isNotEmpty &&
        imageData.startsWith('data:image') &&
        imageData.contains(',')) {
      final bytes = base64.decode(imageData.split(',').last);
      return CircleAvatar(
        radius: size,
        foregroundImage: MemoryImage(bytes, scale: 0.5),
      );
    }

    if (name.isNotEmpty) {
      return CircleAvatar(
        radius: size,
        child: Text(name.substring(0, 2)),
      );
    }

    return CircleAvatar(
      radius: size,
      child: Icon(Icons.person),
    );
  }
}
