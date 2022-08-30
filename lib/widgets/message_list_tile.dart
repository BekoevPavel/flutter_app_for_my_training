import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/models/chat_model.dart';

class MessageListTile extends StatelessWidget {
  final ChatModel chatModel;
  const MessageListTile({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Column(
        children: [
          Text(
            'By ${chatModel.userName}',
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(chatModel.message, style: const TextStyle(color: Colors.black))
        ],
      ),
    );
  }
}
