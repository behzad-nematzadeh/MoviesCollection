import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/failures.dart';

class WrapperException {
  static Failure badRequest() =>
      ServerFailure(HttpError.badRequest.value, HttpError.badRequest.name);

  static Failure handleWrapperException(HttpError httpError) =>
      ServerFailure(httpError.value, httpError.name);
}
