import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'dart:convert';
import 'dart:io';

Future<void> generateTags() async {
  // Call the exe
  print(Directory.current);
  var result = await Process.run('auto_label.exe', []);
  print(result.stdout);
}

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _value = 0;

  Future<void> writeToJson() async {
    var input = await File('user_info.json').readAsString();
    var map = jsonDecode(input);
    map['max_results'] = _value.toInt();
    await File('user_info.json').writeAsString(jsonEncode(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Select a count',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Provide the number of emails to be sorted",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              //Slider with end value
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      activeColor: Colors.purple.shade300,
                      inactiveColor: Colors.white,
                      thumbColor: Colors.white,
                      min: 0,
                      max: 50,
                      divisions: 50,
                      value: _value,
                      label: _value.toStringAsFixed(0),
                      onChanged: (double newValue) {
                        setState(() {
                          _value = newValue;
                          writeToJson();
                        });
                      },
                    ),
                  ),
                  Text(_value.toStringAsFixed(0)),
                ],
              ),
            ]),
      ),
      floatingActionButton: Stack(
        children: [
          if (_value != 0)
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  Navigator.pushNamed(context, '/load');
                  await generateTags();
                  Navigator.pushNamed(context, '/result');

                  // Future.delayed(const Duration(seconds: 5), () {
                  // });
                },
                label: Row(
                  children: <Widget>[
                    Text('Generate',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black)),
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20.0,
            left: 52,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/details');
              },
              label: Row(
                children: <Widget>[
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                  const SizedBox(width: 16),
                  Text('Back',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white, size: 100),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Generating',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  repeatForever: true,
                  pause: const Duration(milliseconds: 500),
                ),
              ),
            ]),
      ),
    );
  }
}
