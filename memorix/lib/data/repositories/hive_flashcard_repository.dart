import 'package:hive/hive.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../models/flashcard_model.dart';

class HiveFlashcardRepository implements FlashcardRepository {
  final Box<FlashcardModel> box;

  HiveFlashcardRepository(this.box);

  @override
  Future<void> addFlashcard(String deckId, Flashcard card) async {
    final model = FlashcardModel.fromEntity(card, deckId);
    await box.put(model.id, model);
  }

  @override
  Future<List<Flashcard>> getDueFlashcards(String deckId) async {
    final now = DateTime.now();
    return box.values
        .where((c) => c.deckId == deckId && c.nextReview.isBefore(now))
        .map((c) => c.toEntity())
        .toList();
  }

  @override
  Future<void> updateFlashcardReview(String flashcardId, int quality) async {
    final model = box.get(flashcardId);
    if (model == null) return;

    if (quality < 2) {
      model.repetitions = 0;
      model.easeFactor = (model.easeFactor - 20).clamp(130, 300);
      model.nextReview = DateTime.now().add(const Duration(days: 1));
    } else {
      model.repetitions += 1;
      model.easeFactor += 10;
      model.nextReview = DateTime.now().add(
        Duration(days: model.repetitions * model.easeFactor ~/ 100),
      );
    }
    await model.save();
  }
}
