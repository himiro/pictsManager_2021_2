import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class BinaryTree
{
  TreeNode firstNode;
  double probability;

  BinaryTree(TreeNode left, TreeNode right)
  {
    probability = left.probability + right.probability;
    this.firstNode = new TreeNode.node(left, right, probability);
  }

  TreeNode getFirstNode()
  {
    return (this.firstNode);
  }
}