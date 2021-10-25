import 'package:birthday_card/constants.dart';
import 'package:birthday_card/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _form = GlobalKey<FormState>();
  // final _fromFocusNode = FocusNode();
  // final _blockOpenFocusNode = FocusNode();
  // final _answerFocusNode = FocusNode();
  // final _hintFocusNode = FocusNode();
  // final _imageUrlFocusNode = FocusNode();
  // final _audioUrlFocusNode = FocusNode();
  // final _message1FocusNode = FocusNode();
  // final _message2FocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  final _audioUrlController = TextEditingController();

  bool _isSubmitting = false;
  bool _showImageChecker = false;
  bool _isAudioPlaying = false;

  String? resultUrl;

  Widget _textField(
    String labelText, {
    String? hintText,
    TextInputType? keyboardType,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    bool required = false,
    bool onlyNumber = false,
    Function(String?)? onSaved,
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: const TextStyle(fontSize: 20),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 2.0))),
        onFieldSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        validator: (value) {
          if (required) {
            if (value == null || value.isEmpty) {
              return 'Cần thiết';
            }
          }
          if (onlyNumber) {
            if (value != null) {
              int age = int.tryParse(value) ?? 0;
              if (age == 0) {
                return 'Không hợp lệ';
              }
            }
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();

    try {
      final doc =
          await FirebaseFirestore.instance.collection(dbCollectionName).add({
                'age': age,
                'from': from,
                'blockOpen': blockOpen,
                'hints': hints,
                'answers': answers,
                'imageURL': imageURL,
                'audioURL': audioURL,
                'message1': message1,
                'message2': message2,
              }..removeWhere((_, value) => value == null || value == ''));
      resultUrl = linkWebApp + '?id=' + doc.id;
      Navigator.pushNamed(context, '/result', arguments: resultUrl);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lỗi không xác định!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 500,
            child: Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      '🎈 Birthday Card 🎈',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 15),
                    _textField('Tuổi*',
                        keyboardType: TextInputType.number,
                        required: true,
                        onlyNumber: true,
                        // nextFocusNode: _fromFocusNode,
                        onSaved: (value) {
                      age = int.parse(value!);
                    }),
                    _textField('Đến từ...', hintText: defaultFrom,
                        // focusNode: _fromFocusNode,
                        // nextFocusNode: _blockOpenFocusNode,
                        onSaved: (value) {
                      from = value ?? defaultFrom;
                    }),
                    _textField('Tiêu đề nhập mật khẩu',
                        hintText: defaultBlockOpen,
                        // focusNode: _blockOpenFocusNode,
                        // nextFocusNode: _answerFocusNode,
                        onSaved: (value) {
                      blockOpen = value ?? defaultBlockOpen;
                    }),
                    _textField('Đáp án* (ngăn cách bằng ;)',
                        hintText: 'sinhnhat; sinh nhật; ngaysinhnhat',
                        // focusNode: _answerFocusNode,
                        // nextFocusNode: _hintFocusNode,
                        required: true, onSaved: (value) {
                      answers = value!.split(';').map((e) => e.trim()).toList();
                    }),
                    _textField('Gợi ý* (ngăn cách bằng ;)',
                        hintText: 'một ngày trong năm; điều ước; thổi nến',
                        // focusNode: _hintFocusNode,
                        // nextFocusNode: _imageUrlFocusNode,
                        required: true, onSaved: (value) {
                      hints = value!.split(';').map((e) => e.trim()).toList();
                    }),
                    _textField('Link ảnh',
                        // focusNode: _imageUrlFocusNode,
                        // nextFocusNode: _audioUrlFocusNode,
                        controller: _imageUrlController,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextButton(
                            child: const Text('Kiểm tra',
                                style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              if (_imageUrlController.text.isNotEmpty) {
                                setState(() {
                                  _showImageChecker = true;
                                });
                              }
                            },
                          ),
                        ), onSaved: (value) {
                      imageURL = value;
                    }),
                    if (_showImageChecker)
                      SizedBox(
                          height: 200,
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.fitHeight,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Container(
                                  color: Colors.grey[400],
                                  child: const Center(
                                    child: Text('Lỗi!'),
                                  ));
                            },
                          )),
                    _textField('Link nhạc',
                        hintText: 'mặc định là beat 4 casting RV',
                        controller: _audioUrlController,
                        // focusNode: _audioUrlFocusNode,
                        // nextFocusNode: _message1FocusNode,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: IconButton(
                            icon: Icon(_isAudioPlaying
                                ? Icons.stop
                                : Icons.play_arrow),
                            onPressed: () {
                              setState(() {
                                _isAudioPlaying = !_isAudioPlaying;
                              });

                              if (!_isAudioPlaying) {
                                audioPlayer.stop();
                              } else {
                                if (_audioUrlController.text.isNotEmpty) {
                                  audioPlayer.play(_audioUrlController.text);
                                } else {
                                  audioPlayer.play(defaultAudioURL);
                                }
                              }
                            },
                          ),
                        ), onSaved: (value) {
                      audioURL = value ?? defaultAudioURL;
                    }),
                    _textField('Lời nhắn 1 (ngắn)', hintText: defaultMessage1,
                        // focusNode: _message1FocusNode,
                        // nextFocusNode: _message2FocusNode,
                        onSaved: (value) {
                      message1 = value ?? defaultMessage1;
                    }),
                    _textField('Lời nhắn 2 (dài)',
                        hintText: defaultMessage2,
                        // focusNode: _message2FocusNode,
                        maxLines: 4, onSaved: (value) {
                      message2 = value ?? defaultMessage2;
                    }),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.done),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Xong', style: TextStyle(fontSize: 20)),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              setState(() {
                                _isSubmitting = true;
                              });
                              await _submit();
                              setState(() {
                                _isSubmitting = false;
                              });
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
