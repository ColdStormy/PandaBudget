import 'dart:io';
import 'dart:typed_data';

Uint8List fixtureBytes(String name) =>
    File('test/fixtures/$name').readAsBytesSync();
