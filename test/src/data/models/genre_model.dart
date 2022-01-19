import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/genre_model.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Crime');

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tGenreModel, isA<Genre>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('genre.json'));
        // act
        final result = GenreModel.fromJson(jsonMap);
        // assert
        expect(result, tGenreModel);
      },
    );
  });
}
