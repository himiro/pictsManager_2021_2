class TreeNode
{
  int color;
  double probability;
  String is_right;
  String code;
  TreeNode left;
  TreeNode right;
  int depth;

  TreeNode(int color, double probability, int depth, Stringcode)
  {
    this.color = color;
    this.probability = probability;
    this.is_right = '0';
    this.left = null;
    this.right = null;
    this.depth = 0;
    if (code == null)
      this.code = this.is_right;
    else
      {
        this.code = code;
      }
  }

  void setRight(String is_right)
  {
    this.is_right = is_right;
  }

  void setCode(String code)
  {
    this.code = code + this.is_right;
  }

  void describeTreeNode()
  {
    print("TreeNode : ");
    print(this.color);
    print(this.probability);
    print("-----------");
  }
}