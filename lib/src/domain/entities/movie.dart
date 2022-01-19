import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String poster;
  final String? year;
  final String? rated;
  final String? released;
  final String? runtime;
  final String? director;
  final String? writer;
  final String? actors;
  final String? plot;
  final String? country;
  final String? awards;
  final String? metaScore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? imdbId;
  final String? type;
  final List<dynamic> genres;
  final List<dynamic> images;

  const Movie({
    required this.id,
    required this.title,
    required this.poster,
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.country,
    this.awards,
    this.metaScore,
    this.imdbRating,
    this.imdbVotes,
    this.imdbId,
    this.type,
    required this.genres,
    required this.images,
  });

  @override
  List<Object> get props => [
        id,
        title,
        poster,
        /*year,
        rated,
        released,
        runtime,
        director,
        writer,
        actors,
        plot,
        country,
        awards,
        metaScore,
        imdbRating,
        imdbVotes,
        imdbId,
        type,*/
        genres,
        images,
      ];
}
