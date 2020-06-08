import 'dart:typed_data';

import 'package:picts_manager_huffman_compression/src/utils/image_utils.dart';

String huffmanCompression()
{
  ImageUtils imageUtils = new ImageUtils("./img/lenna.jpg");
  imageUtils.readImage();
  /*print(ByteData(0));
  print(ByteData(1));
  print(ByteData(2));
  print(ByteData(3));*/
  return "HUFFMAN COMPRESSION";
}