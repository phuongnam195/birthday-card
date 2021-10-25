import 'package:birthday_card/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Stack(children: [
        Center(
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: 150,
                  color: Colors.pink[200],
                ),
                const SizedBox(height: 30),
                const Text('Hãy gửi link này cho đối phương nhé!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    )),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: url,
                  readOnly: true,
                  style: const TextStyle(fontSize: 24, color: Colors.black54),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: url));
                          },
                        ),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 10,
          right: 10,
          child: Text('Made by Phuong Nam'),
        ),
      ]),
    );
  }
}
