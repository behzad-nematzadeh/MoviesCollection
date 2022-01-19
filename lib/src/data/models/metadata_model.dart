import '../../domain/entities/metadata.dart';

class MetadataModel<T> extends Metadata<T> {
  const MetadataModel({
    required String currentPage,
    required int perPage,
    required int pageCount,
    required int totalCount,
  }) : super(
            currentPage: currentPage,
            perPage: perPage,
            pageCount: pageCount,
            totalCount: totalCount);

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel<T>(
        currentPage: json['current_page'] as String,
        perPage: json['per_page'] as int,
        pageCount: json['page_count'] as int,
        totalCount: json['total_count'] as int);
  }
}
