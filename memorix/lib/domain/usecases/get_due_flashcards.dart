import '../entities/flashcard.dart';
import '../repositories/flashcard_repository.dart';

class GetDueFlashcardsUseCase {
  final FlashcardRepository repository;

  GetDueFlashcardsUseCase(this.repository);

  Future<List<Flashcard>> call(String deckId) => repository.getDueFlashcards(deckId);
}