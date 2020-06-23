import "src/huffman_compression.dart";

export 'src/huffman_compression.dart';

String compress()
{
  HuffmanAlgorithm huffmanAlgorithm = new HuffmanAlgorithm();

  return huffmanAlgorithm.huffmanCompression();
}