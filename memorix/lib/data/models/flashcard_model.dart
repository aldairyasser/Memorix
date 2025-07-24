import 'package:hive/hive.dart';
import '../../domain/entities/flashcard.dart';
part 'flashcard_model.g.dart';

@HiveType(typeId: 0)
class FlashcardModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String front;

  @HiveField(2)
  String back;

  @HiveField(3)
  int easeFactor;

  @HiveField(4)
  DateTime nextReview;

  @HiveField(5)
  int repetitions;

  @HiveField(6) 
  String deckId;

  FlashcardModel({
    required this.id,
    required this.front,
    required this.back,
    required this.easeFactor,
    required this.nextReview,
    required this.repetitions,
    required this.deckId,
  });

  factory FlashcardModel.fromEntity(Flashcard entity, String deckId,) => FlashcardModel(
        id: entity.id,
        front: entity.front,
        back: entity.back,
        easeFactor: entity.easeFactor,
        nextReview: entity.nextReview,
        repetitions: entity.repetitions,
        deckId: deckId,
      );

  Flashcard toEntity() => Flashcard(
        id: id,
        front: front,
        back: back,
        easeFactor: easeFactor,
        nextReview: nextReview,
        repetitions: repetitions,
        deckId: deckId,
      );
}