import 'package:flutter/material.dart';
import 'package:memory_match/model/card_model.dart';

class MatchingGame extends StatefulWidget {
  const MatchingGame({super.key});

  @override
  State<MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {

  int itemCount = 6; //کارت(عکس) های مجموعی
  static const int rows = 3;//عکس ها که باید در یک کتار بیایید


  List<CardModel> cards = [];
  List<int> selectedCards = [];
  bool isBusy = false;
  bool gameStarted = false;
  int progress = 0;
  int errors = 0;

  @override
  void initState() {
    super.initState();
  }

  void initializeCards(){
    List<String> imagePaths = List.generate(
      itemCount,
          (index) => 'assets/img${index + 1}.png',
    );
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
    print("length: "+selectedCards.length.toString());
    if(!isBusy && !cards[index].isFlipped && selectedCards.length < 2){
      setState(() {
        cards[index].isFlipped = true;
        selectedCards.add(index);
      });
    }
    print("length2: "+selectedCards.length.toString());

    if (selectedCards.length == 2){
      print("CheckMathcing__");
      checkMatch();

    }
  }

  void checkMatch(){
    isBusy = true;
    Future.delayed(const Duration(milliseconds: 500),() {
      setState(() {
        if (cards[selectedCards[0]].imagePath !=
            cards[selectedCards[1]].imagePath){
          print("Not Equal");
          cards[selectedCards[0]].isFlipped = false;
          cards[selectedCards[1]].isFlipped = false;
          errors++;
        }else{
          progress++;
        }
        print("Equal");
        selectedCards.clear();
        isBusy = false;
      });
    });
  }


  void startGame(){
    progress = 0;
    errors = 0;
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
    double percentage = progress / itemCount;

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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: percentage.clamp(0.0, 1.0),
                              minHeight: 20,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Center(child: Text('Complete $progress out of $itemCount', style: TextStyle(color: Colors.white))),
                        Center(child: Text('Wrong: $errors ', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return GestureDetector(
                            onTap: () => flipCard(index),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                cards[index].isFlipped ? cards[index].imagePath : 'assets/img_q.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        childCount: cards.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rows,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                    ),
                  ),

                ],
              ),
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
