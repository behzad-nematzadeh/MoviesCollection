enum HttpError {
  invalidArgument,
  noConnection,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  unProcessableEntity,
  internalError,
  unavailable,
}

extension HttpErrorExtension on HttpError {
  int get value {
    switch (this) {
      case HttpError.invalidArgument:
        return 100;
      case HttpError.noConnection:
        return 101;
      case HttpError.badRequest:
        return 400;
      case HttpError.unauthorized:
        return 401;
      case HttpError.forbidden:
        return 403;
      case HttpError.notFound:
        return 404;
      case HttpError.unProcessableEntity:
        return 422;
      case HttpError.internalError:
        return 500;
      case HttpError.unavailable:
        return 503;
      default:
        return 500;
    }
  }

  String get name {
    switch (this) {
      case HttpError.invalidArgument:
        return 'invalidArgument !';
      case HttpError.noConnection:
        return 'check network connection !';
      case HttpError.badRequest:
        return 'bad request !';
      case HttpError.unauthorized:
        return 'un authorize request!';
      case HttpError.forbidden:
        return 'forbidden request !';
      case HttpError.notFound:
        return 'service not found !';
      case HttpError.unProcessableEntity:
        return 'The email has already been taken !';
      case HttpError.internalError:
      case HttpError.unavailable:
      default:
        return 'server not found !';
    }
  }
}
