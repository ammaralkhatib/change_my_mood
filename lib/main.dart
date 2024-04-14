import 'package:flutter/material.dart';

void main() {
  runApp(const ChangeMyMoodApp());
}

class ChangeMyMoodApp extends StatelessWidget {
  const ChangeMyMoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Change My Mood',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MoodSelectionScreen(),
    );
  }
}

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  late String currentMood;
  late Color currentColor;
  late String newMood;
  late Color newColor;

  List<String> moods = ['Happy', 'Sad', 'Angry', 'Excited'];
  List<Color> colors = [Colors.blue, Colors.yellow, Colors.red, Colors.green];

  @override
  void initState() {
    super.initState();
    currentMood = moods[0];
    currentColor = colors[0];
    newMood = moods[0];
    newColor = colors[0];
  }

  void startTransformation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodTransformationScreen(
          currentMood: currentMood,
          currentColor: currentColor,
          newMood: newMood,
          newColor: newColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change My Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select your current mood:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: currentMood,
              items: moods.map((String mood) {
                return DropdownMenuItem<String>(
                  value: mood,
                  child: Text(mood),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  currentMood = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select a color:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<Color>(
              value: currentColor,
              items: colors.map((Color color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Color? value) {
                setState(() {
                  currentColor = value!;
                });
              },
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Select your new mood:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: newMood,
              items: moods.map((String mood) {
                return DropdownMenuItem<String>(
                  value: mood,
                  child: Text(mood),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  newMood = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select a color:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<Color>(
              value: newColor,
              items: colors.map((Color color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (Color? value) {
                setState(() {
                  newColor = value!;
                });
              },
            ),
            const SizedBox(height: 32.0),
            TextButton(
              onPressed: startTransformation,
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodTransformationScreen extends StatefulWidget {
  final String currentMood;
  final Color currentColor;
  final String newMood;
  final Color newColor;

  const MoodTransformationScreen({super.key, 
    required this.currentMood,
    required this.currentColor,
    required this.newMood,
    required this.newColor,
  });

  @override
  _MoodTransformationScreenState createState() =>
      _MoodTransformationScreenState();
}

class _MoodTransformationScreenState extends State<MoodTransformationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _emojiSizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(
      begin: widget.currentColor,
      end: widget.newColor,
    ).animate(_animationController);

    _emojiSizeAnimation = Tween<double>(
      begin: 100.0,
      end: 200.0,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: Container(
            color: _colorAnimation.value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _emojiSizeAnimation,
                    builder: (BuildContext context, Widget? child) {
                      return Image.asset(
                        'assets/emoji_${widget.currentMood.toLowerCase()}.png',
                        width: _emojiSizeAnimation.value,
                        height: _emojiSizeAnimation.value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
