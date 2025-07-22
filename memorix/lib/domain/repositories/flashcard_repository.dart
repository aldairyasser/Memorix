import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<void> addFlashcard(String deckId, Flashcard card);
  Future<List<Flashcard>> getDueFlashcards(String deckId);
  Future<void> updateFlashcardReview(String flashcardId, int quality);
}