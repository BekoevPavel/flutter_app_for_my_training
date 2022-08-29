import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_for_my_training/models/chat_model.dart';
import 'package:flutter_app_for_my_training/models/post_model.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message = '';

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PostModel post =
        ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(post.id)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  const Center(
                    child: Text('Error'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: ((context, index) {
                    final QueryDocumentSnapshot doc =
                        snapshot.data!.docs[index];

                    final ChatModel chatModel = ChatModel(
                        userName: doc['userName'],
                        userID: doc['userID'],
                        message: doc['message'],
                        timestamp: doc['timeStamp'] as Timestamp);
                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text('By ${chatModel.userName}'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(chatModel.message)
                        ],
                      ),
                    );
                  }),
                );
              }),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          height: 100,
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _controller,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Enter Message'),
                onChanged: (value) => message = value,
              )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.id)
                        .collection('comments')
                        .add({
                          'userID': FirebaseAuth.instance.currentUser!.uid,
                          'userName':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'message': message,
                          'timeStamp': Timestamp.now()
                        })
                        .then((value) => print('chat doc added'))
                        .catchError(
                            (error) => print('error chat doc ${error}'));
                    _controller.clear();
                    setState(() {
                      message = '';
                    });
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
