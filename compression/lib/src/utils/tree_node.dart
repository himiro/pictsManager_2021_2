class TreeNode
{
  Map value;
  TreeNode left;
  TreeNode right;

  //Syntaxic sugar
  TreeNode(String code, String color, double probability)
  {
    this.value = new Map();
    value['code'] = code;
    value['color'] = color;
    value['probability'] = probability;

  }

  void describeTreeNode()
  {
    print("TreeNode : ");
    this.value.forEach((k,v) => print('${k}: ${v}'));
    print("-----------");
  }
}