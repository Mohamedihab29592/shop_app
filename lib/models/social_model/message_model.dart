class MessageUserModel
{
  String? senderId;
  String? messageId;
  String ? recevierId;
  String ? dateTime;
  String ? text;
  Map<String,dynamic>? messageImage;

  MessageUserModel({
    this.messageId,
    this.recevierId,
    this.dateTime,
    this.text,
    this.messageImage,  this.senderId,
  });
  MessageUserModel.fromJson(Map<String,dynamic>?json)
  {

  messageId = json!['messageId'];
  senderId = json['senderId'];
    recevierId = json['recevierId'];
    dateTime = json['dateTime'];
    messageImage  = json['messageImage'];
    text = json['text'];

  }
  Map<String,dynamic>toMap()
  {
    return {
      'messageId':messageId,
      'senderId':senderId,
      'recevierId':recevierId,
      'messageImage':messageImage,

      'dateTime':dateTime,
      'text':text,


    };
  }

}
