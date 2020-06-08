import 'dart:collection';
import 'dart:io';
import 'package:image/image.dart';

class ImageUtils
{
  Map colorsProbability;
  final String imagePath;
  Image img;

  ImageUtils(this.imagePath)
  {
    this.colorsProbability = new HashMap();
  }

  void readImage()
  {
    this.img = decodeJpg(File(this.imagePath).readAsBytesSync());
    this.fillSortedProbabilities();
    //print("IMAGE : ");
  }

  void fillSortedProbabilities()
  {
    int height = this.img.height;
    int width = this.img.width;
    int totalPixels = width * height;

    for (int y = 0; y < height; y++)
    {
      for (int x = 0; x < width; x++)
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
    this.colorsProbability = this.sortMapByValues();
    //this.colorsProbability.forEach((k,v) => print('${k}: ${v}'));
    //print(totalPixels);
  }

  Map sortMapByValues()
  {
    var sortedEntries = this.colorsProbability.entries.toList()..sort((e1, e2) {
      var diff = e1.value.compareTo(e2.value);
      if (diff == 0) diff = e1.key.compareTo(e2.key);
      return diff;
    });

    return (Map.fromEntries(sortedEntries));
  }
}