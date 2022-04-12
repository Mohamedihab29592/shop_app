class PostModel {
  String? name;
  String? dateTime;
  String? text;
  String? tags;
  int? likes;
  int? comments;
  String? postImage;
  String? uId;
  String? image;

  PostModel({
    this.name,
    this.text,
    this.likes,
    this.comments,
    this.dateTime,
    this.uId,
    this.image,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    text = json['text'];
    likes = json['likes'];
    comments = json['comments'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'likes': likes,
      'comments': comments,
      'dateTime': dateTime,
      'uId': uId,
      'image': image,
      'postImage': postImage,
    };
  }
}
