import 'package:hive/hive.dart';
import '../../domain/entities/deck.dart';
part 'deck_model.g.dart';

@HiveType(typeId: 1)
class DeckModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  DeckModel({required this.id, required this.name});

  Deck toEntity() => Deck(id: id, name: name);

  factory DeckModel.fromEntity(Deck entity) =>
      DeckModel(id: entity.id, name: entity.name);
}
