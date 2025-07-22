class Flashcard {
  final String id;
  final String front;
  final String back;
  final int easeFactor;
  final DateTime nextReview;
  final int repetitions;
  final String deckId;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.easeFactor,
    required this.nextReview,
    required this.repetitions,
    required this.deckId,
  });
}