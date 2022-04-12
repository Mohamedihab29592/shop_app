
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialApp/layout/socialapp/cubit/state.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../models/social_model/post_model.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/iconbroken.dart';
import '../../CommentsScreen.dart';

class Feeds extends StatelessWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(

      listener: (context,state){},
      builder: (context, state) {
       return ConditionalBuilder(
           condition:SocialCubit.get(context).posts.length>0 && SocialCubit.get(context).socialUserModel != 0 ,
           builder:(context)=>  SingleChildScrollView(
             physics: BouncingScrollPhysics(),
             child: Column(
               children: [
                 Card(
                   clipBehavior: Clip.antiAliasWithSaveLayer,
                   elevation: 5,
                   margin: EdgeInsets.all(8),
                   child: Stack(alignment: AlignmentDirectional.bottomEnd,
                     children: [
                       Image(image: NetworkImage('https://image.freepik.com/free-photo/hands-isolated-illuminating-color_23-2148791658.jpg'),
                       fit: BoxFit.cover,
                       height: 200,
                       width: double.infinity,
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text("Connect to the World",style:Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),),
                       ),

                     ],
                   ),
                 ),
                 ListView.separated(
                   shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     itemBuilder:(context,index) =>buildPost(SocialCubit.get(context).posts[index],context,index) ,
                     separatorBuilder:(context,index) => SizedBox(height: 8,) ,
                     itemCount: (SocialCubit.get(context).posts.length),

                 ),
                   SizedBox(height: 10,),
             ],
           ),
           ),
           fallback: (context) => Center(child: Text('no posts yet')),
       );

      },

      


    );
  }

  Widget buildPost(PostModel model, context, index ) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8,
      margin: EdgeInsets.zero,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    // if (postModel.uId != SocialCubit.get(context).model!.uID)
                    //   navigateTo(context, FriendsProfileScreen(postModel.uId));
                    // else
                    //   navigateTo(context, SocialLayout(3));
                  },
                  child: CircleAvatar(
                      radius: 22,
                      backgroundImage:
                      NetworkImage('${model.image}')),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: (){
                          // if (postModel.uId != SocialCubit.get(context).model!.uID)
                          //   navigateTo(context, FriendsProfileScreen(postModel.uId));
                          // else
                          //   navigateTo(context, SocialLayout(3));
                        },
                        child: Text('${model.name}',)),

                    Text(
                      '${model.dateTime}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                if(SocialCubit.get(context).socialUserModel!.uId == model.uId)
                  IconButton(
                      onPressed: () {
                        // scaffoldKey.currentState!.showBodyScrim(true, 0.5);
                        // scaffoldKey.currentState!.
                        // showBottomSheet((context) => Card(
                        //   clipBehavior: Clip.antiAliasWithSaveLayer,
                        //   shape: OutlineInputBorder(
                        //       borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(15),
                        //           topLeft: Radius.circular(15)),borderSide: BorderSide.none),
                        //   elevation: 15,
                        //
                        //   margin: EdgeInsets.zero,
                        //   child: Padding(
                        //     padding:
                        //     const EdgeInsets.symmetric(horizontal: 15),
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Icon(Icons.drag_handle),
                        //         CircleAvatar(
                        //           backgroundImage: NetworkImage(
                        //               '${postModel.image}'),
                        //           radius: 25,
                        //         ),
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Text('${postModel.text}', textAlign: TextAlign.center,),
                        //         SizedBox(height:10,),
                        //         Text('This Post was shared on '+'${postModel.dateTime} ',
                        //           style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
                        //         SizedBox(
                        //           height: 15,
                        //         ),
                        //         InkWell(
                        //           onTap: (){
                        //             //Scaffold.of(context)._currentBottomSheet!.close();
                        //             // SocialCubit.get(context).deletePost(postModel.postId);
                        //           },
                        //           child: Row(
                        //             children: const [
                        //               CircleAvatar(
                        //                 child:
                        //                 Icon(Icons.delete_outline_outlined),
                        //               ),
                        //               SizedBox(
                        //                 width: 15,
                        //               ),
                        //               Text(
                        //                 'Delete post',
                        //                 style: TextStyle(fontSize: 20),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 15,
                        //         ),
                        //         InkWell(
                        //           onTap: (){
                        //             // Scaffold.of(context).currentBottomSheet!.close();
                        //           },
                        //           child: Row(
                        //             children: const [
                        //               CircleAvatar(
                        //                 child:
                        //                 Icon(Icons.edit_outlined),
                        //               ),
                        //               SizedBox(
                        //                 width: 15,
                        //               ),
                        //               Text(
                        //                 'Edit Post',
                        //                 style: TextStyle(fontSize: 20),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 15,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //   shape: OutlineInputBorder(
                        //       borderRadius: BorderRadius.only(
                        //           topRight: Radius.circular(15),
                        //           topLeft: Radius.circular(15)),borderSide: BorderSide.none),
                        // ).closed.then((value) {
                        //   scaffoldKey.currentState!.showBodyScrim(false, 1);
                        // });
                      },
                      icon: Icon(Icons.more_horiz_outlined))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            model.postImage != null ? Text('${model.text}',style: TextStyle(fontSize: 15,),)
                : Text('${model.text}',style: TextStyle(fontSize: 20)),
            if (model.postImage != null)
              Padding(
                  padding: const EdgeInsetsDirectional.only(top: 10),
                  child: Image(image: NetworkImage('${model.postImage}'),)
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: myDivider(),
            ),

            Row(

              children: [
                Expanded(
                  child: InkWell(
                    onTap: ()  {
                      SocialCubit.get(context).likePost( SocialCubit.get(context).postId[index]);

                    },
                    child: Row(
                      children: const [
                        Icon(
                            IconBroken.Heart,
                            color: Colors.red
                        ),
                        SizedBox(
                          width: 5,
                        ),
                       Text(
                       'Like',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 18,),

                Expanded(
                  child: InkWell(
                      onTap: () {
                        // navigateTo(
                        //     context,
                        //     CommentsScreen(
                        //      ));
                      },
                      child: Row(
                        children: const [
                          Icon(
                              IconBroken.Chat,
                              color:Colors.amber
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Comments",),
                        ],
                      )
                  ),
                ),
               SizedBox(width: 50,),
                Expanded(
                  child: PopupMenuButton(
                    // color: SocialCubit.get(context).backgroundColor.withOpacity(1),
                    onSelected: (value) {
                      if(value == 'Share')
                      {
                        // SocialCubit.get(context).createNewPost(
                        //     name: SocialCubit.get(context).model!.name,
                        //     profileImage: SocialCubit.get(context).model!.profilePic,
                        //     postText: postModel.postText,
                        //     postImage: postModel.postImage,
                        //     date: getDate() ,
                        //     time: TimeOfDay.now().format(context).toString()
                        // ) ;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'Share',
                          child:
                          Row(children: const [
                            Icon(Icons.share,color: Colors.green),
                            SizedBox(width: 8,),
                            Text("Share now",),
                          ],))
                    ],
                    child: Row(
                      children: const [
                        Icon(Icons.share, color: Colors.green,),
                        SizedBox(width: 5,),
                        Text("Share",),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(
                        context,
                        CommentsScreen(likes: model.likes, postId: model.uId,postUid: model.uId,),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage('${model.image}')),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Write a comment",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ) ,
                ),


              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
