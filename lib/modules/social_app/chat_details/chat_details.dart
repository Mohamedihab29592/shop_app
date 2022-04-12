import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/social_model/message_model.dart';
import '../../../shared/components/constants.dart';

class ChatDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildMessage(MessageUserModel message, context) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//  if (SocialCubit.get(context).showTime == true)
            Text(
              TimeOfDay.now().format(context).toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            InkWell(
              onTap: () {
//SocialCubit.get(context).time();
              },
// onLongPress: () async{
//   final result = await showDialog(context: context, builder: (context) => alertDialog(context));
//   switch(result){
//     case 'DELETE FOR EVERYONE':
//       SocialCubit.get(context).deleteForEveryone(
//           messageId: message.messageId,
//           receiverId: message.receiverId
//       );
//       break;
//     case 'DELETE FOR ME':
//       SocialCubit.get(context).deleteForMe(
//           messageId: message.messageId,
//           receiverId: message.receiverId
//       );
//       break;
//   }
// },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.text != null && message.messageImage != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                width: intToDouble(
                                            message.messageImage!['width']) <
                                        230
                                    ? intToDouble(
                                        message.messageImage!['width'])
                                    : 230,
                                height: intToDouble(
                                            message.messageImage!['height']) <
                                        250
                                    ? intToDouble(
                                        message.messageImage!['height'])
                                    : 250,
                                decoration: BoxDecoration(
// color: SocialCubit.get(context).messageColor,
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                )),
                                child: Image(image:NetworkImage(message.messageImage!['image']))),

                            Container(
                                width: 190,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                decoration: BoxDecoration(
// color: SocialCubit.get(context).messageColor,
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                                child: Text(
                                  '${message.text}',
                                )),
                          ],
                        )
                      : message.messageImage != null
                          ? Container(
                              padding: EdgeInsets.all(8),
                              width: intToDouble(
                                          message.messageImage!['width']) <
                                      230
                                  ? intToDouble(message.messageImage!['width'])
                                  : 230,
                              height: intToDouble(
                                          message.messageImage!['height']) <
                                      250
                                  ? intToDouble(message.messageImage!['height'])
                                  : 250,
                              decoration: BoxDecoration(
// color: SocialCubit.get(context).messageColor,
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                              child:
  Image(image:NetworkImage(message.messageImage!['image'])))
                          : message.text != null
                              ? Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
// color: SocialCubit.get(context).messageColor,
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                                  child: Text(
                                    '${message.text}',
                                  ))
                              : Container(
                                  height: 0,
                                  width: 0,
                                )
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildMyMessage(MessageUserModel message, context) => Align(
        alignment: AlignmentDirectional.topEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
// SocialCubit.get(context).time();
              },
// onLongPress: () async{
//   final result = await showDialog(context: context, builder: (context) => alertDialog(context));
//   switch(result){
//     case 'DELETE FOR EVERYONE':
//       SocialCubit.get(context).deleteForEveryone(
//           messageId: message.messageId,
//           receiverId: message.receiverId
//       );
//       break;
//     case 'DELETE FOR ME':
//       SocialCubit.get(context).deleteForMe(
//           messageId: message.messageId,
//           receiverId: message.receiverId
//       );
//       break;
//   }
// },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  message.text != null && message.messageImage != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                width: intToDouble(
                                            message.messageImage!['width']) <
                                        230
                                    ? intToDouble(
                                        message.messageImage!['width'])
                                    : 230,
                                height: intToDouble(
                                            message.messageImage!['height']) <
                                        250
                                    ? intToDouble(
                                        message.messageImage!['height'])
                                    : 250,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Image(image:NetworkImage(message.messageImage!['image'])))),

                            Container(
                                width: 190,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
//color: SocialCubit.get(context).myMessageColor,
                                    borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                                child: Text('${message.text}',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        )
                      : message.messageImage != null
                          ? Container(
                              padding: EdgeInsets.all(8),
                              width: 190,
                              height: 250,
                              decoration: BoxDecoration(
// color: SocialCubit.get(context).myMessageColor,
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                              child:
  Image(image:NetworkImage(message.messageImage!['image'])))
                          : message.text != null
                              ? Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
//color: SocialCubit.get(context).myMessageColor,
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )),
                                  child: Text('${message.text}',
                                      style: TextStyle(color: Colors.white)))
                              : Container(
                                  height: 0,
                                  width: 0,
                                )
                ],
              ),
            ),
//  if (SocialCubit.get(context).showTime == true)
            Text(
              TimeOfDay.now().format(context).toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
}
