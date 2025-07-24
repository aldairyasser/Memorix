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

    final now = DateTime.now();
    int repetitions = model.repetitions;
    double ef = model.easeFactor.toDouble(); // convertir a double temporalmente
    DateTime nextReview;

    if (quality < 3) {
      repetitions = 0;
      nextReview = now.add(const Duration(days: 1));
    } else {
      repetitions += 1;
      ef += (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
      if (ef < 1.3) ef = 1.3;

      int interval;
      if (repetitions == 1) {
        interval = 1;
      } else if (repetitions == 2) {
        interval = 6;
      } else {
        interval = (model.repetitions * ef).round();
      }

      nextReview = now.add(Duration(days: interval));
    }

    model.repetitions = repetitions;
    model.easeFactor = ef.round(); // guarda como int nuevamente
    model.nextReview = nextReview;

    await model.save();
  }

}
