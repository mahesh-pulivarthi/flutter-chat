import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshots.hasData) {
            return const Center(
              child: Text('Data not available'),
            );
          }
          final documents = snapshots.data!.docs;
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView.builder(
              reverse: true,
              itemCount: documents.length,
              itemBuilder: (ctx, index) => MessageBubble(
                  message: documents[index]['text'],
                  isMe: FirebaseAuth.instance.currentUser!.uid ==
                      documents[index]['userId'],
                  username: documents[index]['username'],
                  userImage: documents[index]['userImage'],
                  key: ValueKey(documents[index].id)),
            ),
          );
        });
  }
}
