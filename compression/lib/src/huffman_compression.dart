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

  String huffmanCompression() {
    ImageUtils imageUtils = new ImageUtils("./img/Lenna.png");
    imageUtils.readImage();
    // set the probabilities of colors frequencies
    Map colorsProbability = imageUtils.getColorsProbability();
    // change colors to binary code (String type ...)
    List keys = colorsProbability.keys.toList();
    List values = colorsProbability.values.toList();
    TreeNode root = this.createColorsBinaryTreeEquivalent(keys, values);
    //try to write the new image
    String header = imageUtils.headerBinaryTree(root, "");
    print("HEADER : ${header}");
    //List test = imageUtils.encodeImage(this.colorsBinaryCode);
    //print("FINAL LIST : ${test}");
    return "HUFFMAN COMPRESSION";
  }

  // RightNode = 1 and LeftNode = 0
  TreeNode createColorsBinaryTreeEquivalent(List keys, List values)
  {
    print("BINARY TREE UNDER CONSTRUCTION PLEASE WAIT");
    while (values.length > 1)
      {
        TreeNode newNode = null;
        if (values[0] is double) {
          TreeNode left = new TreeNode.leaf(keys[0], values[0]);
          keys.removeAt(0);

          TreeNode right = null;
          if (keys.length > 1) {
            right = new TreeNode.leaf(keys[1], values[1]);
            keys.removeAt(1);
          }
          else
            {
              right = new TreeNode.node(left, values[1]);
            }
          newNode = TreeNode.node(left, right);
        }
        else
          {
            newNode = new TreeNode.node(values[0], values[1]);
          }
        values.add(newNode);
        values.removeAt(1);
        values.removeAt(0);
      }
      print("LENGTH : ${values.length}");
    return values[0];
  }

}