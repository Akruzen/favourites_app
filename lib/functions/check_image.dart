import 'dart:io';

import 'package:flutter/material.dart';

FileImage loadImage (String filePath) {
  return FileImage(File(filePath));
}