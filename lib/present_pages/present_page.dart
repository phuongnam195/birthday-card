import 'package:birthday_card/constants.dart';
import 'package:birthday_card/info.dart';
import 'package:birthday_card/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'first_page.dart';

class PresentPage extends StatelessWidget {
  const PresentPage(this.giftId, {Key? key}) : super(key: key);

  final String giftId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection(dbCollectionName)
              .doc(giftId)
              .get(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                alignment: Alignment.topCenter,
                child: LinearProgressIndicator(),
              );
            }

            if (snapshot.data == null || !snapshot.data!.exists) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('404: Not found!',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 20),
                      TextButton(
                        child: const Text('Tới trang thiết kế',
                            style: TextStyle(
                              fontSize: 24,
                            )),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CreationPage()));
                        },
                      )
                    ],
                  ),
                ),
              );
            }

            final info = snapshot.data!.data() as Map<String, dynamic>;
            age = info['age'];
            from = info['from'];
            blockOpen = info['blockOpen'];
            for (var hint in info['hints']) {
              hints.add(hint as String);
            }
            for (var answer in info['answers']) {
              answers.add(answer as String);
            }
            imageURL = info['imageURL'];
            audioURL = info['audioURL'];
            message1 = info['message1'];
            message2 = info['message2'];

            return const FirstScreen();
          },
        ));
  }
}
