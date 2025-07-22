import 'package:flutter/material.dart';
import 'core/di_container.dart';
import 'core/hive_init.dart';
import 'presentation/pages/deck_selector_page.dart';
import 'presentation/pages/study_page.dart';
import 'domain/entities/deck.dart';
import 'domain/usecases/get_all_decks.dart';
import 'presentation/viewmodels/study_view_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  await initDI();

  runApp(const SmartCardsApp());
}

class SmartCardsApp extends StatelessWidget {
  const SmartCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartCards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeRouter(),
    );
  }
}

class HomeRouter extends StatelessWidget {
  const HomeRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return DeckSelectorPage(
      getDecks: sl<GetAllDecksUseCase>(),
      onDeckSelected: (Deck selectedDeck) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => StudyPage(
              deckId: selectedDeck.id,
              viewModel: sl<StudyViewModel>(),
              getAllDecks: sl<GetAllDecksUseCase>(),
            ),
          ),
        );
      },
    );
  }
}
