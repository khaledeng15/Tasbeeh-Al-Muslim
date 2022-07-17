abstract class ApiException implements Exception {

  // static String toErrorMessage(Object error) {
  //   if (error is ApiException) {
  //     if (error is ConnectionException) {
  //       return Strings.connectionError;
  //     } else if (error is ClientErrorException) {
  //       return Strings.clientError;
  //     } else if (error is ServerErrorException) {
  //       return Strings.serverError;
  //     } else if (error is EmptyResultException) {
  //       return Strings.emptyResultError;
  //     } else {
  //       return Strings.unknownError;
  //     }
  //   } else {
  //     return Strings.unknownError;
  //   }
  // }
}

class EmptyResultException extends ApiException {}

class ConnectionException extends ApiException {}

class ServerErrorException extends ApiException {}

class ClientErrorException extends ApiException {}

class UnknownException extends ApiException {}
