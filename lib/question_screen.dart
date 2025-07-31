import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Was The Tariffs Trump Imposed A Good Idea?",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),

              SizedBox(height: 15),

              Row(
                children: [
                  Text(
                    "X Responses",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Yes Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
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

                  // No Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.thumb_up_alt_outlined),
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
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
