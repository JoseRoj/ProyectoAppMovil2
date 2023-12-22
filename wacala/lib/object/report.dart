import 'dart:convert';

class Report {
  String id;
  String sector;
  Autor autor;
  DateTime date;
  String description;
  List<String> images;
  int still;
  int notStill;
  List<Comment> comment;
  int v;

  Report({
    required this.id,
    required this.sector,
    required this.autor,
    required this.date,
    required this.description,
    required this.images,
    required this.still,
    required this.notStill,
    required this.comment,
    required this.v,
  });

  factory Report.fromRawJson(String str) => Report.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["_id"],
        sector: json["sector"],
        autor: Autor.fromJson(json["autor"]),
        date: DateTime.parse(json["date"]),
        description: json["description"],
        images: List<String>.from(json["images"]),
//List<String>.from(json["images"].map((x) => x)),
        still: json["still"],
        notStill: json["notStill"],
        comment:
            List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sector": sector,
        "autor": autor.toJson(),
        "date": date.toIso8601String(),
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "still": still,
        "notStill": notStill,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
        "__v": v,
      };
}

class Autor {
  String id;
  String username;

  Autor({
    required this.id,
    required this.username,
  });

  factory Autor.fromRawJson(String str) => Autor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Autor.fromJson(Map<String, dynamic> json) => Autor(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}

class Comment {
  Autor autor;
  DateTime date;
  String description;
  String id;

  Comment({
    required this.autor,
    required this.date,
    required this.description,
    required this.id,
  });

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        autor: Autor.fromJson(json["autor"]),
        date: DateTime.parse(json["date"]),
        description: json["description"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "autor": autor.toJson(),
        "date": date.toIso8601String(),
        "description": description,
        "_id": id,
      };
}

/*import 'dart:convert';

class Report {
  String id;
  String sector;
  Autor autor;
  DateTime date;
  String description;
  List<String> images;
  int still;
  int notStill;
  List<dynamic> comment;
  int v;

  Report({
    required this.id,
    required this.sector,
    required this.autor,
    required this.date,
    required this.description,
    required this.images,
    required this.still,
    required this.notStill,
    required this.comment,
    required this.v,
  });

  factory Report.fromRawJson(String str) => Report.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["_id"],
        sector: json["sector"],
        autor: Autor.fromJson(json["autor"]),
        date: DateTime.parse(json["date"]),
        description: json["description"],
        images: List<String>.from(json["images"].map((x) => x)),
        still: json["still"],
        notStill: json["notStill"],
        comment:
            List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sector": sector,
        "autor": autor.toJson(),
        "date": date.toIso8601String(),
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "still": still,
        "notStill": notStill,
        "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
        "__v": v,
      };
}

class Autor {
  String id;
  String username;

  Autor({
    required this.id,
    required this.username,
  });

  factory Autor.fromRawJson(String str) => Autor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Autor.fromJson(Map<String, dynamic> json) => Autor(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}

class Comment {
  String id;
  String description;
  Autor autor;
  DateTime date;

  Comment({
    required this.id,
    required this.autor,
    required this.date,
    required this.description,
  });

  factory Comment.fromRawJson(String str) => Comment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["_id"],
        description: json["description"],
        autor: Autor.fromJson(json["autor"]),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "description": description,
        "autor": autor.toJson(),
        "date": date.toIso8601String(),
      };
}
*/