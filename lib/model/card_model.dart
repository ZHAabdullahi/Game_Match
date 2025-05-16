class CardModel{
  final int id;
  String imagePath;
  bool isFlipped;

  CardModel({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
});
}