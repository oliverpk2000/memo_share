import 'package:flutter/material.dart';
import 'package:memo_share/domain/entry.dart';
import 'package:memo_share/domain/user.dart';

class profileTile extends StatefulWidget {
  const profileTile({super.key, required this.user});

  final User user;

  @override
  State<profileTile> createState() => _profileTileState();
}

class _profileTileState extends State<profileTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueAccent,
          width: 4,
        ),
      ),
      child: Column(
        children: [
          Text('username: ${widget.user.username}'),
          Text('id: ${widget.user.id}')
        ],
      ),
    );
  }
}
