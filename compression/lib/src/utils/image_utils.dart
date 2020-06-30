import 'dart:collection';
import 'dart:io';
import 'package:image/image.dart';
import 'package:picts_manager_huffman_compression/src/utils/binary_tree.dart';
import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class ImageUtils
{
  Map colorsProbability;
  final String imagePath;
  Image img;
  int width;
  int height;

  ImageUtils(this.imagePath)
  {
    this.colorsProbability = new HashMap();
  }

  void readImage()
  {
    this.img = decodePng(File(this.imagePath).readAsBytesSync());
    this.setHeight(this.img.height);
    this.setWidth(this.img.width);
    this.setColorsProbabilities();
  }

  void setHeight(int height)
  {
    this.height = height;
  }

  void setWidth(int width)
  {
    this.width = width;
  }

  void setColorsProbabilities()
  {
    int totalPixels = this.width * this.height;

    for (int y = 0; y < this.height; y++)
    {
      for (int x = 0; x < this.width; x++)
      {
        int pixelColor = this.img.getPixel(x, y);
        if (this.colorsProbability.containsKey(pixelColor))
          {
            this.colorsProbability[pixelColor]++;
          }
        else
          {
            this.colorsProbability[pixelColor] = 1;
          }
      }
    }
    this.colorsProbability.forEach((k,v) => this.colorsProbability.update(k, (dynamic v) => v/totalPixels*100));
    this.colorsProbability = this.sortMapByValuesAsc();
    this.colorsProbability.forEach((k,v) => print('${k}: ${v}'));
  }

  List encodeImage(Map colorsBinaryCode)
  {
    List encodedImage = new List();
    for (int y = 0; y < this.height; y++)
    {
      for (int x = 0; x < this.width; x++)
      {
        int pixelColor = this.img.getPixel(x, y);
        encodedImage.add(colorsBinaryCode[pixelColor]);
      }
    }
    Image resultImage = new Image.fromBytes(this.height, this.width, encodedImage);
    return encodePng(resultImage);
  }

  Map sortMapByValuesAsc()
  {
    var sortedEntries = this.colorsProbability.entries.toList()..sort((e1, e2) {
      var diff = e1.value.compareTo(e2.value);
      if (diff == 0) diff = e1.key.compareTo(e2.key);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }

  Map sortMapByValuesDesc()
  {
    var sortedEntries = this.colorsProbability.entries.toList()..sort((e1, e2) {
      var diff = e2.value.compareTo(e1.value);
      if (diff == 0) diff = e2.key.compareTo(e1.key);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }

  Image getImage()
  {
    return (this.img);
  }

  Map getColorsProbability()
  {
    return (this.colorsProbability);
  }

  /*void createColorsBinaryTreeEquivalent(BinaryTree tree)
  {
    var colors = this.colorsProbability.keys.toList();
    var probas = this.colorsProbability.values.toList();
    if (tree == null) {
      tree = new BinaryTree(colors[0], probas[0]);
    }
    print("FIRST NODE : ${tree.firstNode}");
    print("FIRST NODE : ${tree.firstNode.color}");
    print("FIRST NODE : ${tree.firstNode.code}");
    TreeNode tmp = this.addTreeNode(colors, probas, tree.firstNode, 0, tree.firstNode.depth, tree.firstNode.code);
    tree.firstNode = tmp;
    this.inOrder(tree.firstNode);
  }

  void inOrder(TreeNode root)
  {
    if (root != null) {
      inOrder(root.left);
      int color = root.color;
      double probability = root.probability;
      String is_right = root.is_right;
      String code = root.code;
      print("$color : $probability : $is_right : $code");
      inOrder(root.right);
    }
  }

  TreeNode addTreeNode(List colors, List probas, TreeNode rootNode, int i, int depth, String code)
  {
    print("ADD NODE");
    if (i < colors.length)
    {
      //MCMC VERIFIER ROOT NODE BORDELDE CUL
      int color = colors[i];
      double proba = probas[i];
      TreeNode temp = new TreeNode(color, proba, depth+1, code);
      code = code + rootNode.is_right;
      rootNode = temp;

      // insert left child
      print("LEFT");
      rootNode.left = addTreeNode(colors, probas, rootNode.left,
          2 * i + 1, depth+1, code);
      if (rootNode.left != null) {
        rootNode.left.setRight(rootNode.is_right);
        rootNode.left.setCode(code);
      }
      print("RIGHT");
      // insert right child
      rootNode.right = addTreeNode(colors, probas, rootNode.right,
          2 * i + 2, depth+1, code);
      if (rootNode.right != null) {
        rootNode.right.setRight(rootNode.is_right);
        rootNode.right.setCode(code);
      }
    }
    return rootNode;
  }*/
}