import 'package:moviescollection/src/domain/entities/genre.dart';

class GenreModel extends Genre {
  const GenreModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      GenreModel(id: json['id'] as int, name: json['name'] as String);
}
