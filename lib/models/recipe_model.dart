import 'dart:typed_data';

import 'package:hive/hive.dart';

import 'category_model.dart';

// TODO: Poll said remove g files from Git Repo

@HiveType(typeId: 1)
class RecipeModel extends HiveObject {
  RecipeModel(this.name, this.image, {this.id, this.isFavorite = false});
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List image;

  @HiveField(3)
  bool isFavorite;
}

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final typeId = 0;

  @override
  CategoryModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryModel(
      fields[0] as String,
      imageUrl: fields[1] as String,
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    /*  writer
    ..writeByte(3)
    ..writeByte(0)
    ..writeByte(obj.name)
    ..writeByte(1)
    ..writeByte(obj.imageUrl)
    ..writeByte(2)
    ..writeByte(id) */
  }
}
