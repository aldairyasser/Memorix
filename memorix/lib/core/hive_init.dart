import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/flashcard_model.dart';
import '../data/models/deck_model.dart';


const bool resetBoxesOnStart = false;

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  Hive.registerAdapter(FlashcardModelAdapter());
  Hive.registerAdapter(DeckModelAdapter());

  if (resetBoxesOnStart) {
    try {
      await Hive.deleteBoxFromDisk('flashcards');
    } catch (_) {}
  }

  await Hive.openBox<FlashcardModel>('flashcards');
  await Hive.openBox<DeckModel>('decks');
}
