import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialApp/models/social_model/social_user_model.dart';

import '../layout/socialapp/cubit/cubit.dart';
import '../layout/socialapp/cubit/state.dart';
import '../models/social_model/post_model.dart';


class FriendsProfileScreen extends StatelessWidget {
  String? userUid;
  FriendsProfileScreen(this.userUid);

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Text("friends");
  }
}
