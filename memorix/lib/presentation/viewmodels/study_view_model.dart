import '../../domain/entities/flashcard.dart';
import '../../domain/usecases/get_due_flashcards.dart';
import '../../domain/usecases/update_flashcard_review.dart';
import '../../domain/usecases/add_flashcard.dart';


class StudyViewModel {
  final GetDueFlashcardsUseCase getDueFlashcards;
  final UpdateFlashcardReviewUseCase updateFlashcardReview;
  final AddFlashcardUseCase addFlashcard;


  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _showBack = false;

  StudyViewModel({
    required this.getDueFlashcards,
    required this.updateFlashcardReview,
    required this.addFlashcard,
  });

  List<Flashcard> get cards => _cards;
  int get currentIndex => _currentIndex;
  bool get showBack => _showBack;

  Flashcard? get currentCard =>
      (_cards.isNotEmpty && _currentIndex < _cards.length) ? _cards[_currentIndex] : null;

  Future<void> loadCards(String deckId) async {
    _cards = await getDueFlashcards(deckId);
    _currentIndex = 0;
    _showBack = false;
  }

  void flipCard() {
    _showBack = !_showBack;
  }

  Future<void> reviewCard(int quality) async {
    final card = currentCard;
    if (card == null) return;

    await updateFlashcardReview(card.id, quality);

    _currentIndex++;
    _showBack = false;
  }

  Future<void> createCard(String deckId, Flashcard card) async {
    await addFlashcard(deckId, card);
  }
}