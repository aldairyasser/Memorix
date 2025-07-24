import '../entities/deck.dart';

abstract class DeckRepository {
  Future<void> addDeck(Deck deck);
  Future<List<Deck>> getAllDecks();
}