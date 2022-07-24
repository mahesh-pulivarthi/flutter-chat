import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatForm extends StatefulWidget {
  ChatForm({Key? key}) : super(key: key);

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  final _messageController = TextEditingController();
  late String _enteredMessage = '';

  Future<void> _onSend() async {
    var message = _messageController.text.trim();
    _messageController.clear();
    var user;
    print(message);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        user = documentSnapshot.data();
      }
    });
    await FirebaseFirestore.instance.collection('chat').add({
      'text': message,
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': user['username'],
      'userImage': user['image_url'],
    });
  }

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _messageController.addListener;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: const InputDecoration(
              label: Text('Send a message'),
            ),
            onChanged: (value) {
              _enteredMessage = value;
              // if (kDebugMode) {
              //   print(_enteredMessage);
              // }
            },
          ),
        ),
        IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _onSend,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ))
      ],
    );
  }
}
