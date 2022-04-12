



import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


import '../../modules/social_app/social_login/social_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';
import 'fullscreen.dart';

dynamic signOut (context) async {
  await CacheHelper.removeData(
    key: 'token',
  ).then((value) {
    if (value) {
      navigateAndFinish(context, SocialLoginScreen());
     // SocialCubit.get(context).currentIndex = 0;
     
  }});
}
  void printFullText(dynamic text)
  {
    final pattern = RegExp('.{1,800}');//800 size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));

  }
  String ? token = '';
String ? uId = '';
int cartLength = 0;
int favLength = 0;
dynamic discountLen = 0;


String getDateTomorrow ()
{
  DateTime dateTime =  DateTime.now().add(Duration(days: 1));
  String date =  DateFormat.yMMMd().format(dateTime);
  return date;
}
bool isEdit = false;
String editText = 'Edit';
void editPressed({
  required context,
  required email,
  required name,
  required phone,
})
{
  isEdit =! isEdit;
  if(isEdit) {
    editText = 'Save';
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    //ShopCubit.get(context).emit(EditPressedState());
  } else {
    editText = 'Edit';
    // ShopCubit.get(context).updateProfileData(
    //     email: email,
    //     name: name,
    //     phone: phone
    //);
  }



}

double intToDouble(int num){
  double doubleNum = num.toDouble();
  return doubleNum;
}



