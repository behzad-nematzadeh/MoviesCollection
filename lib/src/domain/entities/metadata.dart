import 'package:equatable/equatable.dart';

class Metadata<T> extends Equatable {
  final String currentPage;
  final int perPage;
  final int pageCount;
  final int totalCount;

  const Metadata({
    required this.currentPage,
    required this.perPage,
    required this.pageCount,
    required this.totalCount
  });

  @override
  List<Object> get props =>
      [currentPage, perPage, pageCount, totalCount];
}
