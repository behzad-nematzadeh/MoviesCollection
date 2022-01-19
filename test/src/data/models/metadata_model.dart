import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/metadata_model.dart';
import 'package:moviescollection/src/domain/entities/metadata.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tMetadataModel =
      MetadataModel(currentPage: "1", perPage: 2, pageCount: 25, totalCount: 250);

  test('should be a subclass of Auth entity', () async {
    // assert
    expect(tMetadataModel, isA<Metadata>());
  });

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('metadata.json'));
        // act
        final result = MetadataModel.fromJson(jsonMap);
        // assert
        expect(result, tMetadataModel);
      },
    );
  });
}
