import 'package:meta/meta.dart';

@immutable
class UserImage {
  const UserImage(this.path);
  final String path;
}