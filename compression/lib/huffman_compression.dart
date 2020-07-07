import "src/huffman_compression.dart";

export 'src/huffman_compression.dart';

String compress(String srcFile, String destFile)
{
  HuffmanAlgorithm huffmanAlgorithm = new HuffmanAlgorithm();
  return huffmanAlgorithm.huffmanCompression(srcFile, destFile);
}