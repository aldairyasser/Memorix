import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/deck.dart';
import '../../domain/usecases/get_all_decks.dart';
import '../../data/models/deck_model.dart';
import 'package:hive/hive.dart';

class DeckSelectorPage extends StatefulWidget {
  final GetAllDecksUseCase getDecks;
  final Function(Deck) onDeckSelected;

  const DeckSelectorPage({super.key, required this.getDecks, required this.onDeckSelected});

  @override
  State<DeckSelectorPage> createState() => _DeckSelectorPageState();
}

class _DeckSelectorPageState extends State<DeckSelectorPage> {
  List<Deck> decks = [];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  void _loadDecks() async {
    final list = await widget.getDecks();
    setState(() {
      decks = list;
    });
  }

  void _createDeck() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    final newDeck = Deck(id: const Uuid().v4(), name: name);
    await Hive.box<DeckModel>('decks').put(newDeck.id, DeckModel.fromEntity(newDeck));
    _controller.clear();
    _loadDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un deck')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nuevo deck',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _createDeck,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: decks.length,
                itemBuilder: (_, i) {
                  final deck = decks[i];
                  return ListTile(
                    title: Text(deck.name),
                    onTap: () {
                      widget.onDeckSelected(deck);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}