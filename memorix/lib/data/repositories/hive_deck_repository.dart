import 'package:hive/hive.dart';
import '../../domain/entities/deck.dart';
import '../../domain/repositories/deck_repository.dart';
import '../models/deck_model.dart';

class HiveDeckRepository implements DeckRepository {
  final Box<DeckModel> box;

  HiveDeckRepository(this.box);

  @override
  Future<void> addDeck(Deck deck) async {
    await box.put(deck.id, DeckModel.fromEntity(deck));
  }

  @override
  Future<List<Deck>> getAllDecks() async {
    return box.values.map((e) => e.toEntity()).toList();
  }
}
