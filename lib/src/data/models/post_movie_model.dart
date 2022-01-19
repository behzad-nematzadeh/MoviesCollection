import 'package:moviescollection/src/domain/entities/post_movie.dart';

class PostMovieModel extends PostMovie {
  const PostMovieModel({
    int? id,
    required String title,
    dynamic poster,
    required int year,
    String? director,
    required String country,
    String? imdbRating,
    String? imdbVotes,
    required String imdbId,
  }) : super(
            id: id,
            title: title,
            poster: poster,
            year: year,
            director: director,
            country: country,
            imdbRating: imdbRating,
            imdbVotes: imdbVotes,
            imdbId: imdbId);

  factory PostMovieModel.fromJson(Map<String, dynamic> json) => PostMovieModel(
        id: json['id'] as int,
        title: json['title'] as String,
        poster: json['poster'] as String,
        year: json['year'] as int,
        director: json['director'] as String,
        country: json['country'] as String,
        imdbRating: json['imdb_rating'] as String,
        imdbVotes: json['imdb_votes'] as String,
        imdbId: json['imdb_id'] as String,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'imdb_id': imdbId,
        'country': country,
        'year': year,
        'director': director,
        'imdb_rating': imdbRating,
        'imdb_votes': imdbVotes,
        'poster': poster,
      };
}
