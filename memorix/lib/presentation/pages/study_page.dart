import 'package:flutter/material.dart';
import '../../domain/entities/deck.dart';
import '../viewmodels/study_view_model.dart';
import 'add_card_page.dart';
import 'deck_selector_page.dart';
import '../../domain/usecases/get_all_decks.dart';

class StudyPage extends StatefulWidget {
  final String deckId;
  final StudyViewModel viewModel;
  final GetAllDecksUseCase getAllDecks;

  const StudyPage({
    Key? key,
    required this.deckId,
    required this.viewModel,
    required this.getAllDecks,
  }) : super(key: key);
  
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  bool loading = true;
  Deck? selectedDeck;

  @override
  void initState() {
    super.initState();
    _loadDefaultDeck();
    widget.viewModel.loadCards(widget.deckId);
  }

  Future<void> _loadDefaultDeck() async {
    final decks = await widget.getAllDecks();
    if (decks.isNotEmpty) {
      selectedDeck = decks.first;
      await _loadCards();
    }
  }

  Future<void> _loadCards() async {
    if (selectedDeck == null) return;
    setState(() => loading = true);
    await widget.viewModel.loadCards(selectedDeck!.id);
    setState(() => loading = false);
  }

  void _flipCard() {
    setState(() => widget.viewModel.flipCard());
  }

  Future<void> _reviewCard(int quality) async {
    await widget.viewModel.reviewCard(quality);
    setState(() {});
  }

  void _goToAddCard() {
    if (selectedDeck == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCardPage(
          viewModel: widget.viewModel,
          deckId: selectedDeck!.id,
        ),
      ),
    ).then((cardAdded) {
      if (cardAdded == true) {
        _loadCards(); 
      }
    });
  }

  void _goToDeckSelector() async {
    final deck = await Navigator.push<Deck>(
      context,
      MaterialPageRoute(
        builder: (_) => DeckSelectorPage(
          getDecks: widget.getAllDecks,
          onDeckSelected: (selected) {
            Navigator.pop(context, selected);
          },
        ),
      ),
    );

    if (deck != null) {
      setState(() {
        selectedDeck = deck;
      });
      await _loadCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.viewModel.currentCard;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedDeck?.name ?? 'SmartCards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark),
            onPressed: _goToDeckSelector,
            tooltip: 'Seleccionar deck',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : card == null
              ? const Center(child: Text('No hay tarjetas pendientes'))
              : GestureDetector(
                  onTap: _flipCard,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            widget.viewModel.showBack ? card.back : card.front,
                            style: const TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: card == null
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ratingButton('Difícil', 0, Colors.red),
                  _ratingButton('Regular', 2, Colors.orange),
                  _ratingButton('Fácil', 4, Colors.green),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddCard,
        tooltip: 'Agregar tarjeta',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _ratingButton(String label, int score, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      onPressed: () => _reviewCard(score),
      child: Text(label),
    );
  }
}
