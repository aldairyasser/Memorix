import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/flashcard.dart';
import '../viewmodels/study_view_model.dart';

class AddCardPage extends StatefulWidget {
  final StudyViewModel viewModel;
  final String deckId;

  const AddCardPage({
    super.key,
    required this.viewModel,
    required this.deckId,
  });

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  void _saveCard() async {
    final front = _frontController.text.trim();
    final back = _backController.text.trim();
    if (front.isEmpty || back.isEmpty) return;

    final newCard = Flashcard(
      id: const Uuid().v4(),
      front: front,
      back: back,
      easeFactor: 250,
      nextReview: DateTime.now(),
      repetitions: 0,
      deckId: widget.deckId,
    );

    await widget.viewModel.createCard(widget.deckId, newCard);
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Tarjeta')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _frontController,
              decoration: const InputDecoration(labelText: 'Frente'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _backController,
              decoration: const InputDecoration(labelText: 'Reverso'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveCard,
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
