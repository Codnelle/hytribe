import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatroom.dart';

class UserSelectorPage extends StatefulWidget {
  const UserSelectorPage({super.key});

  @override
  State<UserSelectorPage> createState() => _UserSelectorPageState();
}

class _UserSelectorPageState extends State<UserSelectorPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start a Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs
              .where(
                (doc) => doc.id != currentUser?.uid,
              )
              .toList();

          if (users == null || users.isEmpty) {
            return const Center(child: Text('No users found to chat with.'));
          }

          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user.id;
                final userData = user.data() as Map<String, dynamic>;
                final username = userData['username'] ?? 'Unnamed';
                final profilePic = userData.containsKey('photoUrl')
                    ? userData['photoUrl']
                    : '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profilePic.isNotEmpty
                        ? NetworkImage(profilePic)
                        : const AssetImage('assets/images/girl.avif')
                            as ImageProvider,
                  ),
                  title: Text(username),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          otherUserId: userId,
                          otherUserName: username,
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
