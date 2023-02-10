import 'package:hive_flutter/adapters.dart';
part 'musicly_model.g.dart';

@HiveType(typeId: 1)
class MusiclyModel extends HiveObject {
  MusiclyModel({required this.name, required this.songId});
  @HiveField(0)
  String name;
  @HiveField(1)
  List<int> songId;
  add(int id) async {
    songId.add(id);
    save();
  }

  deleteData(int id) {
    songId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songId.contains(id);
  }
}
