import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:picts_manager_huffman_compression/src/utils/image_utils.dart';

class HuffmanAlgorithm
{
  Map colorsBinaryCode;

  HuffmanAlgorithm()
  {
    this.colorsBinaryCode = new HashMap();
  }

  String huffmanCompression() {
    ImageUtils imageUtils = new ImageUtils("./img/lenna.jpg");
    imageUtils.readImage();
    // set the probabilities of colors redundances
    Map colorsProbability = imageUtils.getColorsProbability();
    // change colors to binary code (String type ...)
    this.createColorsBinaryValuesEquivalent(colorsProbability);
    // try to write the new image
    /*List test = imageUtils.encodeImage(this.colorsBinaryCode);
    print("FINAL LIST : ${test}");*/
    return "HUFFMAN COMPRESSION";
  }

  void createColorsBinaryValuesEquivalent(Map colorsProbability) {
    int base = 2;
    List keys = colorsProbability.keys.toList();
    for (int i = 1; i <= keys.length; i++) {
      this.colorsBinaryCode[keys[i - 1]] = i.toRadixString(base);
    }
    this.colorsBinaryCode.forEach((k, v) => print('${k}: ${v}'));
  }
}