import 'dart:io';

import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/data/models/pagination_model.dart';
import 'package:moviescollection/src/data/models/post_movie_model.dart';

import 'api_provider.dart';

abstract class MovieRemoteDataSource {
  Future<PaginationModel> getMovies([int pageNumber = 1]);

  Future<MovieModel> getMovieInfo(int movieId);

  Future<PostMovieModel> addMovie(PostMovieModel postMovieModel);

  Future<PaginationModel> searchMovie(String movieName,
      [int pageNumber = 1]);

  Future<PaginationModel> getMoviesByGenreId(int genreId,
      [int pageNumber = 1]);
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final ApiProvider apiProvider;

  MovieRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<PostMovieModel> addMovie(PostMovieModel postMovieModel) {
    if (postMovieModel.poster is File || postMovieModel.poster is String) {
      String path = 'api/v1/movies';
      if (postMovieModel.poster is File) path = 'api/v1/movies/multi';
      return _getDataFromUrl<PostMovieModel>(
          apiProvider.postRequest(path, postMovieModel.toJson()),
          (data) => PostMovieModel.fromJson(data));
    } else {
      throw ServerException(
          code: HttpError.invalidArgument.value,
          message: HttpError.invalidArgument.name);
    }
  }

  @override
  Future<MovieModel> getMovieInfo(int movieId) => _getDataFromUrl<MovieModel>(
      apiProvider.getRequest('api/v1/movies/${movieId.toString()}'),
      (data) => MovieModel.fromJson(data));

  @override
  Future<PaginationModel> getMovies([int pageNumber = 1]) =>
      _getDataFromUrl<PaginationModel>(
          apiProvider.getRequest('api/v1/movies?page=$pageNumber'),
          (pagination) => PaginationModel.fromJson(pagination));

  @override
  Future<PaginationModel> searchMovie(String movieName, [int pageNumber = 1]) =>
      _getDataFromUrl<PaginationModel>(
          apiProvider.getRequest('api/v1/movies?q=$movieName&page=$pageNumber'),
          (pagination) => PaginationModel.fromJson(pagination));

  @override
  Future<PaginationModel> getMoviesByGenreId(int genreId,
          [int pageNumber = 1]) =>
      _getDataFromUrl<PaginationModel>(
          apiProvider
              .getRequest('api/v1/genres/$genreId/movies?page=$pageNumber'),
          (pagination) {
            return PaginationModel.fromJson(pagination);
          });

  Future<T> _getDataFromUrl<T>(Future request, Function(dynamic) func) async {
    var response = await request;
    return func(response);
  }
}
