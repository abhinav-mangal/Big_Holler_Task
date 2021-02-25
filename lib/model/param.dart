import 'dart:io';
import '../imports.dart';

class Param {
  Metadata metadata;
  Location location;
  Position position;
  User user;
  bool isLoginSuccessfully;
  Directory dir;
  Metadatas metadatas;

  Param(
    this.metadata,
    this.metadatas,
    this.location, {
    this.position,
    this.user,
    this.dir,
    this.isLoginSuccessfully,
  });
}
