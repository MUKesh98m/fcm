import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, this.message});

  final RemoteMessage? message;
  static const route = '/notification-screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final initData = FirebaseFirestore.instance.collection('data');

  @override
  void initState() {
    // TODO: implement initState

    initData.get();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final message = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        body: StreamBuilder(
      stream: initData.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            color: Colors.black,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                "Title :- ${snapshot.data!.docs[index]['title']}",
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
              subtitle: Text(snapshot.data!.docs[index]['body']),
              trailing: IconButton(
                  onPressed: () {
                    initData.doc(snapshot.data?.docs[index].id).delete();
                  },
                  icon: const Icon(Icons.delete)),
            ),
          ),
        );
      },
    ));
  }

  insertData(message) {}
}
