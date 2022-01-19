import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/metadata_model.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/data/models/pagination_model.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tMovieModel = MovieModel(
      id: 1,
      title: "The Shawshank Redemption",
      poster: "http://moviesapi.ir/images/tt0111161_poster.jpg",
      genres: [
        "Crime",
        "Drama"
      ],
      images: [
        "http://moviesapi.ir/images/tt0111161_screenshot1.jpg",
        "http://moviesapi.ir/images/tt0111161_screenshot2.jpg",
        "http://moviesapi.ir/images/tt0111161_screenshot3.jpg"
      ]);

  const tMetadataModel =
      MetadataModel(currentPage: "1", perPage: 2, pageCount: 25, totalCount: 250);
  const tPaginationModel =
      PaginationModel(data: [tMovieModel], metadata: tMetadataModel);

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tPaginationModel, isA<Pagination>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('pagination_movie.json'));
        // act
        final result = PaginationModel.fromJson(jsonMap);
        // assert
        expect(result, tPaginationModel);
      },
    );
  });
}
