import 'package:equatable/equatable.dart';

class PostMovie extends Equatable {
  final int? id;
  final String title;
  final dynamic poster;
  final int year;
  final String? director;
  final String country;
  final String? imdbRating;
  final String? imdbVotes;
  final String imdbId;

  const PostMovie({
    this.id,
    required this.title,
    this.poster,
    required this.year,
    this.director,
    required this.country,
    this.imdbRating,
    this.imdbVotes,
    required this.imdbId,
  });

  @override
  List<Object> get props => [
        id!,
        title,
        poster!,
        year,
        director!,
        country,
        imdbRating!,
        imdbVotes!,
        imdbId,
      ];
}
