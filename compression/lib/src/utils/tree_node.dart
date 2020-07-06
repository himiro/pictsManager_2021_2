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

  TreeNode.node(TreeNode left, TreeNode right)
  {
    this.color = null;
    this.probability = left.probability + right.probability;
    this.left = left;
    this.right = right;
  }

  void describeTreeNode(bool recursif, int count)
  {
    print("-----------");
    print("TreeNode ${count} : ");
    print(this.color);
    print(this.probability);
    if (recursif == true)
      {
        if (this.left != null) {
          this.left.describeTreeNode(recursif, count+1);
        }
        if (this.right != null) {
          this.right.describeTreeNode(recursif, count+1);
        }
      }
    print("-----------");
  }
}