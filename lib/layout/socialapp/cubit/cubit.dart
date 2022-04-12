import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialApp/layout/socialapp/cubit/state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:socialApp/models/social_model/message_model.dart';
import 'package:socialApp/models/social_model/post_model.dart';

import '../../../models/social_model/comment_model.dart';
import '../../../models/social_model/notificationModel.dart';
import '../../../models/social_model/recentMessagesModel.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../modules/new_post/new_post.dart';
import '../../../modules/social_app/chats/chats.dart';
import '../../../modules/social_app/feeds/feeds.dart';
import '../../../modules/social_app/settings/settings.dart';
import '../../../modules/social_app/users/users.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/network/remote/dio_helper.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());




  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? socialUserModel;

  void getUserData(String? uId) {
    emit(SocialGetUserLoadingState());

    uId = CacheHelper.getData(key: 'uId');

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      socialUserModel = SocialUserModel.fromJson(value.data());
      print(socialUserModel.toString());

      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    Feeds(),
    Chats(),
    NewPostScreen(),
    Users(),
    Setting(),
  ];

  List<String> titles = ['Home', 'Chats', 'Post', 'Users', 'Settings'];

  void changeBottomNav(int index) {

    if (index == 1) {

      getAllUsers();

    }
    if (index == 4) {
      getUserData(uId);
    }
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNav());
    }
  }

  File? profileImage;
  File? coverImage;
  var picker = ImagePicker();

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverSuccessState());
    } else {
      print('No image selected');
      emit(SocialCoverErrorState());
    }
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialProfileImageErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio, image: value);
      }).catchError((error) {
        //emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(coverImage!.path)
        .pathSegments
        .last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverSuccessState());
        print(value);
        updateUser(name: name, phone: phone, bio: bio, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverErrorState());
    });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // }) {
  //   emit(SocialUserUpdateLoadingState());
  //   if (coverImage != null) {
  //     uploadCoverImage();
  //   } else if (profileImage != null) {
  //     uploadProfileImage();
  //   } else if (coverImage != null && profileImage != null)
  //
  //   {
  //   } else {
  //     updateUser(name: name, phone: phone, bio: bio);
  //   }
  // }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: socialUserModel!.email,
      uId: socialUserModel!.uId,
      cover: cover ?? socialUserModel!.cover,
      image: image ?? socialUserModel!.image,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData(uId);
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostSuccessState());
    } else {
      print('No image selected');
      emit(SocialPostErrorState());
    }
  }

  void uploadPost({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverSuccessState());
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,

          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  PostModel? singlePost;
  void getSinglePost(String? postId){
    emit(GetPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      singlePost = PostModel.fromJson(value.data());
      emit(GetSinglePostSuccessState());
    }).catchError((error){
      emit(GetPostErrorState());
    });
  }



  void deletePost(String? postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) {
      showToast(text: "Post Deleted" , state: ToastStates.ERROR);
      emit(DeletePostSuccessState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostState());
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    PostModel model = PostModel(
      name: socialUserModel!.name,
      image: socialUserModel!.image,
      uId: socialUserModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<CommentModel> comments = [];

  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .get().then((value) {
          value.docs.forEach((element) {
            postId.add(element.id);
            posts.add(PostModel.fromJson(element.data()));

          });
          emit(SocialGetPostsSuccessState());

      }).catchError((error) {
        emit(SocialGetPostsErrorState(error.toString()));
    });

  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(socialUserModel!.uId)
        .set({
      'likes': true,
    }).then((value) {
      emit(SocialLikePostsSuccessState());
    }).catchError((error) {
      emit(SocialLikePostsErrorState(error.toString()));
    });
  }


  void commentPost({
    required String? postId,
    String? comment,
    Map<String,dynamic>? commentImage,
    Map<String,dynamic>? image,
    String ? dateTime,

  }) {
    CommentModel commentModel = CommentModel(
        name: socialUserModel!.name!,
        image: image,
        text: comment!,
        commentImage: commentImage,

        dateTime:dateTime!,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')

        .add(commentModel.toMap())
        .then((value) {
      getPosts();

      emit(SocialCommentSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCommentErrorState(error.toString()));
    });
  }
  // void writeComments(String dateTime,
  //     String text,
  //     String postId,
  //     Map<String,dynamic>? image,) {
  //   emit(SocialCommentLoadingState());
  //   CommentModel model = CommentModel(
  //     name: socialUserModel!.name!,
  //     uId: socialUserModel!.uId!,
  //
  //     dateTime: dateTime,
  //     text: text,
  //     image: socialUserModel!.image,
  //
  //   );
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('comments')
  //        .add(model.toMap())
  //       .then((value) {
  //         getPosts();
  //     emit(SocialCommentSuccessState());
  //   }).catchError((error) {
  //     emit(SocialCommentErrorState(error.toString()));
  //   });
  // }

  void getComments(postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        emit(GetCommentsErrorState());
      });
    });
  }
  bool isCommentImageLoading = false;
  void uploadCommentPic({
    String ? dateTime,
    required String? postId,
    String? commentText,
    required String? time,
  }) {
    isCommentImageLoading = true;
    String? commentImageURL;
    emit(UploadCommentPicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(commentImage!.path).pathSegments.last)
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        commentImageURL = value;
        commentPost(
            postId: postId,
            comment: commentText,
            commentImage: {
              'width' : commentImageWidth,
              'image' : value,
              'height': commentImageHeight
            },
            dateTime: dateTime)
        ;
        emit(UploadCommentPicSuccessState());
        isCommentImageLoading = false;
      }).catchError((error) {
        print('Error While getDownload CommentImageURL ' + error);
        emit(UploadCommentPicErrorState());
      });
    }).catchError((error) {
      print('Error While putting the File ' + error);
      emit(UploadCommentPicErrorState());
    });
  }

  File? commentImage;
  int? commentImageWidth;
  int? commentImageHeight;
  Future getCommentImage() async {
    emit(UpdatePostLoadingState());
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print('Selecting Image...');
    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      print('Image Selected');
      emit(GetCommentPicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetCommentPicErrorState());
    }
  }

  void popCommentImage() {
    commentImage = null;
    emit(DeleteCommentPicState());
  }
  Future setNotificationId() async{
    await FirebaseFirestore.instance.collection('users').get()
        .then((value) {
      value.docs.forEach((element) async {
        var notifications = await element.reference.collection('notifications').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference.update({
            'notificationId' : notificationsElement.id
          });
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  void sendFCMNotification({
    required String? token,
    required String? senderName,
    String? messageText,
    String? messageImage,
  }) {
    DioHelper.postData(
        data: {
          "to": "$token",
          "notification": {
            "title": "$senderName",
            "body":
            "${messageText != null ? messageText : messageImage != null ? 'Photo' : 'ERROR 404'}",
            "sound": "default"
          },
          "android": {
            "Priority": "HIGH",
          },
          "data": {
            "type": "order",
            "id": "87",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        });
    emit(SendMessageSuccessState());
  }
  void sendInAppNotification({
    String? contentKey,
    String? contentId,
    String? content,
    String? receiverName,
    String? receiverId,
  }){
    emit(SendInAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
      contentKey:contentKey,
      contentId:contentId,
      content:content,
      senderName: socialUserModel!.name,
      receiverName:receiverName,
      senderId:socialUserModel!.uId,
      receiverId:receiverId,
      senderProfilePicture:socialUserModel!.image,
      read: false,
      dateTime: Timestamp.now(),
      serverTimeStamp:FieldValue.serverTimestamp(),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('notifications')
        .add(notificationModel.toMap()).then((value) async{
      await setNotificationId();
      emit(SendInAppNotificationLoadingState());
    }).catchError((error) {
      emit(SendInAppNotificationLoadingState());
    });
  }

  List<SocialUserModel> users = [];

  void getAllUsers() {
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != socialUserModel!.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUserErrorState(error.toString()));
      });
    }
  }

  String? imageURL;
  bool isLoading = false;

  void uploadMessagePic({
    String ? senderId,
    required messageId,
    required String recevierId,
    String? text,
    required String dateTime,
  }) {
    isLoading = true;
    emit(UploadMessagePicLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(Uri.file(messageImage!.path).pathSegments.last)
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageURL = value;
        sendMessage(
            messageId:messageId ,
            recevierId: recevierId,
            text: text,
            messageImage: {
              'width' : messageImageWidth,
              'image' : value,
              'height': messageImageHeight
            },
            dateTime: dateTime,
        );
        emit(UploadMessagePicSuccessState());
        isLoading = false;
      }).catchError((error) {
        print('Error While getDownloadURL ' + error);
        emit(UploadMessagePicErrorState());
      });
    }).catchError((error) {
      print('Error While putting the File ' + error);
      emit(UploadMessagePicErrorState());
    });
  }

  void sendMessage({
    required messageId,
    String ? senderId,
    required String recevierId,
    required String dateTime,
    Map<String,dynamic>? messageImage,
     String ? text,
  }) {
    MessageUserModel messageModel = MessageUserModel(
        messageId: messageId,
      senderId: socialUserModel!.uId,
        recevierId: recevierId,
        text: text,
        messageImage: messageImage,
        dateTime: dateTime,

    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .collection('chats')
        .doc(recevierId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) async {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(recevierId)
        .collection('chats')
        .doc(socialUserModel!.uId)
        .collection('message')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageUserModel> message = [];

  void getMessage( String? recevierId,) {
    FirebaseFirestore.instance.collection('users')
        .doc(socialUserModel!.uId)
        .collection('chats')
        .doc(recevierId)
        .collection('messages')
    .orderBy('dateTime')
        .snapshots().listen((event)
    {     message =[];
          event.docs.forEach((element)
          {
            message.add(MessageUserModel.fromJson(element.data()));

          });
emit(SocialGetMessageSuccessState());
    });
  }

  File? messageImage;
  int? messageImageWidth;
  int? messageImageHeight;
  Future getMessageImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      messageImage = File(pickedFile.path);
      var decodedImage = await decodeImageFromList(messageImage!.readAsBytesSync());
      messageImageHeight = decodedImage.height;
      messageImageWidth = decodedImage.width;
      print('$messageImageHeight' + ' height');
      print('$messageImageWidth' + ' Width');
      emit(GetMessagePicSuccessState());
    } else {
      print('No Image Selected');
      emit(GetMessagePicErrorState());
    }
  }
  void setRecentMessage({
    required String? receiverName,
    required String? receiverId,
    String? recentMessageText,
    String? recentMessageImage,
    required String? receiverProfilePic,
    required String? time,
  }) {
    RecentMessagesModel recentMessagesModel = RecentMessagesModel(
        senderId: socialUserModel!.uId,
        senderName: socialUserModel!.name,
        senderProfilePic: socialUserModel!.image,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverProfilePic: receiverProfilePic,
        recentMessageText: recentMessageText,
        recentMessageImage: recentMessageImage,
        read: false,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    RecentMessagesModel myRecentMessagesModel = RecentMessagesModel(
        senderId: socialUserModel!.uId,
        senderName: socialUserModel!.name,
        senderProfilePic: socialUserModel!.image,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverProfilePic: receiverProfilePic,
        recentMessageText: recentMessageText,
        recentMessageImage: recentMessageImage,
        read: true,
        time: time,
        dateTime: FieldValue.serverTimestamp());
    FirebaseFirestore.instance
        .collection('users')
        .doc(socialUserModel!.uId)
        .collection('recentMsg')
        .doc(receiverId)
        .set(myRecentMessagesModel.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SetRecentMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('recentMsg')
        .doc(socialUserModel!.uId)
        .set(recentMessagesModel.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SetRecentMessageErrorState());
    });
  }
  void popMessageImage() {
    messageImage = null;
    emit(DeleteMessagePicState());
  }
}
