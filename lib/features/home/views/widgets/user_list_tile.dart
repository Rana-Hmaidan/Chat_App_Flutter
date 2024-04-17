import 'package:flutter/material.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key, 
    required this.photoUrl, 
    required this.name, 
    required this.onTapItem,
  });

  final String photoUrl;
  final String name;
  final VoidCallback onTapItem;


  @override
  Widget build(BuildContext context) {
    return Card(
     margin: const EdgeInsets.all(10.0),
     color: Colors.white ,
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: ListTile(
              onTap: onTapItem, 
              leading: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 30,
              ),
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
     ),
   );
  }
}