enum ServerErrors {
  Unknown, MoreThanOneFace
}

Map<int, ServerErrors> _codeToError = <int, ServerErrors> {
  0x1: ServerErrors.Unknown,
  0x2: ServerErrors.MoreThanOneFace
};

ServerErrors errorCodeToDomain(int code) {
  final ServerErrors? error = _codeToError[code];

  if (error == null) {
    return ServerErrors.Unknown;
  } else {
    return error;
  }
}