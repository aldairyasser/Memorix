import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class AddFlashcardUseCase {
  final FlashcardRepository repository;

  AddFlashcardUseCase(this.repository);

  Future<void> call(String deckId, Flashcard card) {
    return repository.addFlashcard(deckId, card);
  }
}