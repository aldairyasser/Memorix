import '../entities/deck.dart';
import '../repositories/deck_repository.dart';

class GetAllDecksUseCase {
  final DeckRepository repository;

  GetAllDecksUseCase(this.repository);

  Future<List<Deck>> call() => repository.getAllDecks();
}
