import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class BinaryTree
{
  TreeNode firstNode;

  BinaryTree(int color, double proba)
  {
    this.firstNode = new TreeNode(color, proba, 0, null);
  }
}