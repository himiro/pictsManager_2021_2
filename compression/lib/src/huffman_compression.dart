import 'dart:collection';

import 'package:picts_manager_huffman_compression/src/utils/image_utils.dart';
import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class HuffmanAlgorithm
{
  Map colorsBinaryCode;
  bool lossy;

  HuffmanAlgorithm()
  {
    this.lossy = false;
    this.colorsBinaryCode = new HashMap();
  }

  void setLossy(bool lossy)
  {
    this.lossy = lossy;
  }

  String huffmanCompression(String srcFile, String destFile) {
    ImageUtils imageUtils = new ImageUtils(srcFile);
    if (imageUtils.readImage() == false)
      {
        return "THE IMAGE MUST BE .PNG OR .JPG";
      }
    // set the probabilities of colors frequencies
    Map colorsProbability = imageUtils.getColorsProbability();
    List keys = colorsProbability.keys.toList();
    List values = colorsProbability.values.toList();
    //Binary tree creation
    TreeNode root = this.createColorsBinaryTreeEquivalent(keys, values, imageUtils);
    //write the compressed image
    imageUtils.encodeImage(root, destFile);
    return "HUFFMAN COMPRESSION DONE";
  }

  // RightNode = 1 and LeftNode = 0
  TreeNode createColorsBinaryTreeEquivalent(List keys, List values, ImageUtils imageUtils)
  {
    print("BINARY TREE UNDER CONSTRUCTION PLEASE WAIT");
    while (values.length > 1) {
      TreeNode newNode = null;
      if (values[0] is double) {
        TreeNode left = new TreeNode.leaf(keys[0], values[0]);
        keys.removeAt(0);

        TreeNode right = null;
        if (keys.length > 1) {
          right = new TreeNode.leaf(keys[1], values[1]);
          keys.removeAt(1);
        }
        else {
          if (values[1] is TreeNode) {
            right = new TreeNode.node(left, values[1]);
          }
          else
            {
              right = new TreeNode.leaf(keys[0], values[1]);
              keys.removeAt(0);
            }
        }
        left.setEncoding(left.encoding + '0');
        right.setEncoding(right.encoding + '1');
        newNode = TreeNode.node(left, right);
        if (left.color != null) {
          imageUtils.encodingTable[left.color] = left.encoding;
        }
        if (right.color != null) {
          imageUtils.encodingTable[right.color] = right.encoding;
        }
      }
      else {
        newNode = new TreeNode.node(values[0], values[1]);
      }
      values.add(newNode);
      values.removeAt(1);
      values.removeAt(0);
    }
    return values[0];
  }
}