class TreeNode
{
  int color;
  double probability;
  TreeNode left;
  TreeNode right;

  TreeNode.leaf(int color, double probability)
  {
    this.color = color;
    this.probability = probability;
    this.left = null;
    this.right = null;
  }

  TreeNode.node(TreeNode left, TreeNode right, double probability)
  {
    this.color = null;
    this.probability = probability;
    this.left = left;
    this.right = right;
  }

  void describeTreeNode()
  {
    print("TreeNode : ");
    print(this.color);
    print(this.probability);
    print("-----------");
  }
}