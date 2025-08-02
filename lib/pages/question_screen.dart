import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _selectedIndex = 0;
  bool hasVoted = false;
  String? userVote;
  int yesCount = 0;
  int noCount = 0;
  String questionText = "Loading...";
  String currentQuestionId = "question_1"; // Default fallback
  bool isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getActiveQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      //Bottom Navbar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Discussions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      //Body Section with everything
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background_image.png",
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          Column(children: [_headerText(context), _questionCard(context)]),
        ],
      ),
    );
  }

  Future<void> _getActiveQuestion() async {
    final pointerDoc = await FirebaseFirestore.instance
        .collection('questions')
        .doc('current_question')
        .get();

    final questionId = pointerDoc['activeQuestionId'];

    final questionDoc = await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .get();

    if (questionDoc.exists) {
      setState(() {
        questionText = questionDoc['text'] ?? "No question text.";
        currentQuestionId = questionId;
        isLoading = false;
      });
      _listenToVotes(); // Attach listener for vote counts
    } else {
      setState(() {
        questionText = "Active question not found.";
        isLoading = false;
      });
    }
  }

  void _vote(String answer) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final questionId = currentQuestionId;

    await FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('votes')
        .doc(user.uid)
        .set({
          'answer': answer,
          'timestamp': Timestamp.now(),
          'userId': user.uid,
          'userEmail': user.email,
        });

    // Update count in main document using transaction
    final questionRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(questionRef);
      final data = snapshot.data() ?? {};

      int currentYes = data['yesCount'] ?? 0;
      int currentNo = data['noCount'] ?? 0;

      if (answer == 'yes') {
        currentYes += 1;
      } else {
        currentNo += 1;
      }

      int totalVotes = currentYes + currentNo;
      transaction.update(questionRef, {
        'yesCount': currentYes,
        'noCount': currentNo,
        'totalVotes': totalVotes,
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("You Voted '$answer'")));

    setState(() {
      hasVoted = true;
      userVote = answer;
    });
  }

  void _listenToVotes() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final votesRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(currentQuestionId)
        .collection('votes');

    votesRef.snapshots().listen((snapshot) {
      int yes = 0, no = 0;
      String? myVote;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data['answer'] == 'yes') yes++;
        if (data['answer'] == 'no') no++;
        if (doc.id == uid) myVote = data['answer'];
      }

      setState(() {
        yesCount = yes;
        noCount = no;
        hasVoted = myVote != null;
        userVote = myVote;
      });
    });
  }

  Widget _questionCard(BuildContext context) {
    return Container(
      width: 325.0,
      height: 425.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          //Logo on White card
          Positioned(
            top: 110,
            right: -100,
            child: Transform.rotate(
              angle: -0.5, // in radians (~ -28 degrees)
              child: Opacity(
                opacity: 0.1, // make it faint
                child: Image.asset(
                  "assets/images/TalkingPointLogo.jpg", // replace with your logo path
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🔷 Main content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading ? "Loading..." : questionText,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 15),

                Row(
                  children: [
                    Text(
                      "${yesCount} Yes Responses",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 30),

                    Text(
                      "${noCount} No Responses",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Spacer(),

                if (!hasVoted)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _vote("yes"),
                          icon: Icon(Icons.thumb_up_alt_outlined),
                          label: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007BFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _vote("no"),
                          icon: Icon(Icons.thumb_down_alt_outlined),
                          label: Text("No"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF007BFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Center(
                    child: Text(
                      "You voted: ${userVote?.toUpperCase()}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _headerText(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * .25,
    color: Colors.transparent,
    child: Stack(
      children: [
        // Text on the left
        Padding(
          padding: EdgeInsets.only(left: 24.0, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                ),
              ),
              Text(
                "Question",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),

        // Burger button on the right
        Positioned(
          top: 60,
          right: 20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                print('Menu tapped');
              },
            ),
          ),
        ),
      ],
    ),
  );
}
