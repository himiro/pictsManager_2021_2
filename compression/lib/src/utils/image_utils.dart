import 'dart:collection';
import 'dart:io';
import 'package:image/image.dart';
import 'package:picts_manager_huffman_compression/src/utils/tree_node.dart';

class ImageUtils
{
  Map colorsProbability;
  Map encodingTable;
  final String imagePath;
  Image img;
  int width;
  int height;

  ImageUtils(this.imagePath)
  {
    this.colorsProbability = new HashMap();
    this.encodingTable = new HashMap();
  }

  bool readImage()
  {
    String extension = this.imagePath.substring(this.imagePath.length - 3);
    if (extension == 'png')
      {
        this.img = decodePng(File(this.imagePath).readAsBytesSync());
      }
    else if (extension == 'jpg')
      {
        this.img = decodeJpg(File(this.imagePath).readAsBytesSync());
      }
    else
      {
        return false;
      }
    this.setHeight(this.img.height);
    this.setWidth(this.img.width);
    this.setColorsProbabilities();
    return true;
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
    this.colorsProbability = this.sortMapByValuesAsc(this.colorsProbability);
  }

  List encodeImage(TreeNode root, String destFile)
  {
    var destImage = new File(destFile);
    print("COMPRESSING IMAGE. PLEASE WAIT IT CAN TAKE FEW MINUTES");
    this.encodingTable = this.sortMapByKeysAsc(this.encodingTable);
    destImage.writeAsStringSync(this.generateHeaderTree());
    print("WRITING IMAGE. PLEASE WAIT");
    for (int y = 0; y < this.height; y++)
    {
      for (int x = 0; x < this.width; x++)
      {
        int pixelColor = this.img.getPixel(x, y);
        destImage.writeAsStringSync(this.encodingTable[pixelColor], mode: FileMode.append);
      }
    }
  }

  String generateHeaderTree()
  {
    String res = "";
    this.encodingTable.forEach((k, v) {
      res = res + v;
    });
    return res;
  }

  Map sortMapByKeysAsc(Map map)
  {
    var sortedEntries = map.entries.toList()..sort((e1, e2) {
      var diff = e1.key.compareTo(e2.key);
      if (diff == 0) diff = e1.value.compareTo(e2.value);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }


  Map sortMapByKeysDesc(Map map)
  {
    var sortedEntries = map.entries.toList()..sort((e1, e2) {
      var diff = e2.key.compareTo(e1.key);
      if (diff == 0) diff = e2.value.compareTo(e1.value);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }

  Map sortMapByValuesAsc(Map map)
  {
    var sortedEntries = map.entries.toList()..sort((e1, e2) {
      var diff = e1.value.compareTo(e2.value);
      if (diff == 0) diff = e1.key.compareTo(e2.key);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }

  Map sortMapByValuesDesc(Map map)
  {
    var sortedEntries = map.entries.toList()..sort((e1, e2) {
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
}