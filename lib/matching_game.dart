import 'package:flutter/material.dart';
import 'package:memory_match/model/card_model.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {

  List<CardModel> cards = [];
  List<int> selectedCards = [];
  bool isBusy = false;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();
  }

  void initializeCards(){
    List<String> imagePaths = [
      "assets/a.webp",
      'assets/b.webp',
      'assets/c.webp',
    ];

    List<String> combinedPaths = [...imagePaths, ...imagePaths];

    combinedPaths.shuffle();
    int id = 0;
    // int index = 0;
    cards = combinedPaths.map((path){
      id++;
      return CardModel(id: id, imagePath: path,);
    }).toList();

  }
  void flipCard(int index){
    if(!isBusy && !cards[index].isFlipped && selectedCards.length < 2){
      setState(() {
        cards[index].isFlipped = true;
        selectedCards.add(index);
      });
    }

    if (selectedCards.length == 2){
      checkMatch();
    }
  }

  void checkMatch(){
    isBusy = true;
    Future.delayed(const Duration(seconds: 1),() {
      setState(() {
        if (cards[selectedCards[0]].imagePath !=
        cards[selectedCards[0]].imagePath){
          cards[selectedCards[0]].isFlipped = false;
          cards[selectedCards[1]].isFlipped = false;
        }
        selectedCards.clear();
        isBusy = false;
      });
    });
  }
  
  
  void startGame(){
    initializeCards();
    setState(() {
      gameStarted = true;
    });
  }
  
  void finishGame(){
    setState(() {
      gameStarted = false;
    });
    initializeCards();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: Text("Memory Match game",style: TextStyle(letterSpacing: 4,color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(!gameStarted)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/q.webp", height: 160,),
                const SizedBox(height: 10,),
                TextButton(onPressed: startGame,
                  child: Text(
                    "Start Game",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          if (gameStarted)
            Expanded(
              child: Align(
                alignment: Alignment.center  ,
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          flipCard(index);
                        },

                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: cards[index].isFlipped
                                ? Image.asset(cards[index].imagePath)
                                : Image.asset('assets/q.webp'),
                          ),
                        ),
                      );
                  },
                ),
              )
            ),
          if(gameStarted && cards.every((card) => card.isFlipped))
            Padding(padding: const EdgeInsets.only(bottom: 40),
              child: TextButton(
                  onPressed: finishGame,
                  child: const Text("Finished game, Starting again...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
              ),
            ),
        ],
      ),
    );
  }
}
