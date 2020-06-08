import 'dart:collection';
import 'dart:io';
import 'package:image/image.dart';

class ImageUtils
{
  Map colorsProbability;
  final String imagePath;
  Image img;
  Map colorsBinaryCode;

  ImageUtils(this.imagePath)
  {
    this.colorsProbability = new HashMap();
    this.colorsBinaryCode = new HashMap();
  }

  void readImage()
  {
    this.img = decodeJpg(File(this.imagePath).readAsBytesSync());
    this.fillSortedProbabilities();
    this.createColorsBinaryEquivalent();
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
    this.colorsProbability = this.sortMapByValuesDesc();
    //this.colorsProbability.forEach((k,v) => print('${k}: ${v}'));
    //print(totalPixels);
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

  void createColorsBinaryEquivalent()
  {
    int base = 2;
    List keys = this.colorsProbability.keys.toList();

    for (int i = 1; i <= keys.length; i++) {
      this.colorsBinaryCode[keys[i-1]] = i.toRadixString(base);
    }
    this.colorsBinaryCode.forEach((k,v) => print('${k}: ${v}'));
  }
}