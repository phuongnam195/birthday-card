import 'package:birthday_card/constants.dart';
import 'package:birthday_card/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'second_page.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _hintNumber = 0;
  bool _firstPressed = false;
  bool _passedQuest = false;
  final TextEditingController _controller = TextEditingController();

  void _loadAudio() async {
    audioPlayer.setUrl(audioURL ?? defaultAudioURL);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget openButton() {
      if (!_firstPressed) {
        return InkWell(
          child: Container(
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 40,
            width: 100,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Text(
              'MỞ HỘP',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          onTap: () {
            if (!_passedQuest) {
              setState(() {
                _firstPressed = true;
              });
            } else {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const CountdownPage(),
                  transitionDuration: Duration.zero,
                ),
              );
            }
          },
        );
      } else {
        return Container(
          height: 30,
          alignment: Alignment.center,
          child: FittedBox(
            child: Text(
              blockOpen ?? defaultBlockOpen,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        );
      }
    }

    Widget hintButton(int number) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              'Gợi ý $number',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xffE1ECF4),
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            setState(() {
              _hintNumber = number;
            });
          },
        ),
      );
    }

    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: 'x ' + age.toString(),
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    _loadAudio();

    return Scaffold(
      backgroundColor: const Color(0xffFEF1E8),
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2 - 200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  giftBoxAnimUrl,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(width: 4),
              ],
            ),
            openButton(),
            if (_firstPressed && !_passedQuest)
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(width: 30),
                    SizedBox(
                        width: 300,
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(fontSize: 20),
                          onSubmitted: (value) {
                            if (answers.contains(value)) {
                              setState(() {
                                _firstPressed = false;
                                _hintNumber = 0;
                                _passedQuest = true;
                              });
                            }
                          },
                        )),
                    SizedBox(
                      width: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xff0084FF),
                        ),
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          if (answers.contains(_controller.text)) {
                            setState(() {
                              _firstPressed = false;
                              _hintNumber = 0;
                              _passedQuest = true;
                            });
                          }
                        },
                      ),
                    )
                  ]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 1; i <= hints.length; i++) hintButton(i),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_hintNumber != 0)
                    Text(
                      hints[_hintNumber - 1],
                      style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontStyle: FontStyle.italic),
                    )
                ],
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            from ?? defaultFrom,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}
