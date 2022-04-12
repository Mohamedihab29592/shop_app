


import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialApp/shared/cubit/cubit.dart';
import 'package:socialApp/shared/cubit/states.dart';
import 'package:socialApp/shared/styles/themes.dart';


import 'layout/socialapp/cubit/cubit.dart';

import 'layout/socialapp/sociallayout.dart';
import 'modules/social_app/social_login/social_login_screen.dart';
import 'modules/splashScreen/splashScreen.dart';
import 'shared/bloc_observer.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cache_helper.dart';
import 'shared/network/remote/dio_helper.dart';




void main() async
{// be sure all methods finished  to run the app
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.init();
  await CacheHelper.init();

  bool ? isDarkMode = CacheHelper.getData(key: 'isDarkMode');

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

if(uId != null)
  {
    widget = SocialLayout();
  }
else{
  widget=SocialLoginScreen();
}
  runApp(MyApp(isDarkMode, widget ,uId ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

    bool ? isDarkMode;
    late final Widget startWidget;
    String? uId;



  MyApp(this.isDarkMode,this.startWidget, String? uId, {Key? key}) : super(key: key) ;


  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [

        BlocProvider( create: (BuildContext context)  => AppCubit()..changeAppMode(fromShared: isDarkMode,),

        ),



        BlocProvider( create: (BuildContext context)  => SocialCubit()..getUserData(uId).. getPosts()..getAllUsers(),
        ),

    ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context ,state){
          return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeMode:  AppCubit.get(context).isDarkMode ? ThemeMode.dark: ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: SplashScreen(),
              nextScreen: startWidget,
              splashIconSize: 700,

              animationDuration: const Duration(milliseconds: 2000),
              splashTransition: SplashTransition.fadeTransition,
            ),
            darkTheme: MyTheme.darkTheme ,
            theme: MyTheme.lightTheme,

                 builder: BotToastInit(),
                 navigatorObservers: [BotToastNavigatorObserver()],


              );
            },




      ),
    );
  }
}
