import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/src/data/datasources/remote/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:moviescollection/src/data/datasources/remote/genre_remote_data_source.dart';
import 'package:moviescollection/src/data/models/genre_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'genre_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late GenreRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  late ApiProvider apiProvider;

  setUp(() {
    mockClient = MockClient();
    apiProvider = ApiProvider(httpClient: mockClient);
    dataSource = GenreRemoteDataSourceImpl(apiProvider: apiProvider);
  });

  void setUpMockHttpClientGetSuccess200({required String jsonResult}) {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture(jsonResult), 200));
  }

  void setUpMockHttpClientGetFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('genre', () {
    test('should return List of Genres when the response code is 200 (success)',
        () async {
      final genres = json
          .decode(fixture('genre_list.json'))
          .map((data) => GenreModel.fromJson(data))
          .toList();

      // arrange
      setUpMockHttpClientGetSuccess200(jsonResult: 'genre_list.json');
      // act
      final result = await dataSource.getGenres();
      // assert
      expect(result, equals(genres));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientGetFailure404();
        // act
        final call = dataSource.getGenres;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
