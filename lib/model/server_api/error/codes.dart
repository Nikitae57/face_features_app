enum ServerErrors {
  Unknown, MoreThanOneFace, NoFaces
}

Map<int, ServerErrors> _codeToError = <int, ServerErrors> {
  0x1: ServerErrors.Unknown,
  0x2: ServerErrors.MoreThanOneFace,
  0x3: ServerErrors.NoFaces
};

ServerErrors errorCodeToDomain(int code) {
  final ServerErrors? error = _codeToError[code];

  if (error == null) {
    return ServerErrors.Unknown;
  } else {
    return error;
  }
}