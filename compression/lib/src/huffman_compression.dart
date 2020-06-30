import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:picts_manager_huffman_compression/src/utils/binary_tree.dart';
import 'package:picts_manager_huffman_compression/src/utils/image_utils.dart';
import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class HuffmanAlgorithm
{
  Map colorsBinaryCode;

  HuffmanAlgorithm()
  {
    this.colorsBinaryCode = new HashMap();
  }

  String huffmanCompression() {
    ImageUtils imageUtils = new ImageUtils("./img/Lenna.png");
    imageUtils.readImage();
    // set the probabilities of colors redundances
    Map colorsProbability = imageUtils.getColorsProbability();
    // change colors to binary code (String type ...)
    List keys = colorsProbability.keys.toList();
    List values = colorsProbability.values.toList();
    //valeurs de test à décommenter pour vérifier que ça fonctionne bien avec 10 valeurs
    /*keys = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    values = [0.01, 0.02, 0.02, 0.04, 0.10, 0.11, 0.13, 0.12, 0.18, 0.23];*/
    this.createColorsBinaryTreeEquivalent(keys, values);
    // try to write the new image
    //List test = imageUtils.encodeImage(this.colorsBinaryCode);
    //print("FINAL LIST : ${test}");
    return "HUFFMAN COMPRESSION";
  }

  List createColorsBinaryTreeEquivalent(List keys, List values) {
    if (values == null || keys == null)
      {
        print("ERROR NULL : ");
        return null;
      }
    if (values.length <= 2 || keys.length == 0)
    {
      print("VALUES MAX");
      values.forEach((v) => print('${v}'));
      return values;
    }
    //construction de l'arbre en appels récursifs
    if (values.length > 2 && keys.length-1 > 0)
    {
      int i = 0;
      TreeNode rightLeaf = null;
      TreeNode leftLeaf = null;
      if (values[0] is BinaryTree)
      {
        print("BINARY TREE RIGHT");
        rightLeaf = values[0].getFirstNode();
      }
      else {
        print("BINARY LEAF RIGHT");
        print(keys[i]);
        print(values[i]);
        rightLeaf = new TreeNode.leaf(keys[i], values[i]);
        keys.removeAt(i);
        i++;
      }
      if (values[1] is BinaryTree)
      {
        print("BINARY TREE LEFT");
        print(values[1].probability.toString());
        leftLeaf = values[1].getFirstNode();
      }
      else {
        print("BINARY LEAF LEFT");
        leftLeaf = new TreeNode.leaf(keys[1], values[1]);
        keys.removeAt(i);
      }
      //Remplacer les deux premières valeurs de la liste par un sous arbre binaire
      BinaryTree subTree = new BinaryTree(leftLeaf, rightLeaf);
      values.removeAt(1);
      values.removeAt(0);
      List tmp = new List();
      tmp.add(subTree);
      tmp.addAll(values);
      this.createColorsBinaryTreeEquivalent(keys, tmp);
    }
  }
}