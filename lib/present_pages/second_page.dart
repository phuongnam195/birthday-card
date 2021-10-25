import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:birthday_card/constants.dart';
import 'package:birthday_card/info.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage>
    with TickerProviderStateMixin {
  late Timer _timer;
  int _number = 5;
  bool _isLoaded = false;

  @override
  void initState() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_number == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _number--;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLoaded) {
      audioPlayer.resume();
    }
    _isLoaded = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: LayoutBuilder(
          builder: (ctx, _) {
            if (_number > 0) {
              return Center(
                  child: Text(
                '$_number',
                style: const TextStyle(fontSize: 120),
              ));
            }
            return const SecondPage();
          },
        ));
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Image? _image;
  bool _showImage = false;

  @override
  void initState() {
    if (imageURL != null) {
      _image = Image.network(imageURL!);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_image != null) {
      precacheImage(_image!.image, context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize2 = min(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height) /
        22;

    return Stack(children: [
      Center(
        child: Column(
          mainAxisSize: imageURL == null ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (imageURL != null) const SizedBox(height: 50),
            if (imageURL != null)
              SizedBox(
                  height: 200, width: 200, child: _showImage ? _image : null),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedTextKit(
                onNext: (index, isLast) {
                  setState(() {
                    _showImage = true;
                  });
                },
                animatedTexts: [
                  TypewriterAnimatedText(
                    ' ' + (message1 ?? defaultMessage1),
                    speed: const Duration(milliseconds: 100),
                    textStyle: const TextStyle(fontSize: 50),
                    textAlign: TextAlign.justify,
                  ),
                  TypewriterAnimatedText(
                    message2 ?? defaultMessage2,
                    speed: const Duration(milliseconds: 40),
                    textStyle: TextStyle(fontSize: fontSize2),
                    textAlign: TextAlign.center,
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Lottie.network(
            'https://assets2.lottiefiles.com/packages/lf20_pkanqwys.json',
            fit: BoxFit.fitWidth),
      ),
    ]);
  }
}
