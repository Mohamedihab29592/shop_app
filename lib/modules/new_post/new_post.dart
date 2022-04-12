import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialApp/layout/socialapp/cubit/cubit.dart';
import 'package:socialApp/layout/socialapp/cubit/state.dart';
import 'package:socialApp/shared/styles/iconbroken.dart';

import '../../shared/components/components.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(

                  text: 'post',
                function: () {
                  var now = DateTime.now();
                  if (SocialCubit.get(context).postImage == null) {
                    SocialCubit.get(context).createPost(
                        dateTime: now.toString(), text: textController.text);
                  } else {
                    SocialCubit.get(context).uploadPost(
                        dateTime: now.toString(), text: textController.text);
                  }
                },



              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState)
                LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
              SizedBox(height: 10,),
                Row(
                  children: const [

                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://image.freepik.com/free-photo/african-american-man-with-illuminating-color_23-2148791661.jpg'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        'Mohamed Ihab',
                        style: TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'What is on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                if(SocialCubit.get(context).postImage!=null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius:BorderRadius.circular(4.0),
                          image: DecorationImage(
                              image:   FileImage(SocialCubit.get(context).postImage!),
                              fit: BoxFit.cover)),
                    ),
                    IconButton(icon:CircleAvatar(
                        radius: 20,child: Icon(Icons.close,size: 16,)) ,onPressed: (){ SocialCubit.get(context).removePostImage();},),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(IconBroken.Image),
                            SizedBox(
                              width: 5,
                            ),
                            Text('add photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# tags'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
