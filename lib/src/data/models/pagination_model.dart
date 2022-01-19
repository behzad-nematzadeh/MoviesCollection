import 'package:moviescollection/src/data/models/metadata_model.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';

class PaginationModel extends Pagination {
  const PaginationModel({
    required List<MovieModel>? data,
    required MetadataModel metadata,
  }) : super(data: data, metadata: metadata);

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      data: (json['data'] as List).map((e) {
        return MovieModel.fromJson(e);
      }).toList(),
      metadata: MetadataModel.fromJson(json['metadata']),
    );
  }
}
