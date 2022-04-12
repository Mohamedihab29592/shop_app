import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialApp/models/social_model/social_user_model.dart';

import '../layout/socialapp/cubit/cubit.dart';
import '../layout/socialapp/cubit/state.dart';
import '../models/social_model/comment_model.dart';
import '../models/social_model/post_model.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import '../shared/components/constants.dart';
import '../shared/styles/iconbroken.dart';

class CommentsScreen extends StatelessWidget {
  var commentTextControl = TextEditingController();
  int? likes;

  String? postId;
  String? postUid;

  CommentsScreen({this.likes, this.postId, this.postUid});



  @override
  Widget build(BuildContext context) {
    String? postId = this.postId;

    return Builder(
      builder: (context) {
        SocialCubit.get(context).getSinglePost(postUid);
        SocialCubit.get(context).likePost(postUid!);
        SocialCubit.get(context).getComments(postUid);
        SocialCubit.get(context).getUserData(postUid);

        return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {

            },
            builder: (context, state) {
              dynamic commentImage = SocialCubit.get(context).commentImage;
              PostModel? post = SocialCubit.get(context).singlePost;
              List<CommentModel> comments = SocialCubit.get(context).comments;
              SocialUserModel? user = SocialCubit.get(context).socialUserModel;



              return ConditionalBuilder(
                  builder: ( context)=> Scaffold(
                    //backgroundColor: SocialCubit.get(context).backgroundColor.withOpacity(1),
                    appBar: AppBar(
                      automaticallyImplyLeading: true,
                      leading: IconButton(
                        onPressed: (){
                          comments.clear();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                    ),
                    body: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                // navigateTo(context, WhoLikedScreen(postId));
                              },
                              child: Row(
                                children: const [
                                  Icon(IconBroken.Heart,color: Colors.red,),
                                  SizedBox(width: 5,),
                                  Text(
                                    'tap to see who like your post',
                                  ),
                                  Spacer(),
                                  Icon(IconBroken.Arrow___Right_2),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            myDivider(),
                            SizedBox(height: 15,),
                            comments.length > 0 ?
                            Expanded(
                              child: ListView.separated(
                                  itemBuilder: (context,index) => buildComment(comments[index],context,index, SocialCubit.get(context).socialUserModel!, ),
                                  separatorBuilder: (context,index) => SizedBox(height: 10,),
                                  itemCount: (SocialCubit.get(context).comments.length),
                              ),
                            ) : Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("no comments",),

                                    ],
                                  ),)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child:   SocialCubit.get(context).isCommentImageLoading ?
                              LinearProgressIndicator(color: Colors.blueAccent,) : myDivider(),
                            ),
                            if(commentImage != null)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(bottom: 8.0),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        child:Image.file(
                                            commentImage,
                                            fit: BoxFit.cover,width: 100),
                                      ),
                                      SizedBox(width: 5,),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          child: IconButton(
                                            onPressed: (){
                                              SocialCubit.get(context).popCommentImage();
                                            },
                                            icon: Icon(Icons.close),iconSize: 15,),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              height: 35,
                              child: TextFormField(
                                  controller: commentTextControl,
                                  autofocus: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  //cursorColor: SocialCubit.get(context).textColor,
                                  // style: TextStyle(color: SocialCubit.get(context).textColor),
                                  validator: (value){
                                    if(value!.isEmpty)
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),borderSide: BorderSide.none),
                                      //contentPadding: EdgeInsets.all(10),

                                      hintText: "Write a comment",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: (){
                                                SocialCubit.get(context).getCommentImage();
                                              },
                                              icon: Icon(Icons.camera_alt_outlined,color: Colors.grey,)
                                          ),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: (){
                                                if(commentImage == null) {
                                                  SocialCubit.get(context).commentPost(
                                                    postId: postId,
                                                    comment: commentTextControl.text,
                                                    dateTime: DateTime.now().toString(),
                                                  );
                                                } else {
                                                  SocialCubit.get(context).uploadCommentPic(
                                                    postId: postId,
                                                    commentText: commentTextControl.text == ''? null:commentTextControl.text,
                                                    time: TimeOfDay.now().format(context),
                                                  );
                                                }
                                                SocialCubit.get(context).sendInAppNotification(
                                                    receiverName: post!.name,
                                                    receiverId: post.uId,
                                                    content: 'commented on a post you shared',
                                                    contentId: postId,
                                                    contentKey: 'post'
                                                );
                                                SocialCubit.get(context).sendFCMNotification(
                                                  token: user!.token,
                                                  senderName: SocialCubit.get(context).socialUserModel!.name,
                                                  messageText: '${SocialCubit.get(context).socialUserModel!.name}' + ' commented on a post you shared',
                                                );
                                                commentTextControl.clear();
                                                SocialCubit.get(context).popCommentImage();
                                              },
                                              icon: Icon(Icons.send,color: Colors.blue,)
                                          ),
                                        ],
                                      ),
                                      filled: true,
                                      //fillColor: SocialCubit.get(context).textFieldColor,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(40))
                                  )
                              ),
                            ),
                          ],
                        )),
                  ),
                condition:  SocialCubit.get(context).comments.length>=0,
                fallback: (context) => Center(child: CircularProgressIndicator()),

              );
            });
      },
    );
  }

  Widget buildComment(CommentModel comment, context, index ,SocialUserModel model, ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                radius: 25, backgroundImage: NetworkImage('${model.image}')),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                comment.text != null && comment.image != null
                    ?

                    /// If its (Text & Image) Comment
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                  // color: SocialCubit.get(context).unreadMessage,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${comment.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${comment.text}',
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                              width: intToDouble(comment.image!['width']) <= 400
                                  ? intToDouble(comment.image!['width'])
                                  : 250,
                              height:
                                  intToDouble(comment.image!['height']) <= 300
                                      ? intToDouble(comment.image!['height'])
                                      : 300,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image(
                                  image:
                                      NetworkImage(comment.image!['image']))),
                        ],
                      )
                    : comment.image != null
                        ?

                        /// If its (Image) Comment
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${comment.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              // SizedBox(height: 5,),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  width: intToDouble(comment.image!['width']) <=
                                          400
                                      ? intToDouble(comment.image!['width'])
                                      : 250,
                                  height: intToDouble(
                                              comment.image!['height']) <=
                                          300
                                      ? intToDouble(comment.image!['height'])
                                      : 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image(
                                      image: NetworkImage(
                                          comment.image!['image']))),
                            ],
                          )
                        : comment.text != null
                            ?

                            /// If its (Text) Comment
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                    // color: SocialCubit.get(context).unreadMessage,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${comment.name}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${comment.text}',
                                    ),
                                  ],
                                ))
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                  child: Text(
                    '${comment.dateTime}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
