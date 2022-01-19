import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tMovieModel = MovieModel(
      id: 1,
      title: "The Shawshank Redemption",
      poster: "tt0111161_poster.jpg",
      year: "1994",
      rated: "R",
      released: "14 Oct 1994",
      runtime: "142 min",
      director: "Frank Darabont",
      writer:
          "Stephen King (short story 'Rita Hayworth and Shawshank Redemption'), Frank Darabont (screenplay)",
      actors: "Tim Robbins, Morgan Freeman, Bob Gunton, William Sadler",
      plot:
          "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
      country: "USA",
      awards: "Nominated for 7 Oscars. Another 19 wins &amp; 30 nominations.",
      metaScore: "80",
      imdbRating: "9.3",
      imdbVotes: "1,738,596",
      imdbId: "tt0111161",
      type: "movie",
      genres: [
        "Crime",
        "Drama"
      ],
      images: [
        "http://moviesapi.ir/images/tt0111161_screenshot1.jpg",
        "http://moviesapi.ir/images/tt0111161_screenshot2.jpg",
        "http://moviesapi.ir/images/tt0111161_screenshot3.jpg"
      ]);

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tMovieModel, isA<Movie>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('movie.json'));
        // act
        final result = MovieModel.fromJson(jsonMap);
        // assert
        expect(result, tMovieModel);
      },
    );
  });
}
