import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:memorix/domain/usecases/get_all_decks.dart';
import '../data/models/flashcard_model.dart';
import '../data/models/deck_model.dart';
import '../data/repositories/hive_flashcard_repository.dart';
import '../domain/repositories/flashcard_repository.dart';
import '../domain/repositories/deck_repository.dart';
import '../domain/usecases/get_due_flashcards.dart';
import '../domain/usecases/update_flashcard_review.dart';
import '../presentation/viewmodels/study_view_model.dart';
import '../domain/usecases/add_flashcard.dart';
import '../data/repositories/hive_deck_repository.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  final flashcardBox = Hive.box<FlashcardModel>('flashcards');
  sl.registerSingleton<Box<FlashcardModel>>(flashcardBox);
  sl.registerSingleton<FlashcardRepository>(HiveFlashcardRepository(sl()));

  sl.registerFactory(() => GetDueFlashcardsUseCase(sl()));
  sl.registerFactory(() => UpdateFlashcardReviewUseCase(sl()));
  sl.registerFactory(() => AddFlashcardUseCase(sl()));

  final deckBox = Hive.box<DeckModel>('decks');
  sl.registerSingleton<HiveDeckRepository>(HiveDeckRepository(deckBox));
  sl.registerSingleton<DeckRepository>(sl<HiveDeckRepository>());

  sl.registerFactory(() => GetAllDecksUseCase(sl()));

  sl.registerFactory(() => StudyViewModel(
        getDueFlashcards: sl(),
        updateFlashcardReview: sl(),
        addFlashcard: sl(),
      ));
}

