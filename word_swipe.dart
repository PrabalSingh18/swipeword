import 'package:flutter/material.dart';
import 'dart:math';

class WordSwiper extends StatefulWidget {
  @override
  _WordSwiperState createState() => _WordSwiperState();
}

class _WordSwiperState extends State<WordSwiper>
    with SingleTickerProviderStateMixin {
  List<WordCard> wordCards = [
    const WordCard(
        word: 'Serendipity',
        meaning:
            'The occurrence of events by chance in a happy or beneficial way'),
    const WordCard(word: 'Ephemeral', meaning: 'Lasting for a very short time'),
    const WordCard(
        word: 'Eloquent',
        meaning: 'Fluent or persuasive in speaking or writing'),
    const WordCard(
        word: 'Ubiquitous', meaning: 'Present, appearing, or found everywhere'),
    const WordCard(
        word: 'Mellifluous', meaning: 'Sweet or musical; pleasant to hear'),
  ];

  int currentIndex = 0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSwipeLeft() {
    if (_animationController.isAnimating) return;

    _animationController.forward().then((_) {
      setState(() {
        currentIndex = (currentIndex + 1) % wordCards.length;
        _animationController.reset();
      });
    });

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _handleSwipeRight() {
    if (_animationController.isAnimating) return;

    _animationController.forward().then((_) {
      setState(() {
        currentIndex = (currentIndex - 1 + wordCards.length) % wordCards.length;
        _animationController.reset();
      });
    });

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Swiper', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.purple[100]!, Colors.blue[100]!],
          ),
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              _handleSwipeRight();
            } else if (details.primaryVelocity! < 0) {
              _handleSwipeLeft();
            }
          },
          child: Center(
            child: Stack(
              children: [
                // Next word card
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - _fadeAnimation.value,
                      child: wordCards[(currentIndex + 1) % wordCards.length],
                    );
                  },
                ),
                // Current word card
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: wordCards[currentIndex],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WordCard extends StatelessWidget {
  final String word;
  final String meaning;

  const WordCard({Key? key, required this.word, required this.meaning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[300]!, Colors.blue[300]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                word,
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Helvetica Neue'),
              ),
              const SizedBox(height: 20),
              Text(
                meaning,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
