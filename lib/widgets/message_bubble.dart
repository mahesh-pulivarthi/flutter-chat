import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.username,
      required this.userImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: 140,
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.pink.shade300
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                // mainAxisAlignment:
                //     isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    username.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    // textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.grey.shade100
                            : Theme.of(context).secondaryHeaderColor),
                    // textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: isMe ? 0 : 70,
          left: isMe ? 70 : 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        )
      ],
    );
  }
}
