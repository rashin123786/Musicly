import 'package:json_annotation/json_annotation.dart';

import 'message.dart';

part 'lyrics_model.g.dart';

@JsonSerializable()
class LyricsModel {
  Message? message;

  LyricsModel({this.message});

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return _$LyricsModelFromJson(json);
  }

  Map<String, dynamic> toJson(data1) => _$LyricsModelToJson(this);
}
