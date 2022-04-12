class CommentModel
{
  late String name;

  late String dateTime;
  late String text;

  Map<String,dynamic>? commentImage;
  Map<String,dynamic>? image;

  CommentModel({
    required this.name,

    required this.image,

    required this.dateTime,
    required this.text,
    required this.commentImage,

  });

  CommentModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];

    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    commentImage = json['commentImage'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'image':image,

      'dateTime':dateTime,
      'text':text,
      'commentImage':commentImage,
    };
  }
}