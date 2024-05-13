import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/auth.dart';
import 'create_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  String generateRandomImageUrl() {
    var random = Random();
    var randomNumber = random.nextInt(1000); // Adjust as needed
    return 'https://source.unsplash.com/random/300x200?sig=$randomNumber';
  }

  static const routeName = '/welcome';


  final Auth _auth = Auth();
  String formatTimestamp(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    var now = DateTime.now();
    var difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Welcome')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('model').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching data'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  var title = document['title'];
                  var description = document['description'];
                  var name = document['uploaderName'];
                  var createdAt = document['createdAt'];
                  var pfp = generateRandomImageUrl();
                  var elapsedTime = formatTimestamp(createdAt);

                  return InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateScreen(documentId: document.id),
                      ),
                    ),
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 4,
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(pfp),
                                    ),
                                  ),
                                  Text(
                                    name,
                                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20)
                                    ,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(elapsedTime, style: TextStyle(fontSize: 15),),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              title,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              description,
                              style: TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                },
              );

            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateScreen(documentId: null),
                ),
              );
            },
            child: const Text('Create Entry'),
          ),
        ],
      ),
    );
  }
}