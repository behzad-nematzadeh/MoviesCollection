import 'package:equatable/equatable.dart';
import 'package:moviescollection/src/domain/entities/metadata.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';

class Pagination extends Equatable {
  final List<Movie>? data;
  final Metadata metadata;

  const Pagination({this.data, required this.metadata});

  @override
  List<Object> get props => [data!, metadata];
}
