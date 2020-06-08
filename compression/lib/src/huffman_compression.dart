import 'package:picts_manager_huffman_compression/src/utils/image_utils.dart';

String huffmanCompression()
{
  ImageUtils imageUtils = new ImageUtils("./img/lenna.jpg");
  imageUtils.readImage();
  return "HUFFMAN COMPRESSION";
}
