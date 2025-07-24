import '../repositories/flashcard_repository.dart';

class UpdateFlashcardReviewUseCase {
  final FlashcardRepository repository;

  UpdateFlashcardReviewUseCase(this.repository);

  Future<void> call(String flashcardId, int quality) {
    return repository.updateFlashcardReview(flashcardId, quality);
  }
}