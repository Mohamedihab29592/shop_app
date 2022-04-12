class SocialUserModel
{
  String ? name;
   String  ?email;
   String ? phone;
  String? token;

   String ? uId;
  String ? image;
  String ? cover;
  String ? bio;
 late  bool isEmailVerified;

  SocialUserModel({
     this.name,  this.email , this.phone , this.uId, this.image , this.cover , this.bio , required this.isEmailVerified,
});
  SocialUserModel.fromJson(Map<String,dynamic>?json)
  {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    token = json['token'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String,dynamic>toMap()
  {
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'token':token,
      'uId':uId,
      'image':image,
      'cover':cover,
      'bio':bio,
    'isEmailVerified' : isEmailVerified ,

    };
  }

}
