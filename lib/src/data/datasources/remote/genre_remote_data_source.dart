import 'package:moviescollection/src/data/models/genre_model.dart';

import 'api_provider.dart';

abstract class GenreRemoteDataSource {
  Future<List<GenreModel>> getGenres();
}

class GenreRemoteDataSourceImpl extends GenreRemoteDataSource {
  final ApiProvider apiProvider;

  GenreRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<List<GenreModel>> getGenres() => _getDataFromUrl<List<GenreModel>>(
      apiProvider.getRequest('api/v1/genres'),
      (data) =>
          (data as List).map((model) => GenreModel.fromJson(model)).toList());

  Future<T> _getDataFromUrl<T>(Future request, Function(dynamic) func) async {
    var response = await request;
    return func(response);
  }
}
