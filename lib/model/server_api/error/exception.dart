import 'dart:io';

class NetworkException extends IOException {}

class UploadImageException extends NetworkException {}

class DownloadImageException extends NetworkException {}
